//
//  QCPasswordTextView.m
//  QCPasswordUnlocker
//
//  Created by SXJH on 16/11/24.
//  Copyright © 2016年 SXJH. All rights reserved.
//

#import "QCPasswordView.h"
#import "QCPasswordUnlockerMacroDefines.h"
#import "QCPasswordTextView.h"
static const int buttonTag = 10000;
@interface QCPasswordView()<UITextFieldDelegate>
{
    int _subscript;
    BOOL _isHaveAnimation;
}
@property (nonatomic,strong)UIView * backgroundView;
@property (nonatomic,strong)UIView * inputView;
@property (nonatomic,strong)UILabel * alertTitleLabel;
@property (nonatomic,strong)NSString * currentTitle;
@property (nonatomic,strong)NSMutableString * passwordString;
@property (nonatomic,copy)void(^buttonPressResponsed) (NSString * passwordStr);

@end
@implementation QCPasswordView

+(id)initWithTitle:(NSString *)title enterIntoRoomButtonPressResponsed:(void(^)(NSString * passwordStr))responsed
{
    QCPasswordView * passwordView = [[QCPasswordView alloc] init];
    [passwordView initWithTitle:title enterIntoRoomButtonPressResponsed:responsed];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:passwordView];
    return passwordView;
}
-(void)initWithTitle:(NSString *)title enterIntoRoomButtonPressResponsed:(void(^)(NSString * passwordStr))responsed
{
    if (self.buttonPressResponsed==nil)
    {
        self.buttonPressResponsed = responsed;
    }
    
    [self addObserver];
    _passwordString = [[NSMutableString alloc]initWithCapacity:0];
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    self.frame =CGRectMake(0, 0, width, height);
    self.currentTitle = title;
    
}

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSValue *aValue = [[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    if (_isHaveAnimation)
    {
        [UIView animateWithDuration:0.4 animations:^{
            _inputView.frame = CGRectMake(0, self.frame.size.height - keyboardHeight - _inputView.frame.size.height, _inputView.frame.size.width, _inputView.frame.size.height);
        }];
    }
   
}

- (void)showAnimated:(BOOL)animated
{
    _isHaveAnimation = animated;
    [self createView];
}

- (void)createView
{
    _backgroundView = [[UIView alloc] initWithFrame:self.frame];
    _backgroundView.backgroundColor = QCMakeColor(0, 0, 0, 0.3);
    [self addSubview:_backgroundView];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundViewTap)];
    [_backgroundView addGestureRecognizer:tapGesture];
    
    if (_isHaveAnimation)
    {
        _inputView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, _backgroundView.frame.size.width, 261*QC_RATE_SCALE)];
    }
    else
    {
        _inputView = [[UIView alloc]initWithFrame:CGRectMake(0,self.frame.size.height - 216 - 261*QC_RATE_SCALE , _backgroundView.frame.size.width, 261*QC_RATE_SCALE)];
    }
    _inputView.backgroundColor = [UIColor whiteColor];
    [_backgroundView addSubview:_inputView];

    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(89*QC_RATE_SCALE, 41.5*QC_RATE_6P, 17.4*1.1*QC_RATE_6P, 16.5*1.1*QC_RATE_6P)];
    imageView.image = [UIImage imageNamed:@"room"];
    [_inputView addSubview:imageView];
    
    
    NSString * title = self.currentTitle;
    CGSize size = [self textTitle:title withFont:20.f];
    CGFloat totalWidth = imageView.frame.size.width + size.width + 7.6;

    if (totalWidth>self.frame.size.width-20) {
        totalWidth = self.frame.size.width-20;
        size.width = totalWidth - imageView.frame.size.width - 7.6;
    }
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame), 37*QC_RATE_6P, size.width, 28*QC_RATE_6P)];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:20.f];
    titleLabel.textColor = QCMakeColor(102, 102, 102, 1);
    [_inputView addSubview:titleLabel];

    imageView.frame = CGRectMake((self.frame.size.width-totalWidth)/2, imageView.frame.origin.y,  imageView.frame.size.width, imageView.frame.size.height);
    titleLabel.frame = CGRectMake(CGRectGetMaxX(imageView.frame)+7.6, 37*QC_RATE_6P, size.width, 28*QC_RATE_6P);
    
    UIButton * enterRoomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    enterRoomButton.frame = CGRectMake((self.frame.size.width-209*QC_RATE_SCALE)/2, 201*QC_RATE_SCALE, 209*QC_RATE_SCALE, 35*QC_RATE_SCALE);
    enterRoomButton.backgroundColor = QCMakeColor(0, 162, 255, 1);
    [enterRoomButton setTitle:@"进入房间" forState:UIControlStateNormal];
    [enterRoomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    enterRoomButton.layer.cornerRadius = enterRoomButton.frame.size.height/2;
    [enterRoomButton addTarget:self action:@selector(enterRoomButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [_inputView addSubview:enterRoomButton];
    
    _inputView.userInteractionEnabled = YES;
    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.delegate = self;
    textField.hidden = YES;
    [_inputView addSubview:textField];
    [textField becomeFirstResponder];

    _alertTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake((_inputView.frame.size.width-130*QC_RATE_SCALE)/2, 164*QC_RATE_SCALE, 130*QC_RATE_SCALE, 17*QC_RATE_SCALE)];
    _alertTitleLabel.text = @"密码错误请重新输入";
    _alertTitleLabel.hidden = YES;
    _alertTitleLabel.textAlignment = NSTextAlignmentCenter;
    _alertTitleLabel.font = [UIFont systemFontOfSize:12];
    _alertTitleLabel.textColor = QCMakeColor(255, 76, 58, 1);
    [_inputView addSubview:_alertTitleLabel];
    
    for (int i = 0; i<4; i++)
    {
        QCPasswordTextView * textView = [[QCPasswordTextView alloc]initWithFrame:CGRectMake(75*QC_RATE_SCALE+(53*QC_RATE_SCALE+5)*i, 90*QC_RATE_SCALE, 53*QC_RATE_SCALE, 64*QC_RATE_SCALE)];
        if (i == 0)
        {
            textView.editing = YES;
            textView.corners = UIRectCornerBottomLeft|UIRectCornerTopLeft;
        }
        if (i == 3)
        {
            textView.corners = UIRectCornerBottomRight|UIRectCornerTopRight;
        }
        textView.tag = buttonTag+i;
        [_inputView addSubview:textView];
    }
}
- (void)setShowErrorTip:(BOOL)showErrorTip
{
    [self willChangeValueForKey:@"showErrorTip"];
    _alertTitleLabel.hidden = !showErrorTip;
    [self didChangeValueForKey:@"showErrorTip"];
}
- (void)enterRoomButtonPress
{
    if (self.passwordString.length!=4)
    {
        NSLog(@"error");
    }
    else
    {
        if (self.buttonPressResponsed)
        {
            self.buttonPressResponsed(self.passwordString);
        }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""])
    {
        if (_subscript>0)
        {
            _subscript--;
        }
        QCPasswordTextView * view = (QCPasswordTextView*)[_inputView viewWithTag:_subscript+buttonTag];
        view.number = @"";
        [_passwordString deleteCharactersInRange:NSMakeRange(_passwordString.length-1, 1)];
        if (_subscript!=0)
        {
            view.editing = NO;
        }
        return YES;
    }
    if (_subscript>3)
    {
        return NO;
    }
    QCPasswordTextView * view = (QCPasswordTextView*)[_inputView viewWithTag:_subscript+buttonTag];
    view.editing = YES;
    view.number = string;
    [_passwordString appendString:string];
    _subscript++;
    
    return YES;
}
- (void)dismissAnimated:(BOOL)animated
{
    _isHaveAnimation = animated;
    [self backgroundViewTap];
}
- (void)backgroundViewTap
{
    [self endEditing:YES];
    if (_isHaveAnimation)
    {
        [UIView animateWithDuration:0.6 animations:^{
            _backgroundView.alpha = 0;
            _inputView.frame = CGRectMake(0, self.frame.size.height, _inputView.frame.size.width, _inputView.frame.size.height);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    else
    {
        [self removeFromSuperview];
    }
  
}

- (CGSize)textTitle:(NSString*)title withFont:(float)font
{
    CGSize messageSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, font) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
    return messageSize;
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
