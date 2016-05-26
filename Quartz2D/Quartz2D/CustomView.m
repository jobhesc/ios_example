//
//  CustomView.m
//  Quartz2D
//
//  Created by hesc on 15/8/11.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "CustomView.h"
#define TILE_SIZE 20

@implementation CustomView

-(void)drawRect:(CGRect)rect{
//    [self drawRectWithBase];
//    [self drawRectWithSimple];
//    [self drawRectWithContext];
//    [self drawRectByUIKit];
//    [self drawEllipse];
    
//    [self drawArc];
//    [self drawCurve];
    
//    [self drawText];
//    [self drawImage];
    
//    [self drawLinearGradient];
//    [self drawRadialGradient];
//    [self drawRectWithLinearGradient];
    
//    [self drawBackgroundWithColorPattern];
//    [self drawBackgroundWithPattern];
    
//    [self drawImageWithTransform];
//    [self drawImageWithTransformUseCG];
    
    [self drawTextWithDisplayViewInvalidate];
}


#pragma mark - 基本图形绘制
-(void)drawRectWithBase{
    //1、取得图形上下文对象
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //2、创建路径对象
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 20, 50);
    CGPathAddLineToPoint(path, nil, 20, 100);
    CGPathAddLineToPoint(path, nil, 300, 100);
    
    //3、添加路径到图形上下文
    CGContextAddPath(context, path);
    
    //4、设置图形上下文状态属性
    CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1);  //设置笔触颜色
    CGContextSetRGBFillColor(context, 0, 1.0, 0, 1);  //设置填充颜色
    CGContextSetLineWidth(context, 2.0);  //设置线条宽度
    CGContextSetLineCap(context, kCGLineCapRound);   //设置顶点样式， (20,50)和(300,100)是顶点
    CGContextSetLineJoin(context, kCGLineJoinRound);  //设置连接点样式，(20,100)是连接点
    
    /*设置线段样式
     phase:虚线开始的位置
     lengths:虚线长度间隔（例如下面的定义说明第一条线段长度10，然后间隔8重新绘制10点的长度线段，当然这个数组可以定义更多元素）
     count:虚线数组元素个数
     */
    CGFloat lenths[2] = {10, 8};
    CGContextSetLineDash(context, 0, lenths, 2);
    
    /*设置阴影
     context:图形上下文
     offset:偏移量
     blur:模糊度
     color:阴影颜色
     */
    CGColorRef colorRef = [UIColor grayColor].CGColor;  //颜色转换，由于Quartz 2D跨平台，所以其中不能使用UIKit中的对象，但是UIkit提供了转化方法
    CGContextSetShadowWithColor(context, CGSizeMake(2, 2), 0.8, colorRef);
    
    //5.绘制图像到指定图形上下文
    /*CGPathDrawingMode是填充方式,枚举类型
     kCGPathFill:只有填充（非零缠绕数填充），不绘制边框
     kCGPathEOFill:奇偶规则填充（多条路径交叉时，奇数交叉填充，偶交叉不填充）
     kCGPathStroke:只有边框
     kCGPathFillStroke：既有边框又有填充
     kCGPathEOFillStroke：奇偶填充并绘制边框
     */
    CGContextDrawPath(context, kCGPathFillStroke);
    
    //6、释放对象
    CGPathRelease(path);
}


#pragma mark - 简化图形绘制
-(void)drawRectWithSimple{
    //1、取得图形上下文对象
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //2、创建路径对象
    CGContextMoveToPoint(context, 20, 50);
    CGContextAddLineToPoint(context, 20, 100);
    CGContextAddLineToPoint(context, 300, 100);
    //封闭路径:a.创建一条起点和终点的线,不推荐
    //CGPathAddLineToPoint(path, nil, 20, 50);
    //封闭路径:b.直接调用路径封闭方法
    CGContextClosePath(context);
    
    //3、设置图形上下文状态属性
    [[UIColor redColor] setStroke];  //设置红色边框
    [[UIColor greenColor] setFill];  //设置绿色填充
//    [[UIColor blueColor] set];  //同时设置边框和填充色
    
    //4、绘制路径
    CGContextDrawPath(context, kCGPathFillStroke);
    
}

#pragma mark - 绘制矩形
-(void)drawRectWithContext{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //添加矩形对象
    CGRect rect = CGRectMake(20, 50, 280, 50);
    CGContextAddRect(context, rect);
    //设置属性
    [[UIColor blueColor]set];
    //绘制
    CGContextDrawPath(context, kCGPathFillStroke);
}

