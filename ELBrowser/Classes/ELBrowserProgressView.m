//
//  ELBrowserProgressView.m
//  ELBrowser
//
//  Created by 高欣 on 2019/7/5.
//

#import "ELBrowserProgressView.h"
//角度转换为弧度
#define CircleDegreeToRadian(d) ((d)*M_PI)/180.0
//宽高定义
#define CircleSelfWidth self.frame.size.width
#define CircleSelfHeight self.frame.size.height

@interface ELBrowserProgressView ()

/**
 线条背景色
 */
@property (nonatomic, strong) UIColor *pathBackColor;

/**
 线条填充色
 */
@property (nonatomic, strong) UIColor *pathFillColor;

/**
 起点角度。角度从水平右侧开始为0，顺时针为增加角度。直接传度数 如-90
 */
@property (nonatomic, assign) CGFloat startAngle;

/**
 减少的角度 直接传度数 如30
 */
@property (nonatomic, assign) CGFloat reduceValue;

/**
 线宽
 */
@property (nonatomic, assign) CGFloat strokeWidth;


/**
 是否显示小圆点
 */
@property (nonatomic, assign) BOOL showPoint;

/**
 是否显示文字
 */
@property (nonatomic, assign) BOOL showProgressText;

@end

@implementation ELBrowserProgressView {
    CGFloat fakeProgress;
}
- (instancetype)init {
    if (self = [super init]) {
        [self initialization];
        _startAngle = CircleDegreeToRadian(90);
        _strokeWidth = 3;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
    }
    return self;
}

//初始化数据
- (void)initialization {
    self.backgroundColor = [UIColor grayColor];
    _strokeWidth = 10;//线宽默认为10
    _startAngle = -CircleDegreeToRadian(90);//圆起点位置
    _reduceValue = CircleDegreeToRadian(0);//整个圆缺少的角度
    fakeProgress = 0.0;//用来逐渐增加直到等于progress的值
    _showPoint = YES;//小圆点
    _showProgressText = YES;//文字
}

#pragma Set
- (void)setStartAngle:(CGFloat)startAngle {
    if (_startAngle != CircleDegreeToRadian(startAngle)) {
        _startAngle = CircleDegreeToRadian(startAngle);
    }
}

- (void)setReduceValue:(CGFloat)reduceValue {
    if (_reduceValue != CircleDegreeToRadian(reduceValue)) {
        if (reduceValue>=360) {
            return;
        }
        _reduceValue = CircleDegreeToRadian(reduceValue);
    }
}

- (void)setStrokeWidth:(CGFloat)strokeWidth {
    if (_strokeWidth != strokeWidth) {
        _strokeWidth = strokeWidth;
    }
}

- (void)setPathBackColor:(UIColor *)pathBackColor {
    if (_pathBackColor != pathBackColor) {
        _pathBackColor = pathBackColor;
    }
}

- (void)setPathFillColor:(UIColor *)pathFillColor {
    if (_pathFillColor != pathFillColor) {
        _pathFillColor = pathFillColor;
    }
}

- (void)setShowPoint:(BOOL)showPoint {
    if (_showPoint != showPoint) {
        _showPoint = showPoint;
    }
}

-(void)setShowProgressText:(BOOL)showProgressText {
    if (_showProgressText != showProgressText) {
        _showProgressText = showProgressText;
    }
}


//画背景线、填充线、小圆点、文字
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    //获取图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //设置中心点 半径 起点及终点
    CGFloat maxWidth = self.frame.size.width<self.frame.size.height?self.frame.size.width:self.frame.size.height;
    CGPoint center = CGPointMake(maxWidth/2.0, maxWidth/2.0);
    CGFloat radius = maxWidth/2.0-_strokeWidth/2.0- 5 - 15;//留出5像素，防止与边界相切的地方被切平
    CGFloat endA = _startAngle + (CircleDegreeToRadian(360) - _reduceValue);//圆终点位置
    CGFloat valueEndA = _startAngle + (CircleDegreeToRadian(360)-_reduceValue)*fakeProgress;  //数值终点位置
    
    //背景线
    UIBezierPath *basePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:_startAngle endAngle:endA clockwise:YES];
    //线条宽度
    CGContextSetLineWidth(ctx, _strokeWidth);
    //设置线条顶端
    CGContextSetLineCap(ctx, kCGLineCapRound);
    //线条颜色
    [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3] setStroke];
    //把路径添加到上下文
    CGContextAddPath(ctx, basePath.CGPath);
    //渲染背景线
    CGContextStrokePath(ctx);
    
    //路径线
    UIBezierPath *valuePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:_startAngle endAngle:valueEndA clockwise:YES];
    //设置线条顶端
    CGContextSetLineCap(ctx, kCGLineCapRound);
    //线条颜色
    [_pathFillColor setStroke];
    //把路径添加到上下文
    CGContextAddPath(ctx, valuePath.CGPath);
    //渲染数值线
    CGContextStrokePath(ctx);
    
    //画小圆点
    if (_showPoint) {
        CGContextDrawImage(ctx, CGRectMake(CircleSelfWidth/2 + ((CGRectGetWidth(self.bounds)-_strokeWidth)/2.f-1)*cosf(valueEndA)-_strokeWidth/2.0, CircleSelfWidth/2 + ((CGRectGetWidth(self.bounds)-_strokeWidth)/2.f-1)*sinf(valueEndA)-_strokeWidth/2.0, _strokeWidth, _strokeWidth), [UIImage imageNamed:@"circle_point"].CGImage);
    }
    
    if (_showProgressText) {
        //画文字
        NSString *currentText = [NSString stringWithFormat:@"%.f%%",fakeProgress <= 0 ?0:fakeProgress*100];
        
        NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        textStyle.lineBreakMode = NSLineBreakByWordWrapping;
        textStyle.alignment = NSTextAlignmentCenter;//水平居中
        //字体
        UIFont *font = [UIFont boldSystemFontOfSize:11.0];
        //构建属性集合
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:textStyle,NSForegroundColorAttributeName:self.pathFillColor?:[UIColor whiteColor]};
        //获得size
        CGSize stringSize = [currentText sizeWithAttributes:attributes];
        //垂直居中
        CGRect r = CGRectMake((CircleSelfWidth-stringSize.width)/2.0, (CircleSelfHeight - stringSize.height)/2.0,stringSize.width, stringSize.height);
        [currentText drawInRect:r withAttributes:attributes];
    }
    
}

//设置进度
- (void)setProgress:(CGFloat)progress {
    fakeProgress = progress;
    [self setNeedsDisplay];
    
    if (progress ==  1) {
        [self removeProgressView];
    }
}

- (void)removeProgressView {
    [self removeFromSuperview];
}

- (void)resetFrame:(UIView *)contentView {
    self.frame = CGRectMake(0, 0, 80, 80);
    self.center = contentView.center;
}



@end
