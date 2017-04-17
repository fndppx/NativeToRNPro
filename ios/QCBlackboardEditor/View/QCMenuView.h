//
//  QCMenuView.h
//  QCBlackboardEditor
//
//  Created by SXJH on 16/12/2.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCMenuView : UIView
@property (nonatomic,copy) void(^didSelectedMenuListResponsed)(NSString * menuTitle);
@end
