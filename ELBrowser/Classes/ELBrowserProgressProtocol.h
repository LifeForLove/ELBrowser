//
//  ELBrowserProgressProtocol.h
//  ELBrowser
//
//  Created by 高欣 on 2019/7/5.
//

#import <Foundation/Foundation.h>

@protocol ELBrowserProgressProtocol <NSObject>

@required

- (void)resetFrame:(UIView *)contentView;

- (void)setProgress:(CGFloat)progress;

@end
