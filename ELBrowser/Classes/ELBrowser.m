//
//  ELBrowser.m
//  ELBroswer
//
//  Created by 高欣 on 2018/5/25.
//  Copyright © 2018年 getElementByYou. All rights reserved.
//

#import "ELBrowser.h"
#import "ELPhotoBrowserView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "ELPhotoListModel.h"
#import "ELBrowserConfig.h"
#define itemCount 3 //每行 3 张图片

@interface ElBrowserCollectionViewCell :UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation ElBrowserCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imgView];
        self.imgView.frame = self.contentView.bounds;
    }
    return self;
}

- (UIImageView *)imgView
{
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc]init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
    }
    return _imgView;
}

@end


@interface ELBrowser ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * layout;

/**
 配置模型
 */
@property (nonatomic,strong) ELBrowserConfig *config;


@end


@implementation ELBrowser

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
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)showELBrowserWithConfig:(ELBrowserConfig *)config
{
    //赋值 全局调用
    _config = config;
    
    //如果没给margin 就设置默认值
    config.margin = config.margin ?:3;

    //设置背景颜色
    self.collectionView.backgroundColor = config.collectionViewBackgroundColor ?:[UIColor whiteColor];
    
    //设置collectionView的间隔
    self.layout.minimumLineSpacing = config.margin;
    self.layout.minimumInteritemSpacing = config.margin;

    //根据宽度 计算高度
    CGFloat itemW = (config.width - ((itemCount - 1)* config.margin) )/itemCount;
    self.layout.itemSize = CGSizeMake(itemW,itemW);
    
    //默认设置3行
    NSInteger row = config.smallUrls.count? (config.smallUrls.count- 1) / 3 + 1 :0;
    CGFloat height = row * (itemW  + config.margin) - (row ==0 ?0:config.margin);

    //更新collectionView的高度
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height).priorityHigh();
    }];
    
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ElBrowserCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ElBrowserCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.config.smallUrls[indexPath.item]]];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.config.smallUrls.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //将所有的数据封装到数据模型中 再传到要展示的大图视图中
    ELPhotoListModel * model = [[ELPhotoListModel alloc]init];
    model.listCollectionView = self.collectionView;
    model.indexPath = indexPath;
    model.originalUrls = self.config.smallUrls.count == self.config.originalUrls.count ? self.config.originalUrls : self.config.smallUrls;
    model.smallUrls = self.config.smallUrls;
    
    NSMutableArray * imgArr = [NSMutableArray array];
    for (int a= 0; a < self.config.smallUrls.count; a++) {
        ElBrowserCollectionViewCell * cell = (ElBrowserCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:a inSection:0]];
        UIImage * image = cell.imgView.image;
        if (image) {
            [imgArr addObject:image];
        }else
        {
            [imgArr addObject:[UIImage imageNamed:@"ELBroswerImg.bundle/placeholderimage"]];
        }
    }
    model.imgArr = imgArr;
    
    NSMutableArray * mutArr = [NSMutableArray array];
    for (int a= 0; a < model.smallUrls.count; a++) {
        ELPhotoModel * photoModel = [[ELPhotoModel alloc]init];
        photoModel.smallURL = model.smallUrls[a];
        photoModel.picURL = model.originalUrls[a];
        photoModel.image = model.imgArr[a];
        photoModel.listCellF =  [self listCellFrame:[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:a inSection:indexPath.section]]];
        photoModel.needAnimation = a == indexPath.row ? YES : NO;
        photoModel.config = self.config;
        [mutArr addObject:photoModel];
    }
    model.photoModels = mutArr;
    
    ELPhotoBrowserView * photoView = [[ELPhotoBrowserView alloc]init];
    photoView.listModel = model;
    [photoView show];
}


/**
 获取listCell 在window中的对应位置
 
 @param cell cell
 @return 对应的frame
 */
- (CGRect)listCellFrame:(UICollectionViewCell *)cell
{
    CGRect cellRect = [self.collectionView convertRect:cell.frame toView:self.collectionView];
    CGRect cell_window_rect = [self.collectionView convertRect:cellRect toView:self.window];
    return cell_window_rect;
}

@end
