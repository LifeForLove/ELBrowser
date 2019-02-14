//
//  ELBrowserConfig.h
//  ELBroswer
//
//  Created by 高欣 on 2018/5/25.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ELBrowserConfig : NSObject

/**
 大图图片数组
 */
@property (nonatomic, strong) NSArray<NSString *> *originalUrls;

/**
 小的图片数组
 */
@property (nonatomic, strong) NSArray<NSString *> *smallUrls;

/**
 图片间距
 */
@property (nonatomic, assign) CGFloat margin;

/**
 控件宽度
 */
@property (nonatomic, assign) CGFloat width;

/**
 背景颜色
 */
@property (nonatomic,strong) UIColor *collectionViewBackgroundColor;

/**
 进度条的颜色
 */
@property (nonatomic,strong) UIColor *progressPathFillColor;

/**
 进度条的背景视图的颜色
 */
@property (nonatomic,strong) UIColor *progressBackgroundColor;

/**
 进度条的宽度
 */
@property (nonatomic,assign) NSInteger progressPathWidth;


@end
