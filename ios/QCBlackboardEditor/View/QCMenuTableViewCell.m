//
//  QCMenuTableViewCell.m
//  QCBlackboardEditor
//
//  Created by SXJH on 16/12/2.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#import "QCMenuTableViewCell.h"
@interface QCMenuTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end
@implementation QCMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.text = _menuItem.title;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)_menuItem.count];
    self.headImageView.image = _menuItem.image;
}
+ (CGFloat)getCellRowHeight
{
    return 50;
}
@end
