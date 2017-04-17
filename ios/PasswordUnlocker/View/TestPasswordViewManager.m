//
//  TestPasswordViewManager.m
//  NativeToJSPro
//
//  Created by SXJH on 17/4/14.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "TestPasswordViewManager.h"
#import <React/RCTBridge.h>           //进行通信的头文件
#import <React/RCTEventDispatcher.h>  //事件派发，不导入会引起Xcode警告
#import "QCPasswordView.h"
@interface TestPasswordViewManager()
@property (nonatomic,strong)QCPasswordView * passwordView;
@end
@implementation TestPasswordViewManager
RCT_EXPORT_MODULE()
//- (id)init{
//  if (self = [super init]) {
//    
//  }
//  return  self;
//}

RCT_EXPORT_METHOD(showPassWordWithTitle:(NSString *)title){
  
  dispatch_async(dispatch_get_main_queue(), ^{
    QCPasswordView * passwordView = [QCPasswordView initWithTitle:@"轻课伴轻课伴轻课伴轻课伴轻课伴轻课小小伙伴" enterIntoRoomButtonPressResponsed:^(NSString *passwordStr){
      NSLog(@"%@",passwordStr);
      
    }];
    [passwordView showAnimated:YES];
  
  });
}
RCT_EXPORT_METHOD(dissmissPassWordView){
  [self.passwordView dismissAnimated:YES];
}

@end
