//
//  STTransitionPopAnimation.m
//  ZDY
//
//  Created by 高欣 on 2019/6/10.
//  Copyright © 2019 getElementByYou. All rights reserved.
//

#import "STTransitionPopAnimation.h"

@implementation STTransitionPopAnimation
- (instancetype)init {
    self = [super init];
    if (self) {
        _afterFrame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 5)/2, ([UIScreen mainScreen].bounds.size.height - 5)/2, 5, 5);
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    //转场过渡的容器view
    UIView *containerView = [transitionContext containerView];
    
    //fromVc
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView * bgView = [[UIView alloc]init];
    bgView.backgroundColor = fromVC.view.backgroundColor;
    bgView.frame = containerView.frame;
    [containerView addSubview:bgView];
    
    UIView * tempFromView = nil;
    
    if (self.fromView) {
        tempFromView = self.fromView;
    }else {
        tempFromView = [[UIView alloc]init];
    }
    
    [containerView addSubview:tempFromView];
    fromVC.view.hidden = YES;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        // 竖屏
        [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            bgView.alpha = 0;
            tempFromView.frame = self.afterFrame;
        } completion:^(BOOL finished) {
            BOOL wasCancelled = [transitionContext transitionWasCancelled];
            [tempFromView removeFromSuperview];
            //设置transitionContext通知系统动画执行完毕
            [transitionContext completeTransition:!wasCancelled];
        }];
    }else {
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            bgView.alpha = 0;
            tempFromView.alpha = 0;
        } completion:^(BOOL finished) {
            BOOL wasCancelled = [transitionContext transitionWasCancelled];
            [tempFromView removeFromSuperview];
            //设置transitionContext通知系统动画执行完毕
            [transitionContext completeTransition:!wasCancelled];
        }];
        
    }
}


@end
