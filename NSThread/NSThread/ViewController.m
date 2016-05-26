//
//  ViewController.m
//  NSThread
//
//  Created by hesc on 15/8/16.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateImage:(NSData *)imageData{
    _imageView.image = [UIImage imageWithData:imageData];
}

-(NSData *)requestData{
    @autoreleasepool {
        //对于多线程操作建议把线程操作放到@autoreleasepool中
        NSURL *url = [NSURL URLWithString:@"http://images.apple.com/v/iphone/home/q/home/images/iphone6_medium_2x.png"];
        return [NSData dataWithContentsOfURL:url];
    }
}

-(void)loadImageWithThread{
    //请求数据
    NSData *data = [self requestData];
    /*将数据显示到UI控件,注意只能在主线程中更新UI,
     另外performSelectorOnMainThread方法是NSObject的分类方法，每个NSObject对象都有此方法，
     它调用的selector方法是当前调用控件的方法，例如使用UIImageView调用的时候selector就是UIImageView的方法
     Object：代表调用方法的参数,不过只能传递一个参数(如果有多个参数请使用对象进行封装)
     waitUntilDone:是否线程任务完成执行
     */
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:data waitUntilDone:YES];
}

-(IBAction)loadImage:(id)sender{
    //方法1：使用对象方法
    //创建一个线程，第一个参数是请求的操作，第二个参数是操作方法的参数
    //    NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(loadImage) object:nil];
    //    //启动一个线程，注意启动一个线程并非就一定立即执行，而是处于就绪状态，当系统调度时才真正执行
//    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(loadImageWithThread) object:nil];
//    [thread start];
    
     //方法2：使用类方法
    [NSThread detachNewThreadSelector:@selector(loadImageWithThread) toTarget:self withObject:nil];
}

@end
