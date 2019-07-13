//
//  ELBrowserCustomCollectionViewCell.m
//  ELBrowser_Example
//
//  Created by 高欣 on 2019/7/9.
//  Copyright © 2019 LifeForLove. All rights reserved.
//

#import "ELBrowserCustomCollectionViewCell.h"
#import <Masonry/Masonry.h>
@interface ELBrowserCustomCollectionViewCell ()

@property (nonatomic,strong) UIView *coverView;

@property (nonatomic,strong) UILabel *contentLabel;

@property (nonatomic,strong) UIButton *funcButton;

@end

@implementation ELBrowserCustomCollectionViewCell

@synthesize fromViewController = _fromViewController;
@synthesize browserViewController = _browserViewController;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.coverView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        [self.contentView addSubview:self.coverView];
        [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(100);
        }];
        
        [self.coverView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.coverView).offset(20);
            make.top.top.equalTo(self.coverView).offset(10);
            make.right.top.equalTo(self.coverView).offset(-20);
            make.bottom.top.equalTo(self.coverView).offset(-10);
        }];

        [self.coverView addSubview:self.funcButton];
        [self.funcButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.coverView);
            make.right.equalTo(self.coverView).offset(-20);
            make.size.mas_equalTo(CGSizeMake(60, 45));
        }];

        [self configTarget];
    }
    return self;
}

- (void)configTarget {
    [self.funcButton addTarget:self action:@selector(funcAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)funcAction:(UIButton *)sender {
    [self.browserViewController hidden];
    UIViewController * vc =  [[UIViewController alloc]init];
    vc.title = self.contentLabel.text;
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.fromViewController.navigationController pushViewController:vc animated:YES];
}

-  (void)setModel:(NSString *)model {
    self.contentLabel.text = model;
}

- (void)setBrowserViewController:(ELBrowserViewController *)browserViewController {
    _browserViewController = browserViewController;
}

- (void)setFromViewController:(UIViewController *)fromViewController {
    _fromViewController = fromViewController;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textColor = [UIColor whiteColor];
    }
    return _contentLabel;
}

- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc]init];
    }
    return _coverView;
}

- (UIButton *)funcButton {
    if (_funcButton == nil) {
        _funcButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_funcButton setTitle:@"跳转" forState:UIControlStateNormal];
        [_funcButton setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]];
    }
    return _funcButton;
}

@end
