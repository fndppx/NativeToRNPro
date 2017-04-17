//
//  QCPasswordUnlockerMacroDefines.h
//  QCPasswordUnlocker
//
//  Created by SXJH on 16/11/24.
//  Copyright © 2016年 SXJH. All rights reserved.
//

#ifndef QCPasswordUnlockerMacroDefines_h
#define QCPasswordUnlockerMacroDefines_h

//获取物理屏幕的尺寸
#define QCScreenHeight  ([UIScreen mainScreen].bounds.size.height)
#define QCScreenWidth   ([UIScreen mainScreen].bounds.size.width)
#define QC_ScreenWidth  ((QCScreenWidth<QCScreenHeight)?QCScreenWidth:QCScreenHeight)
#define QC_ScreenHeight ((QCScreenWidth<QCScreenHeight)?QCScreenHeight:QCScreenWidth)
#define QC_RATE         (QC_ScreenWidth/320.0)
#define QC_RATE_SCALE   (QC_ScreenWidth/375.0)//以ip6为标准 ip5缩小 ip6p放大 zoom
#define QC_RATE_6P      ((QC_ScreenWidth>375.0)?QC_ScreenWidth/375.0:1.0)//只有6p会放大


//颜色
#define QCMakeColor(r,g,b,a) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])
#define QCMakeColorRGB(hex)  ([UIColor colorWithRed:((hex>>16)&0xff)/255.0 green:((hex>>8)&0xff)/255.0 blue:(hex&0xff)/255.0 alpha:1.0])
#define QCMakeColorRGBA(hex,a) ([UIColor colorWithRed:((hex>>16)&0xff)/255.0 green:((hex>>8)&0xff)/255.0 blue:(hex&0xff)/255.0 alpha:a])
#define QCMakeColorARGB(hex) ([UIColor colorWithRed:((hex>>16)&0xff)/255.0 green:((hex>>8)&0xff)/255.0 blue:(hex&0xff)/255.0 alpha:((hex>>24)&0xff)/255.0])

#endif /* QCPasswordUnlockerMacroDefines_h */
