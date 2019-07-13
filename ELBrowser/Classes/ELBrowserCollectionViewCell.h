//
//  ELBrowserCollectionViewCell.h
//  ELBrowser
//
//  Created by 高欣 on 2019/7/4.
//

#import <UIKit/UIKit.h>
#import "ELBrowser.h"
#import "ELBrowserProgressProtocol.h"
#import "FLAnimatedImage.h"
#import "ELBrowserCollectionViewCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class ELBrowserCollectionViewCell;

@protocol ELBrowserCollectionViewCellDelegate <NSObject>

- (void)hiddenAction;

/**
 长按手势回调

 @param longGes 手势
 */
- (void)longPressAction:(UILongPressGestureRecognizer *)longGes;

/**
 下载失败的回调
 */
- (void)loadFailedAction;

@end


@interface ELBrowserCollectionViewCell : UICollectionViewCell<ELBrowserCollectionViewCellProtocol>

/**
 要上下滑动  所以要设置scrollView
 */
@property (nonatomic, strong) UIScrollView *scrollView;

/**
 展示的imageView 图片
 */
@property (nonatomic, strong) FLAnimatedImageView *imageView;

/**
 进度条
 */
@property (nonatomic,strong) UIView <ELBrowserProgressProtocol> *progressView;

@property (nonatomic,weak) id<ELBrowserCollectionViewCellDelegate> delegate;

/**
 开始加载图片

 @param originUrl 大图链接
 @param smallUrl 小图链接
 */
- (void)configImageWithOriginUrl:(NSString *)originUrl smallUrl:(NSString *)smallUrl;


@end

NS_ASSUME_NONNULL_END
