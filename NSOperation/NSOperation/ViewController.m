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
}

@end

@interface ImageData : NSObject
@property(nonatomic, assign) int index;
@property(nonatomic, strong) NSData *imageData;
@end

@implementation ImageData



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
    [btnLoadImage addTarget:self action:@selector(loadImagesWithDependency) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLoadImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateImage:(ImageData *)imageData{
    UIImageView *imageView = _imageViews[imageData.index];
    imageView.image = [UIImage imageWithData:imageData.imageData];
}

-(NSData *) requestData:(NSNumber *)index{
    @autoreleasepool {
        NSURL *url = [NSURL URLWithString:@"http://images.apple.com/v/watch/e/apple-pay/images/hero_medium_2x.jpg"];
        return [NSData dataWithContentsOfURL:url];
    }
}

-(void)loadImageWithThread:(NSNumber *)index{
    NSLog(@"current thread:%@", [NSThread currentThread]);
    NSData *data = [self requestData:index];
    
    ImageData *imageData = [ImageData new];
    imageData.index = [index intValue];
    imageData.imageData = data;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self updateImage:imageData];
    }];
//    [self performSelectorOnMainThread:@selector(updateImage:) withObject:imageData waitUntilDone:YES];
}

#pragma mark - NSInvocationOperation方式
-(void)loadImagesWithNSInvocationOperation{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    for(int i = 0; i<_imageViews.count; i++){
        //创建一个调用
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(loadImageWithThread:) object:[NSNumber numberWithInt:i]];
        //创建完NSInvocationOperation对象并不会调用，它由一个start方法启动操作，但是注意如果直接调用start方法，则此操作会在主线程中调用，一般不会这么操作,而是添加到NSOperationQueue中
//        [operation start];
        
        //注意添加到操作队后，队列会开启一个线程执行此操作
        [queue addOperation:operation];
    }
}

#pragma mark - Block方式
-(void)loadImagesWithBlock{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 5; //设置最大并发线程数
    for(int i = 0; i<_imageViews.count; i++){
        [queue addOperationWithBlock:^{
            [self loadImageWithThread:[NSNumber numberWithInt:i]];
        }];
    }
}

#pragma mark - 线程执行顺序
-(void)loadImagesWithDependency{
    //先加载最后一张图片，然后再记载其他图片
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 5; //设置最大并发线程数
    
    int count = (int)_imageViews.count;
    NSBlockOperation *lastBlock = [NSBlockOperation blockOperationWithBlock:^{
        [self loadImageWithThread: [NSNumber numberWithInteger:count-1]];
    }];
    
    for(int i = 0; i<_imageViews.count-1; i++){
        NSBlockOperation *block = [NSBlockOperation blockOperationWithBlock:^{
            [self loadImageWithThread:[NSNumber numberWithInteger:i]];
        }];
        //设置依赖操作为最后一张图片加载操作
        [block addDependency:lastBlock];
        [queue addOperation:block];
    }
    [queue addOperation:lastBlock];
}
@end
