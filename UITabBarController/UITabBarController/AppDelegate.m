//
//  AppDelegate.m
//  UITabBarController
//
//  Created by hesc on 15/8/9.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    TabBarViewController *tabBarController = [TabBarViewController new];
    FirstViewController *homeController = [FirstViewController new];
    SecondViewController *discoveryController = [SecondViewController new];
    
    UIViewController *imController = [UIViewController new];
    imController.tabBarItem.title = @"消息";
    imController.tabBarItem.image = [[UIImage imageNamed:@"icon_xx_up.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    imController.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_xx_down.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIViewController *meController = [UIViewController new];
    meController.tabBarItem.title = @"我";
    meController.tabBarItem.image = [[UIImage imageNamed:@"icon_w_up.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    meController.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_w_down.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
    tabBarController.viewControllers = @[homeController, discoveryController, imController, meController];
    
    _window.rootViewController = tabBarController;
    [_window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