#pragma mark -绘制矩形（使用UIKit的封装方法）
-(void)drawRectByUIKit{
    CGRect rect = CGRectMake(20, 150, 280, 50);
    [[UIColor yellowColor] set];
    //绘制矩形,相当于创建对象、添加对象到上下文、绘制三个步骤
    UIRectFill(rect);  //绘制矩形(只有填充)
    
    CGRect rect2 = CGRectMake(20, 250, 280, 50);
    [[UIColor redColor] setStroke];
    UIRectFrame(rect2);    //绘制矩形(只有边框)
    
}

#pragma mark - 绘制椭圆
-(void)drawEllipse{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //添加对象,绘制椭圆（圆形）的过程也是先创建一个矩形
    CGRect rect = CGRectMake(50, 50, 220, 160);
    CGContextAddEllipseInRect(context, rect);
    
    [[UIColor purpleColor]set];
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

#pragma mark - 绘制弧形
-(void)drawArc{
    CGContextRef context = UIGraphicsGetCurrentContext();
    /*添加弧形对象
     x:中心点x坐标
     y:中心点y坐标
     radius:半径
     startAngle:起始弧度
     endAngle:终止弧度
     closewise:是否逆时针绘制，0则顺时针绘制
     */
    CGContextAddArc(context, 160, 160, 100, 0, M_PI_2, 1);
    
    [[UIColor yellowColor] set];
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

#pragma mark - 绘制贝塞尔曲线
-(void)drawCurve{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, 20, 100); // 移动到起始位置
    /*绘制二次贝塞尔曲线
     c:图形上下文
     cpx:控制点x坐标
     cpy:控制点y坐标
     x:结束点x坐标
     y:结束点y坐标
     */
    CGContextAddQuadCurveToPoint(context, 160, 0, 300, 100);
    
    CGContextMoveToPoint(context, 50, 500);
    /*绘制三次贝塞尔曲线
     c:图形上下文
     cp1x:第一个控制点x坐标
     cp1y:第一个控制点y坐标
     cp2x:第二个控制点x坐标
     cp2y:第二个控制点y坐标
     x:结束点x坐标
     y:结束点y坐标
     */
    CGContextAddCurveToPoint(context, 80, 300, 250, 500, 300, 300);
    
    [[UIColor redColor] setStroke];
    [[UIColor yellowColor] setFill];
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

#pragma mark - 绘制文本
-(void)drawText{
    NSString *str = @"在2014年度的俄罗斯“坦克两项”及“航空飞镖”竞赛和“环太平洋-2014”演习中，中国的参演参赛军人都取得傲人佳绩。在“坦克两项”竞赛中，中国坦克主炮射击19发19中，在所有参赛国家中独获殊荣；在“环太平洋-2014”演习中，中国军舰主炮射击成绩第一，副炮射击全部命中目标，亦是名列前茅。";
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGRect rect = CGRectMake(20, 50, size.width - 40, size.height - 50);
    UIFont *font = [UIFont systemFontOfSize:18];   //设置字体
    UIColor *fontColor = [UIColor redColor];   //字体颜色
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];  //段落样式
    style.alignment=NSTextAlignmentLeft;   //对齐方式
    [str drawInRect:rect withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:fontColor, NSParagraphStyleAttributeName:style}];
}

#pragma mark - 绘制图像
-(void)drawImage{
    UIImage *image = [UIImage imageNamed:@"0.jpg"];
    //从某一个点开始绘制
//    [image drawAtPoint:CGPointMake(10, 50)];
    
    //绘制到某一个矩形区域，注意如果大小不合适会进行拉伸
    [image drawInRect:CGRectMake(10, 50, 300, 450)];
    //平铺绘制
//    [image drawAsPatternInRect:CGRectMake(0, 0, 320, 568)];
}

