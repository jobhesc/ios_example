//
//  ViewController.m
//  NSURLConnection
//
//  Created by hesc on 15/8/26.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "ViewController.h"
#import "MagicKey.h"
#import "SysOption.h"

#define SIGN_SER @"ttyongche(2014)_qing_biezai_daobidao_v2"

@interface ViewController (){
    UIButton *_button;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _button = [[UIButton alloc] initWithFrame:CGRectMake(30, 500, 300, 25)];
    [_button setTitle:@"点我" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor colorWithRed:0 green:146/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(sendRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
}

-(void)sendRequest{
    NSString *urlString = @"http://test.api.ttyongche.com/api/v3/sys/options";
    NSURL *url = [NSURL URLWithString:urlString];
    
    //UUID
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidRef));
    CFRelease(uuidRef);
    
    //时间戳
    NSInteger ts = (NSInteger)[[NSDate date] timeIntervalSince1970];
    
    //签名
    NSString *sign = [self getSign:urlString withTimeStamp:ts withUUID:uuid];

    NSURL *newUrl = [self appendIdentifyParams:url withIdentifyParams:sign];
    
    NSString *clientInfo = [self getClientInfo];
    NSString *clientAuth = [self getClientAuth:sign withTimeStamp:ts withUUID:uuid];
   
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:newUrl];
    [request setHTTPMethod:@"POST"];
    [request addValue:clientInfo forHTTPHeaderField:@"clientInfo"];
    [request addValue:clientAuth forHTTPHeaderField:@"clientAuth"];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if(!error){
            [self loadData:data];
        } else {
            
        }
    }];
}

-(void)loadData:(NSData *)data{
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    SysOption *sysOption = [SysOption new];
    [sysOption setValuesForKeysWithDictionary:dic];
    NSLog(@"%@", sysOption);
}

-(NSURL *)appendIdentifyParams:(NSURL *)url withIdentifyParams:(NSString *)identifyParams{
    NSString *query = [url query];
    if(!query){
        NSString *newUrlString = [[url absoluteString] stringByAppendingFormat:@"?_r=%@", identifyParams];
        return [NSURL URLWithString:newUrlString];
    } else {
        NSString *newUrlString = [[url absoluteString] stringByAppendingFormat:@"&_r=%@", identifyParams];
        return [NSURL URLWithString:newUrlString];
    }
}

-(NSString *)getClientAuth:(NSString *)sign withTimeStamp:(NSInteger)ts withUUID:(NSString *)uuid{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:@"" forKey:@"ticket"];
    [dic setValue:uuid forKey:@"rd"];
    [dic setValue:sign forKey:@"sign"];
    [dic setValue:[MagicKey encodeValue:ts] forKey:@"code"];
    
    return [self stringWithDictionary:dic];
}

-(NSString *)getSign:(NSString *)url withTimeStamp:(NSInteger)ts withUUID:(NSString *)uuid{
    NSString *linkString = [self getLinkString:url];
    NSString *sign = [[[linkString stringByAppendingFormat:@"%ld", (long)ts] stringByAppendingString:uuid] stringByAppendingString:SIGN_SER];
    return [self md5:sign];
}

//将字符串进行MD5加密，返回加密后的字符串。
- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

-(NSString *)getLinkString:(NSString *)url{
    NSArray *array = [url componentsSeparatedByString:@"?"];
    NSString *ss = [array objectAtIndex:0];
    NSArray *linkArray = [ss componentsSeparatedByString:@"/"];
    
    return linkArray.count>=2?[NSString stringWithFormat:@"%@/%@", [linkArray objectAtIndex:linkArray.count-2], [linkArray objectAtIndex:linkArray.count-1]]:[linkArray objectAtIndex:0];
}

-(NSString *)getClientInfo{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSInteger zoneOffset = [NSTimeZone localTimeZone].secondsFromGMT;
    NSNumber *zoneOffsetNumber = [NSNumber numberWithInteger:zoneOffset];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:@"ttyc" forKey:@"appnm"];
    [dic setValue:@"3.1.0" forKey:@"appVer"];
    [dic setValue:@"Android" forKey:@"clientType"];
    [dic setValue:@"SM-G9006V" forKey:@"model"];
    [dic setValue:@"5.0" forKey:@"os"];
    [dic setValue:@"1080x1920" forKey:@"screen"];
    [dic setValue:@"0614003c8d06404995a53d943d3af904" forKey:@"did"];
    [dic setValue:@"1281a7ffe459dc0c" forKey:@"android_id"];
    [dic setValue:@"131" forKey:@"cityid"];
    [dic setValue: [formatter stringFromDate:[NSDate date]] forKey:@"dt"];
    [dic setValue: zoneOffsetNumber forKey:@"tz"];
    [dic setValue:@"TTYC" forKey:@"channel"];
    [dic setValue:@"39.985507,116.376178,65" forKey:@"loc"];
    [dic setValue:@"none" forKey:@"net"];
    [dic setValue:@"0" forKey:@"state"];
    [dic setValue:@"12312314123" forKey:@"imei"];
    
    return [self stringWithDictionary:dic];
}

-(NSString *)stringWithDictionary:(NSDictionary *)dictionary{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    json = [json stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    json = [json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return json;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
