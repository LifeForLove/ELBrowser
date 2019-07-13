//
//  ELBrowserCollectionViewCellProtocol.h
//  ELBrowser
//
//  Created by 高欣 on 2019/7/12.
//

@class ELBrowserViewController;
@protocol ELBrowserCollectionViewCellProtocol <NSObject>

@optional

@property (nonatomic,weak) UIViewController *fromViewController;

@property (nonatomic,weak) ELBrowserViewController *browserViewController;

- (void)setModel:(id)model;

@end
