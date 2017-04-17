//
//  QCAssetItem.h
//  QCBlackboardEditor
//
//  Created by SXJH on 16/11/28.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef enum : NSUInteger {
    QCAlbumLocationTypeMiddle,
    QCAlbumLocationTypeHeader,
    QCAlbumLocationTypeEnd,
} QCAlbumLocationType;
@interface QCAssetItem : NSObject
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL isTopperImage;//是否是上层初始化传递的图片
@property (nonatomic, assign) QCAlbumLocationType albumLocationType;
@property (nonatomic, assign) CGRect facesRect;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIImage * image;

- (instancetype)initWithPhasset:(PHAsset *)asset;
+ (instancetype)asseItemWithPhasset:(PHAsset *)asset;
@end
