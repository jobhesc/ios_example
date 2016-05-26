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
    NSMutableArray *_threads;
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
    btnLoadImage.center = CGPointMake(size.width/4, size.height-100);
    [btnLoadImage setTitle:@"加载图片" forState:UIControlStateNormal];
    [btnLoadImage addTarget:self action:@selector(loadImages) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLoadImage];
    
    UIButton *btnStopLoad = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnStopLoad.bounds = CGRectMake(0, 0, 220, 30);
    btnStopLoad.center = CGPointMake(size.width*3/4, size.height-100);
    [btnStopLoad setTitle:@"停止加载" forState:UIControlStateNormal];
    [btnStopLoad addTarget:self action:@selector(stopLoad) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnStopLoad];
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
    
    NSThread *currentThread = [NSThread currentThread];
    //  如果当前线程处于取消状态，则退出当前线程
    if(currentThread.isCancelled){
        [NSThread exit];
    }
    
    ImageData *imageData = [ImageData new];
    imageData.index = [index intValue];
    imageData.imageData = data;
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:imageData waitUntilDone:YES];
}

-(void)loadImages{
    _threads = [NSMutableArray new];
    for(int i = 0; i<_imageViews.count; i++){
        //使用NSObject分类扩展方法，开启后台线程去加载图片
//        [self performSelectorInBackground:@selector(loadImageWithThread:) withObject:[NSNumber numberWithInt:i]];
        
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(loadImageWithThread:) object:[NSNumber numberWithInt:i]];
        thread.name = [NSString stringWithFormat:@"thread%i", i];
        [thread start];
        [_threads addObject:thread];
    }
}

-(void)stopLoad{
    if(_threads != nil && _threads.count > 0){
        for(int i = 0; i<_threads.count; i++){
            NSThread *thread = _threads[i];
            if(!thread.isFinished){
                [thread cancel];
            }
        }
    }
}

@end
