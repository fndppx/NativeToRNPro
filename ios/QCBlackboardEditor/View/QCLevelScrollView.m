//
//  QCLevelScrollView.m
//  QCBlackboardEditor
//
//  Created by SXJH on 16/11/29.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#import "QCLevelScrollView.h"
#import "QCCarouselAlbumCell.h"
#import "QCAssetItem.h"
#import "QCPhotoHeaderAndEndCell.h"
#import "QCBlackboardEditorMacroDefines.h"
#import "QCPhotoManager.h"
#define QCBetweenImageGap  15.f
#define QCRealWidth (QC_ScreenWidth-30)/3
#define QCRealHeigh  105*QCRealWidth/130
#define QCScaleMultiple 1.5f

@interface QCLevelScrollView()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGFloat _insertLocation;//当前插入的位置
    CGFloat _currentOffset;//ScrollView偏移
    BOOL _isSelectedHeader;//是否选择了第一张
    BOOL _isInsertHeader;//是否插在第一张
    CGSize _collectionCellItemSize;//item的大小
    CGFloat _currentGrowSize;
    BOOL _isReachEnded;
    BOOL _isScaleBig;
    BOOL _isCanDrag;
    BOOL _isReloadingData;
    CGFloat  _lastContentOffX;//记录上次位置判断滑动方向

}
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic, strong)NSMutableArray * imageViewArray;//数据源
@property (nonatomic, strong)NSArray * initialImageArray;//默认初始化的图片数组
@property (nonatomic, strong)UIView * pointView;//插入点
@property (nonatomic, strong)UIView * basePointView;//屏幕中心点view
@property (nonatomic, strong)UIImageView * realPointView;//插入点图片
@property (nonatomic, strong)UILabel * pageLabel;
@property (nonatomic, strong)UIVisualEffectView * effectView;
@end
@implementation QCLevelScrollView
- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame])
    {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _effectView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:_effectView];
        [self initCollectionView];
    }
    return self;
}
- (void)setInsertImageArray:(NSArray *)insertImageArray
{
    [self willChangeValueForKey:@"insertImageArray"];
    _initialImageArray = insertImageArray;
    int count = 0;
    for (UIImage * image in _initialImageArray)
    {
        QCAssetItem * item = [[QCAssetItem alloc]init];
        item.albumLocationType = QCAlbumLocationTypeMiddle;
        item.isTopperImage = YES;
        item.image = image;
        item.index = count;
        [_imageViewArray insertObject:item atIndex:_imageViewArray.count-1];
        count++;
    }
    double gapWidth = QCBetweenImageGap;

    if (_initialImageArray.count>0)
    {
        _pointView.frame = CGRectMake((self.frame.size.width-2)/2+(QCRealWidth+gapWidth)/2, 100, 2, 100);
        _insertLocation = _pointView.frame.origin.x;
    }
    [self didChangeValueForKey:@"insertImageArray"];

}

