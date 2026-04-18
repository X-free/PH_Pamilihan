//
//  PB_NativeTipsHelper.m
//

#import "PB_NativeTipsHelper.h"
#import "PB_GetVC.h"

static NSString *const kPBNativeLoadingDimId = @"pb_native_loading_dim";
static NSString *const kPBNativeToastId = @"pb_native_message_toast";
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
        UIView *host = vc.view.window ?: vc.view;
        if (CGRectIsEmpty(host.bounds)) {
            return;
        }

        for (UIView *sub in [host.subviews copy]) {
            if ([sub.accessibilityIdentifier isEqualToString:kPBNativeToastId]) {
                [sub removeFromSuperview];
            }
        }

        UIView *toast = [[UIView alloc] init];
        toast.accessibilityIdentifier = kPBNativeToastId;
        toast.translatesAutoresizingMaskIntoConstraints = NO;
        toast.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.78];
        toast.layer.cornerRadius = 10.0;
        toast.layer.masksToBounds = YES;
        toast.alpha = 0.0;

        UILabel *label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.text = message;
        label.textColor = UIColor.whiteColor;
        label.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;

        [toast addSubview:label];
        [host addSubview:toast];

        UILayoutGuide *safe = host.safeAreaLayoutGuide;
        const CGFloat side = 24.0;
        const NSTimeInterval kPBToastVisibleSeconds = 3.0;

        [NSLayoutConstraint activateConstraints:@[
            [label.leadingAnchor constraintEqualToAnchor:toast.leadingAnchor constant:14],
            [label.trailingAnchor constraintEqualToAnchor:toast.trailingAnchor constant:-14],
            [label.topAnchor constraintEqualToAnchor:toast.topAnchor constant:12],
            [label.bottomAnchor constraintEqualToAnchor:toast.bottomAnchor constant:-12],

            [toast.leadingAnchor constraintEqualToAnchor:safe.leadingAnchor constant:side],
            [toast.trailingAnchor constraintEqualToAnchor:safe.trailingAnchor constant:-side],
            [toast.centerYAnchor constraintEqualToAnchor:safe.centerYAnchor],
        ]];

        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            toast.alpha = 1.0;
        } completion:^(__unused BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kPBToastVisibleSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    toast.alpha = 0.0;
                } completion:^(__unused BOOL done) {
                    [toast removeFromSuperview];
                }];
            });
        }];
    });
}

@end
