//
//  QCBlackboardEditorController.m
//  QCBlackboardEditor
//
//  Created by 0dayZh on 2016/11/24.
//  Copyright © 2016年 qingclass. All rights reserved.
//

#import "QCBlackboardEditorController.h"
#import "QCAlbumView.h"
#import "QCLevelScrollView.h"
#import "QCBlackboardEditorMacroDefines.h"
#import "QCMenuView.h"
#import "QCBlackboardAddTextViewController.h"
#import "QCNavigationController.h"
#import "QCPhotoManager.h"
typedef enum : NSUInteger {
    QCDragirectionTypeNone,
    QCDragirectionTypeUp,
    QCDragirectionTypeDown,
} QCDragirectionType;

@interface QCBlackboardEditorController ()<QCBlackboardAddTextViewControllerDelegate>
{
    CGFloat _levelScrollViewOffset;//ScrollView偏移量
    NSInteger _currentIndex;//顶部当前最靠近中间view的index
    NSInteger _currentInsertIndex;
    NSArray * _insertArray;
    BOOL _isOpened;
}
@property (weak,nonatomic) IBOutlet UIView *previewContanerView;
@property (strong,nonatomic) QCAlbumView * albumView;
@property (strong,nonatomic) QCLevelScrollView *levelScrollView;
@property (assign,nonatomic) QCDragirectionType dragirectionType;
@property (strong,nonatomic) QCMenuView * menuView;
@property (strong,nonatomic) UIView *dragSwitchView;//拖动的view
@property (strong,nonatomic) UIView *dragGerstureView;
@property (strong,nonatomic) UIButton * selectPhotoBtn;
@property (strong,nonatomic) UIButton * selectTextBtn;
@end

@implementation QCBlackboardEditorController

