//
//  ViewController.m
//  BoundAnimation
//
//  Created by hesc on 15/8/16.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    UILabel *label = [[UILabel alloc] init];
    label.bounds = CGRectMake(0, 0, size.width, 50);
    label.center = CGPointMake(size.width/2, size.height/2-80);
    label.alpha = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor redColor];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"28元"];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(0, 2)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(2, 1)];
    label.attributedText = str;
    [self.view addSubview:label];
    
    [UIView animateWithDuration:1 delay:2 usingSpringWithDamping:0.3 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        label.center = CGPointMake(size.width/2, size.height/2);
        label.alpha = 1;
    } completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
