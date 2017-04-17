//
//  QCMenuView.m
//  QCBlackboardEditor
//
//  Created by SXJH on 16/12/2.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#import "QCMenuView.h"
#import "QCMenuTableViewCell.h"
#import "QCPhotoAblumList.h"
#import "QCPhotoManager.h"
@interface QCMenuView()<UITableViewDelegate,UITableViewDataSource,PHPhotoLibraryChangeObserver>
@property (nonatomic,strong)UITableView * menuTableView;
@property (nonatomic, retain)NSMutableArray<QCPhotoAblumList *> *photoTitleArray;

@end
@implementation QCMenuView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effectView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:effectView];
        [self initMenuTableView];
    }
    return self;
}
- (void)initMenuTableView
{
    self.photoTitleArray = [NSMutableArray arrayWithArray:[QCPhotoManager getPhotoAblumList]];
    _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    [self addSubview:_menuTableView];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.backgroundColor = [UIColor clearColor];
    _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_menuTableView];
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photoTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * photoTitleCell = @"QCMenuTableViewCellIdentifier";
    
    QCMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:photoTitleCell];
    if (!cell)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"QCMenuTableViewCell" owner:self options:nil]lastObject];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.menuItem = self.photoTitleArray[indexPath.row];

    [QCPhotoManager requestImageForAsset:self.photoTitleArray[indexPath.row].headImageAsset size:CGSizeMake(200, 200) resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage * image, NSDictionary * info) {
        cell.menuItem.image = image;
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [QCMenuTableViewCell getCellRowHeight];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectedMenuListResponsed)
    {
        self.didSelectedMenuListResponsed(self.photoTitleArray[indexPath.row].title);
    }
}

#pragma mark - 相册变化回调
- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    __weak typeof(self)weakSelf = self;
    dispatch_sync(dispatch_get_main_queue(), ^{
        weakSelf.photoTitleArray = [NSMutableArray arrayWithArray:[QCPhotoManager getPhotoAblumList]];
        [weakSelf.menuTableView reloadData];
    });
}
- (void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}
@end
