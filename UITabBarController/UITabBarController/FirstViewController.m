//
//  FirstViewController.m
//  UITabBarController
//
//  Created by hesc on 15/8/9.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

-(instancetype)init{
    if(self = [super init]){
        self.view.backgroundColor = [UIColor redColor];
        self.title = @"首页";
        
        self.tabBarItem.title = self.title;
        self.tabBarItem.image = [[UIImage imageNamed:@"icon_sy_up.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_sy_down.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
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
