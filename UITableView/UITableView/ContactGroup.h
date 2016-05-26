//
//  ContactGroup.h
//  UITableView
//
//  Created by hesc on 15/8/7.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactGroup: NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, strong) NSMutableArray *contacts;

-(ContactGroup *)initWithName: (NSString *)name andDetail:(NSString *)detail andContacts:(NSMutableArray *)contacts;

+(ContactGroup *)initWIthName:(NSString *)name andDetail:(NSString *)detail andContacts:(NSMutableArray *)contacts;

@end
