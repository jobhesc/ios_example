//
//  ViewController.m
//  NSThread2
//
//  Created by hesc on 15/8/16.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "ViewController.h"
#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define CELL_SPACE 10


@interface ViewController (){
    NSMutableArray *_imageViews;
    dispatch_semaphore_t _semaphore;  //定义一个信号量
}

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat cellWidth = (size.width-(COLUMN_COUNT+1)*CELL_SPACE)/(COLUMN_COUNT*1.0);
    CGFloat cellHeight = (size.height - (ROW_COUNT+1)*CELL_SPACE)/(ROW_COUNT*1.0);
    
    _imageViews = [[NSMutableArray alloc]init];
    for(int i = 0; i<ROW_COUNT; i++){
        for(int j = 0; j<COLUMN_COUNT; j++){
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CELL_SPACE*(j+1)+cellWidth*j, CELL_SPACE*(i+1)+cellHeight*i, cellWidth, cellHeight)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.view addSubview:imageView];
            [_imageViews addObject:imageView];
        }
    }
    
    UIButton *btnLoadImage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnLoadImage.bounds = CGRectMake(0, 0, 220, 30);
    btnLoadImage.center = CGPointMake(size.width/2, size.height-100);
    [btnLoadImage setTitle:@"加载图片" forState:UIControlStateNormal];
    [btnLoadImage addTarget:self action:@selector(loadImageWithConcurrent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLoadImage];
    
    /*初始化信号量
     参数是信号量初始值
     */
    _semaphore = dispatch_semaphore_create(1);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateImage:(NSData *)imageData withIndex:(int)index{
    UIImageView *imageView = _imageViews[index];
    imageView.image = [UIImage imageWithData:imageData];
}

-(NSData *) requestData:(NSNumber *)index{
//    @autoreleasepool {
//        NSURL *url = [NSURL URLWithString:@"http://images.apple.com/v/watch/e/apple-pay/images/hero_medium_2x.jpg"];
//        return [NSData dataWithContentsOfURL:url];
//    }
    
    //GCD中多线程操作方法不需要使用@autoreleasepool，GCD会管理内存
    NSURL *url = [NSURL URLWithString:@"http://images.apple.com/v/watch/e/apple-pay/images/hero_medium_2x.jpg"];
    return [NSData dataWithContentsOfURL:url];

}

-(void)loadImageWithThread:(NSNumber *)index{
    NSLog(@"current thread:%@", [NSThread currentThread]);
    NSData *data = [self requestData:index];
    
    /*信号等待
    第二个参数：等待时间
    */
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    //信号通知
    dispatch_semaphore_signal(_semaphore);
    
    //更新UI界面,此处调用了GCD主线程队列的方法
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_sync(mainQueue, ^{
        [self updateImage:data withIndex:[index intValue]];
    });
    
}

#pragma mark - 串行方式
-(void)loadImagesWithSerialQueue{
    /*创建一个串行队列
     第一个参数：队列名称
     第二个参数：队列类型
     */
    dispatch_queue_t serialQueue = dispatch_queue_create("myThreadQueue", DISPATCH_QUEUE_SERIAL);//注意queue对象不是指针类型
    for(int i=0; i<_imageViews.count; i++){
        //异步执行队列任务
        dispatch_async(serialQueue, ^{
            [self loadImageWithThread:[NSNumber numberWithInt:i]];
        });
    }
    //非ARC环境请释放
    //    dispatch_release(seriQueue);
    
}

#pragma mark - 并行方式
-(void)loadImageWithConcurrent{
    /*创建一个并行队列
     第一个参数：队列名称
     第二个参数：队列类型
     */
//    dispatch_queue_t concurrentQueue = dispatch_queue_create("myThreadQueue", DISPATCH_QUEUE_CONCURRENT);//注意queue对象不是指针类型
    
    //实际开发中我们通常不会重新创建一个并发队列而是使用dispatch_get_global_queue()方法取得一个全局的并发队列
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for(int i=0; i<_imageViews.count; i++){
        //异步执行队列任务
        dispatch_async(concurrentQueue, ^{
            [self loadImageWithThread:[NSNumber numberWithInt:i]];
        });
    }
}

@end
