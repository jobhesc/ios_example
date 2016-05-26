//
//  ViewController.m
//  MotionEvent
//
//  Created by hesc on 15/8/11.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "ViewController.h"
#import "ShakeImageView.h"

@interface ViewController (){
    ShakeImageView *_imageView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageView = [[ShakeImageView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    _imageView.userInteractionEnabled = YES;
    
    [self.view addSubview:_imageView];
}

-(void)viewDidAppear:(BOOL)animated{
    //视图显示时让控件变成第一响应者
    [_imageView becomeFirstResponder];
}

-(void)viewDidDisappear:(BOOL)animated{
    //视图不显示时注销控件第一响应者的身份
    [_imageView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
