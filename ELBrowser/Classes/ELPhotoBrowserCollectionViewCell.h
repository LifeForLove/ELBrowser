//
//  ElPhotoBrowserCollectionViewCell.h
//  RACMVVMDemo
//
//  Created by apple on 2018/4/12.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ELPhotoBrowserCollectionViewCell;
@class ELPhotoModel;
@protocol ELPhotoBrowserCollectionViewCellDelegate <NSObject>

/**
 缩小

 @param cell 对应的cell
 */
- (void)hiddenAction:(ELPhotoBrowserCollectionViewCell *)cell;

/**
 背景渐变

 @param alpha 渐变值
 */
- (void)backgroundAlpha:(CGFloat)alpha;

@end

@interface ELPhotoBrowserCollectionViewCell : UICollectionViewCell

/**
 单个图片模型
 */
@property (nonatomic,strong) ELPhotoModel *photoModel;

/**
 展示的imageView 图片
 */
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, weak) id<ELPhotoBrowserCollectionViewCellDelegate> delegate;

@end
