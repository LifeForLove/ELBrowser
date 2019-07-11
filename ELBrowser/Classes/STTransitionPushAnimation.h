//
//  STTransitionPushAnimation.h
//  ZDY
//
//  Created by 高欣 on 2019/6/10.
//  Copyright © 2019 getElementByYou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface STTransitionPushAnimation : NSObject<UIViewControllerAnimatedTransitioning>

/**
 需要动画的view
 */
@property (nonatomic,strong) UIImageView *fromImageView;

@property (nonatomic,assign) CGRect beforeFrame;

@end

NS_ASSUME_NONNULL_END
