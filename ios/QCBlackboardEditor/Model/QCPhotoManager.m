


//
//  QCPhotoManager.m
//  QCBlackboardEditor
//
//  Created by SXJH on 16/11/28.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#import "QCPhotoManager.h"
#import "QCPhotoAblumList.h"
#import "QCAssetItem.h"
#import "QCBlackboardEditorMacroDefines.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
@implementation QCPhotoManager
#pragma mark - 获取所有相册列表
+ (QCPhotoManager*)shareManager
{
    static QCPhotoManager * _shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [[QCPhotoManager alloc]init];
    });
    return _shareManager;
}
- (void)clearCacheDicInfo
{
    if (_cacheImageDic.allKeys.count>0)
    {
        [_cacheImageDic removeAllObjects];
    }
    if (_carouselCacheImageDic.allKeys.count>0)
    {
        [_carouselCacheImageDic removeAllObjects];
    }
}
- (id)init
{
    if (self = [super init]) {
        _cacheImageDic = [[NSMutableDictionary alloc]initWithCapacity:0];
        _carouselCacheImageDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    }
    return self;
}
+ (NSArray<QCPhotoAblumList *> *)getPhotoAblumList
{
    NSMutableArray<QCPhotoAblumList *> *photoAblumList = [NSMutableArray array];
    
    //获取所有智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
        //过滤掉视频和最近删除
        if(collection.assetCollectionSubtype != 202 && collection.assetCollectionSubtype < 212)
        {
            NSArray<PHAsset *> *assets = [[self class] getAssetsInAssetCollection:collection ascending:NO];
            if (assets.count > 0) {
                QCPhotoAblumList *ablum = [[QCPhotoAblumList alloc] init];
                ablum.title = collection.localizedTitle;
                ablum.count = assets.count;
                ablum.headImageAsset = assets.firstObject;
                ablum.assetCollection = collection;
                [photoAblumList addObject:ablum];
            }
        }
    }];
    
    //获取用户创建的相册
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray<PHAsset *> *assets = [[self class] getAssetsInAssetCollection:collection ascending:NO];
        if (assets.count > 0) {
            QCPhotoAblumList *ablum = [[QCPhotoAblumList alloc] init];
            ablum.title = collection.localizedTitle;
            ablum.count = assets.count;
            ablum.headImageAsset = assets.firstObject;
            ablum.assetCollection = collection;
            [photoAblumList addObject:ablum];
        }
    }];
    
    return photoAblumList;
}

#pragma mark - 获取指定相册内的所有图片
+ (NSArray<PHAsset *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending
{
    NSMutableArray<PHAsset *> *arr = [NSMutableArray array];
    
    PHFetchResult *result = [[self class] fetchAssetsInAssetCollection:assetCollection ascending:ascending];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (((PHAsset *)obj).mediaType == PHAssetMediaTypeImage) {
            [arr addObject:obj];
        }
    }];
    return arr;
}

+ (PHFetchResult *)fetchAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending
{
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
    return result;
}

#pragma mark - 获取asset对应的图片
+ (void)requestImageForAsset:(PHAsset *)asset size:(CGSize)size resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *, NSDictionary *))completion
{
    //请求大图界面，当切换图片时，取消上一张图片的请求，对于iCloud端的图片，可以节省流量
    static PHImageRequestID requestID = -1;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat width = MIN(QC_ScreenWidth, QC_ScreenHeight);
    if (requestID >= 1 && size.width/width==scale) {
        [[PHCachingImageManager defaultManager] cancelImageRequest:requestID];
    }
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = resizeMode;//控制照片尺寸
    //option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;//控制照片质量
    option.networkAccessAllowed = YES;
    requestID = [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey];
        //不要该判断，即如果该图片在iCloud上时候，会先显示一张模糊的预览图，待加载完毕后会显示高清图
        // && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]
        if (downloadFinined && completion) {
            completion(image, info);
        }
    }];
}
+ (BOOL)isCanUsePhotos
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied)
        {
            //无权限
            return NO;
        }
    }
    else
    {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
        {
            //无权限
            return NO;
        }
    }
    return YES;
}
@end
