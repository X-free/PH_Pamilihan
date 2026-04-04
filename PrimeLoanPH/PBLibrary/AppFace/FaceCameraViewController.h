//
//  FaceCameraViewController.h
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/9.
//

#import "PPBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FaceCameraViewController : PPBaseViewController

@property (copy, nonatomic) void(^faceImage)(UIImage *image);



@end

NS_ASSUME_NONNULL_END
