//
//  ContactViewController.m
//  UINavigationController
//
//  Created by hesc on 15/8/9.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "ContactViewController.h"
#import "PublishAccountViewController.h"

@interface ContactViewController ()

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"联系人";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"账号" style:UIBarButtonItemStyleDone target:self action:@selector(gotoPublishAccount)];
    self.navigationItem.backBarButtonItem.title = self.navigationItem.title;
}

-(void)gotoPublishAccount{
    PublishAccountViewController *accountController = [PublishAccountViewController new];
    [self.navigationController pushViewController:accountController animated:YES];
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
