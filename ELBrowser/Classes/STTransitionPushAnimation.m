//
//  STTransitionPushAnimation.m
//  ZDY
//
//  Created by 高欣 on 2019/6/10.
//  Copyright © 2019 getElementByYou. All rights reserved.
//

#import "STTransitionPushAnimation.h"

@implementation STTransitionPushAnimation

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [containerView addSubview:toVC.view];
    
    UIView * bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0;
    bgView.frame = containerView.frame;
    [containerView addSubview:bgView];
    
    
    UIView *tempView = nil;
    if (self.fromImageView) {
        tempView = self.fromImageView;
    }else {
        tempView = [[UIView alloc]init];
    }
    toVC.view.hidden = YES;
    
    [containerView addSubview:tempView];
    tempView.frame = self.beforeFrame;
    
    CGRect finalFrame;
    if (self.fromImageView.image) {
        finalFrame = [self configImageSize:self.fromImageView.image containerView:containerView];
    }else {
        finalFrame = toVC.view.frame;
    }
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         bgView.alpha = 1;
                         tempView.frame = finalFrame;
                     } completion:^(BOOL finished) {
                         toVC.view.hidden = NO;
                         [bgView removeFromSuperview];
                         [tempView removeFromSuperview];
                         [transitionContext completeTransition:YES];
                     }];
}

/**
 根据图片大小 适配手机 更改图片大小
 
 @param image 下载的图片
 @return 适配后的大小
 */
- (CGRect)configImageSize:(UIImage *)image containerView:(UIView *)containerView {
    CGFloat imageViewY = 0;
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    CGFloat fitWidth =  0;
    CGFloat fitHeight = 0;
    
    CGFloat device_w = containerView.bounds.size.width;
    CGFloat device_h = containerView.bounds.size.height;
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
    return  CGRectMake(0, imageViewY, fitWidth, fitHeight);
}

@end
