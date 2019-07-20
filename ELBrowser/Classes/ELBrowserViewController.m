//
//  ELBrowserViewController.m
//  ELBrowser
//
//  Created by 高欣 on 2019/7/4.
//

#import "ELBrowserViewController.h"
#import "ELBrowserCollectionViewCell.h"
#import "STTransitionPopAnimation.h"
#import "STTransitionPushAnimation.h"
#import "ELBrowserPageControlProtocol.h"
#import "ELBrowserCollectionViewCellProtocol.h"

#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "UIView+WebCache.h"
#import "SDWebImagePrefetcher.h"

@interface ELBrowserViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIViewControllerTransitioningDelegate,ELBrowserCollectionViewCellDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;


@property (nonatomic,strong) UICollectionViewFlowLayout *layout;

/**
 返回的frame
 */
@property (nonatomic,assign) CGRect backAnimationFrame;


/**
 添加拖动缩小手势
 */
@property (nonatomic,strong) UIPanGestureRecognizer * panGes;

@property (nonatomic, strong) STTransitionPopAnimation *popAnimation;
@property (nonatomic, strong) STTransitionPushAnimation *pushAnimation;

/**
 分页视图
 */
@property (nonatomic,strong) UIView<ELBrowserPageControlProtocol> * pageControl;

@property (strong, nonatomic) UIView<ELBrowserViewProtocol>* customView;

/**
 分页记录当前选中的
 */
@property (nonatomic,assign) NSInteger offsetPageIndex;

@end

@implementation ELBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createView];
    [self configTarget];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentSelectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    });
}

