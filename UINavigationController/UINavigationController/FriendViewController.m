//
//  FriendViewController.m
//  UINavigationController
//
//  Created by hesc on 15/8/9.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "FriendViewController.h"
#import "ContactViewController.h"

@interface FriendViewController ()

@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"朋友";
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"联系人" style:UIBarButtonItemStyleDone target:self action:@selector(addFriends)];
    self.navigationItem.backBarButtonItem.title = @"朋友";
}

-(void)addFriends{
    ContactViewController *contactController = [ContactViewController new];
    [self.navigationController pushViewController:contactController animated:YES];
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
