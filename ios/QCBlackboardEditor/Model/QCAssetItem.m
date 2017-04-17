
//
//  QCAssetItem.m
//  QCBlackboardEditor
//
//  Created by SXJH on 16/11/28.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#import "QCAssetItem.h"

@implementation QCAssetItem
- (instancetype)initWithPhasset:(PHAsset *)asset
{
    if (self = [super init])
    {
        self.asset = asset;
        self.selected = NO;
    }
    return self;
}

+ (instancetype)asseItemWithPhasset:(PHAsset *)asset
{
    return [[self alloc]initWithPhasset:asset];
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    QCAssetItem *copy = [[[self class] allocWithZone:zone] init];
    copy.selected = self.selected;
    copy.asset = self.asset;
    copy.index = self.index;
    return copy;
}
@end
