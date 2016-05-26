//
//  ViewController.h
//  NSThread
//
//  Created by hesc on 15/8/16.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnLoadImage;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

-(IBAction)loadImage:(id)sender;
@end

