//
//  PB_CallCell.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/7.
//

#import "PB_CallCell.h"

@implementation PB_CallCell

+ (void)pb_to_callPhone:(NSString *)number{
    NSMutableString * chargeS = [[NSMutableString alloc] initWithFormat:@"tel:%@",number];
    NSURL *url = [NSURL URLWithString:chargeS];
    if ([[UIApplication sharedApplication] canOpenURL:url])
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

@end
