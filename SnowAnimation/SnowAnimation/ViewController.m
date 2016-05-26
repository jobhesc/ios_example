//
//  ViewController.m
//  SnowAnimation
//
//  Created by hesc on 15/8/15.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    CALayer *layer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIImage *image = [UIImage imageNamed:@"back.jpg"];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 120, 160)];
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    imageView.image = image;
//    [self.view addSubview:imageView];
//    
//    [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//        imageView.frame = CGRectMake(60, 80, 210, 280);
//    } completion:nil];
    
    UIImage *backgroundImage= [UIImage imageNamed:@"back.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    layer = [[CALayer alloc] init];
    layer.bounds = CGRectMake(0, 0, 25 , 25);
    layer.position = CGPointMake(50, 150);
    [layer setContents:(id)[UIImage imageNamed:@"snow.png"].CGImage];
    [self.view.layer addSublayer:layer];
}

#pragma mark - 基础动画
//移动动画
-(void)translateAnimationWithBasic:(CGPoint)location{
    //创建动画并指定动画属性
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    //设置动画的初始值和结束值
//    basicAnimation.fromValue = [NSNumber numberWithInt:50];  //可以不设置，默认为图层初始状态
    basicAnimation.toValue = [NSValue valueWithCGPoint:location];
    
    //设置其他动画属性
    basicAnimation.duration = 5.0;  //动画持续5秒
//    basicAnimation.repeatCount = HUGE_VALF;
    basicAnimation.removedOnCompletion = NO;  //运行一次是否移除动画
    //存储位置信息，以便后面使用
    [basicAnimation setValue:[NSValue valueWithCGPoint:location] forKey:@"BasicAnimationLocation"];
    
    basicAnimation.delegate = self;
    
    //添加动画到图层，注意key相当于给动画进行命名，以后获得该动画时可以使用此名称获取
    [layer addAnimation:basicAnimation forKey:@"BasicAnimation_Translation"];
}

//旋转动画
-(void)rotaionAnimation{
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnimation.toValue = [NSNumber numberWithFloat:M_PI_2*3];
    basicAnimation.duration = 6.0;
    basicAnimation.autoreverses = true; //旋转后再旋转到原来的位置
    basicAnimation.repeatCount = HUGE_VALF;  //设置无限循环
    basicAnimation.removedOnCompletion = NO;  //
    
    [layer addAnimation:basicAnimation forKey:@"BasicAnimation_Rotation"];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    
    CAAnimation *animation = [layer animationForKey:@"BasicAnimation_Translation"];
    if(animation){
        if(layer.speed == 0){
            [self animationResume];
        } else {
            [self animationPause];
        }
    } else {
//        [self translateAnimationWithBasic:location];
        [self translateAnimationWithKeyFrame:location];
        [self rotaionAnimation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//动画暂停
-(void)animationPause{
    //取得指定图层的媒体时间，后面参数用于指定图层，这里不需要
    CFTimeInterval interval = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    //设置时间偏移量，保证暂停时停留在旋转的位置
    [layer setTimeOffset:interval];
    //速度设置为0，暂停动画
    layer.speed = 0;
}

//动画恢复
-(void)animationResume{
   //获得暂停了多长时间
    CFTimeInterval beginTime = CACurrentMediaTime() - layer.timeOffset;
    //设置偏移量
    [layer setTimeOffset:0];
    //设置开始时间
    layer.beginTime = beginTime;
    //设置动画速度，开始运动
    layer.speed = 1;
}

-(void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"animation(%@) start.\r_layer.frame=%@", anim, NSStringFromCGRect(layer.frame));
    NSLog(@"%@", [layer animationForKey:@"BasicAnimation_Translation"]);
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"animation(%@) stop.\r_layer.frame=%@", anim, NSStringFromCGRect(layer.frame));
    
    //开启事物
    [CATransaction begin];
    //禁用隐式动画
    [CATransaction setDisableActions:YES];
    
    layer.position = [[anim valueForKey:@"BasicAnimationLocation"] CGPointValue];
    
    //提交事物
    [CATransaction commit];
    
    //暂停动画
    [self animationPause];
}

#pragma mark 关键帧动画
-(void)translateAnimationWithKeyFrame:(CGPoint)location{
    //1.创建关键帧动画并设置动画属性
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //2.设置关键帧,这里有四个关键帧
//    NSValue *key1 = [NSValue valueWithCGPoint:layer.position];  //对于关键帧，初始值不能忽略
//    NSValue *key2 = [NSValue valueWithCGPoint:CGPointMake(80, 220)];
//    NSValue *key3 = [NSValue valueWithCGPoint:CGPointMake(45, 300)];
//    NSValue *key4 = [NSValue valueWithCGPoint:CGPointMake(55, 400)];
//    keyframeAnimation.values = @[key1, key2, key3, key4];
//    //各个关键帧的时间控制
//    keyframeAnimation.keyTimes = @[@0.0, @0.5, @0.75, @1.0];
//    //动画计算模式
//    keyframeAnimation.calculationMode = kCAAnimationCubic;
    
    //绘制贝塞尔曲线
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, layer.position.x, layer.position.y);
    CGPathAddCurveToPoint(path, NULL, 160, 280, -30, 300, 55, 400);
    keyframeAnimation.path = path;
    CGPathRelease(path);
    
    //3.设置其他属性
    keyframeAnimation.duration = 8.0;
    keyframeAnimation.beginTime = CACurrentMediaTime() + 2;  //延迟2秒执行
    
    [layer addAnimation:keyframeAnimation forKey:@"KCKeyframeAnimation_Position"];
}
@end
