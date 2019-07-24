//
//  ELCustomAnimViewController.m
//  ELBrowser_Example
//
//  Created by ZCGC on 2019/7/24.
//  Copyright © 2019 LifeForLove. All rights reserved.
//

#import "ELCustomAnimViewController.h"
#import <UIImageView+WebCache.h>
#import <ELBrowser.h>
#import <Masonry.h>

@interface ELCustomAnimViewController ()<ELBrowserViewControllerDelegate,ELBrowserViewControllerDataSource>

@property (strong, nonatomic) UIImageView * imageView1;
@property (strong, nonatomic) UIImageView * imageView2;

@property (nonatomic, assign) CGPoint firstTouchPoint;

@end

@implementation ELCustomAnimViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义动画";
    self.view.backgroundColor = [UIColor grayColor];
    
    self.imageView1 = [[UIImageView alloc]init];
    [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:@"http://ww1.sinaimg.cn/square/673c0421ly1g59r5dmsswj222o340x6p.jpg"]];
    self.imageView1.userInteractionEnabled = YES;
    self.imageView1.tag = 0;
    [self.view addSubview:self.imageView1];
    
    self.imageView2 = [[UIImageView alloc]init];
    [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:@"http://ww2.sinaimg.cn/square/673c0421ly1g59r5fqddoj22b33gmx6r.jpg"]];
    self.imageView2.userInteractionEnabled = YES;
    self.imageView2.tag = 1;
    [self.view addSubview:self.imageView2];
    
    UITapGestureRecognizer * ges1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTapAction:)];
    UITapGestureRecognizer * ges2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTapAction:)];
    [self.imageView1 addGestureRecognizer:ges1];
    [self.imageView2 addGestureRecognizer:ges2];
    
    [self.imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(150);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView1.mas_bottom).offset(40);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
}

- (void)imageViewTapAction:(UIGestureRecognizer *)ges {
    NSMutableArray * originalImageUrls = [NSMutableArray array];
    NSMutableArray * smallImageUrls = [NSMutableArray array];
    
    [smallImageUrls addObject:@"http://ww1.sinaimg.cn/square/673c0421ly1g59r5dmsswj222o340x6p.jpg"];
    [smallImageUrls addObject:@"http://ww2.sinaimg.cn/square/673c0421ly1g59r5fqddoj22b33gmx6r.jpg"];
    
    [originalImageUrls addObject:@"http://ww1.sinaimg.cn/bmiddle/673c0421ly1g59r5dmsswj222o340x6p.jpg"];
    [originalImageUrls addObject:@"http://ww2.sinaimg.cn/bmiddle/673c0421ly1g59r5fqddoj22b33gmx6r.jpg"];
    
    
    ELBrowserViewController * vc = [[ELBrowserViewController alloc]init];
    vc.delegate = self;
    vc.dataSource = self;
    vc.originalUrls = originalImageUrls;
    vc.smallUrls = smallImageUrls;//非必传
    [vc showWithFormViewController:self selectIndex:ges.view.tag];
    
}

#pragma mark -  ELBrowserViewControllerDelegate

/**
 自定义返回样式
 */
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


#pragma mark -  ELBrowserViewControllerDataSource

/**
 自定义开始的位置
 
 @param selectIndex 当前选中index
 @return 开始的位置
 */
- (CGRect)el_browserBeginFrameWithSelectIndex:(NSInteger)selectIndex {
    if (selectIndex == 0) {
        return self.imageView1.frame;
    } else {
        return self.imageView2.frame;
    }
}

/**
 自定义返回位置
 
 @param selectIndex 当前选中index
 @return 消失的位置
 */
- (CGRect)el_browserBackFrameWithSelectIndex:(NSInteger)selectIndex {
   return CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
}


@end
