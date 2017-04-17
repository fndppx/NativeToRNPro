//
//  QCPasswordTextView.h
//  QCPasswordUnlocker
//
//  Created by SXJH on 16/11/24.
//  Copyright © 2016年 SXJH. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface QCPasswordTextView : UIView
@property (nonatomic,strong) UITextField * textField;
@property (nonatomic,assign) NSString * number;
@property (nonatomic,assign,getter=isEditing) BOOL editing;
@property (nonatomic,assign) UIRectCorner corners;
@property (nonatomic,strong) UILabel * numberLabel;
@end
