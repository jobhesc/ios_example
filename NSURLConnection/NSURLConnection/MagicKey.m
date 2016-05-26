//
//  MagicKey.m
//  NSURLConnection
//
//  Created by hesc on 15/8/28.
//  Copyright (c) 2015年 hesc. All rights reserved.
//


#import <CommonCrypto/CommonDigest.h>
#import "MagicKey.h"

#define base_timestamp  946656000000L
#define LENGTH  16
#define DEFAULT_MAGIC  21993961

@implementation MagicKey
+ (NSString *)encodeValue:(NSInteger)value {
    NSInteger extraValue = 0;
    NSMutableData *data = [NSMutableData data];
    
    NSUInteger code = [[NSDate date] hash];
    [data appendBytes:&code length:4];
    
    uint32_t bigValue = CFSwapInt32HostToBig((uint32_t) value);
    [data appendBytes:&bigValue length:4];
    
    
    bigValue = CFSwapInt32HostToBig((uint32_t) extraValue);
    [data appendBytes:&bigValue length:4];
    
    NSInteger time = (NSInteger) ([[NSDate date] timeIntervalSince1970]*1000 - base_timestamp);
    bigValue = CFSwapInt32HostToBig((uint32_t) time);
    [data appendBytes:&bigValue length:4];
    
    NSInteger zero = 0;
    bigValue = CFSwapInt32HostToBig((uint32_t) zero);
    [data appendBytes:&bigValue length:4];
    
    unsigned char *bytes = [data mutableBytes];
    bytes[LENGTH] = (unsigned char) (DEFAULT_MAGIC & 0x000000ff);
    bytes[LENGTH] = (unsigned char) (DEFAULT_MAGIC & 0x000000ff);
    bytes[LENGTH + 1] = (unsigned char) ((DEFAULT_MAGIC & 0x0000ff00) >> 8);
    bytes[LENGTH + 2] = (unsigned char) ((DEFAULT_MAGIC & 0x00ff0000) >> 16);
    bytes[LENGTH + 3] = (unsigned char) ((DEFAULT_MAGIC & 0xff000000) >> 24);
    
    unsigned char hash[CC_MD5_DIGEST_LENGTH];
    CC_MD5(bytes, LENGTH+4, hash);
    
    unsigned char result[LENGTH* 2];
    for (int i = 0; i < LENGTH; i++) {
        result[2 * i] = ((hash[i] & 0x03) | ((bytes[i] & 0x0f) << 2) | ((hash[i] & 0x0C) << 4));
        result[2 * i + 1] = ((hash[i] & 0xC0) | ((bytes[i] & 0xf0) >> 2) | ((hash[i] & 0x30) >> 4));
    }
    
    NSMutableString *ms = [NSMutableString string];
    for (NSInteger i = 0; i < LENGTH * 2; i++) {
        [ms appendFormat:@"%02x", (int) (result[i])];
    }
    
    return ms;
}
@end
