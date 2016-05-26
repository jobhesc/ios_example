//
//  ViewController.m
//  NSCondition
//
//  Created by hesc on 15/8/17.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "ViewController.h"
#define COLUMN_COUNT 3
#define ROW_COUNT 5
#define CELL_SPACE 10

@interface ViewController (){
    NSMutableArray *_imageViews;
    NSMutableArray *_imageNames;
    NSCondition *_condition;
    int _currentIndex;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat cellWidth = (size.width-(COLUMN_COUNT+1)*CELL_SPACE)/(COLUMN_COUNT*1.0);
    CGFloat cellHeight = (size.height - (ROW_COUNT+1)*CELL_SPACE)/(ROW_COUNT*1.0);
    
    _imageViews = [NSMutableArray array];
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
    btnLoadImage.center = CGPointMake(size.width/4, size.height-50);
    [btnLoadImage setTitle:@"加载图片" forState:UIControlStateNormal];
    [btnLoadImage addTarget:self action:@selector(loadImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLoadImage];
    
    UIButton *btnCreateImage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCreateImage.bounds = CGRectMake(0, 0, 220, 30);
    btnCreateImage.center = CGPointMake(size.width*3/4, size.height-50);
    [btnCreateImage setTitle:@"创建图片" forState:UIControlStateNormal];
    [btnCreateImage addTarget:self action:@selector(createImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCreateImage];
    
    _imageNames = [NSMutableArray array];
    _currentIndex = 0;
    //初始化锁对象
    _condition = [NSCondition new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadImage{
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for(int i = 0; i<_imageViews.count; i++){
        dispatch_async(globalQueue, ^{
            [self loadImageWithThread:i];
        });
    }
}

-(void)createImage{
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        [self createImageWithThread];
    });
}
                   
-(void)createImageWithThread{
    //加锁
    [_condition lock];
    
    //如果当前已经有图片，则等待，保证只有一张图片可以装载
    if(_imageNames.count > 0){
        NSLog(@"createimage wait, index is %i", _currentIndex);
        [_condition wait];
    } else {
        NSLog(@"createImage work, index is %i", _currentIndex);
        [_imageNames addObject:[NSString stringWithFormat:@"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_%i.jpg", _currentIndex++]];
        //唤醒一个等待线程
        [_condition signal];
    }
    
    //解锁
    [_condition unlock];
}

-(void)loadImageWithThread:(int)index{
    //加锁
    [_condition lock];
    
    //如果有资源则加载，否则等待
    if(_imageNames.count > 0){
        NSLog(@"loadimage work, index is %i", index);
        [self loadAndUpdateImage:index];
        //唤醒所有等待线程
        [_condition broadcast];
    } else {
        NSLog(@"loadimage wait, index is %i", index);
        NSLog(@"%@", [NSThread currentThread]);
        //线程等待
        [_condition wait];
        
        NSLog(@"loadimage restore, index is %i", index);
        //一旦创建了图片，就加载
        [self loadAndUpdateImage:index];
    }
    
    //解锁
    [_condition unlock];
}

-(void)loadAndUpdateImage:(int)index{
    NSData *data = [self requestData:index];
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_sync(mainQueue, ^{
        UIImageView *imageView = _imageViews[index];
        imageView.image = [UIImage imageWithData:data];
    });
}

-(NSData *)requestData:(int)index{
    NSData *data;
    NSString *name;
    name = [_imageNames lastObject];
    [_imageNames removeObject:name];
    if(name){
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:name]];
    }
    return data;
}

@end
