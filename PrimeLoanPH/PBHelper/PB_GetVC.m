//
//  PB_GetVC.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/7.
//

#import "PB_GetVC.h"

@implementation PB_GetVC


+ (UIViewController *)pb_to_getCurrentViewController {
    UIViewController* pb_t_viewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    BOOL hasFind = YES;
    while (hasFind) {
        if (pb_t_viewController.presentedViewController) {
            pb_t_viewController = pb_t_viewController.presentedViewController;
        } else {
            if ([pb_t_viewController isKindOfClass:[UINavigationController class]]) {
                pb_t_viewController = ((UINavigationController *)pb_t_viewController).visibleViewController;
            } else if ([pb_t_viewController isKindOfClass:[UITabBarController class]]) {
                pb_t_viewController = ((UITabBarController* )pb_t_viewController).selectedViewController;
            } else {
                break;
            }
        }
    }
    return pb_t_viewController;
}


+ (void)pb_to_removeViewController:(id)targetVC {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *vc = targetVC;
        //移除控制器操作
        NSMutableArray *pb_t_vcArr = [NSMutableArray arrayWithArray:vc.navigationController.viewControllers];
        for (NSInteger i = [pb_t_vcArr count]-1; i > 0; i--) {
            UIViewController *pb_t_vc = pb_t_vcArr[i];
            if ([pb_t_vc isKindOfClass:[vc class]]){
                [pb_t_vcArr removeObject:pb_t_vc];
                break;
            }
        }
        vc.navigationController.viewControllers = pb_t_vcArr;
    });
}



@end
