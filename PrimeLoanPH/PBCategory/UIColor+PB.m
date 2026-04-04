//
//  UIColor+PB.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/7.
//

#import "UIColor+PB.h"

@implementation UIColor (PB)

+ (UIColor *)PBColorBackHexStr:(NSString *)color alpha:(CGFloat)alpha
{
    NSString *PBColorString_ = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([PBColorString_ length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([PBColorString_ hasPrefix:@"0X"])
    {
        PBColorString_ = [PBColorString_ substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([PBColorString_ hasPrefix:@"#"])
    {
        PBColorString_ = [PBColorString_ substringFromIndex:1];
    }
    if ([PBColorString_ length] != 6)
    {
        return [UIColor clearColor];
    }
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [PBColorString_ substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [PBColorString_ substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [PBColorString_ substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

+ (UIColor *)PBColorBackHexStr:(NSString *)color
{
    //默认alpha值为1
    UIColor *pb_result_color = [self PBColorBackHexStr:color alpha:1.0f];
    return pb_result_color;
}


@end
