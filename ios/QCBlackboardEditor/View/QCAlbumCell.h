//
//  QCAlbumCell.h
//  QCBlackboardEditor
//
//  Created by SXJH on 16/11/28.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCAssetItem.h"
@interface QCAlbumCell : UICollectionViewCell
@property (nonatomic,strong)QCAssetItem *currentAsset;
@property (nonatomic,strong)NSString *index;
@property (nonatomic,copy)void(^cellPressResponsed) ();
- (void)loadView;
@end
