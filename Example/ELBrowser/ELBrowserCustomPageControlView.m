//
//  ELBrowserCustomPageControlView.m
//  ELBrowser_Example
//
//  Created by 高欣 on 2019/7/9.
//  Copyright © 2019 LifeForLove. All rights reserved.
//

#import "ELBrowserCustomPageControlView.h"
#import <Masonry.h>

@interface ELBrowserCustomPageControlView ()
@property (nonatomic,strong) UIPageControl *pageControl;

@end

@implementation ELBrowserCustomPageControlView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)resetFrame:(UIView *)view {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view).offset(-20);
        make.height.mas_equalTo(40);
        make.width.equalTo(view);
        make.centerX.equalTo(view);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (void)el_browserPageControlChanged:(NSInteger)currentSelectIndex totalCount:(NSInteger)totalCount {
    self.pageControl.numberOfPages = totalCount;
    self.pageControl.currentPage = currentSelectIndex;
    
    self.pageControl.hidden = totalCount <= 1 ? YES : NO;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc]init];
    }
    return _pageControl;
}

@end
