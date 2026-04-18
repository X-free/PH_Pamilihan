//
//  PPBaseViewController.h
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPBaseViewController : UIViewController

@property (nonatomic, assign) BOOL showNavBar;
@property (nonatomic, assign) BOOL showBackBtn;
@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, assign) BOOL isDismiss; //是否是dismiss回去
@property (nonatomic, strong) UIFont *nameFont;
@property (nonatomic, strong) UIColor *navBgColr;
/// 使用 `icon_return_black`（如透明/浅色顶栏）；默认 NO 为白底用的 `icon_return_white`
@property (nonatomic, assign) BOOL useDarkNavBackIcon;

/// 自定义导航容器（与 `PB_NaviBa_H` 同高）。子类请将内容顶部约束到该视图 `bottomAnchor`，避免与宏算高度不一致产生缝隙。
@property (nonatomic, strong, readonly) UIView *pb_navigationBarContainerView;

///pop页面
- (void)popController;

/// 插入全屏 SwiftUI / 遮罩后调用，保证自定义顶栏与返回键不被盖住。
- (void)pp_bringCustomNavigationBarToFront;

@end

NS_ASSUME_NONNULL_END
