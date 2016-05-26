//
//  ViewController.m
//  CircleImage
//
//  Created by hesc on 15/8/15.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "ViewController.h"
#define PHOTO_WIDTH 150

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize size = [UIScreen mainScreen].bounds.size;
    //添加阴影图层
    CALayer *shadowLayer = [CALayer new];
    shadowLayer.bounds = CGRectMake(0, 0, PHOTO_WIDTH, PHOTO_WIDTH);
    shadowLayer.position = CGPointMake(size.width/2, size.height/2);
    shadowLayer.cornerRadius = PHOTO_WIDTH/2.0;
    shadowLayer.shadowColor = [UIColor grayColor].CGColor;
    shadowLayer.shadowOffset = CGSizeMake(2, 1);
    shadowLayer.shadowOpacity = 1;
    shadowLayer.borderColor = [UIColor whiteColor].CGColor;
    shadowLayer.borderWidth = 2;
    [self.view.layer addSublayer:shadowLayer];
    
    CALayer *layer = [[CALayer alloc] init];
    layer.bounds = CGRectMake(0, 0, PHOTO_WIDTH, PHOTO_WIDTH);
    layer.position = CGPointMake(size.width/2.0, size.height/2.0);
    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.cornerRadius = PHOTO_WIDTH/2.0;
    //注意仅仅设置圆角，对于图形而言可以正常显示，但是对于图层中绘制的图片无法正确显示
    //如果想要正确显示则必须设置masksToBounds=YES，剪切子图层
    layer.masksToBounds = YES;
    //阴影效果无法和masksToBounds同时使用，因为masksToBounds的目的就是剪切外边框，
    //而阴影效果刚好在外边框
    //    layer.shadowColor=[UIColor grayColor].CGColor;
    //    layer.shadowOffset=CGSizeMake(2, 2);
    //    layer.shadowOpacity=1;
    
    //设置边框
    layer.borderColor = [UIColor whiteColor].CGColor;
    layer.borderWidth = 2;
    
    layer.delegate = self;
    //利用图层形变解决图像倒立问题
//    layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
    [layer setValue:@M_PI forKeyPath:@"transform.rotation.x"];
    
    //使用setContents显示图像
//    UIImage *image = [UIImage imageNamed:@"photo.jpg"];
//    [layer setContents:(id)image.CGImage];
    
    [self.view.layer addSublayer:layer];
    //调用图层setNeedDisplay,否则代理方法不会被调用
    [layer setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//绘制图形、图像到图层，注意参数中的ctx是图层的图形上下文，其中绘图位置也是相对图层而言的
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    CGContextSaveGState(ctx);
    
    //解决图片倒立的问题
//    CGContextScaleCTM(ctx, 1, -1);
//    CGContextTranslateCTM(ctx, 0, -PHOTO_WIDTH);
    
    UIImage *image = [UIImage imageNamed:@"photo.jpg"];
    //注意这个位置是相对于图层而言的不是屏幕
    CGContextDrawImage(ctx, CGRectMake(0, 0, PHOTO_WIDTH, PHOTO_WIDTH), image.CGImage);
    
    CGContextRestoreGState(ctx);
}
@end