- (void)initCollectionView
{
    _imageViewArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<2; i++)
    {
        QCAssetItem * item = [[QCAssetItem alloc]init];
        if (i==0)
        {
            item.albumLocationType = QCAlbumLocationTypeHeader;
        }
        else
        {
            item.albumLocationType = QCAlbumLocationTypeEnd;
        }
        [_imageViewArray addObject:item];
    }
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 16, self.frame.size.width, QCRealHeigh) collectionViewLayout:flowLayout];
    [_collectionView registerNib:[UINib nibWithNibName:@"QCCarouselAlbumCell"bundle:nil]forCellWithReuseIdentifier:@"QCCarouselAlbumCellidentifier"];
    [_collectionView registerNib:[UINib nibWithNibName:@"QCPhotoHeaderAndEndCell"bundle:nil]forCellWithReuseIdentifier:@"QCPhotoHeaderAndEndCellIdentifier"];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.bounces = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self addSubview:_collectionView];
    
    _pageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,self.frame.size.height-30, _collectionView.frame.size.width, 25)];
    _pageLabel.text = @"1/20";
    _pageLabel.hidden = YES;
    _pageLabel.textColor = [UIColor whiteColor];
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_pageLabel];
    
    _pointView = [[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width-2)/2, 100, 2, 100)];
    _pointView.backgroundColor = [UIColor clearColor];
    [self addSubview:_pointView];
    [_pointView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    
    _basePointView = [[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width-1)/2, 0, 1, 168)];
    _basePointView.backgroundColor = [UIColor clearColor];
    [self addSubview:_basePointView];
    
    _realPointView = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-self.frame.size.height*23/177)/2, 0,self.frame.size.height*23/177, self.frame.size.height)];
    _realPointView.image = [UIImage imageNamed:@"compass_icon"];
    [self addSubview:_realPointView];

    _collectionCellItemSize = CGSizeMake(QCRealWidth, QCRealHeigh);
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"])
    {
        self.realPointView.center = CGPointMake(self.pointView.center.x, self.realPointView.center.y);
    }
}

#pragma mark - SeterAndGeter
- (void)setInitSubscript:(NSInteger)initSubscript
{
    [self willChangeValueForKey:@"initSubscript"];
    double gapWidth = QCBetweenImageGap;
    [self.collectionView setContentOffset:CGPointMake((initSubscript)*(QCRealWidth+gapWidth), 0) animated:NO];
    
    if (initSubscript < 0)
    {
        initSubscript = 0;
    }
    if (initSubscript == 0)
    {
        CGFloat tempGapWidth = QCBetweenImageGap/2;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:initSubscript inSection:0];
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.row]];
        QCCarouselAlbumCell * cell = (QCCarouselAlbumCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        CGRect parentRect = [self.collectionView convertRect:cell.frame toView:self];
        _isSelectedHeader = YES;
        _pointView.frame = CGRectMake(parentRect.origin.x + parentRect.size.width + tempGapWidth , _pointView.frame.origin.y, _pointView.frame.size.width, _pointView.frame.size.height);
    }
    else
    {
        [self.collectionView setContentOffset:CGPointMake((initSubscript-1)*(QCRealWidth+gapWidth), 0) animated:NO];
    }
    
    _insertLocation = _pointView.frame.origin.x;
    [self didChangeValueForKey:@"initSubscript"];
}

- (void)setHiddenPoint:(BOOL)hiddenPoint
{
    [self willChangeValueForKey:@"hiddenPoint"];
    _hiddenPoint = hiddenPoint;
    
    if (!_hiddenPoint)
    {
        double delayInSeconds = 0.2;
        dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), ^(void){
            [self findCurrentSelectView];
            [UIView animateWithDuration:1 animations:^{
                _realPointView.hidden = _hiddenPoint;
                
            }];
        });
    }
    else
    {
        _realPointView.hidden = _hiddenPoint;
    }
    [self didChangeValueForKey:@"hiddenPoint"];

}

- (NSArray*)getArrayOfAllImageView
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 1; i<self.imageViewArray.count-1; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        QCCarouselAlbumCell * cell = (QCCarouselAlbumCell*)[self collectionView:self.collectionView cellForItemAtIndexPath:indexPath];
        UIImageView * imageView = cell.currentShowImageView;
        [array addObject:imageView.image];
    }

    return [array copy];
}

- (BOOL)isBlowUped
{
    return _isScaleBig;
}

- (CGFloat)scrollViewOffset
{
    return self.collectionView.contentOffset.x;
}

- (NSInteger)indexRowOfCurrentScreenMiddleView
{
    return [self findCurrentViewMiddleCell];
}

- (BOOL)isCanDrag
{
    return _isCanDrag;
}

