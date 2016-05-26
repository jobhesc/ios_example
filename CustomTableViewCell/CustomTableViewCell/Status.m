//
//  Status.m
//  CustomTableViewCell
//
//  Created by hesc on 15/8/9.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "Status.h"

@implementation Status

-(Status *)initWithDictionary:(NSDictionary *)dic{
    if(self = [super init]){
        self.Id = [dic[@"id"] longLongValue];
        self.profileImageUrl = dic[@"profileImageUrl"];
        self.mbtype = dic[@"mbtype"];
        self.userName = dic[@"userName"];
        self.createAt = dic[@"createAt"];
        self.source = dic[@"source"];
        self.text = dic[@"text"];
    }
    return self;
}

+(Status *)initWithDictionary:(NSDictionary *)dic{
    Status *status = [[Status alloc] initWithDictionary:dic];
    return status;
}

-(NSString *)source{
    return  [NSString stringWithFormat:@"来自 %@", _source];
}

@end
