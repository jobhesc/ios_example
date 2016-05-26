//
//  ViewController.m
//  UIScrollView
//
//  Created by hesc on 15/8/4.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加scrollview
    _scrollView = [[UIScrollView alloc] initWithFrame: [UIScreen mainScreen].applicationFrame];
    _scrollView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:_scrollView];
    
    //添加图片
    UIImage *image = [UIImage imageNamed:@"image01.jpg"];
    _imageView = [[UIImageView alloc] initWithImage:image];
    [_scrollView addSubview:_imageView];
    
    //contentSize必须设置,否则无法滚动，当前设置为图片大小
    _scrollView.contentSize = _imageView.frame.size;
    
    //实现缩放：maxinumZoomScale必须大于minimumZoomScale同时实现viewForZoomingInScrollView方法
    _scrollView.minimumZoomScale = 0.6;
    _scrollView.maximumZoomScale = 3.0;
    
    _scrollView.delegate = self;
    //隐藏滚动条
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    //禁用弹簧效果
//    _scrollView.bounces = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) scrollViewDidZoom:(UIScrollView *)scrollView{
    CGSize originalSize = _scrollView.bounds.size;
    CGSize contentSize = _scrollView.contentSize;
    
    CGFloat offsetX = originalSize.width>contentSize.width?(originalSize.width-contentSize.width)/2.0:0;
    CGFloat offsetY = originalSize.height>contentSize.height?(originalSize.height-contentSize.height)/2.0:0;
    
    _imageView.center = CGPointMake(contentSize.width/2.0+offsetX, contentSize.height/2.0+offsetY);
}

#pragma mark - 实现缩放视图代理方法，不实现此方法无法缩放
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewWillBeginDecelerating");
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndDecelerating");
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"scrollViewWillBeginDragging");
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"scrollViewDidEndDragging");
}
-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    NSLog(@"scrollViewWillBeginZooming");
}
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    NSLog(@"scrollViewDidEndZooming");
}
- (IBAction)load:(id)sender {
}
@end