#pragma mark -CollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageViewArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isReloadingData) {
        return;
    }
    QCAssetItem *currentAsset = self.imageViewArray[indexPath.row];
    if (currentAsset.asset.localIdentifier.length != 0)
    {
        [[QCPhotoManager shareManager].carouselCacheImageDic removeObjectForKey:currentAsset.asset.localIdentifier];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    _isCanDrag = self.imageViewArray.count>2;
    QCAssetItem * assetItem = self.imageViewArray[indexPath.row];
    assetItem.index = indexPath.row-1;
    if (assetItem.albumLocationType == QCAlbumLocationTypeHeader||assetItem.albumLocationType == QCAlbumLocationTypeEnd)
    {
        QCPhotoHeaderAndEndCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QCPhotoHeaderAndEndCellIdentifier" forIndexPath:indexPath];
        cell.isHeader = indexPath.row==0;
        return cell;
    }
    else
    {
        QCCarouselAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QCCarouselAlbumCellidentifier" forIndexPath:indexPath];
        cell.currentAssetItem = assetItem;
        cell.backgroundColor = [UIColor redColor];
        [cell loadView];
        __weak typeof(self)weakSelf = self;
        cell.buttonDeletePress = ^(QCAssetItem * item){
            if (weakSelf.deleteSelectPhotoResponsed)
            {
                weakSelf.deleteSelectPhotoResponsed(item);
            }
        };
        [cell setHiddenDeleteBtn:_isScaleBig];
        
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _collectionCellItemSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, [self leftOrRightGapWidth], 0, [self leftOrRightGapWidth]);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.imageViewArray.count<3)
    {
        return (self.frame.size.width-2*QCRealWidth);
    }
    else
    {
        return QCBetweenImageGap;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.imageViewArray.count<3)
    {
        return;
    }
    CGFloat tempGapWidth = QCBetweenImageGap/2;
    QCCarouselAlbumCell * cell = (QCCarouselAlbumCell*)[collectionView cellForItemAtIndexPath:indexPath];
    CGRect parentRect = [self.collectionView convertRect:cell.frame toView:self];
    
    if (indexPath.row == 0)
    {
        _isSelectedHeader = YES;
        _pointView.frame = CGRectMake(parentRect.origin.x + parentRect.size.width + tempGapWidth , _pointView.frame.origin.y, _pointView.frame.size.width, _pointView.frame.size.height);
        
    }
    else if (indexPath.row == self.imageViewArray.count-1)
    {
        _isSelectedHeader = NO;
        _isInsertHeader = NO;
        _pointView.frame = CGRectMake(parentRect.origin.x - tempGapWidth, _pointView.frame.origin.y, _pointView.frame.size.width, _pointView.frame.size.height);
    }
    
    _insertLocation = _pointView.frame.origin.x;
    
}

