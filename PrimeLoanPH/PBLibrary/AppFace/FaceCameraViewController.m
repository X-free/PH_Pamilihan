//
//  FaceCameraViewController.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/9.
//

#import "FaceCameraViewController.h"

@interface FaceCameraViewController ()<AVCapturePhotoCaptureDelegate>

//捕获设备，通常是前置摄像头、后置等
@property (nonatomic, strong) AVCaptureDevice *device;
//输入设备
@property (nonatomic, strong) AVCaptureDeviceInput *input;
//输出图片
@property (nonatomic, strong) AVCapturePhotoOutput *imgOutPut;
//把输入和输出结合在一起，并开始启动捕获设备
@property (nonatomic, strong) AVCaptureSession *session;
//图像预览层，实时显示捕获的图像
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) UILabel *msgLabel;
@property (nonatomic, strong) UIImageView *resultImgV;
@property (nonatomic, strong) QMUIButton *cancelMenuBtn;
@property (nonatomic, strong) QMUIButton *sureMenuBtn;
@property (nonatomic, assign) UIButton *photoButton;
@property (nonatomic, strong) UIImage *resultImg;

@end

@implementation FaceCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self beginUI];
}

//创建UI
- (void)beginUI {
    self.showNavBar = NO;
    self.view.backgroundColor = UIColor.blackColor;
    //
    _resultImgV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _resultImgV.contentMode = UIViewContentModeScaleAspectFill;
    _resultImgV.hidden = YES;
    [self.view addSubview:self.resultImgV];
    
    //占位背景
    CGFloat img_h = SCREEN_WIDTH * 622.0/375;
    UIImageView *holdImgV = [[UIImageView alloc] initWithImage:UIImageMake(@"faceBorderHold")];
    [self.view addSubview:holdImgV];
    [holdImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(img_h);
    }];
    //导航栏
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, NavigationContentTop-44, 44, 44)];
    [self.view addSubview:backBtn];
    [backBtn setImage:UIImageMake(@"main_back_icon") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    //
    _msgLabel = [[UILabel alloc] init];
    _msgLabel.text = @"Please make sure you are the only one around";
    _msgLabel.textColor = PB_WhiteColor;
    _msgLabel.font = UIFontMake(PB_Ratio(16));
    [self.view addSubview:self.msgLabel];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(NavigationContentTop + PB_Ratio(40));
    }];
    //
    UIButton *photoButton = [[UIButton alloc] init];
    [photoButton setBackgroundImage:[UIImage imageNamed:@"tp_btn"] forState:UIControlStateNormal];
    photoButton.layer.cornerRadius = PB_Ratio(25);
    photoButton.layer.masksToBounds = YES;
    [photoButton setTitle:@"take photo" forState:UIControlStateNormal];
    photoButton.titleLabel.font = UIFontBoldMake(PB_Ratio(18));
    [photoButton bringSubviewToFront:photoButton.titleLabel];
    [photoButton addTarget:self action:@selector(photoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoButton];
    _photoButton = photoButton;
    [photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_offset(-PB_BottomBarXH - PB_Ratio(10));
        make.height.mas_equalTo(PB_Ratio(50));
        make.width.mas_equalTo(SCREEN_WIDTH - PB_Ratio(20)*2);
    }];
    CGFloat left = PB_Ratio(25);
    CGFloat space = PB_Ratio(15);
    CGFloat btn_w = (SCREEN_WIDTH - left * 2 - space)/2;
    CGFloat btn_h = PB_Ratio(50);
    _cancelMenuBtn = [[QMUIButton alloc] init];
    [_cancelMenuBtn setBackgroundImage:UIImageMake(@"grayGLayer") forState:UIControlStateNormal];
    [_cancelMenuBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    _cancelMenuBtn.layer.cornerRadius =  btn_h/2;
    _cancelMenuBtn.titleLabel.font = UIFontMediumMake(18);
    [_cancelMenuBtn setTitleColor:PB_WhiteColor forState:UIControlStateNormal];
    _cancelMenuBtn.layer.masksToBounds = YES;
    _cancelMenuBtn.tag = 11;
//    [_cancelMenuBtn bringSubviewToFront:_cancelMenuBtn.titleLabel];
    [_cancelMenuBtn addTarget:self action:@selector(bottomMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelMenuBtn];
    //
    _sureMenuBtn = [[QMUIButton alloc] init];
    [_sureMenuBtn setBackgroundImage:UIImageMake(@"tp_btn") forState:UIControlStateNormal];
    [_sureMenuBtn setTitle:@"Sure" forState:UIControlStateNormal];
    _sureMenuBtn.layer.cornerRadius =  btn_h/2;
    _sureMenuBtn.titleLabel.font = UIFontMediumMake(18);
    [_sureMenuBtn setTitleColor:PB_WhiteColor forState:UIControlStateNormal];
    _sureMenuBtn.layer.masksToBounds = YES;
    _sureMenuBtn.tag = 12;
    [_sureMenuBtn addTarget:self action:@selector(bottomMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sureMenuBtn];
    [self.cancelMenuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-PB_BottomBarXH - PB_Ratio(10));
        make.left.mas_equalTo(left);
        make.size.mas_equalTo(CGSizeMake(btn_w, btn_h));
    }];
    [self.sureMenuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.cancelMenuBtn);
        make.left.mas_equalTo(self.cancelMenuBtn.mas_right).offset(space);
        make.size.mas_equalTo(self.cancelMenuBtn);
    }];
    [self.sureMenuBtn bringSubviewToFront:self.sureMenuBtn.titleLabel];
    self.sureMenuBtn.hidden = YES;
    [self.cancelMenuBtn bringSubviewToFront:self.cancelMenuBtn.titleLabel];
    self.cancelMenuBtn.hidden = YES;
    
    
    if([self checkCameraPermission] && [self isFrontCameraAvailable]){
        [self beginCamera];
    }
    
}

