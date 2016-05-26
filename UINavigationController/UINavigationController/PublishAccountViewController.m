//
//  PublishAccountViewController.m
//  UINavigationController
//
//  Created by hesc on 15/8/9.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "PublishAccountViewController.h"

@interface PublishAccountViewController ()

@end

@implementation PublishAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"账号";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"朋友" style:UIBarButtonItemStyleDone target:self action:@selector(gotoFriends)];
    
}

-(void)gotoFriends{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
