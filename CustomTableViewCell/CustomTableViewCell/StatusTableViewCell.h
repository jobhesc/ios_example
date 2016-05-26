//
//  StatusTableViewCell.h
//  CustomTableViewCell
//
//  Created by hesc on 15/8/9.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Status.h"

@interface StatusTableViewCell : UITableViewCell

@property(nonatomic, strong) Status *status;
@property(nonatomic, assign) CGFloat height;

@end
