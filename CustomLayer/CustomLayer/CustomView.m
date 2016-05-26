//
//  CustomView.m
//  CustomLayer
//
//  Created by hesc on 15/8/15.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "CustomView.h"
#import "CustomLayer.h"

@implementation CustomView

-(instancetype)initWithFrame:(CGRect)frame{
    NSLog(@"initWithFrame");
    if(self = [super initWithFrame:frame]){
        CustomLayer *layer = [CustomLayer new];
        layer.bounds = CGRectMake(0, 0, 185, 185);
        layer.position = CGPointMake(160, 284);
        layer.backgroundColor = [UIColor colorWithRed:0 green:146/255.0 blue:1 alpha:1].CGColor;
        [self.layer addSublayer:layer];
        [layer setNeedsDisplay];
    }
    
    return self;
}

-(void)drawRect:(CGRect)rect{
    NSLog(@"2-drawRect:");
    NSLog(@"CGContext:%@", UIGraphicsGetCurrentContext());
    [super drawRect:rect];
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    NSLog(@"1-drawLayer:");
    NSLog(@"CGContext:%@", ctx);
    [super drawLayer:layer inContext:ctx];
}

@end
