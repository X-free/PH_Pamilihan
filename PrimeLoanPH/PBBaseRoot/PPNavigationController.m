//
//  PPNavigationController.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/27.
//

#import "PPNavigationController.h"

@interface PPNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation PPNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 13.0, *)) {
        self.navigationBar.standardAppearance.backgroundColor = [UIColor whiteColor];
    }else{
        self.navigationBar.barTintColor = [UIColor whiteColor];
    }

    __weak PPNavigationController *weakSelf = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        
        self.delegate = weakSelf;
    }
}


#pragma mark - push

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:YES];
}


- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated{
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)]&& animated == YES ){
        
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return [super popToRootViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] ){
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return [super popToViewController:viewController animated:animated];
    
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animate {
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        if (navigationController.childViewControllers.count == 1) {
            self.interactivePopGestureRecognizer.enabled = NO;
        }else
            self.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

    [viewController.navigationController setNavigationBarHidden:YES animated:NO];
   
}

@end
