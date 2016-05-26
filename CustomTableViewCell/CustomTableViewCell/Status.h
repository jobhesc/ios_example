//
//  Status.h
//  CustomTableViewCell
//
//  Created by hesc on 15/8/9.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Status : NSObject

@property(nonatomic, assign) long long Id;
@property(nonatomic, copy) NSString * profileImageUrl;
@property(nonatomic, copy) NSString *userName;
@property(nonatomic, copy) NSString *mbtype;
@property(nonatomic, copy) NSString *createAt;
@property(nonatomic, copy) NSString *source;
@property(nonatomic, copy) NSString *text;

-(Status *) initWithDictionary:(NSDictionary *)dic;

+(Status *) initWithDictionary:(NSDictionary *)dic;

@end
