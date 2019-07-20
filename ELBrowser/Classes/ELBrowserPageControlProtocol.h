//
//  ELBrowserPageControlProtocol.h
//  ELBrowser
//
//  Created by 高欣 on 2019/7/9.
//

#import "ELBrowserViewProtocol.h"

@protocol ELBrowserPageControlProtocol <ELBrowserViewProtocol>

@required

- (void)el_browserPageControlChanged:(NSInteger)currentSelectIndex totalCount:(NSInteger)totalCount;

@end
