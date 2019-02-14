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
##仿朋友圈图片浏览器


###使用方法
```
    ELBrowser * browser = [[ELBrowser alloc]init];
     ELBrowserConfig * config = [[ELBrowserConfig alloc]init];
     config.width = 200;
     config.originalUrls = originalImageUrls;
     config.smallUrls = thumbnailImageUrls;
     [browser showELBrowserWithConfig:config];
     [self.view addSubview:browser];
     [browser mas_makeConstraints:^(MASConstraintMaker *make) {
     make.size.mas_equalTo(200);
     make.center.equalTo(self.view);
```

###代码说明
最主要解决的问题,拖拽手势与collectionView滑动冲突的解决.
当手指接触到屏幕的时候,会调用:

```
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer == self.panGes) {
        //记录刚接触时的坐标
        firstTouchPoint = [touch locationInView:self.window];
    }
    return YES;
}
```


当手指开始滑动的时候,会调用:

```
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //判断是否是左右滑动  滑动区间设置为+-10
    CGPoint touchPoint = [gestureRecognizer locationInView:self.window];
    CGFloat dirTop = firstTouchPoint.y - touchPoint.y;
    if (dirTop > -10 && dirTop < 10) {
        return NO;
    }
    //判断是否是上下滑动
    CGFloat dirLift = firstTouchPoint.x - touchPoint.x;
    if (dirLift > -10 && dirLift < 10 && self.imageView.frame.size.height > [UIScreen mainScreen].bounds.size.height) {
        return NO;
    }
    
    return YES;
}
```




## 效果图

![image](https://github.com/LifeForLove/ELBrowser/blob/master/QQ20180423-151831.gif)

## Author

LifeForLove, getElementByYou@163.com

## License

ELBrowser is available under the MIT license. See the LICENSE file for more info.


