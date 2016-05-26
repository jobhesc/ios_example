//
//  ViewController.m
//  TransitionAnimation
//
//  Created by hesc on 15/8/16.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "ViewController.h"
#define IMAGE_COUNT 6

@interface ViewController (){
    UIImageView *_imageView;
    int _currentIndex;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.image = [UIImage imageNamed:@"0.jpg"];
    [self.view addSubview:_imageView];
    
    //添加手势
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftRecognizer];
    
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightRecognizer];
    
    _currentIndex = 0;
}

-(void)leftSwipe:(UISwipeGestureRecognizer *)recognizer{
    [self transitionAnimation:YES];
}

-(void)rightSwipe:(UISwipeGestureRecognizer *)recognizer{
    [self transitionAnimation:NO];
}

-(void)transitionAnimation:(BOOL)isNext{
    CATransition *transition = [[CATransition alloc] init];
    //设置动画类型,注意对于苹果官方没公开的动画类型只能使用字符串，并没有对应的常量定义
    transition.type = @"cube";
    
    //设置子类型
    if(isNext){
        transition.subtype = kCATransitionFromRight;
    } else {
        transition.subtype = kCATransitionFromLeft;
    }
    
    transition.duration = 1;
    
    if(isNext){
        _currentIndex = (_currentIndex+1)%IMAGE_COUNT;
    } else {
        _currentIndex = (_currentIndex + IMAGE_COUNT - 1)%IMAGE_COUNT;
    }
    _imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg", _currentIndex]];
    
    [_imageView.layer addAnimation:transition forKey:@"TransitionAnimation"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