- (void)createView {
    self.view.backgroundColor = [UIColor blackColor];
    self.collectionView.frame = CGRectMake(-kCollectionViewPadding, 0, self.view.bounds.size.width  + kCollectionViewPadding * 2, self.view.bounds.size.height);
    
    // 自定义cell
    Class customCell = NSClassFromString(self.customCellClassString);
    if (self.customCellClassString.length > 0 && [customCell isSubclassOfClass:[ELBrowserCollectionViewCell class]]) {
        //注册自定义cell
        [self.collectionView registerClass:customCell forCellWithReuseIdentifier:@"cell"];
    }else {
        [self.collectionView registerClass:[ELBrowserCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    
    [self.view addSubview:self.collectionView];
    
    // 分页视图
    Class customPageControlClass = NSClassFromString(self.customPageControlClassString);
    if (self.customPageControlClassString.length > 0 && [customPageControlClass isSubclassOfClass:[UIView class]]) {
        self.pageControl = [[customPageControlClass alloc]init];
        if ([self.pageControl conformsToProtocol:@protocol(ELBrowserPageControlProtocol)]) {
            [self.view addSubview:self.pageControl];
            //设置当前选中pageIndex
            [self.pageControl el_browserPageControlChanged:_currentSelectIndex totalCount:self.originalUrls.count];
        }
    }
    
    // 自定义view
    Class customViewClass = NSClassFromString(self.customViewClassString);
    if (self.customViewClassString.length > 0 && [customViewClass isSubclassOfClass:[UIView class]]) {
        self.customView = [[customViewClass alloc]init];
        if ([self.customView conformsToProtocol:@protocol(ELBrowserViewProtocol)]) {
            [self.view addSubview:self.customView];
        }
        
        if ([self.customView respondsToSelector:@selector(setFromViewController:)]) {
            self.customView.fromViewController = self.fromViewController;
        }
        
        if ([self.customView respondsToSelector:@selector(setBrowserViewController:)]) {
            self.customView.browserViewController = self;
        }
    }
}

- (void)configTarget {
    // 拖动手势
    self.panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    self.panGes.delegate = self;
    [self.collectionView addGestureRecognizer:self.panGes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceWillOrientation)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}


- (BOOL)shouldAutorotate {
    switch (self.panGes.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        case UIGestureRecognizerStateEnded:
            return NO;
        default:
            return YES;
            break;
    }
}

- (void)deviceWillOrientation {
    //旋转的时候重置页面
    [self  recover];
    _offsetPageIndex = _collectionView.contentOffset.x / _layout.itemSize.width;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGes) {
        CGPoint velocity = [self.panGes velocityInView:gestureRecognizer.view];

        int a = velocity.x;
        if (velocity.y > 0 && abs(a) <= 150) {
            //下滑
            return YES;
        }else {
            //上滑
            return NO;
        }
    }
    return YES;
}

#pragma mark - UIPanGestureRecognizer Target
- (void)handleGesture:(UIPanGestureRecognizer *)panGesture {
    CGPoint  translation = [panGesture translationInView:self.collectionView];
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            //隐藏加载进度条
            ELBrowserCollectionViewCell * cell = (ELBrowserCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentSelectIndex inSection:0]];
            if (cell.progressView) {
                cell.progressView.hidden = YES;
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGFloat progress = translation.y / self.view.bounds.size.height;
            progress = fminf(fmaxf(progress, 0.0), 1.0);
            
            CGFloat ratio = 1.0f - progress * 0.5;
            [self.collectionView setCenter:CGPointMake(self.view.center.x + translation.x * ratio, self.view.center.y + translation.y * ratio)];
            self.collectionView.transform = CGAffineTransformMakeScale(ratio, ratio);
            self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:ratio];
            NSLog(@"%@",NSStringFromCGRect(self.collectionView.frame));
        }
            break;
        case UIGestureRecognizerStateEnded:  {
            CGFloat progress = translation.y / self.view.bounds.size.height;
            progress = fminf(fmaxf(progress, 0.0), 1.0);
            if (progress > 0.1) {
                [self hidden];
            }else {
                ELBrowserCollectionViewCell * cell = (ELBrowserCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentSelectIndex inSection:0]];
                [UIView animateWithDuration:0.2 animations:^{
                    if (cell.progressView) {
                        cell.progressView.hidden = NO;
                    }
                    [self recover];
                }];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - 恢复
- (void)recover {
    self.collectionView.center = CGPointMake(self.view.center.x,
                                             self.view.center.y);
    self.collectionView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    self.view.backgroundColor =  [UIColor blackColor];
}

#pragma mark - 展示
- (void)showWithFormViewController:(UIViewController *)viewController {
    [self showWithFormViewController:viewController selectIndex:0];
}

- (void)showWithFormViewController:(UIViewController *)viewController selectIndex:(NSInteger)selectIndex {
    if (!viewController || ![viewController isKindOfClass:[UIViewController  class]]) {
        return;
    }
    
    if (self.originalUrls.count == 0) {
        return;
    }
    
    // 如果传入的大小图图片数量不相同 || 小图的数组没有传值
    if (self.smallUrls.count == 0 || self.smallUrls.count != self.originalUrls.count) {
        self.smallUrls = self.originalUrls;
    }
    
    _currentSelectIndex = selectIndex;
    
    _fromViewController = viewController;
    
    //将图片读取到内存中
    for (NSString * key in self.originalUrls) {
        [[SDImageCache sharedImageCache] queryCacheOperationForKey:key done:nil];
    }
    
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    [viewController presentViewController:self animated:YES completion:nil];
}

#pragma mark - 消失
- (void)hidden {
    //清除大图缓存
    for (NSString * key in self.originalUrls) {
        [[SDImageCache sharedImageCache] removeImageForKey:key fromDisk:NO withCompletion:nil];
    }
    
    __weak typeof(self) weakS = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if ([weakS.delegate respondsToSelector:@selector(el_browserDissmissComplate)]) {
            [weakS.delegate el_browserDissmissComplate];
        }
    }];
}

#pragma mark -  TransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    NSString * originUrl = self.currentSelectIndex < self.originalUrls.count ? self.originalUrls[self.currentSelectIndex] : nil;
    //先取大图
    UIImage  * img = [self sdCacheImg:originUrl];
    if (!img) {
        //再取小图
        NSString * smallUrl = self.currentSelectIndex < self.smallUrls.count ? self.smallUrls[self.currentSelectIndex] : nil;
        img = [self sdCacheImg:smallUrl];
    }
    
    UIImageView * imageView = [[UIImageView alloc]initWithImage:img];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    self.pushAnimation.fromImageView = imageView;
    
    [self updateBackFrame];
    
    self.pushAnimation.beforeFrame = self.backAnimationFrame;
    return self.pushAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    ELBrowserCollectionViewCell * cell = (ELBrowserCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentSelectIndex inSection:0]];
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.image = cell.imageView.image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    self.popAnimation.fromView = imageView;
    CGRect backF = [cell.scrollView convertRect:cell.imageView.frame toView:self.view];
    self.popAnimation.fromView.frame = backF;
    
    [self updateBackFrame];
    
    self.popAnimation.afterFrame = self.backAnimationFrame;
    
    return self.popAnimation;
}

