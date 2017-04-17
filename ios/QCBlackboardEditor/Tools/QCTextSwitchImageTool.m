//
//  QCTextSwitchImageTool.m
//  QCBlackboardEditor
//
//  Created by SXJH on 16/12/2.
//  Copyright © 2016年 qingclass. All rights reserved.
//
#define Side_Gap 28

#import "QCTextSwitchImageTool.h"
#import "QCBlackboardEditorMacroDefines.h"
@implementation QCTextSwitchImageTool

+(void)imageFromText:(NSString*) textContent withFont: (CGFloat)fontSize sizeWidth:(CGFloat)sizeWidth responsed:(void(^)(UIImageView * imageView,CGFloat realHeight))responsed
{
    CGFloat gapWidth = Side_Gap;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil];
    
    CGSize textSize = [textContent boundingRectWithSize:CGSizeMake(sizeWidth-gapWidth*2, 10000)
                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic
                                                  context:nil].size;
    CGFloat fHeight = textSize.height;
    
    UILabel * label = [[UILabel alloc]init];
    label.text = textContent;
    label.font = [UIFont systemFontOfSize:fontSize];
    [label sizeToFit];
    
    if (fHeight<=label.frame.size.height)
    {
        gapWidth = ([UIScreen mainScreen].bounds.size.width - textSize.width)/2;
    }
    
    CGSize newSize = CGSizeMake(sizeWidth, sizeWidth*3/4);
    UIGraphicsBeginImageContextWithOptions(newSize,NO,0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetCharacterSpacing(ctx, 1);
    CGContextSetTextDrawingMode (ctx, kCGTextFillStroke);
    CGContextSetRGBFillColor (ctx, 255, 255, 255, 1);
    CGContextFillRect(ctx, CGRectMake(0, 0, sizeWidth, sizeWidth*3/4));
    CGContextSetRGBStrokeColor (ctx, 0, 0, 0, 1);
    CGContextSetLineWidth(ctx, 0.08);
    CGRect rect = CGRectMake(gapWidth, (sizeWidth*3/4-fHeight)/2, textSize.width , fHeight);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [textContent drawInRect:rect withAttributes: @{NSFontAttributeName :[UIFont systemFontOfSize:fontSize], NSForegroundColorAttributeName :QCMakeColor(51, 51, 51, 1),NSParagraphStyleAttributeName:paragraphStyle}];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, sizeWidth, sizeWidth*3/4)];
    imageView.image = image;
    
    if (responsed)
    {
        responsed(imageView,sizeWidth*3/4);
    }
    
}

@end
