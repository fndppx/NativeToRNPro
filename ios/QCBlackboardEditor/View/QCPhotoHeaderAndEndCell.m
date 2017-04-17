//
//  QCPhotoHeaderAndEndCell.m
//  QCBlackboardEditor
//
//  Created by SXJH on 16/11/29.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#import "QCPhotoHeaderAndEndCell.h"
@interface QCPhotoHeaderAndEndCell()
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@end
@implementation QCPhotoHeaderAndEndCell
- (void)setIsHeader:(BOOL)isHeader
{
    _endLabel.hidden = isHeader;
    _headerLabel.hidden = !isHeader;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    _endLabel.hidden = NO;
    _headerLabel.hidden = NO;
    // Initialization code
}

@end
