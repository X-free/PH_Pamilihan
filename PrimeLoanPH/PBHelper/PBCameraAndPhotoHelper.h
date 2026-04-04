//
//  PBCameraAndPhotoHelper.h
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^PickImageComplete)(UIImage *image);


@interface PBCameraAndPhotoHelper : NSObject

// 访问相机
+ (void)pb_to_useCameraFromVC:(UIViewController *)fromVC isFront:(BOOL)isFront finishPicking:(PickImageComplete)finishPicking;
// 访问相册
+ (void)pb_to_useAlbumFromVC:(UIViewController *)fromVC finishPicking:(PickImageComplete)finishPicking;

@end

NS_ASSUME_NONNULL_END
