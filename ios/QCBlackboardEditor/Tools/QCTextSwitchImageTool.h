//
//  QCTextSwitchImageTool.h
//  QCBlackboardEditor
//
//  Created by SXJH on 16/12/2.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QCTextSwitchImageTool : NSObject
+(void)imageFromText:(NSString*) textContent withFont: (CGFloat)fontSize sizeWidth:(CGFloat)sizeWidth responsed:(void(^)(UIImageView * imageView,CGFloat realHeight))responsed;
@end
