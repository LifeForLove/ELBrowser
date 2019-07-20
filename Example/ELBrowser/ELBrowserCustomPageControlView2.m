//
//  ELBrowserCustomPageControlView2.m
//  ELBrowser_Example
//
//  Created by ZCGC on 2019/7/19.
//  Copyright © 2019 LifeForLove. All rights reserved.
//

#import "ELBrowserCustomPageControlView2.h"
#import <Masonry.h>
@interface ELBrowserCustomPageControlView2 ()

@end

@implementation ELBrowserCustomPageControlView2

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.font = [UIFont systemFontOfSize:12];
        self.textColor = [UIColor whiteColor];
    }
    return self;
}

- (void)resetFrame:(UIView *)view {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view).offset(-20);
        make.left.equalTo(view).offset(20);
    }];
}

- (void)el_browserPageControlChanged:(NSInteger)currentSelectIndex totalCount:(NSInteger)totalCount {
    self.text = [NSString stringWithFormat:@"%ld/%ld",currentSelectIndex + 1,totalCount];
}


@end
