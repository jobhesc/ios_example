//
//  ViewController.m
//  Banner
//
//  Created by hesc on 15/8/5.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "ViewController.h"

#define IMAGEVIEW_COUNT 3

@interface ViewController ()<UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    UIImageView *_leftImageView;
    UIImageView *_rightImageView;
    UIImageView *_centerImageView;
    UIPageControl *_pageControl;
    UILabel *_label;
    NSMutableDictionary *_imageData;
    int _currentImageIndex;
    int _imageCount;
    
    int _screen_width;  //屏幕宽度
    int _screen_height;  //屏幕高度
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setScreenSize];
    [self loadImageData];
    [self addScrollView];
    [self addImageViews];
    [self addPageControl];
    [self addLabel];
    [self setDefaultImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setScreenSize{
    _screen_width = [UIScreen mainScreen].bounds.size.width;
    _screen_height = [UIScreen mainScreen].bounds.size.height;
}

-(void) loadImageData{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"imageInfo" ofType:@"plist"];
    _imageData = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    _imageCount = (int)_imageData.count;
}

-(void) addScrollView{
    _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_scrollView];
    _scrollView.delegate = self;
    
    _scrollView.contentSize = CGSizeMake(IMAGEVIEW_COUNT*_screen_width, _screen_height);
    //默认显示中间的图片
    [_scrollView setContentOffset:CGPointMake(_screen_width, 0) animated:NO];
    //设置分页
    _scrollView.pagingEnabled = YES;
    //去掉水平滚动条
    _scrollView.showsHorizontalScrollIndicator = NO;
}

-(void) addImageViews{
    _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _screen_width, _screen_height)];
    _centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_screen_width, 0, _screen_width, _screen_height)];
    _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_screen_width*2, 0, _screen_width, _screen_height)];
    _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    _centerImageView.contentMode = UIViewContentModeScaleAspectFit;
    _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_scrollView addSubview:_leftImageView];
    [_scrollView addSubview:_centerImageView];
    [_scrollView addSubview:_rightImageView];
}

-(void) addPageControl{
    _pageControl = [[UIPageControl alloc] init];
    
    CGSize size = [_pageControl sizeForNumberOfPages:_imageCount];
    _pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
    _pageControl.center = CGPointMake(_screen_width/2, _screen_height-50);
    //设置颜色
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:193/255.0 green:219/255.0 blue:249/255.0 alpha:1];
    //当前页的颜色
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0 green:150/255.0 blue:1 alpha:1];
    //总页数
    _pageControl.numberOfPages = _imageCount;
    
    [self.view addSubview:_pageControl];
}

-(void) addLabel{
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, _screen_width, 30)];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor colorWithRed:0 green:150/255.0 blue:1 alpha:1];
    [self.view addSubview:_label];
}

-(void) setDefaultImage{
    _leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg", _imageCount]];
    _centerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg", 1]];
    _rightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg", 2]];
    
    _currentImageIndex = 0;
    [self setPageInfo];
}

-(void)setPageInfo{
    _pageControl.currentPage = _currentImageIndex;
    NSString *_imageName = [NSString stringWithFormat:@"%i.jpg", _currentImageIndex+1];
    _label.text = _imageData[_imageName];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //重新加载图片
    [self reloadImage];
    //移动到中间
    [_scrollView setContentOffset:CGPointMake(_screen_width, 0) animated:NO];
    //设置分页信息
    [self setPageInfo];
}

-(void) reloadImage{
    CGPoint offset = _scrollView.contentOffset;

    if(offset.x>_screen_width){  //向右移动
        _currentImageIndex = (_currentImageIndex + 1)%_imageCount;
    } else {  //向左移动
        _currentImageIndex = (_currentImageIndex + _imageCount - 1)%_imageCount;
    }
    
    int _rightImageIndex = (_currentImageIndex + 1)%_imageCount;
    int _leftImageIndex = (_currentImageIndex + _imageCount - 1)%_imageCount;
    
    _centerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg", _currentImageIndex+1]];
    _leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg", _leftImageIndex+1]];
    _rightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg", _rightImageIndex+1]];
    
}
- (IBAction)load:(id)sender {
}
@end
