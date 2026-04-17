//
//  PB_NativeTipsHelper.m
//

#import "PB_NativeTipsHelper.h"
#import "PB_GetVC.h"

static NSString *const kPBNativeLoadingDimId = @"pb_native_loading_dim";
static NSMutableArray<UIView *> *pb_nativeLoadingOverlays;

static void pb_overlayRegister(UIView *dim) {
    if (!pb_nativeLoadingOverlays) {
        pb_nativeLoadingOverlays = [NSMutableArray array];
    }
    if (dim && ![pb_nativeLoadingOverlays containsObject:dim]) {
        [pb_nativeLoadingOverlays addObject:dim];
    }
}

static void pb_overlayUnregister(UIView *dim) {
    [pb_nativeLoadingOverlays removeObject:dim];
}

@implementation PB_NativeTipsHelper

+ (void)pb_showLoadingInView:(UIView *)hostView {
    if (!hostView) {
        return;
    }
    void (^work)(void) = ^{
        [self pb_hideLoadingInView:hostView];
        UIView *dim = [[UIView alloc] initWithFrame:hostView.bounds];
        dim.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        dim.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.22];
        dim.userInteractionEnabled = YES;
        dim.accessibilityIdentifier = kPBNativeLoadingDimId;
        UIActivityIndicatorView *spin;
        if (@available(iOS 13.0, *)) {
            spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
            spin.color = UIColor.whiteColor;
        } else {
            spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        }
        spin.translatesAutoresizingMaskIntoConstraints = NO;
        [dim addSubview:spin];
        [NSLayoutConstraint activateConstraints:@[
            [spin.centerXAnchor constraintEqualToAnchor:dim.centerXAnchor],
            [spin.centerYAnchor constraintEqualToAnchor:dim.centerYAnchor],
        ]];
        [spin startAnimating];
        [hostView addSubview:dim];
        pb_overlayRegister(dim);
    };
    if ([NSThread isMainThread]) {
        work();
    } else {
        dispatch_async(dispatch_get_main_queue(), work);
    }
}

+ (void)pb_hideLoadingInView:(UIView *)hostView {
    if (!hostView) {
        return;
    }
    void (^work)(void) = ^{
        NSMutableArray<UIView *> *found = [NSMutableArray array];
        for (UIView *sub in hostView.subviews) {
            if ([sub.accessibilityIdentifier isEqualToString:kPBNativeLoadingDimId]) {
                [found addObject:sub];
            }
        }
        for (UIView *v in found) {
            [v removeFromSuperview];
            pb_overlayUnregister(v);
        }
    };
    if ([NSThread isMainThread]) {
        work();
    } else {
        dispatch_async(dispatch_get_main_queue(), work);
    }
}

+ (void)pb_hideAllLoading {
    void (^work)(void) = ^{
        NSArray<UIView *> *copy = [pb_nativeLoadingOverlays copy];
        for (UIView *v in copy) {
            [v removeFromSuperview];
        }
        [pb_nativeLoadingOverlays removeAllObjects];
    };
    if ([NSThread isMainThread]) {
        work();
    } else {
        dispatch_async(dispatch_get_main_queue(), work);
    }
}

+ (void)pb_presentAlertWithMessage:(NSString *)message {
    if (message.length == 0) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *vc = [PB_GetVC pb_to_getCurrentViewController];
        while (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }
        if (!vc || vc.isBeingDismissed) {
            return;
        }
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [vc presentViewController:ac animated:YES completion:nil];
    });
}

@end
