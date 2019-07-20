//
//  ELBrowserViewController.h
//  ELBrowser
//
//  Created by 高欣 on 2019/7/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ELBrowserViewController;
@protocol ELBrowserViewControllerDataSource <NSObject>

@optional

/**
 返回的frame
 */
- (CGRect)el_browserBackFrameWithSelectIndex:(NSInteger)selectIndex;

@end

@protocol ELBrowserViewControllerDelegate <NSObject>

@optional
/**
 长按手势的回调
 */
- (void)el_browserLongPress:(ELBrowserViewController *)browserViewContrller;

/**
 下载失败的回调
 */
- (void)el_browserLoadFailed:(ELBrowserViewController *)browserViewContrller;

/**
 消失的回调
 */
- (void)el_browserDissmissComplate;

@end

@interface ELBrowserViewController : UIViewController

/**
 大图图片数组 (必传)
 */
@property (nonatomic, strong) NSArray<NSString *> *originalUrls;

/**
 小的图片数组
 */
@property (nonatomic, strong) NSArray<NSString *> *smallUrls;

/**
 当前选中的Index
 */
@property (nonatomic,assign,readonly) NSInteger currentSelectIndex;

/**
 presentViewController
 */
@property (nonatomic,weak,readonly) UIViewController *fromViewController;

/**
 自定义进度条视图 (类名 需要遵循ELBrowserProgressProtocol 协议)
 */
@property (nonatomic,copy) NSString *customProgressClassString;

/**
 自定义分页视图 (类名 需要遵循ELBrowserPageControlProtocol 协议)
 */
@property (nonatomic,copy) NSString *customPageControlClassString;

/**
 自定义cell (类名)  需要继承自 ELBrowserCollectionViewCell
 */
@property (nonatomic,copy) NSString *customCellClassString;

/**
 自定义cell 模型数组
 */
@property (nonatomic,strong) NSArray *customCellModelArray;

/**
 自定义view
 */
@property (strong, nonatomic) NSString * customViewClassString;

@property (nonatomic, weak, nullable) id <ELBrowserViewControllerDelegate> delegate;
@property (nonatomic, weak, nullable) id <ELBrowserViewControllerDataSource> dataSource;

- (void)showWithFormViewController:(UIViewController *)viewController;
- (void)showWithFormViewController:(UIViewController *)viewController selectIndex:(NSInteger)selectIndex;

- (void)hidden;

@end

NS_ASSUME_NONNULL_END