- (void)beginCamera {
    
    self.device = [self cameraWithPosition:AVCaptureDevicePositionFront];
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    self.imgOutPut = [[AVCapturePhotoOutput alloc] init];
    self.session = [[AVCaptureSession alloc] init];
    //设置图像大小
    self.session.sessionPreset = AVCaptureSessionPresetHigh;//AVCaptureSessionPreset1920x1080;
    //输入输出设备结合
    if([self.session canAddInput:self.input]){
        [self.session addInput:self.input];
    }
    
    
    if([self.session canAddOutput:self.imgOutPut]){
        [self.session addOutput:self.imgOutPut];
    }
    //预览层生成
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    //设备开始取景
    [self.session startRunning];
}

- (AVCapturePhotoSettings *)photoSettings {
    AVCapturePhotoSettings *photoSettings = [AVCapturePhotoSettings photoSettings];
    photoSettings.flashMode = AVCaptureFlashModeOff;
    return photoSettings;
}
 
#pragma mark - AVCapturePhotoCaptureDelegate
 
- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error {
    if (error) {
        NSLog(@"Error capturing photo: %@", error.localizedDescription);
    } else {
        // 获取图片
        UIImage *image = [UIImage imageWithData:photo.fileDataRepresentation];
        // 处理图片，例如展示在UIImageView或者保存到相册
        NSLog(@"Photo captured!");
        UIImage *showImg =  [self handleOriginalImage:image];
        
        //图片进行裁剪
        UIImage *resultImg = showImg;
        CGFloat width = 720;
        CGFloat height = 900;
        self.resultImg = [self recImage:resultImg fortargetSize:CGSizeMake(width, height)];
        self.resultImgV.image = showImg;
        self.resultImgV.hidden = NO;
        self.cancelMenuBtn.hidden = NO;
        self.sureMenuBtn.hidden = NO;
        self.photoButton.hidden = YES;
    }
}

#pragma mark - 图片处理 - 前置摄像头需要处理左右成像问题
-(UIImage *)handleOriginalImage:(UIImage *)aImage {
    UIImage *img;
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
    transform = CGAffineTransformRotate(transform, M_PI_2);
    transform = CGAffineTransformTranslate(transform, aImage.size.height,0);
    transform = CGAffineTransformScale(transform, -1, 1);
    CGContextRef ctx =CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,CGImageGetBitsPerComponent(aImage.CGImage),0,CGImageGetColorSpace(aImage.CGImage),CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
    CGImageRef cgimg =CGBitmapContextCreateImage(ctx);
    img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//获取目标摄像头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    AVCaptureDeviceDiscoverySession *captureDeviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera]
                                          mediaType:AVMediaTypeVideo
                                           position:position];
    NSArray *captureDevices = [captureDeviceDiscoverySession devices];
    for (AVCaptureDevice *device in captureDevices) {
        if(device.position == position){
            return device;
        }
    }
    
    return nil;
}


