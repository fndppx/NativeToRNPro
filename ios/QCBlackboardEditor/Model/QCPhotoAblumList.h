//
//  QCPhotoAblumList.h
//  QCBlackboardEditor
//
//  Created by SXJH on 16/11/28.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface QCPhotoAblumList : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UIImage* image;
@property (nonatomic, strong) PHAsset *headImageAsset;
@property (nonatomic, strong) PHAssetCollection *assetCollection;
@end
