//
//  PB_GetVC.h
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PB_GetVC : NSObject

///获取当前控制器wwerwer
+ (UIViewController *)pb_to_getCurrentViewController;


//移除目标控制器weqwrwer
+ (void)pb_to_removeViewController:(id)targetVC NS_SWIFT_NAME(pb_to_removeFromNavigation(_:));

@end

NS_ASSUME_NONNULL_END
