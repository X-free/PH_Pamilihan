//
//  PB_OpenUrl.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/7.
//

#import "PB_OpenUrl.h"

@implementation PB_OpenUrl

+ (void)pb_to_openUrl:(NSURL *)url{
    if ([[UIApplication sharedApplication] canOpenURL:url])
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}


@end