#pragma mark - 绘制线性渐变图案
-(void)drawLinearGradient{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //使用rgb颜色空间
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    /*指定渐变色
     space:颜色空间
     components:颜色数组,注意由于指定了RGB颜色空间，那么四个数组元素表示一个颜色（red、green、blue、alpha），
     如果有三个颜色则这个数组有4*3个元素
     locations:颜色所在位置（范围0~1），这个数组的个数不小于components中存放颜色的个数
     count:渐变个数，等于locations的个数
     */
    CGFloat components[12] = {
        248.0/255.0,86.0/255.0,86.0/255.0,1,
        249.0/255.0,127.0/255.0,127.0/255.0,1,
        1.0,1.0,1.0,1.0};
    CGFloat locations[3] = {0, 0.3, 1};
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef, components, locations, 3);
    /*绘制线性渐变
     context:图形上下文
     gradient:渐变色
     startPoint:起始位置
     endPoint:终止位置
     options:绘制方式,kCGGradientDrawsBeforeStartLocation 开始位置之前就进行绘制，到结束位置之后不再绘制，
     kCGGradientDrawsAfterEndLocation开始位置之前不进行绘制，到结束点之后继续填充
     */
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGContextDrawLinearGradient(context, gradientRef, CGPointZero, CGPointMake(size.width, size.height), kCGGradientDrawsAfterEndLocation);
    
    CGColorSpaceRelease(colorSpaceRef);
}

#pragma mark - 绘制径向渐变图案
-(void)drawRadialGradient{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //使用rgb颜色空间
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    /*指定渐变色
     space:颜色空间
     components:颜色数组,注意由于指定了RGB颜色空间，那么四个数组元素表示一个颜色（red、green、blue、alpha），
     如果有三个颜色则这个数组有4*3个元素
     locations:颜色所在位置（范围0~1），这个数组的个数不小于components中存放颜色的个数
     count:渐变个数，等于locations的个数
     */
    CGFloat components[12] = {
        248.0/255.0,86.0/255.0,86.0/255.0,1,
        249.0/255.0,127.0/255.0,127.0/255.0,1,
        1.0,1.0,1.0,1.0};
    CGFloat locations[3] = {0, 0.3, 1};
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef, components, locations, 3);
    
    /*绘制径向渐变
     context:图形上下文
     gradient:渐变色
     startCenter:起始点位置
     startRadius:起始半径（通常为0，否则在此半径范围内容无任何填充）
     endCenter:终点位置（通常和起始点相同，否则会有偏移）
     endRadius:终点半径（也就是渐变的扩散长度）
     options:绘制方式,kCGGradientDrawsBeforeStartLocation 开始位置之前就进行绘制，但是到结束位置之后不再绘制，
     kCGGradientDrawsAfterEndLocation开始位置之前不进行绘制，但到结束点之后继续填充
     */
    CGContextDrawRadialGradient(context, gradientRef, CGPointMake(160, 284), 0, CGPointMake(165, 289), 150,kCGGradientDrawsAfterEndLocation);
    
    CGColorSpaceRelease(colorSpaceRef);
}

#pragma mark - 渐变填充
-(void)drawRectWithLinearGradient{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //使用rgb颜色空间
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    //裁切处一块矩形用于显示，注意必须先裁切再调用渐变
    //CGContextClipToRect(context, CGRectMake(20, 50, 280, 300));
    //裁切还可以使用UIKit中对应的方法
    UIRectClip(CGRectMake(20, 50, 280, 300));
    
    CGFloat components[12] = {
        248.0/255.0,86.0/255.0,86.0/255.0,1,
        249.0/255.0,127.0/255.0,127.0/255.0,1,
        1.0,1.0,1.0,1.0};
    CGFloat locations[3] = {0, 0.3, 1};
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef, components, locations, 3);
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGContextDrawLinearGradient(context, gradientRef, CGPointZero, CGPointMake(size.width, size.height), kCGGradientDrawsAfterEndLocation);
    
    CGColorSpaceRelease(colorSpaceRef);
}

#pragma mark - 有颜色填充模式
void drawColoredTile(void *info, CGContextRef context){
    //有颜色填充，这里设置填充色
    CGContextSetRGBFillColor(context, 254/255.0, 52/255.0, 90/255.0, 1);
    CGContextFillRect(context, CGRectMake(0, 0, TILE_SIZE, TILE_SIZE));
    CGContextFillRect(context, CGRectMake(TILE_SIZE, TILE_SIZE, TILE_SIZE, TILE_SIZE));
}

