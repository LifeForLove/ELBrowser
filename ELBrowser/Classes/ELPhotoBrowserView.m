//
//  ElPhotoBrowserView.m
//  RACMVVMDemo
//
//  Created by apple on 2018/4/11.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import "ELPhotoBrowserView.h"
#import "ELPhotoBrowserCollectionViewCell.h"
#import "Masonry.h"
#import "ELPhotoListModel.h"
@interface ELPhotoBrowserView()<UICollectionViewDelegate,UICollectionViewDataSource,ELPhotoBrowserCollectionViewCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * layout;
@property (nonatomic, strong) UIPageControl *pageControl;

@end


@implementation ELPhotoBrowserView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self creatView];
    }
    return self;
}

- (void)creatView
{
    [self addSubview:self.collectionView];
    self.collectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [UIView animateWithDuration:0.2 animations:^{
        self.collectionView.backgroundColor = [UIColor blackColor];
    }];
    
    [self.collectionView addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-50);
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ELPhotoBrowserCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.photoModel = self.listModel.photoModels[indexPath.item];
    cell.delegate = self;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listModel.originalUrls.count;
}

- (void)setListModel:(ELPhotoListModel *)listModel
{
    _listModel = listModel;
    
    [self.collectionView reloadData];
    self.pageControl.numberOfPages = self.listModel.originalUrls.count;
    self.pageControl.hidden = self.listModel.originalUrls.count <= 1 ? YES : NO;
    
    [self.collectionView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width * self.listModel.indexPath.item,0)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.pageControl.currentPage = self.listModel.indexPath.item;
    });
    
}


/**
 隐藏
 
 @param cell 回到对应的cell
 */
- (void)hiddenAction:(ELPhotoBrowserCollectionViewCell *)cell
{
    [self.pageControl removeFromSuperview];
    for (int i = 0; i < self.listModel.originalUrls.count; i++)
    {
        NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
        if (i == indexPath.item) {
            [UIView animateWithDuration:0.4 animations:^{
                self.collectionView.backgroundColor = [UIColor clearColor];
                cell.imageView.frame = self.listModel.photoModels[i].listCellF;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
            return;
        }
        
    }
    
}


/**
 更改pageControl
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = (int)scrollView.contentOffset.x / (int)[UIScreen mainScreen].bounds.size.width;
}


/**
 设置背景的透明度

 @param alpha 透明度值
 */
- (void)backgroundAlpha:(CGFloat)alpha
{
    self.collectionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha];
    self.pageControl.alpha = alpha == 1 ?:0;
}


- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ELPhotoBrowserCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.backgroundColor = [UIColor clearColor];
        self.layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.layout.minimumLineSpacing = 0;
        self.layout.minimumInteritemSpacing = 0;
    }
    return _collectionView;
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc]init];
    }
    return _pageControl;
}


- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

@end
