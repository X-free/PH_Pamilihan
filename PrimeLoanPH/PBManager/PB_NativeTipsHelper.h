//
//  PB_NativeTipsHelper.h
//  PrimeLoanPH
//
//  iOS 18+ 上 QMUITips/QMUIToastView 因 maskView 与 addSubview 冲突会崩溃；Loading 用自绘遮罩；短提示用自绘 Toast（不用 QMUITips）。
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PB_NativeTipsHelper : NSObject

+ (void)pb_showLoadingInView:(UIView *)hostView;
+ (void)pb_hideLoadingInView:(UIView *)hostView;
+ (void)pb_hideAllLoading;

/// 屏幕中央自动消失 Toast（约 3s），替代系统 Alert；调用点无需修改方法名。
+ (void)pb_presentAlertWithMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
