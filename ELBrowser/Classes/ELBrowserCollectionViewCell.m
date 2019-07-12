//
//  ELBrowserCollectionViewCell.m
//  ELBrowser
//
//  Created by 高欣 on 2019/7/4.
//

#import "ELBrowserCollectionViewCell.h"
#import "ELBrowserProgressView.h"
#import "ELBrowserViewController.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCache.h"
@interface ELBrowserCollectionViewCell ()<UIScrollViewDelegate>

@end


@implementation ELBrowserCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
        
        self.scrollView.frame = self.contentView.bounds;
        
        //点击手势
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTapAction:)];
        [self.scrollView addGestureRecognizer:tapGes];
        
        UILongPressGestureRecognizer * longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewLongPressAction:)];
        [self.imageView addGestureRecognizer:longGes];
        
    }
    return self;
}

- (void)setDelegate:(id<ELBrowserCollectionViewCellDelegate>)delegate {
    _delegate = delegate;
    ELBrowserViewController *vc = (ELBrowserViewController *)delegate;
    [self addCustomViewWithViewController:vc];
}

- (void)addCustomViewWithViewController:(ELBrowserViewController *)vc {
    if (self.progressView) {
        return;
    }
    //进度条
    if (vc.customProgressClassString.length > 0) {
        Class progressClass = NSClassFromString(vc.customProgressClassString);
        if ([progressClass isSubclassOfClass:[UIView class]] && !self.progressView) {
            self.progressView = [[progressClass alloc]init];
        }
    } else {
        // 添加默认进度条样式
        self.progressView = [[ELBrowserProgressView alloc]init];
    }
}


#pragma mark - 点击手势
- (void)imageViewTapAction:(UITapGestureRecognizer *)ges {
    [self.scrollView setZoomScale:1];
    [self.scrollView setContentOffset:CGPointZero];
    [self hiddenAction];
}

#pragma mark - 长按手势
- (void)imageViewLongPressAction:(UILongPressGestureRecognizer *)ges {
    switch (ges.state) {
        case UIGestureRecognizerStateBegan: {
            [self.delegate longPressAction:ges];
        }
            break;
        case UIGestureRecognizerStateEnded:
            break;
            
        default:
            break;
    }
}


#pragma mark - 消失
- (void)hiddenAction {
    [self.delegate hiddenAction];
}

#pragma mark - 根据图片链接来设置图片
- (void)configImageWithOriginUrl:(NSString *)originUrl smallUrl:(NSString *)smallUrl {
    UIImage * cacheImg;

    if ([originUrl hasPrefix:@"http"]) {
        //1 查是否有大图缓存
        cacheImg = [self sdCacheImg:originUrl];
        if (!cacheImg && smallUrl) {
            //2 查是否有小图缓存
            cacheImg = [self sdCacheImg:smallUrl];
        }
    }

    if (cacheImg) {
        CGRect imgF = [self configImageSize:cacheImg];
        self.imageView.frame = imgF;
    }else {
        self.imageView.image = nil;
        self.imageView.frame = CGRectZero;
    }
    
    // 下载大图
    [self loadImage:originUrl cacheImg:cacheImg];
}

- (void)loadImage:(NSString *)picurl cacheImg:(UIImage *)cacheImg
{
    //下载图片
    __weak typeof(self) weakS = self;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:picurl] placeholderImage:cacheImg options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        CGFloat progress = (float)receivedSize/(float)expectedSize;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![weakS.contentView.subviews containsObject:weakS.progressView]) {
                [weakS.contentView addSubview:weakS.progressView];
            }
            [weakS.progressView setProgress:progress];
        });
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakS.progressView removeFromSuperview];
            UIImage * tempImg = image;
            if (tempImg == nil) {
                //如果下载失败 显示小图
                tempImg = cacheImg;
                [weakS.delegate loadFailedAction];
            }
            [weakS updateImageViewWithImage:tempImg];
        });
    }];
}

#pragma mark - 读取本地图片
- (UIImage *)getImageWithBoudleName:(NSString *)boudleName imgName:(NSString *)imgName {
    NSBundle * bundle = [NSBundle bundleForClass:[self class]];
    NSURL * url = [bundle URLForResource:boudleName withExtension:@"bundle"];
    NSBundle * targetBundle = [NSBundle bundleWithURL:url];
    UIImage * image = [UIImage imageNamed:imgName inBundle:targetBundle compatibleWithTraitCollection:nil];
    return image;
}

