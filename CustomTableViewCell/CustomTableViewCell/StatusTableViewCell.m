//
//  StatusTableViewCell.m
//  CustomTableViewCell
//
//  Created by hesc on 15/8/9.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "StatusTableViewCell.h"

#define Color(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define StatusTableViewCellControlSpacing 10 //控件间隔
#define StatusTableViewCellBackgroundColor Color(251,251,251)
#define StatusGrayColor Color(50, 50,50)
#define StatusLightGrayColor Color(120,120,120)

#define StatusTableViewCellAvatarWidth 40 //头像宽度
#define StatusTableViewCellAvatarHeight StatusTableViewCellAvatarWidth
#define StatusTableViewCellUserNameFontSize 14
#define StatusTableViewCellMbTypeWidth 13  //会员图标宽度
#define StatusTableViewCellMbTypeHeight StatusTableViewCellMbTypeWidth
#define StatusTableViewCellCreateAtFontSize 12
#define StatusTableViewCellSourceFontSize 12
#define StatusTableViewCellTextFontSize 14

@interface StatusTableViewCell(){
    UIImageView *_avatar;  //头像
    UIImageView *_mbType; //会员类型
    UILabel *_userName;
    UILabel *_source;
    UILabel *_createAt;
    UILabel *_text;
}
@end

@implementation StatusTableViewCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    //头像
    _avatar = [[UIImageView alloc] init];
    [self addSubview:_avatar];
    //会员类型
    _mbType = [UIImageView new];
    [self addSubview:_mbType];
    //用户名
    _userName = [UILabel new];
    _userName.textColor = StatusGrayColor;
    _userName.font = [UIFont systemFontOfSize:StatusTableViewCellUserNameFontSize];
    [self addSubview:_userName];
    
    //日期
    _createAt = [UILabel new];
    _createAt.textColor = StatusLightGrayColor;
    _createAt.font = [UIFont systemFontOfSize:StatusTableViewCellCreateAtFontSize];
    [self addSubview:_createAt];
    
    //设备
    _source = [UILabel new];
    _source.textColor = StatusLightGrayColor;
    _source.font = [UIFont systemFontOfSize:StatusTableViewCellSourceFontSize];
    [self addSubview:_source];
    
    //内容
    _text = [UILabel new];
    _text.textColor = StatusGrayColor;
    _text.font = [UIFont systemFontOfSize:StatusTableViewCellTextFontSize];
    _text.numberOfLines = 0;  // 多行
    [self addSubview:_text];
    
}

-(void)setStatus:(Status *)status{
    //设置头像的大小和位置
    CGFloat avatarX = 10, avatarY = 10;
    _avatar.image = [UIImage imageNamed:status.profileImageUrl];
    _avatar.frame = CGRectMake(avatarX, avatarY, StatusTableViewCellAvatarWidth, StatusTableViewCellAvatarHeight);
   
    //设置用户名的大小和位置
    CGFloat userNameX = CGRectGetMaxX(_avatar.frame) + StatusTableViewCellControlSpacing;
    CGFloat userNameY = avatarY;
    CGSize userNameSize = [status.userName sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:StatusTableViewCellUserNameFontSize]}];
    _userName.text = status.userName;
    _userName.frame = CGRectMake(userNameX, userNameY, userNameSize.width, userNameSize.height);
    
    //设置会员类型的大小和位置
    CGFloat mbtypeX = CGRectGetMaxX(_userName.frame) + StatusTableViewCellControlSpacing;
    CGFloat mbtypeY = avatarY;
    _mbType.image = [UIImage imageNamed:status.mbtype];
    _mbType.frame = CGRectMake(mbtypeX, mbtypeY, StatusTableViewCellMbTypeWidth, StatusTableViewCellMbTypeHeight);
    
    //设置日期的大小和位置
    CGSize createAtSize = [status.createAt sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:StatusTableViewCellCreateAtFontSize]}];
    CGFloat createAtX = userNameX;
    CGFloat createAtY = CGRectGetMaxY(_avatar.frame) - createAtSize.height;
    _createAt.text = status.createAt;
    _createAt.frame = CGRectMake(createAtX, createAtY, createAtSize.width, createAtSize.height);
    
    //设置设备的大小和位置
    CGFloat sourceX = CGRectGetMaxX(_createAt.frame) + StatusTableViewCellControlSpacing;
    CGFloat sourceY = createAtY;
    CGSize sourceSize = [status.source sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:StatusTableViewCellSourceFontSize]}];
    _source.text = status.source;
    _source.frame = CGRectMake(sourceX, sourceY, sourceSize.width, sourceSize.height);
    
    //设置内容的大小和位置
    CGFloat textX = avatarX;
    CGFloat textY = CGRectGetMaxY(_avatar.frame) + StatusTableViewCellControlSpacing;
    CGFloat textWidth = self.frame.size.width - 2*StatusTableViewCellControlSpacing;
    CGSize textSize = [status.text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:StatusTableViewCellTextFontSize]} context:nil].size;
    _text.text = status.text;
    _text.frame = CGRectMake(textX, textY, textSize.width, textSize.height);
    
    _height = CGRectGetMaxY(_text.frame) + StatusTableViewCellControlSpacing;
    
}


@end
