//
//  ViewController.m
//  loadFile
//
//  Created by hesc on 15/8/17.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLConnectionDataDelegate>{
    NSMutableData *_data; //响应数据
    UITextField *_textField;
    UIButton *_button;
    UIProgressView *_progressView;
    UILabel *_label;
    long long _totalLength;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //地址栏
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(30, 50, 300, 25)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.textColor = [UIColor colorWithRed:0 green:146/255.0 blue:1 alpha:1];
    _textField.text = @"";
    [self.view addSubview:_textField];
    
    //进度条
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(30, 100, 300, 25)];
    [self.view addSubview:_progressView];
    
    //状态显示
    _label = [[UILabel alloc] initWithFrame:CGRectMake(30, 130, 300, 25)];
    _label.textColor = [UIColor colorWithRed:0 green:146/255.0 blue:1 alpha:1];
    [self.view addSubview:_label];
    
    //下载按钮
    _button = [[UIButton alloc] initWithFrame:CGRectMake(30, 500, 300, 25)];
    [_button setTitle:@"下载" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor colorWithRed:0 green:146/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(sendRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
}

-(void)sendRequest{
    NSString *urlstr = @"http://p.gdown.baidu.com/69526198038855b758b25cadc1a9bc7e4e48d89ae64b6ab61fdc61864e31bb32f378f584ac3fddc203c5f44029457071e7026937bf11d88f8e58376e1aeb0d1df10b241792db8065ba1169705c5ec31169b3ca047307c62e970a19271e9eac0008c7c406420f95e313809f8c37646b6b93b11c8ab4d2c0650c3d270330aec8980a174243f1c4c6d40fe1039228fb348c56556e9eb6c031fcf1c8722efee06dc7c3d4470f49e4cf86c724380afd7ba1195af94f2b410c63a3";
    //注意对于url中的中文是无法解析的，需要进行url编码(指定编码类型为utf-8)
    //另外注意url解码使用stringByRemovingPercentEncoding方法
    urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //创建URL连接
    NSURL *url = [NSURL URLWithString:urlstr];
    
    /*创建请求
     cachePolicy:缓存策略
     a.NSURLRequestUseProtocolCachePolicy 协议缓存，根据response中的Cache-Control字段判断缓存是否有效，如果缓存有效则使用缓存数据否则重新从服务器请求
     b.NSURLRequestReloadIgnoringLocalCacheData 不使用缓存，直接请求新数据
     c.NSURLRequestReloadIgnoringCacheData 等同于 SURLRequestReloadIgnoringLocalCacheData
     d.NSURLRequestReturnCacheDataElseLoad 直接使用缓存数据不管是否有效，没有缓存则重新请求
     eNSURLRequestReturnCacheDataDontLoad 直接使用缓存数据不管是否有效，没有缓存数据则失败
     timeoutInterval:超时时间设置（默认60s）
     */
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3000.0f];
    
    //创建连接
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    //启动连接
    [connection start];
}

-(void)updateProgress{
    if(_data.length == _totalLength){
        _label.text = @"下载完成";
    } else {
        _label.text = @"正在下载...";
        [_progressView setProgress:(float)(_data.length*1.0/_totalLength)];
    }
}

#pragma mark - 连接代理方法
//开始响应
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _data = [NSMutableData new];
    _progressView.progress = 0;
    
    //通过响应头中的Content-Length取得整个响应的长度
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSDictionary *headerFields = [httpResponse allHeaderFields];
    _totalLength = [[headerFields objectForKey:@"Content-Length"] longLongValue];
}

//接受响应数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    //连续接收数据
    [_data appendData:data];
    //更新进度
    [self updateProgress];
}

//数据接收完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    //数据接收完保存文件(注意苹果官方要求：下载数据只能保存在缓存目录)
    NSString *savePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    savePath = [savePath stringByAppendingString:_textField.text];
    [_data writeToFile:savePath atomically:YES];
    
    NSLog(@"下载文件保存路径： %@", savePath);
}

//请求失败
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //如果连接超时或者连接地址错误可能就会报错
    NSLog(@"连接失败，失败原因:%@", error.localizedDescription);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