#pragma mark - 相机权限
- (BOOL)checkCameraPermission;
{
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
            return NO;
        }else if(status == AVAuthorizationStatusNotDetermined) {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            __block BOOL isgranted = YES;
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                isgranted=granted;
                dispatch_semaphore_signal(sema);
            }];
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            return isgranted;
        }else
        {
            return YES;
        }
    } else {
        return YES;
    }
}

// 前面的摄像头是否可用
- (BOOL)isFrontCameraAvailable{
    BOOL isEnable =  [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
    if(isEnable == NO){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [PB_NativeTipsHelper pb_presentAlertWithMessage:@"The front camera is not available"];
        });
       
        NSLog(@"前置摄像头不可用");
    }
    return isEnable;
}

#pragma mark - click

- (void)photoButtonClick{
    AVCaptureConnection *connection = [self.imgOutPut connectionWithMediaType:AVMediaTypeVideo];
    if(!connection){
        [PB_NativeTipsHelper pb_presentAlertWithMessage:@"Take photo failure"];

        NSLog(@"拍照失败了");
        return;
    }
    
    // 创建图片任务
    __block AVCapturePhotoOutput *photoOutput = self.imgOutPut;
    [photoOutput capturePhotoWithSettings:[self photoSettings] delegate:self];
}

- (void)goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

    
- (void)bottomMenuButtonClick:(QMUIButton *)button{
    if (button.tag == 11){//取消
        self.resultImgV.hidden = YES;
        self.cancelMenuBtn.hidden = YES;
        self.sureMenuBtn.hidden = YES;
        self.photoButton.hidden = NO;
    }else if (button.tag == 12){//确定
        [self requestToUploadFaceToServe];
    }
}


-(UIImage*)recImage:(UIImage*)image fortargetSize: (CGSize)targetSize{
    //NSLog(@"image%lf---image%lf",image.size.width,image.size.height);
   // image1080.000000---image1920.000000
    // 加载原始图片（这里使用一个示例图片，替换成你的图片名字）
    UIImage *originalImage = image;

    // 创建画布
    UIGraphicsBeginImageContextWithOptions(targetSize, YES, 1.0);
    [[UIColor orangeColor] setFill]; // 设置白色背景
    UIRectFill(CGRectMake(0, 0, targetSize.width, targetSize.height));

    // 计算人像的裁剪区域
    CGRect cropRect;
    CGSize originalSize = originalImage.size;
    if (originalSize.width / originalSize.height >= targetSize.width / targetSize.height) {
        // 原始图比例更宽，裁剪高度
        CGFloat newHeight = originalSize.height * (targetSize.width / originalSize.width);
        cropRect = CGRectMake(0, (originalSize.height - newHeight) / 2, originalSize.width, newHeight);
    } else {
        // 原始图比例更高，裁剪宽度
        CGFloat yy = originalSize.height;
        CGFloat newWidth = originalSize.width * (targetSize.height / yy);
        if(newWidth < 720){//进行尺寸匹配
            newWidth = 720;
        }
        cropRect = CGRectMake((originalSize.width - newWidth) / 2, 0, newWidth, yy);
    }

    // 获取裁剪后的人像
    CGImageRef croppedImageRef = CGImageCreateWithImageInRect([originalImage CGImage], cropRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:croppedImageRef];

    // 绘制人像到画布中央
    CGFloat x = (targetSize.width - croppedImage.size.width) / 2.0;
    CGFloat y = (targetSize.height - croppedImage.size.height) / 2.0;
    [croppedImage drawAtPoint:CGPointMake(x, y)];

    // 获取绘制后的图片
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    //NSLog(@"%lf---%lf",finalImage.size.width,finalImage.size.height);
    // 结束画布绘制
    UIGraphicsEndImageContext();
    return finalImage;
}


#pragma mark - request
- (void)requestToUploadFaceToServe{
    if(!self.resultImg){
        NSLog(@"裁剪后的照片不存在")
        return;
    }
    if(self.faceImage){
        self.faceImage(self.resultImg);
    }
    [self goBack];
    
}




@end
