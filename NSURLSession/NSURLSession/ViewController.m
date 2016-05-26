//
//  ViewController.m
//  NSURLSession
//
//  Created by hesc on 15/8/20.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "ViewController.h"
#define DEFAULT_COLOR [UIColor colorWithRed:0 green:146/255.0 blue:1.0 alpha:1.0]

@interface ViewController ()<NSURLSessionDownloadDelegate>{
    UIButton *_btnDownload;
    UIButton *_btnResume;
    UIButton *_btnSuspend;
    UIButton *_btnCancel;
    UIProgressView *_progressView;
    UILabel *_label;
    NSURLSessionDownloadTask *_downloadTask;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI];
}

-(void)layoutUI{
    //进度条
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(10, 50, 300, 25)];
    [self.view addSubview:_progressView];
    //状态显示
    _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 400, 25)];
    _label.textColor = DEFAULT_COLOR;
    [self.view addSubview:_label];
    
    //下载按钮
    _btnDownload = [[UIButton alloc] initWithFrame:CGRectMake(20, 500, 50, 25)];
    [_btnDownload setTitle:@"下载" forState:UIControlStateNormal];
    [_btnDownload setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal ];
    [_btnDownload addTarget:self action:@selector(executeDownload) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnDownload];
    
    //取消按钮
    _btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(100, 500, 50, 25)];
    [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [_btnCancel setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
    [_btnCancel addTarget:self action:@selector(cancelDownload) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnCancel];
    
    //挂起按钮
    _btnSuspend = [[UIButton alloc] initWithFrame:CGRectMake(180, 500, 50, 25)];
    [_btnSuspend setTitle:@"挂起" forState:UIControlStateNormal];
    [_btnSuspend setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
    [_btnSuspend addTarget:self action:@selector(suspendDownload) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnSuspend];
    //恢复按钮
    _btnResume = [[UIButton alloc] initWithFrame:CGRectMake(260, 500, 50, 25)];
    [_btnResume setTitle:@"恢复" forState:UIControlStateNormal];
    [_btnResume setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
    [_btnResume addTarget:self action:@selector(resumeDownload) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnResume];
}

//下载文件
-(void)executeDownload{
    //创建url
    NSString *urlString = @"http://p.gdown.baidu.com/69526198038855b758b25cadc1a9bc7e4e48d89ae64b6ab61fdc61864e31bb32f378f584ac3fddc203c5f44029457071e7026937bf11d88f8e58376e1aeb0d1df10b241792db8065ba1169705c5ec31169b3ca047307c62e970a19271e9eac0008c7c406420f95e313809f8c37646b6b93b11c8ab4d2c0650c3d270330aec8980a174243f1c4c6d40fe1039228fb348c56556e9eb6c031fcf1c8722efee06dc7c3d4470f49e4cf86c724380afd7ba1195af94f2b410c63a3";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    /**
     NSURLSession支持进程三种会话：
     
     defaultSessionConfiguration：进程内会话（默认会话），用硬盘来缓存数据。
     ephemeralSessionConfiguration：临时的进程内会话（内存），不会将cookie、缓存储存到本地，只会放到内存中，当应用程序退出后数据也会消失。
     backgroundSessionConfiguration：后台会话，相比默认会话，该会话会在后台开启一个线程进行网络数据处理。
     */
    //创建会话
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 500.0f; //请求超时时间
    sessionConfig.allowsCellularAccess = true;  //是否允许蜂窝下载（2G/3G/4G)
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];  //指定配置和代理
    _downloadTask = [session downloadTaskWithRequest:request];
    [_downloadTask resume];
}

//取消下载
-(void)cancelDownload{
    if(_downloadTask != nil){
        [_downloadTask cancel];
    }
}

//下载挂起
-(void)suspendDownload{
    if(_downloadTask != nil){
        [_downloadTask suspend];
    }
}

//恢复下载
-(void)resumeDownload{
    if(_downloadTask != nil){
        [_downloadTask resume];
    }
}

#pragma mark - 下载任务代理
//下载中（会多次调用，可以记录下载进度）
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    [self setUIStatus:totalBytesWritten expectedToWrite:totalBytesExpectedToWrite];
}

//下载完成
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSError *error;
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *savePath = [cachePath stringByAppendingPathComponent:@"files"];
    NSLog(@"%@", savePath);
    
    NSURL *url = [NSURL URLWithString:savePath];
    [[NSFileManager defaultManager] copyItemAtURL:location toURL:url error:&error];
    if(error){
        NSLog(@"Error is %@", error.localizedDescription);
    }
}

//任务完成， 不管是否下载完成
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    [self setUIStatus:0 expectedToWrite:0];
    if(error){
        NSLog(@"Error is %@", error.localizedDescription);
    }
}

-(void)setUIStatus:(int64_t) totalBytesWritten expectedToWrite:(int64_t) totalBytesExpectToWrite{
    dispatch_async(dispatch_get_main_queue(), ^{
        _progressView.progress = (float)totalBytesWritten/totalBytesExpectToWrite;
        if(totalBytesWritten == totalBytesExpectToWrite){
            [_label setText:@"下载完成"];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        } else {
            [_label setText:@"正在下载..."];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
