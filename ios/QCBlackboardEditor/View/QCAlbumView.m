//
//  QCAlbumView.m
//  QCBlackboardEditor
//
//  Created by SXJH on 16/11/28.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#import "QCAlbumView.h"
#import "QCPhotoAblumList.h"
#import "QCAssetItem.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <Photos/Photos.h>
#import "QCBlackboardEditorMacroDefines.h"
#import "QCPhotoManager.h"
#import "QCAlbumCell.h"
static const int kMaxSelectedItem = 1000;
@interface QCAlbumView()<UICollectionViewDelegate,UICollectionViewDataSource,PHPhotoLibraryChangeObserver>
{
    NSInteger _photoIndex;
    BOOL _enableInteract;
    BOOL _isReloadingData;
    BOOL _isFirstLoadAblumList;//首次加载图片 默认相机胶卷其次所有照片
}
@property (nonatomic, strong)UICollectionView * collectionView;
@property (nonatomic, strong)NSMutableArray * assets;
@property (nonatomic, strong)PHImageRequestOptions *option;
@property (nonatomic, retain)NSMutableArray<QCPhotoAblumList *> * photoTitleArray;
@property (nonatomic, retain)NSMutableDictionary * cellSizeDictionary;
@property (nonatomic, strong)NSMutableArray * selectedViewArray;
@property (nonatomic, strong)NSString * currentSelectMenuTitle;

@end
@implementation QCAlbumView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _isFirstLoadAblumList = YES;
        //注册相册图片改变的通知
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
        _currentSelectMenuTitle = @"相机胶卷";
        [self initCollectionView];
    }
    return self;
}
#pragma mark - 相册变化回调
- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    __weak typeof(self)weakSelf = self;
    dispatch_sync(dispatch_get_main_queue(), ^{
        [weakSelf getSwitchAlbumWithMenuTitle:_currentSelectMenuTitle completion:^{
            [weakSelf reloadAll];
        }];
    });
}

- (void)initCollectionView
{
    _assets = [NSMutableArray arrayWithCapacity:0];;
    _selectedViewArray = [NSMutableArray arrayWithCapacity:0];
    _cellSizeDictionary = [NSMutableDictionary dictionary];
    _option = [[PHImageRequestOptions alloc] init];
    _option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:flowLayout];
     [_collectionView registerNib:[UINib nibWithNibName:@"QCAlbumCell"bundle:nil]forCellWithReuseIdentifier:@"QCAlbumCellidentifier"];
    _collectionView.contentInset = UIEdgeInsetsMake(184*QC_RATE_SCALE+10, 0, 0, 0);
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self addSubview:_collectionView];
    
    [self getSwitchAlbumWithMenuTitle:_currentSelectMenuTitle completion:^{
        [_collectionView reloadData];
    }];
}

