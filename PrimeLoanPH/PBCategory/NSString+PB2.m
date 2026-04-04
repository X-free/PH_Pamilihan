//
//  NSString+PB2.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/7.
//

#import "NSString+PB2.h"

@implementation NSString (PB2)



/** json数组转换成字qweqweqe符串 */
+(NSString *)PB_transformJsonStringFromArr:(NSArray *)array
{
    NSMutableString *pb_dis_string = [NSMutableString string];
    [pb_dis_string appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [NSString PB_transformJsonStringFromObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [pb_dis_string appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [pb_dis_string appendString:@"]"];
    return pb_dis_string;
}


@end