/**
 从SDWebimage中获取缓存的图片
 
 @param picurl 传入图片链接
 @return 返回图片
 */
- (UIImage *)sdCacheImg:(NSString *)picurl {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:picurl]];
    SDImageCache* cache = [SDImageCache sharedImageCache];
    return [cache imageFromMemoryCacheForKey:key];
}

/**
 根据图片大小 适配手机 更改图片大小
 
 @param image 下载的图片
 @return 适配后的大小
 */
- (CGRect)configImageSize:(UIImage *)image {
    CGFloat imageViewY = 0;
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    CGFloat fitWidth =  0;
    CGFloat fitHeight = 0;
    
    CGFloat device_w = self.contentView.bounds.size.width - 2 * kCollectionViewPadding;
    CGFloat device_h = self.contentView.bounds.size.height;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        // 竖屏
        fitWidth = device_w;
        fitHeight = fitWidth * imageHeight / imageWidth;
        if (fitHeight < device_h) {
            imageViewY = (device_h - fitHeight) * 0.5;
        }
        return  CGRectMake(0, imageViewY, fitWidth, fitHeight);
    }else {
        // 横屏
        
        if (imageHeight <= device_h) {
            // 图片高 < 屏幕高度
            fitHeight = imageHeight;
            
            // 图片宽是否大于屏幕宽
            if (imageWidth > device_w) {
                // 大于
                fitWidth = device_w;
                fitHeight = fitWidth / imageWidth * fitHeight;
            } else {
              //小于
                fitWidth = imageWidth;
            }
        }else {
            // 图片 > 屏幕高度
            fitHeight = device_h;
            fitWidth = fitHeight / imageHeight * imageWidth;
            
            if (fitWidth > device_w) {
                // 图片宽度大于屏幕宽度
                fitWidth = device_w;
                fitHeight = device_w / imageWidth * imageHeight;
            }
        }
        
        CGFloat  imageViewX = (device_w - fitWidth) * 0.5;
        
        if (fitHeight < device_h) {
            imageViewY = (device_h - fitHeight) * 0.5;
        }
        return  CGRectMake(imageViewX, imageViewY, fitWidth, fitHeight);
    }
}

/**
 更新图片的位置
 
 @param image 传入网络获取的图片
 */
- (void)updateImageViewWithImage:(UIImage *)image {
    //如果image 等于空 说明下载失败 可在此处设置下载失败的背景图片
    if (!image)
    {
        UIImage * errorImg = [self getImageWithBoudleName:@"ELBrowser" imgName:@"imageerror"];
        self.imageView.frame = [self configImageSize:errorImg];
        self.imageView.image = errorImg;
    }else
    {
        /*
         根据手机宽度适配图片大小
         用 imgOriginF 记录frame
         */
        self.imageView.frame = [self configImageSize:image];
    }
    self.scrollView.contentSize = CGSizeMake(self.imageView.frame.size.width, self.imageView.frame.size.height);
}

#pragma mark - ScrollViewDelegate
/**
 缩放图片的时候将图片放在中间
 
 @param scrollView 背景scrollView
 */
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                        scrollView.contentSize.height * 0.5 + offsetY);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    //返回需要缩放的view
    return self.imageView;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    if ([self.contentView.subviews containsObject:self.progressView]) {
        [self.progressView removeFromSuperview];
    }
    [self.imageView sd_cancelCurrentImageLoad];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = CGRectMake(kCollectionViewPadding, 0, self.contentView.bounds.size.width - 2 * kCollectionViewPadding, self.contentView.bounds.size.height);
    self.progressView.center = self.contentView.center;
    [self.progressView resetFrame:self.contentView];

    [self updateImageViewWithImage:self.imageView.image];
}

- (FLAnimatedImageView *)imageView {
    if(_imageView == nil) {
        _imageView = [[FLAnimatedImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}


- (UIScrollView *)scrollView {
    if(_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.maximumZoomScale = 2;
        _scrollView.minimumZoomScale = 1;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}


@end
