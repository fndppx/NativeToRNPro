//
//  TestPasswordView.h
//  NativeToJSPro
//
//  Created by SXJH on 17/4/14.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "QCPasswordView.h"
#import <React/RCTComponent.h>
#import <React/UIView+React.h>
@interface TestPasswordView : QCPasswordView
@property (nonatomic, copy) RCTBubblingEventBlock onClickBanner;

@end
