//
//  SysOption.h
//  NSURLConnection
//
//  Created by hesc on 15/8/28.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalConfig : NSObject
@property (nonatomic, assign) int call_space_time;
@property (nonatomic, assign) int call_space_time_hint;
@property (nonatomic, assign) int news_max_length;
@property (nonatomic, assign) int leave_word_count;
@property (nonatomic, copy) NSString *h5_get_coupon_url;
@property (nonatomic, copy) NSString *service_hotline;
@end

@interface PromptResult : NSObject
@property (nonatomic, copy) NSString *driver_accept_order_rule;
@property (nonatomic, copy) NSString *passenger_leave_a_message_template;
@property (nonatomic, copy) NSString *host_user_isolation_type;
@property (nonatomic, copy) NSString *host_user_report_type;
@property (nonatomic, copy) NSString *customer_user_isolation_type;
@property (nonatomic, copy) NSString *customer_user_report_type;
@property (nonatomic, copy) NSString *driver_comment_passenger_hint;
@property (nonatomic, copy) NSString *passenger_comment_driver_hint;
@property (nonatomic, copy) NSString *passenger_comment_driver_button_text;

@end

@interface SysOption : NSObject
@property (nonatomic, strong) GlobalConfig *global;
@property (nonatomic, strong) PromptResult *prompt;

@end