#pragma mark - 更新返回的frame
- (void)updateBackFrame {
    if ([self.dataSource respondsToSelector:@selector(el_browserBackFrameWithSelectIndex:)]) {
        self.backAnimationFrame = [self.dataSource el_browserBackFrameWithSelectIndex:self.currentSelectIndex];
    }else {
        //设置默认值
        self.backAnimationFrame = CGRectMake((self.view.bounds.size.width - 5)/2, (self.view.bounds.size.height - 5)/2, 5, 5);
    }
}

#pragma mark - 从SDWebimage 缓存中取图片
- (UIImage *)sdCacheImg:(NSString *)url {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:url]];
    SDImageCache* cache = [SDImageCache sharedImageCache];
    return [cache imageFromDiskCacheForKey:key];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.originalUrls.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.bounds.size.width  + kCollectionViewPadding * 2, self.view.bounds.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //先取自定义cell
    ELBrowserCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSString * originUrl = self.originalUrls[indexPath.item];
    NSString * smallUrl = self.smallUrls[indexPath.item];
    
    if ([cell respondsToSelector:@selector(setModel:)]) {
        id obj = indexPath.item < self.customCellModelArray.count ? self.customCellModelArray[indexPath.item] : nil;
        [cell setModel:obj];
    }
    
    if ([cell respondsToSelector:@selector(setFromViewController:)]) {
        cell.fromViewController = self.fromViewController;
    }
    
    if ([cell respondsToSelector:@selector(setBrowserViewController:)]) {
        cell.browserViewController = self;
    }
    
    cell.delegate = self;
    
    [cell configImageWithOriginUrl:originUrl smallUrl:smallUrl];
    return cell;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator  {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _currentSelectIndex = scrollView.contentOffset.x / (self.view.bounds.size.width  + kCollectionViewPadding * 2);
    if ([self.pageControl respondsToSelector:@selector(el_browserPageControlChanged:totalCount:)]) {
        [self.pageControl el_browserPageControlChanged:_currentSelectIndex totalCount:self.originalUrls.count];
    }
}

#pragma mark -  ELBrowserCollectionViewCellDelegate
- (void)hiddenAction {
    [self hidden];
}

#pragma mark - 长按手势
- (void)longPressAction:(UILongPressGestureRecognizer *)longGes {
    if ([self.delegate respondsToSelector:@selector(el_browserLongPress:)]) {
        [self.delegate el_browserLongPress:self];
    }
}

#pragma mark - 下载失败
-  (void)loadFailedAction {
    if ([self.delegate respondsToSelector:@selector(el_browserLoadFailed:)]) {
        [self.delegate el_browserLoadFailed:self];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    switch (self.panGes.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        case UIGestureRecognizerStateEnded:
            return;
        default:
            break;
    }
    
    self.collectionView.frame = CGRectMake(-kCollectionViewPadding, 0, self.view.bounds.size.width  + kCollectionViewPadding * 2, self.view.bounds.size.height);
    
    [self.layout setItemSize:CGSizeMake(self.collectionView.bounds.size.width, self.view.bounds.size.height)];
    
    [self.collectionView setCollectionViewLayout:self.layout];
    
    //屏幕旋转之后 滚动到指定位置
    if (self.offsetPageIndex) {
        [self.collectionView setContentOffset:CGPointMake(self.offsetPageIndex * self.layout.itemSize.width, 0) animated:NO];
    }
    
    //重置pageControl frame
    if ([self.pageControl respondsToSelector:@selector(resetFrame:)]) {
        [self.pageControl resetFrame:self.view];
    }
    
    if ([self.customView respondsToSelector:@selector(resetFrame:)]) {
        [self.customView resetFrame:self.view];
    }
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        self.layout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
        self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _collectionView;
}

- (STTransitionPushAnimation *)pushAnimation {
    if (_pushAnimation == nil) {
        _pushAnimation = [[STTransitionPushAnimation alloc]init];
    }
    return _pushAnimation;
}

- (STTransitionPopAnimation *)popAnimation {
    if (_popAnimation == nil) {
        _popAnimation = [[STTransitionPopAnimation alloc]init];
    }
    return _popAnimation;
}

- (UICollectionViewFlowLayout *)layout {
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
    }
    return _layout;
}

- (void)dealloc {
    [[NSNotificationCenter  defaultCenter]removeObserver:self];
}

@end
