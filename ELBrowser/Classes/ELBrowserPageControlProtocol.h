//
//  ELBrowserPageControlProtocol.h
//  ELBrowser
//
//  Created by 高欣 on 2019/7/9.
//

#import <Foundation/Foundation.h>

@protocol ELBrowserPageControlProtocol <NSObject>

@required

- (void)resetFrame:(UIView *)view;

- (void)el_browserPageControlChanged:(NSInteger)currentSelectIndex totalCount:(NSInteger)totalCount;

@end
