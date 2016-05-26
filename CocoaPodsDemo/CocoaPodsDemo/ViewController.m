//
//  ViewController.m
//  CocoaPodsDemo
//
//  Created by hesc on 15/10/8.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "ViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController (){
    UIImageView *_imageView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:@"http://picture.youth.cn/qtdb/201510/W020151008223066875453.jpg"]];
    [self.view addSubview:_imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
