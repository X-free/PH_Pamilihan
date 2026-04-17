//
//  PB_NativeTipsHelper.h
//  PrimeLoanPH
//
//  iOS 18+ 上 QMUITips/QMUIToastView 因 maskView 与 addSubview 冲突会崩溃，统一改用系统遮罩与 UIAlertController。
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PB_NativeTipsHelper : NSObject

+ (void)pb_showLoadingInView:(UIView *)hostView;
+ (void)pb_hideLoadingInView:(UIView *)hostView;
+ (void)pb_hideAllLoading;

/// 与旧 QMUITips showError / showWithText / showInfo 类似：弹系统 Alert（OK）
+ (void)pb_presentAlertWithMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
