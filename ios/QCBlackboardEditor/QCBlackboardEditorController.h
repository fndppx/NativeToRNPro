//
//  QCBlackboardEditorController.h
//  QCBlackboardEditor
//
//  Created by 0dayZh on 2016/11/24.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QCBlackboardEditorController;
@protocol QCBlackboardEditorControllerDelegate <NSObject>

@optional
- (void)blackboardEditerControllerWillDismiss:(QCBlackboardEditorController *)controller;
- (void)blackboardEditerControllerDidRequestToSave:(QCBlackboardEditorController *)controller;

@end

typedef NS_ENUM(NSUInteger, QCBlackboardEditorState) {
    QCBlackboardEditorStateEditing,
    QCBlackboardEditorStateSaving
};

@interface QCBlackboardEditorController : UIViewController

@property (nonatomic, weak) id<QCBlackboardEditorControllerDelegate> delegate;
@property (nonatomic, assign) QCBlackboardEditorState state;

/**
 UIImage数组
 */
@property (nonatomic, strong ,readonly) NSArray * uploadImageArray;

/**
 插入图片

 @param initImageArray 图片数组
 @param insertIndex 索引
 */
- (void)setInitImageArray:(NSArray *)initImageArray withInsertIndex:(NSInteger)insertIndex;
+ (instancetype)editorController;

@end
