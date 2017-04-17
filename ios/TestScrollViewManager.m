

//
//  TestScrollViewManager.m
//  NativeToJSPro
//
//  Created by SXJH on 17/4/14.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "TestScrollViewManager.h"
#import "TestScrollView.h"      //第三方组件的头文件
#import <React/RCTBridge.h>           //进行通信的头文件
#import <React/RCTEventDispatcher.h>  //事件派发，不导入会引起Xcode警告

@implementation TestScrollViewManager

//  标记宏（必要）
RCT_EXPORT_MODULE()

//  事件的导出，onClickBanner对应view中扩展的属性
RCT_EXPORT_VIEW_PROPERTY(onClickBanner, RCTBubblingEventBlock)

//  通过宏RCT_EXPORT_VIEW_PROPERTY完成属性的映射和导出
RCT_EXPORT_VIEW_PROPERTY(autoScrollTimeInterval, CGFloat);

RCT_EXPORT_VIEW_PROPERTY(imageURLStringsGroup, NSArray);

RCT_EXPORT_VIEW_PROPERTY(autoScroll, BOOL);

- (UIView *)view
{
  //  实际组件的具体大小位置由js控制
  TestScrollView *testScrollView = [TestScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"Image"]];
  //  初始化时将delegate指向了self
  testScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
  testScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
  return testScrollView;
}

/**
 *  当事件导出用到 sendInputEventWithName 的方式时，会用到
 - (NSArray *) customDirectEventTypes {
 return @[@"onClickBanner"];
 }
 */

#pragma mark SDCycleScrollViewDelegate
/**
 *  banner点击
 */
- (void)cycleScrollView:(TestScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
  //    这也是导出事件的方式，不过好像是旧方法了，会有警告
  //    [self.bridge.eventDispatcher sendInputEventWithName:@"onClickBanner"
  //                                                   body:@{@"target": cycleScrollView.reactTag,
  //                                                          @"value": [NSNumber numberWithInteger:index+1]
  //                                                        }];
  
  if (!cycleScrollView.onClickBanner) {
    return;
  }
  
  NSLog(@"oc did click %li", [cycleScrollView.reactTag integerValue]);
  
  //  导出事件
  cycleScrollView.onClickBanner(@{@"target": cycleScrollView.reactTag,
                                  @"value": [NSNumber numberWithInteger:index+1]});
}

// 导出枚举常量，给js定义样式用
- (NSDictionary *)constantsToExport
{
  return @{
           @"SDCycleScrollViewPageContolAliment": @{
               @"right": @(SDCycleScrollViewPageContolAlimentRight),
               @"center": @(SDCycleScrollViewPageContolAlimentCenter)
               }
           };
}

//  因为这个类继承RCTViewManager，实现RCTBridgeModule，因此可以使用原生模块所有特性
//  这个方法暂时没用到
RCT_EXPORT_METHOD(testResetTime:(RCTResponseSenderBlock)callback) {
  callback(@[@(234)]);
}

@end
