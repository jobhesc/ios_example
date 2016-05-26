//
//  ViewController.m
//  Quartz2D
//
//  Created by hesc on 15/8/11.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "ViewController.h"
#import "CustomView.h"

@interface ViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>{
    CustomView *_contentView;
    NSArray *_fontSize;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _fontSize = @[@15,@18, @20, @22, @25, @28, @30, @32, @35, @40];
    
    _contentView = [[CustomView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.title = @"中华人民共和国中国共产党";
    _contentView.fontSize = 15;
    [self.view addSubview:_contentView];
    
    [self addPickView];
    
    //利用图形上下文添加水印效果
    UIImage *image = [self drawImageAtImageContext];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.center = CGPointMake(160, 300);
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addPickView{
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat height = 268;
    UIPickerView *pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, size.height-268, size.width, height)];
    pickView.dataSource = self;
    pickView.delegate = self;
    [self.view addSubview:pickView];
}

#pragma mark - pickerView数据源
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _fontSize.count;
}

#pragma mark - pickerView代理方法
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%@号字体", _fontSize[row]];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _contentView.fontSize = [[_fontSize objectAtIndex:row] intValue];
    //刷新视图
    [_contentView setNeedsDisplay];
}

#pragma mark - 利用图形上下文添加水印效果
-(UIImage *)drawImageAtImageContext{
    //获得一个位图上下文对象
    CGSize size = CGSizeMake(300, 188);  //画布大小
    UIGraphicsBeginImageContext(size);
    
    UIImage *image = [UIImage imageNamed:@"0.jpg"];
    [image drawInRect:CGRectMake(0, 0, 300, 188)];  //注意绘图的位置是相对于画布顶点而言，不是屏幕
    
    //添加水印
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 200, 178);
    CGContextAddLineToPoint(context, 270, 178);
    
    [[UIColor redColor] setStroke];
    CGContextSetLineWidth(context, 2);
    
    CGContextDrawPath(context, kCGPathStroke);
    
    NSString *sign = @"无印出品";
    [sign drawInRect:CGRectMake(200, 158, 100, 30) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor redColor]}];
    //返回绘制的新图形
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //最后一定不要忘记关闭对应的上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
