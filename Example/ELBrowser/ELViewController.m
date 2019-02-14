//
//  ELViewController.m
//  ELBrowser
//
//  Created by LifeForLove on 02/14/2019.
//  Copyright (c) 2019 LifeForLove. All rights reserved.
//

#import "ELViewController.h"

#import "Masonry.h"
#import "ELBrowser.h"

@interface ElTableViewCell :UITableViewCell

@property (nonatomic,strong) ELBrowser * browser;


/**
 图片链接数组
 */
@property (nonatomic,strong) NSArray *picArr;


@end


@implementation ElTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        [self createView];
    }
    return self;
}

- (void)createView
{
    [self.contentView addSubview:self.browser];
    [self.browser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.width.mas_equalTo(200);
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
}

- (void)setPicArr:(NSArray *)picArr
{
    _picArr = picArr;
    
    NSMutableArray * thumbnailImageUrls = [NSMutableArray array];
    NSMutableArray * originalImageUrls = [NSMutableArray array];
    for (NSDictionary * dic in picArr) {
        [thumbnailImageUrls addObject:dic[@"timg"]];
        [originalImageUrls addObject:dic[@"oimg"]];
    }
    
    ELBrowserConfig * config = [[ELBrowserConfig alloc]init];
    config.originalUrls = originalImageUrls;//大图
    config.smallUrls = thumbnailImageUrls;//缩略图 (必传)
    config.width = 200;//宽度 (必传)
    //    config.progressPathWidth = 1;
    //    config.progressPathFillColor = [UIColor redColor];
    //    config.progressBackgroundColor = [UIColor whiteColor];
    [self.browser showELBrowserWithConfig:config];
    
}


- (ELBrowser *)browser
{
    if (_browser == nil) {
        _browser = [[ELBrowser alloc]init];
    }
    return _browser;
}


@end


@interface ELViewController ()

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *infoArr;

@end

@implementation ELViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.infoArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ImageURLPlist.plist" ofType:nil]];
    
    //******************** 如果不使用tableView 直接用下面这种写法就行了 ************************
    
    /*
     NSArray * imgArr = self.infoArr.firstObject;
     NSMutableArray * thumbnailImageUrls = [NSMutableArray array];
     NSMutableArray * originalImageUrls = [NSMutableArray array];
     for (NSDictionary * dic in imgArr) {
     [thumbnailImageUrls addObject:dic[@"timg"]];
     [originalImageUrls addObject:dic[@"oimg"]];
     }
     
     ELBrowser * browser = [[ELBrowser alloc]init];
     ELBrowserConfig * config = [[ELBrowserConfig alloc]init];
     config.width = 200;
     //    config.progressPathWidth = 1;
     //    config.progressPathFillColor = [UIColor redColor];
     //    config.progressBackgroundColor = [UIColor whiteColor];
     config.originalUrls = originalImageUrls;
     config.smallUrls = thumbnailImageUrls;
     [browser showELBrowserWithConfig:config];
     [self.view addSubview:browser];
     [browser mas_makeConstraints:^(MASConstraintMaker *make) {
     make.size.mas_equalTo(200);
     make.center.equalTo(self.view);
     }];
     */
    
    
    //****************** 使用tableView的情况 *********************************
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ElTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ElTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.picArr = self.infoArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (UITableView *)tableView
{
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
