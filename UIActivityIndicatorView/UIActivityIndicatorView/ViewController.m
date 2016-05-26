//
//  ViewController.m
//  UIActivityIndicatorView
//
//  Created by hesc on 15/8/27.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [imageView setImage:[UIImage imageNamed:@"1.jpg"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    
    [self showUIActivityIndicatorViewWithView];
//    [self showUIActivityIndicatorViewWithAlert];
}

-(void)showUIActivityIndicatorViewWithView{
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    UIView *view = [[UIView alloc] init];
    view.bounds = CGRectMake(0, 0, 50, 50);
    view.center = CGPointMake(size.width/2, size.height/2);
    view.alpha = 0.8;
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:view];
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicatorView.frame = CGRectMake(0, 0, 50, 50);
    [view addSubview:indicatorView];
    [indicatorView startAnimating];
}

-(void)showUIActivityIndicatorViewWithAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"  " delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    UIActivityIndicatorView *progress= [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 100, 30, 30)];
    progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [alert addSubview:progress];
    [progress startAnimating];
    [alert show];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"loading..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
//    
//    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    indicatorView.frame = CGRectMake(0, 0, 50, 50);
//    [alertView addSubview:indicatorView];
//    
//    [indicatorView startAnimating];
//    [alertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