+ (instancetype)editorController
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"BlackboardEditor" bundle:nil];
    QCBlackboardEditorController *vc = [sb instantiateInitialViewController];
    return vc;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[QCPhotoManager shareManager]clearCacheDicInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // preview contaner view
    CALayer *layer = self.previewContanerView.layer;
    layer.shadowColor = [UIColor lightGrayColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, -0.5);
    layer.shadowRadius = 1;
    layer.shadowOpacity = 1;
    
    __weak typeof(self)weakSelf = self;
    _albumView = [[QCAlbumView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-44)];
    _albumView.buttonSelectPress = ^(QCAssetItem * item,BOOL isSelected){
        if (isSelected)
        {
            [weakSelf.levelScrollView addAssetItem:item];
        }
        else
        {
            [weakSelf.levelScrollView deleteAssetItem:item];
        }
    };
    [self.view addSubview:_albumView];

    _menuView = [[QCMenuView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, _albumView.frame.size.height-QCLevelScrollViewHeight-16)];
    _menuView.didSelectedMenuListResponsed = ^(NSString * menuTitle){
        [weakSelf.selectPhotoBtn setTitle:menuTitle forState:UIControlStateNormal];
        [weakSelf openOrCloseMenuView:NO];
        [weakSelf.albumView reloadAllWithMenuTitle:menuTitle];
    };
    [self.view addSubview:_menuView];
    
    _levelScrollView = [[QCLevelScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, QCLevelScrollViewHeight)];
    _levelScrollView.backgroundColor = [UIColor clearColor];
    if (_insertArray.count>0)
    {
        [_levelScrollView setInsertImageArray:_insertArray];
        _levelScrollView.initSubscript = _currentInsertIndex;
    }
    _levelScrollView.deleteSelectPhotoResponsed = ^(QCAssetItem* item){
        [weakSelf.levelScrollView deleteAssetItem:item];
        [weakSelf.albumView reloadViewWithDeleteItem:item];
    };
    _levelScrollView.amendmentLocationResponsed = ^{
        [weakSelf.albumView reloadAll];
    };
    _levelScrollView.scaleBigOrSmallResponsed = ^{
        weakSelf.selectTextBtn.selected = weakSelf.selectPhotoBtn.selected = weakSelf.levelScrollView.isBlowUped;
        weakSelf.selectPhotoBtn.userInteractionEnabled = weakSelf.selectTextBtn.userInteractionEnabled = !weakSelf.levelScrollView.isBlowUped;
    };
    [self.view addSubview:_levelScrollView];
    
    _dragGerstureView = [[UIView alloc]initWithFrame:CGRectMake(0, QCLevelScrollViewHeight+64-(50-16)/2, self.view.frame.size.width, 50)];
    _dragGerstureView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_dragGerstureView];
    
    _dragSwitchView = [[UIView alloc]initWithFrame:CGRectMake(0, (50-16)/2, self.view.frame.size.width, 16)];
    _dragSwitchView.backgroundColor = QCMakeColor(102, 102, 102, 1);
    [_dragGerstureView addSubview:_dragSwitchView];
    
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizer:)];
    [_dragGerstureView addGestureRecognizer:panGesture];

    UIView * switchLine = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-79)/2,6, 79, 4)];
    switchLine.backgroundColor = QCMakeColor(255, 255, 255, 1);
    switchLine.layer.cornerRadius = 2;
    [_dragSwitchView addSubview:switchLine];
    
    UIView * downTabbarView = [[UIView alloc]initWithFrame:CGRectMake(0,  self.view.frame.size.height-44, self.view.frame.size.width, 44)];
    downTabbarView.backgroundColor = QCMakeColor(0, 0, 0, 0.5);
    [self.view addSubview:downTabbarView];
    
    _selectPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectPhotoBtn.frame = CGRectMake(0, 0, 150, downTabbarView.frame.size.height);
    [_selectPhotoBtn setTitle:@"相册" forState:UIControlStateNormal];
    _selectPhotoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _selectPhotoBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _selectPhotoBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    _selectPhotoBtn.backgroundColor = [UIColor clearColor];
    [_selectPhotoBtn addTarget:self action:@selector(photoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_selectPhotoBtn setTitleColor:QCMakeColor(0, 162, 255, 1) forState:UIControlStateNormal];
    [_selectPhotoBtn setTitleColor:QCMakeColor(255, 255, 255, 1) forState:UIControlStateSelected];
    [downTabbarView addSubview:_selectPhotoBtn];
    
    _selectTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectTextBtn.frame = CGRectMake(downTabbarView.frame.size.width-60, 0, 60, downTabbarView.frame.size.height);
    [_selectTextBtn setTitle:@"文字" forState:UIControlStateNormal];
    _selectTextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _selectTextBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _selectTextBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25);
    [_selectTextBtn addTarget:self action:@selector(textButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_selectTextBtn setTitleColor:QCMakeColor(0, 162, 255, 1) forState:UIControlStateNormal];
    [_selectTextBtn setTitleColor:QCMakeColor(255, 255, 255, 1) forState:UIControlStateSelected];
    [downTabbarView addSubview:_selectTextBtn];
}
- (void)panGestureRecognizer:(UIPanGestureRecognizer*)recognizer
{
    CGPoint translatedPoint = [recognizer translationInView:self.view];
    CGFloat y = recognizer.view.center.y + translatedPoint.y;
    CGPoint velocity = [recognizer velocityInView:recognizer.view];

    if (!_levelScrollView.isCanDrag)
    {
        return;
    }
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        _dragirectionType = QCDragirectionTypeNone;
        _levelScrollViewOffset = self.levelScrollView.scrollViewOffset;
        _currentIndex = _levelScrollView.indexRowOfCurrentScreenMiddleView;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        [_levelScrollView setHiddenPoint:YES];

        if (velocity.y>0)
        {
            if (y >= 64+QCLevelScrollViewHeight+QCRiseLength)
            {
                y = 64+QCLevelScrollViewHeight+QCRiseLength;
            }
            
            _dragirectionType = QCDragirectionTypeDown;
            _levelScrollView.frame =CGRectMake(0, 64, _levelScrollView.frame.size.width, y-64);
            [_levelScrollView pointOfPanGersture: y-64-QCLevelScrollViewHeight withOffset:_levelScrollViewOffset indexRow:_currentIndex isReachEnded:NO];

        }
        else
        {
            if (y <= 64+QCLevelScrollViewHeight)
            {
                y = 64+QCLevelScrollViewHeight;
            }
         
            _dragirectionType = QCDragirectionTypeUp;
            _levelScrollView.frame =CGRectMake(0, 64, _levelScrollView.frame.size.width, y-64);
            [_levelScrollView pointOfPanGersture: y-64-QCLevelScrollViewHeight withOffset:_levelScrollViewOffset indexRow:_currentIndex isReachEnded:NO];

        }
        
        recognizer.view.center = CGPointMake(recognizer.view.center.x, y);
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {

        if (_dragirectionType == QCDragirectionTypeUp)
        {
            [_levelScrollView setHiddenPoint:NO];
            [_albumView setEnableInteract:YES];
            _levelScrollView.frame =CGRectMake(0, 64, _levelScrollView.frame.size.width, QCLevelScrollViewHeight);
            [_levelScrollView pointOfPanGersture:0 withOffset:0 indexRow:_currentIndex isReachEnded:NO];
            [_levelScrollView reloadCollectionData];
            _dragGerstureView.frame = CGRectMake(0, 63+QCLevelScrollViewHeight-(50-16)/2, self.view.frame.size.width, 50);
            _dragirectionType = QCDragirectionTypeDown;
        }
        else if (_dragirectionType == QCDragirectionTypeDown)
        {
            [_levelScrollView setHiddenPoint:YES];
            [_albumView setEnableInteract:NO];
            _levelScrollView.frame =CGRectMake(0, 64, _levelScrollView.frame.size.width, QCLevelScrollViewHeight+QCRiseLength);
            [_levelScrollView pointOfPanGersture:QCRiseLength withOffset:0 indexRow:_currentIndex isReachEnded:YES];
            [_levelScrollView reloadCollectionData];
            _dragGerstureView.frame = CGRectMake(0, 64+QCLevelScrollViewHeight-(50-16)/2+QCRiseLength, self.view.frame.size.width, 50);
            _dragirectionType = QCDragirectionTypeDown;
        }
    }
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - Action

- (IBAction)cancelButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(blackboardEditerControllerWillDismiss:)])
    {
        [self.delegate blackboardEditerControllerWillDismiss:self];
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonPressed:(id)sender
{
   
    if ([self.delegate respondsToSelector:@selector(blackboardEditerControllerDidRequestToSave:)])
    {
        [self.delegate blackboardEditerControllerDidRequestToSave:self];
    }
}

- (IBAction)photoButtonPressed:(id)sender
{
    if (_levelScrollView.blowUped)
    {
        return;
    }
    _isOpened = !_isOpened;
    [self openOrCloseMenuView:_isOpened];
}

- (void)openOrCloseMenuView:(BOOL)open
{
    if (open)
    {
        [UIView animateWithDuration:0.3 animations:^{
            _menuView.frame = CGRectMake(0, _albumView.frame.origin.y+QCLevelScrollViewHeight+16, self.view.frame.size.width, _menuView.frame.size.height);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            _menuView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, _menuView.frame.size.height);
        }];
    }
    _isOpened = open;
}
- (IBAction)textButtonPressed:(id)sender
{
    if (_levelScrollView.blowUped)
    {
        return;
    }
    [self performSegueWithIdentifier:@"SendValue" sender:self];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //     Get the new view controller using [segue destinationViewController].
    //     Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SendValue"])
    {
        QCNavigationController *receive = segue.destinationViewController;
        QCBlackboardAddTextViewController * addTextVC = receive.viewControllers.firstObject;
        [addTextVC setValue:self forKey:@"delegate"];
    }
}
#pragma mark - QCBlackboardAddTextViewControllerDelegate
- (void)blackboardAddTextViewController:(QCBlackboardAddTextViewController *)viewController didAddTextImageView:(UIImageView *)textImageView
{
    QCAssetItem * item = [[QCAssetItem alloc]init];
    item.albumLocationType = QCAlbumLocationTypeMiddle;
    item.isTopperImage = YES;
    item.image = textImageView.image;    
    [self.levelScrollView addAssetItem:item];
}
#pragma mark - 上传图片数组
- (NSArray*)uploadImageArray
{
    if (_levelScrollView)
    {
        NSArray * array = [_levelScrollView getArrayOfAllImageView];
        return [array copy];
    }
    
    return nil;
}
- (void)setInitImageArray:(NSArray *)initImageArray withInsertIndex:(NSInteger)insertIndex
{
    [self willChangeValueForKey:@"initImageArray"];
    _insertArray = initImageArray;
    _currentInsertIndex = insertIndex;
    [self didChangeValueForKey:@"initImageArray"];
}
- (void)dealloc
{
    [[QCPhotoManager shareManager] clearCacheDicInfo];
}
@end
