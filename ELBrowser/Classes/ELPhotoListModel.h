//
//  ELPhotoListModel.h
//  ELBroswer
//
//  Created by 高欣 on 2018/5/25.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ELBrowserConfig;

/**
 当前图片的数据模型
 */
@interface ELPhotoModel : NSObject

@property (nonatomic,assign) CGRect listCellF;

@property (nonatomic,copy) NSString *smallURL;

@property (nonatomic,copy) NSString *picURL;

@property (nonatomic,strong) UIImage *image;

/**
 只有第一张才需要动画
 */
@property (nonatomic,assign) BOOL needAnimation;

@property (nonatomic,strong) ELBrowserConfig *config;

@end



@interface ELPhotoListModel : NSObject

@property (nonatomic,strong) UICollectionView *listCollectionView;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,strong) NSArray *originalUrls;

@property (nonatomic,strong) NSArray *smallUrls;

@property (nonatomic,strong) NSArray *imgArr;

@property (nonatomic,strong) NSArray <ELPhotoModel *>*photoModels;

@end
