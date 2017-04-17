//
//  QCPasswordTextView.h
//  QCPasswordUnlocker
//
//  Created by SXJH on 16/11/24.
//  Copyright © 2016年 SXJH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCPasswordView : UIView
@property (nonatomic,assign)BOOL showErrorTip;
+ (id)initWithTitle:(NSString *)title enterIntoRoomButtonPressResponsed:(void(^)(NSString * passwordStr))responsed;
- (void)showAnimated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated;
@end
