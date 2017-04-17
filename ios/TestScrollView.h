//
//  TestScrollView.h
//  NativeToJSPro
//
//  Created by SXJH on 17/4/14.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "SDCycleScrollView.h"
#import <React/RCTComponent.h>
#import <React/UIView+React.h>
@interface TestScrollView : SDCycleScrollView
@property (nonatomic, copy) RCTBubblingEventBlock onClickBanner;

@end
