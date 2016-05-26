//
//  ContactGroup.m
//  UITableView
//
//  Created by hesc on 15/8/7.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "ContactGroup.h"

@implementation ContactGroup

-(ContactGroup *)initWithName:(NSString *)name andDetail:(NSString *)detail andContacts:(NSMutableArray *)contacts{
    if(self = [super init]){
        self.name = name;
        self.detail = detail;
        self.contacts = contacts;
    }
    return self;
}

+(ContactGroup *)initWIthName:(NSString *)name andDetail:(NSString *)detail andContacts:(NSMutableArray *)contacts{
    ContactGroup *group = [[ContactGroup alloc] initWithName:name andDetail:detail andContacts:contacts];
    return group;
}
@end
