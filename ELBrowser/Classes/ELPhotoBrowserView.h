//
//  ELPhotoBrowserView.h
//  ELBroswer
//
//  Created by 高欣 on 2018/5/25.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ELPhotoListModel;


/**
 展示的大图View
 */
@interface ELPhotoBrowserView : UIView

@property (nonatomic,strong) ELPhotoListModel *listModel;

- (void)show;

@end
