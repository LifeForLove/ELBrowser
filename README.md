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
##图片浏览器

###简述
使用UIViewController+CollectionView结构,动画效果使用转场动画实现,加载图片使用SDWebImageView,将图片加载到内存中,解决了从本地缓存读取页面滑动时卡顿的问题,视图销毁后做了释放内存的处理,代码简单,结构清晰

支持横竖屏
支持GIF
支持自定义加载视图
支持自定义 collectionViewCell
支持自定义分页视图

###使用方法
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

## Author

LifeForLove, getElementByYou@163.com

## License

ELBrowser is available under the MIT license. See the LICENSE file for more info.