#pragma mark - SrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _currentOffset = scrollView.contentOffset.x;
    if (_isReachEnded)
    {
        if (scrollView.contentOffset.x<_lastContentOffX && fabs(scrollView.contentOffset.x)>=1)
        {
            if (scrollView.contentOffset.x <= (QCBetweenImageGap+QCRealWidth+QCRiseLength*QCScaleMultiple))
            {
                [scrollView setContentOffset:CGPointMake((QCBetweenImageGap+QCRealWidth+QCRiseLength*QCScaleMultiple), 0)];
                return;
            }
            
        }
        else if (scrollView.contentOffset.x>_lastContentOffX && fabs(scrollView.contentOffset.x)>1)
        {
            
            if (scrollView.contentOffset.x >= (QCBetweenImageGap+QCRealWidth+QCRiseLength*QCScaleMultiple)*(self.imageViewArray.count-2))
            {
                [scrollView setContentOffset:CGPointMake((QCBetweenImageGap+QCRealWidth+QCRiseLength*QCScaleMultiple)*(self.imageViewArray.count-2), 0)];
                return;

            }
            
        }
    }
    
    if (!_isSelectedHeader)
    {
        [self findCurrentSelectView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _lastContentOffX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _isSelectedHeader = NO;
    _isInsertHeader = NO;
    [self findCurrentSelectView];
    
    NSInteger row = [self findCurrentViewMiddleCell];
    
    if (_isReachEnded)
    {
        [self.collectionView setContentOffset:CGPointMake((QCBetweenImageGap+QCRealWidth+QCRiseLength*QCScaleMultiple)*row, 0)animated:YES];
        _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",row,self.imageViewArray.count-2];

    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSInteger row = [self findCurrentViewMiddleCell];
    if (_isReachEnded)
    {
        [self.collectionView setContentOffset:CGPointMake((QCBetweenImageGap+QCRealWidth+QCRiseLength*QCScaleMultiple)*row, 0) animated:YES];
        _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",row,self.imageViewArray.count-2];

    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _isSelectedHeader = NO;
    _isInsertHeader = NO;
    [self findCurrentSelectView];
}

#pragma mark - 查找位置
//查找插入点
- (void)findCurrentSelectView
{
    CGFloat tempWidth = QCBetweenImageGap/2;
    for (QCCarouselAlbumCell * cell in self.collectionView.visibleCells)
    {
        CGRect parentRect = [self.collectionView convertRect:cell.frame toView:self];
        CGRect parentRectCompare = [self.collectionView convertRect:cell.frame toView:self];
        
        if (parentRect.origin.x>0&&parentRect.origin.x + parentRect.size.width<self.collectionView.frame.size.width)
        {
            parentRectCompare.origin.x = parentRectCompare.origin.x-tempWidth;
            parentRectCompare.size.width = parentRectCompare.size.width+tempWidth*2;
            if (CGRectIntersectsRect(_basePointView.frame,parentRectCompare))
            {
                double endValue = (parentRectCompare.origin.x+parentRectCompare.size.width-(QCRealWidth+tempWidth*2)/2)-self.frame.size.width/2;
                [UIView animateWithDuration:0 animations:^{
                    if (endValue>1)//有误差所以为1
                    {
                        _insertLocation = parentRectCompare.origin.x;
                        _pointView.frame = CGRectMake(parentRectCompare.origin.x, _pointView.frame.origin.y, _pointView.frame.size.width, _pointView.frame.size.height);
                    }
                    else
                    {
                        _insertLocation = parentRectCompare.origin.x+parentRectCompare.size.width;
                        
                        _pointView.frame = CGRectMake(parentRectCompare.origin.x+parentRectCompare.size.width, _pointView.frame.origin.y, _pointView.frame.size.width, _pointView.frame.size.height);
                    }
                    
                }];
                
                break;
            }
        }
    }
}

//查找中心位置cell的index
- (NSInteger)findCurrentViewMiddleCell
{
    CGFloat tempWidth = QCBetweenImageGap/2;
    for (QCCarouselAlbumCell * cell in self.collectionView.visibleCells)
    {
        CGRect parentRect1 = [self.collectionView convertRect:cell.frame toView:self];
        parentRect1.origin.x = parentRect1.origin.x-tempWidth;
        parentRect1.size.width = parentRect1.size.width+tempWidth*2;
        if (CGRectIntersectsRect(_basePointView.frame,parentRect1))
        {
            NSIndexPath * indexPath =   [self.collectionView indexPathForCell:cell];
            
            return indexPath.row;
            break;
        }
        
    }
    return 0;
}

//ScrollView在5上边有一个位置的bug需要修正 例如手动给ScrollView设置offset 为1.123456  但是实际上 ScrollView的offset 为 1.000000 累加多次会出现位置不精确问题
- (void)amendmentScrollViewOffsetHandle
{
    CGFloat tempWidth = QCBetweenImageGap/2;
    for (QCCarouselAlbumCell * cell in self.collectionView.visibleCells)
    {
        CGRect parentRect1 = [self.collectionView convertRect:cell.frame toView:self];
        parentRect1.origin.x = parentRect1.origin.x-tempWidth;
        parentRect1.size.width = parentRect1.size.width+tempWidth*2;
        if (CGRectIntersectsRect(_basePointView.frame,parentRect1))
        {
            CGFloat point = parentRect1.origin.x + parentRect1.size.width/2;
            if (fabs(point - _basePointView.frame.origin.x) < 1)
            {
                [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentSize.width - self.collectionView.frame.size.width , 0) animated:YES];
                [self findCurrentSelectView];
                break;
            }
        }
    }
}

#pragma mark - 增加删除图片
- (void)addAssetItem:(QCAssetItem*)item
{
    if (_pointView.frame.origin.x == (self.frame.size.width-2)/2)
    {
        [_imageViewArray insertObject:item atIndex:_imageViewArray.count-1];
        [self preventRepatLoadHandle];
    }
    else
    {
        CGFloat tempWidth = QCBetweenImageGap;
        NSString * index = [NSString stringWithFormat:@"%f",(self.collectionView.contentOffset.x + _insertLocation +15)/(QCRealWidth+tempWidth)];
        NSInteger indexRow = [index integerValue];
        [_imageViewArray insertObject:item atIndex:indexRow];
        [self preventRepatLoadHandle];
    }
    [self addOrDeleteItem:YES];
}

- (void)preventRepatLoadHandle
{
    [self reloadCollectionData];
}

- (void)reloadCollectionData
{
    _isReloadingData = YES;
    [self.collectionView reloadData];
    _isReloadingData = NO;
}

- (void)deleteAssetItem:(QCAssetItem*)item
{
    [_imageViewArray removeObject:item];
    if (_imageViewArray.count<3)
    {
        _isSelectedHeader = NO;
    }
    [self preventRepatLoadHandle];
    [self addOrDeleteItem:NO];
}

- (void)reloadViewWithitem:(QCAssetItem*)item
{
    if (_pointView.frame.origin.x == (self.frame.size.width-2)/2)
    {
        [_imageViewArray insertObject:item atIndex:_imageViewArray.count-1];
        [self reloadCollectionData];
    }
    else
    {
        CGFloat tempWidth = (self.frame.size.width-3*QCRealWidth)/2;
        NSString * index = [NSString stringWithFormat:@"%f",(self.collectionView.contentOffset.x + _insertLocation +15)/(QCRealWidth+tempWidth)];
        NSInteger indexRow = [index integerValue];
        [_imageViewArray insertObject:item atIndex:indexRow];
        [self reloadCollectionData];
    }
}
- (void)addOrDeleteItem:(BOOL)isAddItem
{
    double delayInSeconds = 0.2;
    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), ^(void){
        [self updateCollectViewOffsetWithIsAddItem:isAddItem];
    });
}
- (void)updateCollectViewOffsetWithIsAddItem:(BOOL)isAddItem
{
    for (int i = 0; i<self.imageViewArray.count; i++)
    {
        QCAssetItem * assetItem = self.imageViewArray[i];
        assetItem.index = i-1;
    }
    
    if (self.amendmentLocationResponsed)
    {
        self.amendmentLocationResponsed();
    }
    
    if (isAddItem)
    {
        CGFloat imageGapWidth = QCBetweenImageGap;
        
        if ( self.imageViewArray.count>3)
        {
            _currentOffset += QCRealWidth + imageGapWidth;
            if (_isSelectedHeader)
            {
                [self.collectionView setContentOffset:CGPointMake(_currentOffset , 0) animated:YES];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                
                QCCarouselAlbumCell * cell = (QCCarouselAlbumCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
                CGRect parentRect = [self.collectionView convertRect:cell.frame toView:self];
                CGFloat gap= QCBetweenImageGap/2;
                
                if (!_isInsertHeader)
                {
                    _pointView.frame = CGRectMake(parentRect.origin.x+parentRect.size.width+ gap, _pointView.frame.origin.y, _pointView.frame.size.width, _pointView.frame.size.height);
                    _insertLocation = _pointView.frame.origin.x;
                    _isInsertHeader = YES;
                }
                else
                {
                    _pointView.frame = CGRectMake(_pointView.frame.origin.x, _pointView.frame.origin.y, _pointView.frame.size.width, _pointView.frame.size.height);
                    _insertLocation = _pointView.frame.origin.x;
                }
            }
            else
            {
                [self.collectionView setContentOffset:CGPointMake(_currentOffset , 0) animated:YES];
            }
        }
        if (!_isSelectedHeader)
        {
            [self findCurrentSelectView];
        }
    }
    else
    {
        if (self.imageViewArray.count>2)
        {
            [self findCurrentSelectView];
        }
        else
        {
            _pointView.frame = CGRectMake((self.frame.size.width-2)/2, 100, 2, 100);
            _insertLocation = _pointView.frame.origin.x;
        }
        _currentOffset = self.collectionView.contentOffset.x;
        
    }
}

#pragma mark - 手势
- (void)pointOfPanGersture:(CGFloat)point withOffset:(CGFloat)offset indexRow:(NSInteger)indexRow isReachEnded:(BOOL)isReachEnded
{
    point = point*QCScaleMultiple;
    _collectionCellItemSize =CGSizeMake(QCRealWidth+point, QCRealHeigh+point*3/4);
    _currentGrowSize = point;
    if (point>0) {
        _isScaleBig = YES;
    }
    else
    {
        _isScaleBig = NO;
    }
    
    if (self.scaleBigOrSmallResponsed)
    {
        self.scaleBigOrSmallResponsed();
    }
    
    if (isReachEnded)
    {
        _isReachEnded = isReachEnded;
    }
    else
    {
        _isReachEnded = isReachEnded;
    }
    
    [self reloadCollectionData];
    self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, 16, self.frame.size.width,  QCRealHeigh+point*3/4);
    self.effectView.frame = self.bounds;
    [self findCurrentViewMiddleCell];
    CGFloat offsetOfScale = [self calculateOffsetWithGrowSize:point indexRow:indexRow-1];
    
    if (_isReachEnded)
    {
        [self.collectionView setContentOffset:CGPointMake(offsetOfScale+(self.frame.size.width-(QCRealWidth+_currentGrowSize)- 2*(self.frame.size.width-3*QCRealWidth)/2)/2+(self.frame.size.width-3*QCRealWidth)/2, 0) animated:NO];
        _pageLabel.frame = CGRectMake(0,self.frame.size.height-30, _collectionView.frame.size.width, 25);
        _pageLabel.hidden = NO;
        _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",indexRow,self.imageViewArray.count-2];
    }
    else
    {
        [self.collectionView setContentOffset:CGPointMake(offsetOfScale, 0)animated:NO];
        _pageLabel.hidden = YES;

    }
    [self rectifyCollectionView];

}
- (void)rectifyCollectionView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadCollectionData) object:nil];
    [self performSelector:@selector(reloadCollectionData) withObject:nil afterDelay:0.5];
}


#pragma mark - 计算放大后ScrollView应该改变的offset
- (CGFloat)calculateOffsetWithGrowSize:(CGFloat)growSize indexRow:(NSInteger)indexRow
{
    return  growSize+QCRealWidth-(self.frame.size.width-(QCRealWidth+growSize)- 2*(self.frame.size.width-3*QCRealWidth)/2)/2+indexRow*(QCRealWidth+growSize+(self.frame.size.width-3*QCRealWidth)/2);
}

- (CGFloat)leftOrRightGapWidth
{
    if (_isReachEnded)
    {
        return (self.frame.size.width-(QCRealWidth+_currentGrowSize)- 2*(self.frame.size.width-3*QCRealWidth)/2)/2+(self.frame.size.width-3*QCRealWidth)/2;
    }
    else
    {
        return 0;
    }
}

- (void)dealloc
{
    [self.pointView removeObserver:self forKeyPath:@"frame"];
}
@end
