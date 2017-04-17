




//
//  QCBlackboardEditorManager.m
//  NativeToJSPro
//
//  Created by SXJH on 17/4/16.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "QCBlackboardEditorManager.h"
#import "QCBlackboardEditorController.h"
#import "AppDelegate.h"
#import <React/RCTBridge.h>
#import <React/RCTBridgeMethod.h>
#import <React/RCTEventDispatcher.h>
@interface QCBlackboardEditorController()<UIApplicationDelegate,QCBlackboardEditorControllerDelegate>

@end
@implementation QCBlackboardEditorManager{
  RCTPromiseResolveBlock _resolveBlock;
  RCTPromiseRejectBlock _rejectBlock;
}
@synthesize bridge = _bridge;

RCT_EXPORT_MODULE()
//普通函数
RCT_EXPORT_METHOD(pushBlackboardVC){
  QCBlackboardEditorController *editor = [QCBlackboardEditorController editorController];
  editor.delegate = self;
  AppDelegate * delegate  = (AppDelegate*)[UIApplication sharedApplication].delegate;
  dispatch_async(dispatch_get_main_queue(), ^{
    [delegate.nav presentViewController:editor animated:YES completion:nil];
    
  });
}

//回调函数
//RCT_REMAP_METHOD(pushBlackboardVC,resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter){
//  _resolveBlock=resolver;
//  _rejectBlock=rejecter;
//  QCBlackboardEditorController *editor = [QCBlackboardEditorController editorController];
//  editor.delegate = self;
//  AppDelegate * delegate  = [UIApplication sharedApplication].delegate;
//  dispatch_async(dispatch_get_main_queue(), ^{
//    [delegate.nav presentViewController:editor animated:YES completion:nil];
//
//  });
//}
- (void)blackboardEditerControllerWillDismiss:(QCBlackboardEditorController *)controller{
  //  _resolveBlock(@"dismiss");
  [self.bridge.eventDispatcher sendAppEventWithName:@"Dismiss" body:nil];
}
- (void)blackboardEditerControllerDidRequestToSave:(QCBlackboardEditorController *)controller{
  //  _resolveBlock(@"save");
  [self.bridge.eventDispatcher sendAppEventWithName:@"Save" body:nil];
  
}
//self.bridge.eventDispatcher sendAppEventWithName:@"EventReminder" body:@{@"name":[NSString stringWithFormat:@"%@",value],@"errorCode":@"0",@"msg":@"成功"}];
@end
