//
//  LoginViewController.m
//  UIModalController
//
//  Created by hesc on 15/8/10.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"

@interface LoginViewController (){
    UITextField *_txtUserName;
    UITextField *_txtPassword;
    
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addLoginForm];
    [self addGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addGestureRecognizer{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide{
    for(UIResponder *responder in self.view.subviews){
        if(responder.isFirstResponder){
            [responder resignFirstResponder];
        }
    }
}

-(void)addLoginForm{
    //用户名
    UILabel *lbUserName = [[UILabel alloc] initWithFrame:CGRectMake(50, 150, 100, 30)];
    lbUserName.text = @"用户名：";
    [self.view addSubview:lbUserName];
    
    _txtUserName = [[UITextField alloc] initWithFrame:CGRectMake(120, 150, 150, 30)];
    _txtUserName.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_txtUserName];
    
    //密码
    UILabel *lbPassword = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, 100, 30)];
    lbPassword.text = @"密码：";
    [self.view addSubview:lbPassword];
    
    _txtPassword = [[UITextField alloc] initWithFrame:CGRectMake(120, 200, 150, 30)];
    _txtPassword.borderStyle = UITextBorderStyleRoundedRect;
    _txtPassword.secureTextEntry = YES;
    [self.view addSubview:_txtPassword];
    
    //登陆按钮
    UIButton *btnLogin = [UIButton buttonWithType:UIButtonTypeSystem];
    btnLogin.frame =CGRectMake(70, 270, 80, 30);
    [btnLogin setTitle:@"登陆" forState:UIControlStateNormal];
    [self.view addSubview:btnLogin];
    [btnLogin addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    //取消登陆按钮
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeSystem];
    btnCancel.frame = CGRectMake(170, 270, 80, 30);
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [self.view addSubview:btnCancel];
    [btnCancel addTarget:self action:@selector(cancelLogin) forControlEvents:UIControlEventTouchUpInside];
}

-(void)cancelLogin{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)login{
    if([_txtUserName.text isEqualToString:@"hesc"] && [_txtPassword.text isEqualToString:@"1"]){
        [self.delegate showUserInfoWithUserName:_txtUserName.text];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"系统信息" message:@"用户名或者密码错误，请重新输入" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alertView show];
    }    
}

@end
