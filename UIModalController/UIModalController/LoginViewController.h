//
//  LoginViewController.h
//  UIModalController
//
//  Created by hesc on 15/8/10.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShowMainDelegate;

@interface LoginViewController : UIViewController
@property (nonatomic, strong) id<ShowMainDelegate> delegate;
@end