-(void)drawBackgroundWithColorPattern{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //模式填充颜色空间,注意对于有颜色填充模式，这里传NULL
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreatePattern(NULL);
    //将填充色颜色空间设置为模式填充的颜色空间
    CGContextSetFillColorSpace(context, colorSpaceRef);
    
    //填充模式回调函数结构体
    CGPatternCallbacks callback = {0, &drawColoredTile, NULL};
    /*填充模式
     info://传递给callback的参数
     bounds:瓷砖大小
     matrix:形变
     xStep:瓷砖横向间距
     yStep:瓷砖纵向间距
     tiling:贴砖的方法
     isClored:绘制的瓷砖是否已经指定了颜色(对于有颜色瓷砖此处指定位true)
     callbacks:回调函数
     */
    CGPatternRef pattern = CGPatternCreate(NULL, CGRectMake(0, 0, 2*TILE_SIZE, 2*TILE_SIZE), CGAffineTransformIdentity, 2*TILE_SIZE, 2*TILE_SIZE, kCGPatternTilingNoDistortion, true, &callback);
    
    CGFloat alpha = 1;
    //注意最后一个参数对于有颜色瓷砖指定为透明度的参数地址，对于无颜色瓷砖则指定当前颜色空间对应的颜色数组
    CGContextSetFillPattern(context, pattern, &alpha);
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    
    CGColorSpaceRelease(colorSpaceRef);
    CGPatternRelease(pattern);
}

#pragma mark - 无颜色填充模式
//填充瓷砖的回调函数（必须满足CGPatternCallbacks签名）
void drawTile(void *info, CGContextRef context){
    CGContextFillRect(context, CGRectMake(0, 0, TILE_SIZE, TILE_SIZE));
    CGContextFillRect(context, CGRectMake(TILE_SIZE, TILE_SIZE, TILE_SIZE, TILE_SIZE));
}

-(void)drawBackgroundWithPattern{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    //模式填充颜色空间
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreatePattern(rgbColorSpace);
    
    //将填充色颜色空间设置为模式填充的颜色空间
    CGContextSetFillColorSpace(context, colorSpaceRef);
    
    //填充模式回调函数结构体
    CGPatternCallbacks callback = {0, &drawTile, NULL};
    /*填充模式
     info://传递给callback的参数
     bounds:瓷砖大小
     matrix:形变
     xStep:瓷砖横向间距
     yStep:瓷砖纵向间距
     tiling:贴砖的方法
     isClored:绘制的瓷砖是否已经指定了颜色(对于有颜色瓷砖此处指定位true)
     callbacks:回调函数
     */
    CGPatternRef pattern = CGPatternCreate(NULL, CGRectMake(0, 0, 2*TILE_SIZE, 2*TILE_SIZE), CGAffineTransformIdentity, 2*TILE_SIZE, 2*TILE_SIZE, kCGPatternTilingNoDistortion, false, &callback);
    
    CGFloat components[] = {254/255.0, 52/255.0, 90/255.0,1};
    //注意最后一个参数对于无颜色填充模式指定为当前颜色空间颜色数据
    CGContextSetFillPattern(context, pattern, components);
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    
    CGColorSpaceRelease(colorSpaceRef);
    CGColorSpaceRelease(rgbColorSpace);
    CGPatternRelease(pattern);
}

#pragma mark - 图形上下文形变
-(void)drawImageWithTransform{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //保存初始状态
    CGContextSaveGState(context);
    
    //图形上下文向右平移100
    CGContextTranslateCTM(context, 100, 0);
    //图形上下文缩放0.8
    CGContextScaleCTM(context, 0.8, 0.8);
    //图形上下文旋转
    CGContextRotateCTM(context, M_PI_4/4);
    
    UIImage *image = [UIImage imageNamed:@"0.jpg"];
    [image drawInRect:CGRectMake(0, 50, 240, 300)];
    
    //恢复到初始状态
    CGContextRestoreGState(context);
}

#pragma mark - 使用Core Graphics绘制图像
-(void)drawImageWithTransformUseCG{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *image = [UIImage imageNamed:@"0.jpg"];
    
    CGContextSaveGState(context);
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat height = 450, y = 50;
    //上下文形变
    CGContextScaleCTM(context, 1.0, -1.0);  //在y轴缩放-1相当于沿着x张旋转180
    CGContextTranslateCTM(context, 0,  -(screenSize.height-(screenSize.height-2*y-height))); //向上平移
    
    CGRect rect = CGRectMake(10, y, 300, height);
    //注意这里传入的是CGImage，UIImage已经存在转换的方法
    CGContextDrawImage(context, rect, image.CGImage);
    
    CGContextRestoreGState(context);
}

#pragma mark - 演示视图刷新
-(void)drawTextWithDisplayViewInvalidate{
    
    UIColor *color = [UIColor redColor];
    UIFont *font = [UIFont fontWithName:@"Marker Felt" size:self.fontSize];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;   // 居中排列
    
    CGRect rect = CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 100);
    [self.title drawInRect:rect withAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName: color}];
}
@end
