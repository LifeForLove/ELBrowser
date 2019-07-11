//
//  ELCustomProgressView.m
//  ELBrowser_Example
//
//  Created by 高欣 on 2019/7/9.
//  Copyright © 2019 LifeForLove. All rights reserved.
//

#import "ELCustomProgressView.h"

@interface ELCustomProgressView ()
//背景圆环
@property (nonatomic, strong) CAShapeLayer *backCircle;
//前面圆环
@property (nonatomic, strong) CAShapeLayer *foreCircle;

@property (nonatomic, assign) CGRect circlesSize;

@end

@implementation ELCustomProgressView

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, 80, 80) circlesSize:CGRectMake(30, 3, 30, 3)];
}

- (instancetype)initWithFrame:(CGRect)frame circlesSize:(CGRect)size
{
    self = [super initWithFrame:frame];
    if (self) {
        self.circlesSize = size;
        self.layer.cornerRadius = 10;
        [self initView];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [self addBackCircleWithSize:self.circlesSize.origin.x lineWidth:self.circlesSize.origin.y];
    [self addForeCircleWidthSize:self.circlesSize.size.width lineWidth:self.circlesSize.size.height];
}

//添加背景的圆环
- (void)addBackCircleWithSize:(CGFloat)radius lineWidth:(CGFloat)lineWidth{
    self.backCircle = [self createShapeLayerWithSize:radius lineWith:lineWidth color:[UIColor grayColor]];
    self.backCircle.strokeStart = 0;
    self.backCircle.strokeEnd = 1;
    self.backCircle.strokeColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:0.3].CGColor;
    [self.layer addSublayer:self.backCircle];
}

//前面的圆环
- (void)addForeCircleWidthSize:(CGFloat)radius lineWidth:(CGFloat)lineWidth{
    self.foreCircle = [self createShapeLayerWithSize:radius lineWith:lineWidth color:[UIColor greenColor]];
    
    self.foreCircle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius)
                                                          radius:radius-lineWidth/2
                                                      startAngle:-M_PI/2
                                                        endAngle:M_PI/180*270
                                                       clockwise:YES].CGPath;
    self.foreCircle.strokeStart = 0;
    self.foreCircle.strokeEnd = 0.8;
    self.foreCircle.strokeColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:self.foreCircle];
}

//创建圆环
-(CAShapeLayer *)createShapeLayerWithSize:(CGFloat)radius lineWith:(CGFloat)lineWidth color:(UIColor *)color{
    CGRect foreCircle_frame = CGRectMake(self.bounds.size.width/2-radius,
                                         self.bounds.size.height/2-radius,
                                         radius*2,
                                         radius*2);
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = foreCircle_frame;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius)
                                                        radius:radius-lineWidth/2
                                                    startAngle:0
                                                      endAngle:M_PI*2
                                                     clockwise:YES];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.strokeColor = color.CGColor;
    layer.lineWidth = lineWidth;
    layer.lineCap = @"round";
    
    return layer;
}

#pragma mark -  ELBrowserProgressProtocol

- (void)resetFrame:(UIView *)contentView {
    self.center = contentView.center;
}

- (void)setProgress:(CGFloat)progress {
    if (self.foreCircle) {
        self.foreCircle.strokeEnd = progress;
    }
}

@end