- (void)getSwitchAlbumWithMenuTitle:(NSString*)menuTitle completion:(void(^)())completion
{
    if (self.photoTitleArray.count == 0)
    {
        _photoTitleArray = [NSMutableArray arrayWithArray:[QCPhotoManager  getPhotoAblumList]];
    }
    
    int titleIndex = 0;
    BOOL isFindMenuTitle = NO;
    if (_isFirstLoadAblumList)
    {
        _isFirstLoadAblumList = NO;
        NSString * defaultName = @"相机胶卷";
        NSString * thenName = @"所有照片";

        for (QCPhotoAblumList * ablum in self.photoTitleArray)
        {
            if ([ablum.title isEqualToString:defaultName])
            {
                _currentSelectMenuTitle = menuTitle;
                isFindMenuTitle = YES;
                break;
            }
            if ([ablum.title isEqualToString:thenName])
            {
                _currentSelectMenuTitle = menuTitle;
                isFindMenuTitle = YES;
                break;
            }
            titleIndex++;
        }
    }
    else
    {
        for (QCPhotoAblumList * ablum in self.photoTitleArray)
        {
            if ([ablum.title isEqualToString:menuTitle])
            {
                _currentSelectMenuTitle = menuTitle;
                isFindMenuTitle = YES;
                break;
            }
            titleIndex++;
        }

    }
   
    if (self.photoTitleArray.count == 0)
    {
        if (completion)
        {
            completion();
        }
        return;
    }
    //获取选中相册内容
    int menuTitleIndex = 0;
    if (isFindMenuTitle)
    {
        menuTitleIndex = titleIndex;
    }
    NSArray *selectedPhotoArray = [QCPhotoManager getAssetsInAssetCollection:self.photoTitleArray[menuTitleIndex].assetCollection ascending:NO];
    
    //保持选中的照片还是选中状态
    NSMutableArray * selectedArray = [NSMutableArray array];
    NSMutableArray * selectedIdentifierArray = [NSMutableArray array];
    
    for (QCAssetItem *item in self.selectedViewArray)
    {
        [selectedArray addObject:item];
        [selectedIdentifierArray addObject:item.asset.localIdentifier];
        
    }
    [self.assets removeAllObjects];
    [selectedPhotoArray enumerateObjectsUsingBlock:^(PHAsset *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (![selectedIdentifierArray containsObject:obj.localIdentifier])
        {
            QCAssetItem *item = [QCAssetItem asseItemWithPhasset:obj];
            [self.assets addObject:item];
        }
        else
        {
            for (QCAssetItem *item in selectedArray)
            {
                if ([item.asset.localIdentifier isEqualToString:obj.localIdentifier])
                {
                    [self.assets addObject:item];
                    break;
                }
            }
        }
        if (stop)
        {
            if (completion)
            {
                completion();
            }
            return;
        }
    }];
    
}

#pragma mark - CollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QCAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QCAlbumCellidentifier" forIndexPath:indexPath];
    cell.currentAsset = self.assets[indexPath.row];
    [cell loadView];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    NSValue *cellSizeValue = [_cellSizeDictionary objectForKey:@(indexPath.row)];
    if (cellSizeValue)
    {
        size = [cellSizeValue CGSizeValue];
    }
    else
    {
        size = CGSizeMake((self.frame.size.width - 3*5) / 4.f, (self.frame.size.width - 3*5) / 4.f);
        [_cellSizeDictionary setObject:[NSValue valueWithCGSize:size] forKey:@(indexPath.row)];
    }
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 3, 0, 3);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 3.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 3.f;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isReloadingData)
    {
        return;
    }
    QCAssetItem *currentAsset = self.assets[indexPath.row];
    if (currentAsset.asset.localIdentifier.length != 0)
    {
        [[QCPhotoManager shareManager].cacheImageDic removeObjectForKey:currentAsset.asset.localIdentifier];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionView)
    {
        QCAssetItem * item = _assets[indexPath.row];
        item.selected = !item.selected;
        if (item.selected)
        {
            if ([self mutableArrayValueForKey:@"selectedViewArray"].count == kMaxSelectedItem)
            {
                item.selected = !item.selected;
                [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                return;
            }

            [self.selectedViewArray addObject:item];

            if (self.buttonSelectPress)
            {
                self.buttonSelectPress(item,YES);
            }
        }
        else
        {
            NSUInteger index = [[self mutableArrayValueForKey:@"selectedViewArray"] indexOfObject:item];
            [[self mutableArrayValueForKey:@"selectedViewArray"] removeObjectAtIndex:index];
            if (self.buttonSelectPress)
            {
                self.buttonSelectPress(item,NO);
            }
        }
    }
}
#pragma mark - reload
- (void)reloadAllWithMenuTitle:(NSString*)menuTitle
{
    [self getSwitchAlbumWithMenuTitle:menuTitle completion:^{
        [self reloadAll];
    }];
}
- (void)reloadAll
{
    _isReloadingData = YES;
    [self.collectionView reloadData];
    _isReloadingData = NO;
}

- (void)reloadViewWithDeleteItem:(QCAssetItem*)item
{
    item.selected = !item.selected;
    [self.selectedViewArray removeObject:item];
}
- (void)setEnableInteract:(BOOL)enableInteract
{
    [self willChangeValueForKey:@"enableInteract"];
    _enableInteract = enableInteract;
    self.userInteractionEnabled = enableInteract;
    [self didChangeValueForKey:@"enableInteract"];
}
- (BOOL)isEnableInteract
{
    return _enableInteract;
}
- (void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}
@end
