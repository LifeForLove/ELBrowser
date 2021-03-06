//
//  ELViewController.m
//  ELBrowser
//
//  Created by LifeForLove on 02/14/2019.
//  Copyright (c) 2019 LifeForLove. All rights reserved.
//

#import "ELViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <ELBrowser.h>
#import <Masonry.h>
#import "ELBrowserCustomPageControlView.h"
#import "ELCustomProgressView.h"
#import "ELCustomAnimViewController.h"

@interface ELCollectionViewCell :UICollectionViewCell
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation ELCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imgView];
        self.imgView.frame = self.contentView.bounds;
    }
    return self;
}

- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc]init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
    }
    return _imgView;
}
@end


@protocol ElTableViewCellDelegate <NSObject>

- (void)selectCollectionCellWithIndex:(NSInteger)index picArr:(NSArray *)picArr;

@end

@interface ElTableViewCell :UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,ELBrowserViewControllerDelegate,ELBrowserViewControllerDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UICollectionViewFlowLayout *layout;

@property (strong, nonatomic) UILabel * titleLabel;

/**
 图片链接数组
 */
@property (nonatomic,strong) NSArray *picArr;

@property (nonatomic,weak) id<ElTableViewCellDelegate> delegate;

@end


@implementation ElTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        [self createView];
    }
    return self;
}

- (void)createView {
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.titleLabel];
    [self.collectionView registerClass:[ELCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.width.mas_equalTo(200);
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.picArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat item_w = (200 - 2 * 4)/3;
    return CGSizeMake(item_w,item_w);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ELCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.picArr[indexPath.item][@"timg"]]];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    NSMutableArray * originalImageUrls = [NSMutableArray array];
    NSMutableArray * smallImageUrls = [NSMutableArray array];
    for (NSDictionary * dic in self.picArr) {
        [originalImageUrls addObject:dic[@"oimg"]];
        [smallImageUrls addObject:dic[@"timg"]];
    }
    ELBrowserViewController * vc = [[ELBrowserViewController alloc]init];
    vc.delegate = self;
    vc.dataSource = self;
    vc.originalUrls = originalImageUrls;
    vc.smallUrls = smallImageUrls;//非必传
    
    if ([self.titleLabel.text isEqualToString:@"自定义加载视图"]) {
        
#pragma mark - 自定义进度条 非必传
        vc.customProgressClassString = @"ELCustomProgressView";
        
    } else if ([self.titleLabel.text isEqualToString:@"自定义cell"]) {
        
#pragma mark - 自定义cell 非必传
        vc.customCellClassString = @"ELBrowserCustomCollectionViewCell";
        //自定义cell的数据模型
        vc.customCellModelArray = @[@"测试1",@"测试2",@"测试3",@"测试4"];
        
    } else if ([self.titleLabel.text isEqualToString:@"自定义view"]) {
        
#pragma mark - 自定义cell 非必传
        vc.customViewClassString = @"ELBrowserCustomView1";
        
    } else if ([self.titleLabel.text isEqualToString:@"自定义分页视图1"]) {
        
#pragma mark - 自定义分页视图 非必传
        vc.customPageControlClassString = @"ELBrowserCustomPageControlView";
        
    } else if ([self.titleLabel.text isEqualToString:@"自定义分页视图2"]) {
        
#pragma mark - 自定义分页视图 非必传
        vc.customPageControlClassString = @"ELBrowserCustomPageControlView2";
        
    } else if ([self.titleLabel.text isEqualToString:@"组合使用样式"]) {
#pragma mark - 组合使用样式
        vc.customViewClassString = @"ELBrowserCustomView1";
        vc.customPageControlClassString = @"ELBrowserCustomPageControlView2";
    } else if ([self.titleLabel.text isEqualToString:@"自定义动画样式"]) {
#pragma mark - 自定义返回样式
        ELCustomAnimViewController * vc = [[ELCustomAnimViewController alloc]init];
        [[self viewController].navigationController pushViewController:vc animated:YES];
        return;
    }
    [vc showWithFormViewController:[self viewController] selectIndex:indexPath.item];
}

#pragma mark -  ELBrowserViewControllerDelegate
/**
 长按手势
 */
-  (void)el_browserLongPressAction:(ELBrowserViewController *)browserViewContrller  {
    NSLog(@"longpressAction");
}

/**
 消失回调
 */
- (void)el_browserDissmissComplate {
    NSLog(@"el_browserDissmissComplate");
}

#pragma mark -  ELBrowserViewControllerDataSource

/**
 自定义开始的位置
 
 @param selectIndex 当前选中index
 @return 开始的位置
 */
- (CGRect)el_browserBeginFrameWithSelectIndex:(NSInteger)selectIndex {
    UICollectionViewCell * cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0]];
    UIViewController * topVc = [self viewController];
    CGRect cellf = [self.collectionView convertRect:cell.frame toView:topVc.view];
    return cellf;
}

/**
 自定义返回位置

 @param selectIndex 当前选中index
 @return 消失的位置
 */
- (CGRect)el_browserBackFrameWithSelectIndex:(NSInteger)selectIndex {
    UICollectionViewCell * cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0]];
    UIViewController * topVc = [self viewController];
    CGRect cellf = [self.collectionView convertRect:cell.frame toView:topVc.view];
    return cellf;
}

- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        self.layout.sectionInset = UIEdgeInsetsMake(2,2,2,2);
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
    }
    return _layout;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
    }
    return _titleLabel;
}


- (void)setPicArr:(NSArray *)picArr {
    _picArr = picArr;
    
    NSMutableArray * thumbnailImageUrls = [NSMutableArray array];
    NSMutableArray * originalImageUrls = [NSMutableArray array];
    for (NSDictionary * dic in picArr) {
        [thumbnailImageUrls addObject:dic[@"timg"]];
        [originalImageUrls addObject:dic[@"oimg"]];
    }
    
    [self.collectionView reloadData];
}


@end


@interface ELViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *infoArr;

@property (strong, nonatomic) NSArray * titleArr;

@end

@implementation ELViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.infoArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ImageURLPlist.plist" ofType:nil]];
    
    self.titleArr = @[@"普通样式",
                      @"自定义cell",
                      @"自定义view",
                      @"长图、GIF图",
                      @"自定义分页视图1",
                      @"自定义分页视图2",
                      @"自定义加载视图",
                      @"组合使用样式",
                      @"自定义动画样式"];
    
    //****************** 使用tableView的情况 *********************************
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(CGRectGetMaxY(self.navigationController.navigationBar.frame));
        make.left.right.bottom.equalTo(self.view);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ElTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ElTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.picArr = self.infoArr[indexPath.row];
    [cell.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        NSInteger row = MAX(0, cell.picArr.count - 1) / 3 + 1;
        CGFloat item_h = (200 - 2 * 4)/3 + 2;
        make.height.mas_equalTo(row * item_h + 2);
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text =  indexPath.row < self.titleArr.count ? self.titleArr[indexPath.row] : nil;
    return cell;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 44.f;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
