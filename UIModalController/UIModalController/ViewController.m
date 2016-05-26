//
//  ViewController.m
//  UIModalController
//
//  Created by hesc on 15/8/10.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "MeViewController.h"

@interface ViewController ()<UIActionSheetDelegate, ShowMainDelegate>{
    UIBarButtonItem *_loginButton;
    UIBarButtonItem *_meButton;
    UILabel *_loginInfo;
    BOOL _isLogined;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBar];
    [self addLoginInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addLoginInfo{
    _loginInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 30)];
    _loginInfo.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_loginInfo];
}

-(void)addNavigationBar{
   
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, 44+20)];
    [self.view addSubview:navigationBar];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"聊天"];
    
    _loginButton = [[UIBarButtonItem alloc] initWithTitle:@"登陆" style:UIBarButtonItemStyleDone target:self action:@selector(login)];
    navigationItem.leftBarButtonItem = _loginButton;
    
    _meButton = [[UIBarButtonItem alloc] initWithTitle:@"我" style:UIBarButtonItemStyleDone target:self action:@selector(me)];
    navigationItem.rightBarButtonItem = _meButton;
    _meButton.enabled = NO;
    
    [navigationBar pushNavigationItem:navigationItem animated:NO];
}

-(void)me{
    MeViewController *meController = [MeViewController new];
    meController.userInfo = _loginInfo.text;
    [self presentViewController:meController animated:YES completion:nil];
}

-(void)login{
    if(!_isLogined){
        LoginViewController *loginController = [LoginViewController new];
        loginController.delegate = self;
        [self presentViewController:loginController animated:YES completion:nil];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"系统消息" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"注销" otherButtonTitles: nil];
        [actionSheet showInView:self.view];
    }
}

#pragma mark - 实现代理方法
-(void)showUserInfoWithUserName:(NSString *)userName{
    _isLogined = YES;
    _loginInfo.text = [NSString stringWithFormat:@"hello %@", userName];
    _loginButton.title = @"注销";
    _meButton.enabled = YES;
}

#pragma mark - 实现注销方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        _isLogined = NO;
        _loginButton.title = @"登陆";
        _loginInfo.text = @"";
        _meButton.enabled = NO;
    }
}

@end
