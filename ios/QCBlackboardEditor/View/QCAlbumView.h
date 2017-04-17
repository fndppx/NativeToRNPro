//
//  QCAlbumView.h
//  QCBlackboardEditor
//
//  Created by SXJH on 16/11/28.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCAssetItem.h"
@interface QCAlbumView : UIView

/**
 选择图片响应
 */
@property (nonatomic,copy)void(^buttonSelectPress)(QCAssetItem*item,BOOL isSelected);

/**
 是否有交互性
 */
@property (nonatomic,assign,getter=isEnableInteract)BOOL enableInteract;

/**
 删除item后更新

 @param item 列表中的item
 */
- (void)reloadViewWithDeleteItem:(QCAssetItem*)item;

/**
 重新加载整个视图
 */
- (void)reloadAll;
- (void)reloadAllWithMenuTitle:(NSString*)menuTitle;
@end
