//
//  UINavigationController+PBB.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/7.
//

#import "UINavigationController+PBB.h"
#import <objc/runtime.h>
static const char * pb_pop_only_ider = "pb_pop_only_ider";


@interface UINavigationController ()<UINavigationControllerDelegate>

@end


@implementation UINavigationController (PBB)


- (BOOL)isPopGestureRecognizerEnable {
    return [objc_getAssociatedObject(self, pb_pop_only_ider) boolValue];
}

- (void)setIsPopGestureRecognizerEnable:(BOOL)isPopGestureRecognizerEnable {
     objc_setAssociatedObject(self, pb_pop_only_ider, [NSNumber numberWithBool:isPopGestureRecognizerEnable], OBJC_ASSOCIATION_ASSIGN);
}

@end
