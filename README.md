# ELBrowser

[![CI Status](https://img.shields.io/travis/LifeForLove/ELBrowser.svg?style=flat)](https://travis-ci.org/LifeForLove/ELBrowser)
[![Version](https://img.shields.io/cocoapods/v/ELBrowser.svg?style=flat)](https://cocoapods.org/pods/ELBrowser)
[![License](https://img.shields.io/cocoapods/l/ELBrowser.svg?style=flat)](https://cocoapods.org/pods/ELBrowser)
[![Platform](https://img.shields.io/cocoapods/p/ELBrowser.svg?style=flat)](https://cocoapods.org/pods/ELBrowser)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ELBrowser is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ELBrowser'
```
## 图片浏览器

### 简述
	
	可深度自定义的图片浏览器

	支持横竖屏
	支持GIF
	支持自定义加载视图
	支持自定义 collectionViewCell
	支持自定义分页视图
	支持自定义view
	支持自定义交互动画
	支持自定义动画起始位置
	
### 效果图
![image](https://github.com/LifeForLove/ELBrowser/blob/master/demo.gif )

### 使用方法

```
     ELBrowserViewController * vc = [[ELBrowserViewController alloc]init];
    vc.delegate = self;
    vc.dataSource = self;
    vc.originalUrls = originalImageUrls;
    vc.smallUrls = smallImageUrls;//非必传
    
    if ([self.titleLabel.text isEqualToString:@"自定义加载视图"]) {
        
#pragma mark - 自定义进度条 非必传
        vc.customProgressClassString = @"ELCustomProgressView";
        
    } else if ([self.titleLabel.text isEqualToString:@"自定义cell"]) {
        
#pragma mark - 自定义cell 非必传
        vc.customCellClassString = @"ELBrowserCustomCollectionViewCell";
        //自定义cell的数据模型
        vc.customCellModelArray = @[@"测试1",@"测试2",@"测试3",@"测试4"];
        
    } else if ([self.titleLabel.text isEqualToString:@"自定义view"]) {
        
#pragma mark - 自定义cell 非必传
        vc.customViewClassString = @"ELBrowserCustomView1";
        
    } else if ([self.titleLabel.text isEqualToString:@"自定义分页视图1"]) {
        
#pragma mark - 自定义分页视图 非必传
        vc.customPageControlClassString = @"ELBrowserCustomPageControlView";
        
    } else if ([self.titleLabel.text isEqualToString:@"自定义分页视图2"]) {
        
#pragma mark - 自定义分页视图 非必传
        vc.customPageControlClassString = @"ELBrowserCustomPageControlView2";
        
    } else if ([self.titleLabel.text isEqualToString:@"组合使用样式"]) {
#pragma mark - 组合使用样式
        vc.customViewClassString = @"ELBrowserCustomView1";
        vc.customPageControlClassString = @"ELBrowserCustomPageControlView2";
    }
    [vc showWithFormViewController:[self viewController] selectIndex:indexPath.item];
```

## 代码
	
	使用UIViewController+CollectionView结构
	动画效果使用转场动画实现
	加载图片使用SDWebImageView,将图片加载到内存中
	解决了从本地缓存读取页面滑动时卡顿的问题
	视图销毁后做了释放内存的处理,代码简单,结构清晰
	
#### 自定义说明
	
	每种自定义样式只需要遵循对应的协议即可，在使用时只需传入类名，无需导入非常方便。
	
##### ELBrowserViewProtocol 

	自定义view，遵循了这个协议的视图是添加在（ELBrowserViewController）控制的view上的。
	
	协议方法 
	
	@required
	- (void)resetFrame:(UIView *)view; 是用来重置自定义view的frame

	@optional
	@property (nonatomic,weak) UIViewController *fromViewController; 弹出图片浏览器的控制器
	@property (nonatomic,weak) ELBrowserViewController *browserViewController; 图片浏览器控制器
	
##### ELBrowserProgressProtocol
	
	自定义进度条，如果不传则会加载默认的进度条，继承自ELBrowserViewProtocol，可自定义进度条位置
	
	协议方法 
	- (void)setProgress:(CGFloat)progress; 回调进度

##### ELBrowserPageControlProtocol

	自定义分页控件
	
	协议方法 
	- (void)el_browserPageControlChanged:(NSInteger)currentSelectIndex totalCount:(NSInteger)totalCount; 滑动时回调此方法显示分页位置

##### 自定义交互动画 ELBrowserViewControllerDelegate
	
	需要实现协议方法
	- (void)el_browserCustomBackGesture:(UIPanGestureRecognizer *)gesture browserCollectionView:(UICollectionView *)collectionView browserViewController:(ELBrowserViewController *)browserViewController {

    CGPoint  translation = [gesture translationInView:collectionView];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            self.firstTouchPoint = translation;
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat offset_y = translation.y - self.firstTouchPoint.y;
            CGFloat alpha = 1- (offset_y / browserViewController.view.bounds.size.height);
            collectionView.frame = CGRectMake(collectionView.frame.origin.x, offset_y, collectionView.frame.size.width, collectionView.frame.size.height);
            browserViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha];
        }
            break;
        case UIGestureRecognizerStateEnded:  {
            CGFloat offset_y = translation.y - self.firstTouchPoint.y;
            if (offset_y > 30) {
                [browserViewController hidden];
            } else {
                collectionView.frame = CGRectMake(collectionView.frame.origin.x, 0, collectionView.frame.size.width, collectionView.frame.size.height);
                browserViewController.view.backgroundColor = [UIColor blackColor];
            }
        }
            break;
        default:
            break;
    }
	}
	
##### 自定义动画起始位置 ELBrowserViewControllerDataSource

	/**
	自定义开始的位置
	@param selectIndex 当前选中index
	@return 开始的位置
	*/
	- (CGRect)el_browserBeginFrameWithSelectIndex:(NSInteger)selectIndex;

	/**
	自定义返回位置
	@param selectIndex 当前选中index
	@return 消失的位置
	*/
	- (CGRect)el_browserBackFrameWithSelectIndex:(NSInteger)selectIndex;

## Author

如果使用中遇到任何问题欢迎加我微信ios_gx,如果觉得写得还行欢迎star。

另外，承接各种变态需求。

getElementByYou@163.com

## License

ELBrowser is available under the MIT license. See the LICENSE file for more info.


