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

///pop页面
- (void)popController;

@end

NS_ASSUME_NONNULL_END
