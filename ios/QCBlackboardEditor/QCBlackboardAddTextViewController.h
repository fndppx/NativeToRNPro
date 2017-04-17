//
//  QCBlackboardAddTextViewController.h
//  QCBlackboardEditor
//
//  Created by 0dayZh on 2016/11/25.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QCBlackboardAddTextViewController;
@protocol QCBlackboardAddTextViewControllerDelegate <NSObject>

- (void)blackboardAddTextViewControllerWillDismiss:(QCBlackboardAddTextViewController *)viewController;
- (void)blackboardAddTextViewController:(QCBlackboardAddTextViewController *)viewController didAddText:(NSString *)text;
- (void)blackboardAddTextViewController:(QCBlackboardAddTextViewController *)viewController didAddTextImageView:(UIImageView *)textImageView;

@end

@interface QCBlackboardAddTextViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, weak) id<QCBlackboardAddTextViewControllerDelegate>   delegate;

@end
