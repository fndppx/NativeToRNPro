//
//  QCBlackboardAddTextViewController.m
//  QCBlackboardEditor
//
//  Created by 0dayZh on 2016/11/25.
//  Copyright © 2016年 qingclass. All rights reserved.
//
#define MAX_LIMITLENGTH 70//最大字数限制
#import "QCBlackboardAddTextViewController.h"
#import "QCTextSwitchImageTool.h"
#import "QCBlackboardEditorMacroDefines.h"
@interface QCBlackboardAddTextViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@end

@implementation QCBlackboardAddTextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initlimitLabelColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)initlimitLabelColor
{
    self.limitLabel.textColor = QCMakeColor(204, 204, 204, 1);
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"还能输入%d个字",MAX_LIMITLENGTH]];
    NSRange range = [text.string rangeOfString:@"70"];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]range:range];
    self.limitLabel.attributedText = text;
}
#pragma mark - UITextViewDelegate

#pragma mark - Action

- (IBAction)cancelButtonPressed:(id)sender
{
    [self.view endEditing:YES];
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonPressed:(id)sender
{
    if (self.textView.text.length == 0)
    {
        [self createAlertViewWithMessage:@"文字不能为空!"];
        return;
    }
    if (self.textView.text.length>MAX_LIMITLENGTH) {
        [self createAlertViewWithMessage:@"文字超出最大限度!"];
        return;
    }
    __weak typeof(self)weakSelf = self;
    [QCTextSwitchImageTool imageFromText:self.textView.text withFont:21 sizeWidth:[UIScreen mainScreen].bounds.size.width responsed:^(UIImageView *imageView, CGFloat realHeight) {
        if ([weakSelf.delegate respondsToSelector:@selector(blackboardAddTextViewController:didAddTextImageView:)]) {
            [weakSelf.delegate blackboardAddTextViewController:weakSelf didAddTextImageView:imageView];
            [weakSelf cancelButtonPressed:nil];
        }
    }];
}
#pragma mark - textViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""])
    {
        return YES;
    }
    if (textView.text.length>MAX_LIMITLENGTH-1)
    {
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger textNumber = MAX_LIMITLENGTH-textView.text.length;
    NSMutableAttributedString *text;
    if (textNumber<0) {
        textNumber = labs(textNumber);
        text = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"您已超出%ld个字",(unsigned long)textNumber]];
        NSRange range = [text.string rangeOfString:[NSString stringWithFormat:@"%ld",textNumber]];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]range:range];
    }
    else
    {
        textNumber = labs(textNumber);
        text = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"还能输入%ld个字",(unsigned long)textNumber]];
        NSRange range = [text.string rangeOfString:[NSString stringWithFormat:@"%ld",textNumber]];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]range:range];
    }
    
      self.limitLabel.attributedText = text;
}

- (void)createAlertViewWithMessage:(NSString*)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
