//
//  SecondViewController.m
//  UITabBarController
//
//  Created by hesc on 15/8/9.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

-(instancetype)init{
    if(self = [super init]){
        self.view.backgroundColor = [UIColor greenColor];
        self.title = @"发现";
        
        self.tabBarItem.title = self.title;
        self.tabBarItem.image = [[UIImage imageNamed:@"icon_fx_up.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_fx_down.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        self.tabBarItem.badgeValue = @"5";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
