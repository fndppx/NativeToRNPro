//
//  QCAlbumCell.m
//  QCBlackboardEditor
//
//  Created by SXJH on 16/11/28.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#import "QCAlbumCell.h"
#import <Photos/Photos.h>
#import "QCBlackboardEditorMacroDefines.h"
#import "QCPhotoManager.h"
@interface QCAlbumCell()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIView *cornerView;
@property (weak, nonatomic) IBOutlet UILabel *cornerLabel;
@property (nonatomic, strong)PHImageRequestOptions *option;
@property (nonatomic,strong) UIImageView *checkBox;
@property (nonatomic,strong) NSString * currentIndex;
@property (nonatomic,strong) NSMutableDictionary *cacheImageDic;
@end
@implementation QCAlbumCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    self.option = [[PHImageRequestOptions alloc] init];
    self.option.resizeMode = PHImageRequestOptionsResizeModeFast;
    self.cacheImageDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    self.cornerLabel.adjustsFontSizeToFitWidth = YES;
}
- (IBAction)buttonPress:(id)sender
{
    if (self.cellPressResponsed)
    {
        self.cellPressResponsed();
    }
}
- (void)setIndex:(NSString *)index
{
    self.cornerLabel.text = index;
}
- (void)loadView
{
    QCAssetItem *asset = self.currentAsset;
    self.cornerView.layer.cornerRadius = self.cornerView.frame.size.height/2;
    CGSize size = CGSizeMake(200,150);

    self.cornerView.hidden = !asset.selected;
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.cornerLabel.text = [NSString stringWithFormat:@"%ld",asset.index+1];

    if ([[QCPhotoManager shareManager].cacheImageDic objectForKey:asset.asset.localIdentifier])
    {
        self.photoImageView.image = [[QCPhotoManager shareManager].cacheImageDic objectForKey:asset.asset.localIdentifier];
    }
    else
    {
        [[PHImageManager defaultManager] requestImageForAsset:asset.asset targetSize:size contentMode:PHImageContentModeAspectFill options:self.option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            self.photoImageView.image = result;
            if (result != nil)
            {
                [[QCPhotoManager shareManager].cacheImageDic setObject:result forKey:asset.asset.localIdentifier];
            }
        }];
    }
   
}

@end
