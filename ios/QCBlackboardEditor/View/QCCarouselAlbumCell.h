//
//  QCCarouselAlbumCell.h
//  QCBlackboardEditor
//
//  Created by SXJH on 16/11/29.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCAssetItem.h"
@interface QCCarouselAlbumCell : UICollectionViewCell
@property (nonatomic,strong)QCAssetItem * currentAssetItem;
@property (nonatomic,strong,readonly)UIImageView * currentShowImageView;
@property (nonatomic,assign)BOOL hiddenDeleteBtn;
@property (nonatomic,copy)void(^buttonDeletePress)(QCAssetItem * item);
- (void)loadView;
@end
