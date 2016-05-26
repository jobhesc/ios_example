//
//  ViewController.m
//  CoreImage
//
//  Created by hesc on 15/8/12.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    UIImagePickerController *_imagePickerController;  // 系统照片选择控制器
    UIImageView *_imageView;  // 图片显示控件
    CIContext *_context;  // Core Image图形上下文
    CIImage *_image; // 我们要编辑的图片
    CIImage *_outputImage;  // 处理后的图片
    CIFilter *_colorControlsFilter;  // 色彩滤镜
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self showAllCIFilters];
    
    [self initLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化布局
-(void)initLayout{
    //初始化图片选择器
    _imagePickerController = [UIImagePickerController new];
    _imagePickerController.delegate = self;
    
    //创建图片显示控件
    CGSize size = [UIScreen mainScreen].bounds.size;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, size.width, size.height-64)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    
    //上方显示导航
    self.navigationItem.title = @"图片滤镜";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"打开" style:UIBarButtonItemStyleDone target:self action:@selector(openPhoto:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(savePhoto:)];
    
    //下方控制面板
    UIView *controlView = [[UIView alloc] initWithFrame:CGRectMake(0, size.height-118, size.width, 118)];
    [self.view addSubview:controlView];
    //添加饱和度(默认为1，大于饱和度增加小于1则降低)
    [self addControlItemView:controlView withTitle:@"饱和度" withTitleRect:CGRectMake(10, 10, 60, 25) withItemRect:CGRectMake(80, 10, 230, 25) withMinValue:0 withMaxValue:2 withValue:1 withAction:@selector(changeStaturation:)];
    //添加亮度(默认为0)
    [self addControlItemView:controlView withTitle:@"亮度" withTitleRect:CGRectMake(10, 40, 60, 25) withItemRect:CGRectMake(80, 40, 230, 25) withMinValue:-1 withMaxValue:1 withValue:0 withAction:@selector(changeBrightness:)];
    //添加对比度(默认为1)
    [self addControlItemView:controlView withTitle:@"对比度" withTitleRect:CGRectMake(10, 70, 60, 25) withItemRect:CGRectMake(80, 70, 230, 25) withMinValue:0 withMaxValue:2 withValue:1 withAction:@selector(changeContrast:)];
    
    //初始化CIContext
    //创建基于CPU的图像上下文
    //    NSNumber *number=[NSNumber numberWithBool:YES];
    //    NSDictionary *option=[NSDictionary dictionaryWithObject:number forKey:kCIContextUseSoftwareRenderer];
    //    _context=[CIContext contextWithOptions:option];
    _context=[CIContext contextWithOptions:nil];//使用GPU渲染，推荐,但注意GPU的CIContext无法跨应用访问，例如直接在UIImagePickerController的完成方法中调用上下文处理就会自动降级为CPU渲染，所以推荐现在完成方法中保存图像，然后在主程序中调用
    //    EAGLContext *eaglContext=[[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES1];
    //    _context=[CIContext contextWithEAGLContext:eaglContext];//OpenGL优化过的图像上下文
    
    //取得滤镜
    _colorControlsFilter = [CIFilter filterWithName:@"CIColorControls"];
}

-(void)addControlItemView:(UIView *)parentView withTitle:(NSString *)title withTitleRect:(CGRect)titleRect withItemRect:(CGRect)itemRect withMinValue:(float)minValue withMaxValue:(float)maxValue withValue:(float)value withAction:(SEL)action {
    //标题
    UILabel *label = [[UILabel alloc] initWithFrame:titleRect];
    label.text = title;
    label.font = [UIFont systemFontOfSize:12];
    [parentView addSubview:label];
    
    //slider
    UISlider *slider = [[UISlider alloc] initWithFrame:itemRect];
    slider.minimumValue = minValue;
    slider.maximumValue = maxValue;
    slider.value = value;
    [parentView addSubview:slider];
    
    [slider addTarget:self action:action forControlEvents:UIControlEventValueChanged];
}

//打开图片
-(void)openPhoto:(UIBarButtonItem *)button{
    //打开图片选择器
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

//保存图片
-(void)savePhoto:(UIBarButtonItem *)button{
    UIImageWriteToSavedPhotosAlbum(_imageView.image, nil, nil, nil);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系统信息" message:@"保存成功" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
    [alert show];
}

//改变饱和度
-(void)changeStaturation:(UISlider *)slider{
    [_colorControlsFilter setValue:[NSNumber numberWithFloat:slider.value] forKey:@"inputSaturation"]; // 设置滤镜参数
    [self setImage];
}

//改变亮度
-(void)changeBrightness:(UISlider *)slider{
    [_colorControlsFilter setValue:[NSNumber numberWithFloat:slider.value] forKey:@"inputBrightness"];
    [self setImage];
}

//改变对比度
-(void)changeContrast:(UISlider *)slider{
    [_colorControlsFilter setValue:[NSNumber numberWithFloat:slider.value] forKey:@"inputContrast"];
    [self setImage];
}

-(void)setImage{
    CIImage *outputImage = [_colorControlsFilter outputImage]; //取得输出图像
    CGImageRef temp = [_context createCGImage:outputImage fromRect:[outputImage extent]];
    _imageView.image = [UIImage imageWithCGImage:temp]; //转化为CGImage显示在界面中
    CGImageRelease(temp); //释放CGImage对象
}

#pragma mark 图片选择器代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //关闭选择器
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //取得图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    _imageView.image = image;
    //初始化CIImage源图像
    _image = [CIImage imageWithCGImage:image.CGImage];
    [_colorControlsFilter setValue:_image forKey:@"inputImage"]; // 设置滤镜的输入图片
}

#pragma mark - 显示所有内置的滤镜
-(void)showAllCIFilters{
    NSArray *filterNames = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    for(NSString *filterName in filterNames){
        CIFilter *filter = [CIFilter filterWithName:filterName];
        NSLog(@"\rfilter:%@\rattributes:%@", filterName, filter.attributes);
    }
}

@end
