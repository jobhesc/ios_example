//
//  ViewController.h
//  UIModalController
//
//  Created by hesc on 15/8/10.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowMainDelegate
-(void)showUserInfoWithUserName:(NSString *)userName;
@end

@interface ViewController : UIViewController


@end

