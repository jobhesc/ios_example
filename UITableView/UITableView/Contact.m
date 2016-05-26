//
//  Contact.m
//  UITableView
//
//  Created by hesc on 15/8/7.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

@implementation Contact

-(Contact *)initWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName andPhoneNumber:(NSString *)phoneNumber{
    if(self = [super init]){
        self.firstName = firstName;
        self.lastName = lastName;
        self.phoneNumber = phoneNumber;
    }
    return self;
}

+(Contact *)initWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName andPhoneNumber:(NSString *)phoneNumber{
    Contact *contact = [[Contact alloc] initWithFirstName:firstName andLastName:lastName andPhoneNumber:phoneNumber];
    return contact;
}

-(NSString *)getName{
    return [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];
}

@end