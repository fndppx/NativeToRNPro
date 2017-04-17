
//
//  QCCarouselAlbumCell.m
//  QCBlackboardEditor
//
//  Created by SXJH on 16/11/29.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#import "QCCarouselAlbumCell.h"
#import "QCBlackboardEditorMacroDefines.h"
#import "QCPhotoManager.h"
@interface QCCarouselAlbumCell()
@property (nonatomic, strong)PHImageRequestOptions *option;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton * deleteBtn;

@end
@implementation QCCarouselAlbumCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    self.option = [[PHImageRequestOptions alloc] init];
    self.option.resizeMode = PHImageRequestOptionsResizeModeFast;
}
- (IBAction)deleteButtonPress:(id)sender
{
    if (self.buttonDeletePress)
    {
        self.buttonDeletePress(self.currentAssetItem);
    }
}

- (void)loadView
{
    QCAssetItem *asset = self.currentAssetItem;
    self.deleteBtn.layer.cornerRadius = self.deleteBtn.frame.size.height/2;
    [self.deleteBtn setTitle:@"" forState:UIControlStateNormal];
    CGSize size = CGSizeMake(400,300);
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    if (asset.isTopperImage)
    {
        self.headImageView.image = asset.image;
    }
    else
    {
        
        if ([[QCPhotoManager shareManager].carouselCacheImageDic objectForKey:asset.asset.localIdentifier])
        {
            self.headImageView.image = [[QCPhotoManager shareManager].carouselCacheImageDic objectForKey:asset.asset.localIdentifier];
        }
        else
        {
            [[PHImageManager defaultManager] requestImageForAsset:asset.asset targetSize:size contentMode:PHImageContentModeAspectFill options:self.option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                UIImageView * srcImageView = [[UIImageView alloc]initWithImage:result];
                UIImage * targetImage = [QCCarouselAlbumCell clipImageInRect:CGRectMake((srcImageView.frame.size.width-size.width)/2, (srcImageView.frame.size.height-size.height)/2, size.width, size.height) srcImage:result];
                self.headImageView.image = targetImage;
                if (result != nil)
                {
                    [[QCPhotoManager shareManager].carouselCacheImageDic setObject:targetImage forKey:asset.asset.localIdentifier];
                }
            }];
        }
    }
}
+ (UIImage *)clipImageInRect:(CGRect)rect srcImage:(UIImage*)image
{
    CGImageRef cgRef = image.CGImage;
    CGImageRef imageRef = CGImageCreateWithImageInRect(cgRef, rect);
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return thumbScale;
}


- (void)setHiddenDeleteBtn:(BOOL)hiddenDeleteBtn
{
    _deleteBtn.hidden = hiddenDeleteBtn;
}

- (UIImageView*)currentShowImageView
{
    return self.headImageView;
}
@end
