//
//  ViewController.m
//  GestureRecognizer
//
//  Created by hesc on 15/8/11.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "ViewController.h"
#define ImageCount 3

@interface ViewController ()<UIGestureRecognizerDelegate>{
    UIImageView *_imageView;
    int _currentIndex;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
    [self addGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initLayout{
    CGSize size = [UIScreen mainScreen].applicationFrame.size;
    CGFloat topPadding = 20;
    CGFloat y = 44+20+topPadding, height = size.height-y-topPadding;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, size.width, height)];
    _imageView.contentMode = UIViewContentModeScaleToFill;
    _imageView.userInteractionEnabled = YES;
    [self.view addSubview:_imageView];
    
    _currentIndex = 0;
    [self setImage];
    [self showPhotoName];
}

-(void)addGesture{
    //添加点按手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    tapGesture.numberOfTapsRequired = 1;  //点按次数
    tapGesture.numberOfTouchesRequired = 1; // 点按的手指数
    //添加手势到控制器视图
    [self.view addGestureRecognizer:tapGesture];
    
    //添加长按手势
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressImage:)];
    longPressGesture.minimumPressDuration = 0.5;  // 设置长按时间，默认为0.5秒，不要轻易修改该值
    //添加手势到图片控件
    [_imageView addGestureRecognizer:longPressGesture];
    
    //添加捏合手势
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchImage:)];
    [self.view addGestureRecognizer:pinchGesture];
    
    //添加旋转手势
    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateImage:)];
    [self.view addGestureRecognizer:rotateGesture];
    
    //添加拖动手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImage:)];
    [_imageView addGestureRecognizer:panGesture];
    
    //添加轻扫手势
    //注意一个轻扫手势只能控制一个方向
    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeImage:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;  //默认向右轻扫
    [self.view addGestureRecognizer:swipeRightGesture];
    
    UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeImage:)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftGesture];
    
    
    //解决在图片上滑动时拖动手势和轻扫手势的冲突
    [panGesture requireGestureRecognizerToFail:swipeLeftGesture];
    [panGesture requireGestureRecognizerToFail:swipeRightGesture];
    //解决拖动和长按手势之间的冲突
    [longPressGesture requireGestureRecognizerToFail:panGesture];
    
    
    //演示不同视图的手势同时执行
    UILongPressGestureRecognizer *viewLongPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressView:)];
    viewLongPressGesture.delegate = self;
    [self.view addGestureRecognizer:viewLongPressGesture];
}

//设置图片到控件上
-(void)setImage{
    _imageView.image = [UIImage imageNamed:[self getImageName]];
}

//获取图片名称
-(NSString *)getImageName{
    return [NSString stringWithFormat:@"%i.jpg", _currentIndex];
}

//标题显示图片名称
-(void)showPhotoName{
    [self setTitle:[self getImageName]];
}

//下一张图片
-(void)nextImage{
    _currentIndex = (_currentIndex + ImageCount + 1)%ImageCount;
    [self setImage];
    [self showPhotoName];
}

//上一张图片
-(void)lastImage{
    _currentIndex = (_currentIndex + ImageCount - 1)%ImageCount;
    [self setImage];
    [self showPhotoName];
}


#pragma mark - 手势代理事件
//点按手势
-(void)tapImage:(UITapGestureRecognizer *)gestureRecognizer{
    //点按隐藏/显示导航栏
    BOOL hiden = !self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:hiden animated:YES] ;
}

//长按手势
-(void)longPressImage:(UILongPressGestureRecognizer *)gestureRecognizer{
    //由于长按该方法会调用多次，需要判断状态
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"系统信息" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
        [actionSheet showInView:self.view];
    }
}

//捏合手势
-(void)pinchImage:(UIPinchGestureRecognizer *)gestureRecognizer{
    if(gestureRecognizer.state == UIGestureRecognizerStateChanged){  //捏合进行缩放
        //捏合手势中scale属性记录缩放比例
        _imageView.transform = CGAffineTransformMakeScale(gestureRecognizer.scale, gestureRecognizer.scale);
    } else if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:0.5 animations:^{
            _imageView.transform = CGAffineTransformIdentity;  //取消一切形变
        }];
    }
}

//旋转手势
-(void)rotateImage:(UIRotationGestureRecognizer *)gestureRecognizer{
    if(gestureRecognizer.state == UIGestureRecognizerStateChanged){  //对图片进行旋转
        //旋转手势中rotation属性记录旋转角度
        _imageView.transform = CGAffineTransformMakeRotation(gestureRecognizer.rotation);
    } else if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:0.8 animations:^{
            _imageView.transform = CGAffineTransformIdentity;  //取消一切形变
        }];
    }
}

//清扫手势
-(void)swipeImage:(UISwipeGestureRecognizer *)gestureRecognizer{
    if(gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft){
        [self lastImage];
    } else if(gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight){
        [self nextImage];
    }
}

//拖动手势
-(void)panImage:(UIPanGestureRecognizer *)gestureRecognizer{
    if(gestureRecognizer.state == UIGestureRecognizerStateChanged){
        //利用拖动手势的translationInView:方法取得在相对指定视图（这里是控制器根视图）的移动
        CGPoint translation = [gestureRecognizer translationInView:self.view];
        _imageView.transform = CGAffineTransformMakeTranslation(translation.x, translation.y);
    } else if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:0.8 animations:^{
            _imageView.transform = CGAffineTransformIdentity;  //取消一切形变
        }];
    }
}


#pragma mark - 演示不同视图的手势同时执行
-(void)longPressView:(UILongPressGestureRecognizer *)gesture{
    NSLog(@"view long press!");
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    //注意，这里控制只有在UIImageView中才能向下传播，其他情况不允许
    if([otherGestureRecognizer.view isKindOfClass:[UIImageView class]]){
        return YES;
    }
    return NO;
}

@end
