//
//  QCPhotoManager.h
//  QCBlackboardEditor
//
//  Created by SXJH on 16/11/28.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@class QCPhotoAblumList;
@interface QCPhotoManager : NSObject
@property (nonatomic,strong)NSMutableDictionary * cacheImageDic;//相册
@property (nonatomic,strong)NSMutableDictionary * carouselCacheImageDic;//轮播图片

/**
 清空缓存图片
 */
- (void)clearCacheDicInfo;
+ (QCPhotoManager*)shareManager;
+ (NSArray<QCPhotoAblumList *> *)getPhotoAblumList;
+ (NSArray<PHAsset *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending;
+ (void)requestImageForAsset:(PHAsset *)asset size:(CGSize)size resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *, NSDictionary *))completion;
+ (BOOL)isCanUsePhotos;
@end
