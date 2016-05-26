//
//  ViewController.m
//  TouchEventController
//
//  Created by hesc on 15/8/11.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "ViewController.h"
#import "CustomImageView.h"

@interface ViewController (){
    CustomImageView *_imageView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageView = [[CustomImageView alloc] initWithFrame:CGRectMake(50, 50, 150, 169)];
    [self.view addSubview:_imageView];
            
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"UIViewController start touch...");
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"UIViewController end touch...");
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    CGPoint current = [touch locationInView:self.view];
    CGPoint previous = [touch previousLocationInView:self.view];
    
    CGPoint offset = CGPointMake(current.x-previous.x, current.y-previous.y);
    CGPoint center = _imageView.center;
    _imageView.center = CGPointMake(center.x+offset.x, center.y+offset.y);
    
    NSLog(@"UIViewController moving...");
}

@end
