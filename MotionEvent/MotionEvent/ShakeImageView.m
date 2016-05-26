//
//  ShakeImageView.m
//  MotionEvent
//
//  Created by hesc on 15/8/11.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "ShakeImageView.h"
#define ImageCount 3

@implementation ShakeImageView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.image = [self getImage];
    }
    return self;
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
     //这里只处理摇晃事件
    if(motion == UIEventSubtypeMotionShake){
        self.image = [self getImage];
    }
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
}

-(UIImage *)getImage{
    int index =arc4random()%ImageCount;
    return [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg", index]];
}

@end
