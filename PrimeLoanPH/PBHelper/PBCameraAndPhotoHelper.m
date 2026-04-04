//
//  PBCameraAndPhotoHelper.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/7.
//

#import "PBCameraAndPhotoHelper.h"
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>


static PickImageComplete _pb_to_finishPicking_block;
@interface PBCameraAndPhotoHelper ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation PBCameraAndPhotoHelper

// 访问相机功能
+ (void)pb_to_useCameraFromVC:(UIViewController *)fromVC isFront:(BOOL)isFront finishPicking:(nonnull PickImageComplete)finishPicking {
    
    if([self pb_t_toCheckCameraAvailable] == NO){
        NSLog(@"摄像头不可用");
        return;
    }
    if(isFront){
        if([self pb_t_toCheckFrontCameraAvailable] == NO){
            NSLog(@"前置相机不可用");
            return;
        }
    }
    _pb_to_finishPicking_block = [finishPicking copy];
    // 判断相机授权，弹出访问权限提示框
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(),^{
            if (granted) { // 授权成功
                [self pb_t_toOpenOnlyCamera:fromVC isFront:isFront];
            } else { // 拒绝授权
                [self pb_t_toShowCameraRequestTipAlert:fromVC];
            }
        });
    }];
}

// 打开相机
+ (void)pb_t_toOpenOnlyCamera:(UIViewController *)fromVC isFront:(BOOL)isFront{
//    if (@available(iOS 11.0, *)) {
//        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
//    }
    UIImagePickerController *pb_t_pickerCtrloller = [[UIImagePickerController alloc] init];
    pb_t_pickerCtrloller.delegate = [self self];
    pb_t_pickerCtrloller.sourceType = UIImagePickerControllerSourceTypeCamera;
    if(isFront){
        pb_t_pickerCtrloller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    pb_t_pickerCtrloller.modalPresentationStyle = UIModalPresentationFullScreen;
    [fromVC presentViewController:pb_t_pickerCtrloller animated:YES completion:nil];
}

// 不能打开相机时提示
+ (void)pb_t_toShowCameraRequestTipAlert:(UIViewController *)fromVC {
    PMMyWeekSelf
    QMUIAlertController *pb_t_qmui_alertViewController =[QMUIAlertController alertControllerWithTitle:@"Tip" message:PB_CameraTipMsg preferredStyle:QMUIAlertControllerStyleAlert];
    [pb_t_qmui_alertViewController addAction:[QMUIAlertAction actionWithTitle:@"Cancel" style:QMUIAlertActionStyleCancel handler:nil]];
    [pb_t_qmui_alertViewController addAction:[QMUIAlertAction actionWithTitle:@"Confirm" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        [weakSelf pb_t_toOpenSetting];
    }]];
    [pb_t_qmui_alertViewController showWithAnimated:YES];
}


// 访问相册功能
+ (void)pb_to_useAlbumFromVC:(UIViewController *)fromVC finishPicking:(PickImageComplete)finishPicking {
    _pb_to_finishPicking_block = [finishPicking copy];
    
    // 判断相册授权，弹出访问权限提示框
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(),^{
            if (status == PHAuthorizationStatusAuthorized) {
                [self pb_t_openThePhotoAlbumFun:fromVC];
            } else {
                [self pb_t_showPhotoAlbumAllowTipAlert:fromVC];
            }
        });
    }];
}

// 打开相册
+ (void)pb_t_openThePhotoAlbumFun:(UIViewController *)fromVC {
//    if (@available(iOS 11.0, *)) {
//        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
//    }
    UIImagePickerController *pb_t_pickerCtrloller = [[UIImagePickerController alloc] init];
    pb_t_pickerCtrloller.delegate = [self self];
    pb_t_pickerCtrloller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pb_t_pickerCtrloller.modalPresentationStyle = UIModalPresentationFullScreen;
    [fromVC presentViewController:pb_t_pickerCtrloller animated:YES completion:nil];
}

// 不能打开相册时提示
+ (void)pb_t_showPhotoAlbumAllowTipAlert:(UIViewController *)fromVC {

    PMMyWeekSelf
    QMUIAlertController *pb_t_qmui_alertViewController =[QMUIAlertController alertControllerWithTitle:@"Tip" message:PB_PhotoTipContent preferredStyle:QMUIAlertControllerStyleAlert];
    [pb_t_qmui_alertViewController addAction:[QMUIAlertAction actionWithTitle:@"Cancel" style:QMUIAlertActionStyleCancel handler:nil]];
    [pb_t_qmui_alertViewController addAction:[QMUIAlertAction actionWithTitle:@"Confirm" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        [weakSelf pb_t_toOpenSetting];
    }]];
    [pb_t_qmui_alertViewController showWithAnimated:YES];
}

// 打开设置
+ (void)pb_t_toOpenSetting {
    NSURL *pb_t_url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [PB_OpenUrl pb_to_openUrl:pb_t_url];
}

// 回调
+ (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{
//        if (@available(iOS 11.0, *)) {
//            [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        }
    }];
    
    UIImage *pb_t_image_ = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (pb_t_image_ && _pb_to_finishPicking_block) {
        _pb_to_finishPicking_block(pb_t_image_);
        _pb_to_finishPicking_block = nil;
    }

}

+ (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
//        if (@available(iOS 11.0, *)) {
//            [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        }
    }];
}

// 判断设备是否有摄像头
+ (BOOL)pb_t_toCheckCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
  
// 前面的摄像头是否可用
+ (BOOL)pb_t_toCheckFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}


@end
