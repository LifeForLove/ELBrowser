//
//  ELBrowserCustomView1.m
//  ELBrowser_Example
//
//  Created by ZCGC on 2019/7/20.
//  Copyright © 2019 LifeForLove. All rights reserved.
//

#import "ELBrowserCustomView1.h"
#import <Masonry.h>
@interface ELBrowserCustomView1 ()

@end

@implementation ELBrowserCustomView1

@synthesize fromViewController = _fromViewController;
@synthesize browserViewController = _browserViewController;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTitle:@"保存" forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]];
        
        [self configTarget];
    }
    return self;
}

- (void)resetFrame:(UIView *)view {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-20);
        make.bottom.equalTo(view).offset(-20);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
}

- (void)configTarget {
    [self addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)saveAction:(UIButton *)sender {
    NSLog(@"保存图片");
}

- (void)setBrowserViewController:(ELBrowserViewController *)browserViewController {
    _browserViewController = browserViewController;
}

- (void)setFromViewController:(UIViewController *)fromViewController {
    _fromViewController = fromViewController;
}

@end
