//
//  ELBrowserProgressProtocol.h
//  ELBrowser
//
//  Created by 高欣 on 2019/7/5.
//

#import "ELBrowserViewProtocol.h"

@protocol ELBrowserProgressProtocol <ELBrowserViewProtocol>

@required

- (void)setProgress:(CGFloat)progress;

@end
