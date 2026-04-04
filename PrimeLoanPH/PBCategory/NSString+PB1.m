//
//  NSString+PB1.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/7.
//

#import "NSString+PB1.h"

@implementation NSString (PB1)

+ (BOOL)PB_CheckStringIsEmpty:(id)str
{
    NSString *pb_dis_string = [NSString stringWithFormat:@"%@", str];
    return (([pb_dis_string isKindOfClass:[NSNull class]])  || [pb_dis_string isEqual:[NSNull null]]||(pb_dis_string.length == 0) || (pb_dis_string == nil)|| ([pb_dis_string isEqualToString:@"(null)"]) || ([pb_dis_string isEqualToString:@"<null>"]) || ([[pb_dis_string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]));
}

@end
