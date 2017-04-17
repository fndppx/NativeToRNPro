//
//  QCLevelScrollView.h
//  QCBlackboardEditor
//
//  Created by SXJH on 16/11/29.
//  Copyright © 2016年 qingclass. All rights reserved.
//
#define QCLevelScrollViewHeight 168*QC_RATE_SCALE

#define QCRiseLength 128*QC_RATE_SCALE

#import <UIKit/UIKit.h>
#import "QCAssetItem.h"
@interface QCLevelScrollView : UIView

/**
 更正image标注位置
 */
@property (nonatomic,copy)void(^amendmentLocationResponsed)();

/**
 放大或者缩小状态改变
 */
@property (nonatomic,copy)void(^scaleBigOrSmallResponsed)();

/**
 点击删除图片
 */
@property (nonatomic,copy)void(^deleteSelectPhotoResponsed)(QCAssetItem * item);

/**
 初始化插入位置
 */
@property (nonatomic,assign) NSInteger initSubscript;

/**
 scrollview偏移量
 */
@property (nonatomic,assign) CGFloat scrollViewOffset;
/**
 隐藏指针
 */
@property (nonatomic,assign,getter=isHiddenPoint) BOOL hiddenPoint;

/**
 是否放大
 */
@property (readonly,nonatomic,assign,getter=isBlowUped) BOOL blowUped;

/**
 当前屏幕中间位置的图片索引
 */
@property (nonatomic,assign) NSInteger indexRowOfCurrentScreenMiddleView;

/**
 是否可以拖拽
 */
@property (nonatomic,assign,readonly) BOOL isCanDrag;

/**
 插入数组
 */
@property (nonatomic,strong) NSArray * insertImageArray;


/**
 初始化方法

 @param frame frame
 @param imageArray 初始化的图片数组
 @return self
 */
//- (id)initWithFrame:(CGRect)frame initializeImageArray:(NSArray*)imageArray;

/**
 添加图片item

 @param item 图片的item
 */
- (void)addAssetItem:(QCAssetItem*)item;

/**
 删除图片item

 @param item 图片的item
 */
- (void)deleteAssetItem:(QCAssetItem*)item;

/**
 当上层拖动按钮时来控制内部view的位置改变方法

 @param point 上层拖动y坐标
 @param offset 当前ScrollView的起始offset
 @param indexRow 当前屏幕中间的cell的index
 @param isReachEnded 是否拖动到最底部
 */
- (void)pointOfPanGersture:(CGFloat)point  withOffset:(CGFloat)offset indexRow:(NSInteger)indexRow isReachEnded:(BOOL)isReachEnded;

/**
 获取image数组
 */
- (NSArray*)getArrayOfAllImageView;

/**
 重新加载数据
 */
- (void)reloadCollectionData;

@end
