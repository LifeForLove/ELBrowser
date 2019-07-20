//
//  ELBrowserViewProtocol.h
//  ELBrowser
//
//  Created by ZCGC on 2019/7/20.
//

#import <Foundation/Foundation.h>

@class ELBrowserViewController;
@protocol ELBrowserViewProtocol <NSObject>

@required

- (void)resetFrame:(UIView *)view;

@optional

@property (nonatomic,weak) UIViewController *fromViewController;

@property (nonatomic,weak) ELBrowserViewController *browserViewController;

@end
