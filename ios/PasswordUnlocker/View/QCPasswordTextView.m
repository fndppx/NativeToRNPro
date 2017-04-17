//
//  QCPasswordTextView.m
//  QCPasswordUnlocker
//
//  Created by SXJH on 16/11/24.
//  Copyright © 2016年 SXJH. All rights reserved.
//

#import "QCPasswordTextView.h"
#import "QCPasswordUnlockerMacroDefines.h"

@interface QCPasswordTextView()
{
    BOOL _isEditing;
}
@property (nonatomic,strong) UIView * contentView;
@end
@implementation QCPasswordTextView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = QCMakeColor(151, 151, 151, 1);
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(1, 1, frame.size.width-2, frame.size.height-2)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height)];
        _numberLabel.backgroundColor = [UIColor clearColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:_numberLabel];
    }
    return self;
}
- (void)setNumber:(NSString *)number
{
    [self willChangeValueForKey:@"number"];

    if (number.length==0)
    {
        _numberLabel.text = number;
    }
    else
    {
        _numberLabel.text = @"●";
    }
    [self didChangeValueForKey:@"number"];

}
- (void)setEditing:(BOOL)editing
{
    [self willChangeValueForKey:@"editing"];
    _isEditing = editing;
    if (_isEditing)
    {
        self.backgroundColor = QCMakeColor(0, 162, 255, 1);
    }
    else
    {
        self.backgroundColor = QCMakeColor(151, 151, 151, 1);
    }
    [self willChangeValueForKey:@"editing"];


}
- (void)setCorners:(UIRectCorner)corners
{
    [self willChangeValueForKey:@"corners"];
    UIBezierPath *outsideMaskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *outsideMaskLayer = [[CAShapeLayer alloc] init];
    outsideMaskLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    outsideMaskLayer.path = outsideMaskPath.CGPath;
    self.layer.masksToBounds = YES;
    self.layer.mask = outsideMaskLayer;
    
    UIBezierPath *insideMaskPath = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *insideMaskLayer = [[CAShapeLayer alloc] init];
    insideMaskLayer.frame = _contentView.bounds;
    insideMaskLayer.path = insideMaskPath.CGPath;
    _contentView.layer.masksToBounds = YES;
    _contentView.layer.mask = insideMaskLayer;
    [self didChangeValueForKey:@"corners"];

}

- (BOOL)isEditing
{
    return _isEditing;
}

@end
