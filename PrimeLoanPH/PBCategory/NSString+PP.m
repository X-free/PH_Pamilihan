//
//  NSString+PP.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/27.
//

#import "NSString+PP.h"

@implementation NSString (PP)







/** json对象转换成字符串 */
+(NSString *)PB_transformJsonStringFromObject:(id)fromObj
{
    NSString *pb_t_de_value = nil;
    if (!fromObj)
    {
        return pb_t_de_value;
    }
    if ([fromObj isKindOfClass:[NSString class]])
    {
        pb_t_de_value = [self pb_changeJsonStrWithString:fromObj];
    }
    else if([fromObj isKindOfClass:[NSDictionary class]])
    {
        pb_t_de_value = [self PB_getJsonStringFromDictionary:fromObj];
    }
    else if([fromObj isKindOfClass:[NSArray class]])
    {
        pb_t_de_value = [self PB_transformJsonStringFromArr:fromObj];
    }
    return pb_t_de_value;
}

/** json字符串转换成普通字符串 */
+(NSString *) pb_changeJsonStrWithString:(NSString *) string
{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}

+(NSString *) PB_getJsonStringFromDictionary:(NSDictionary *)dictionary
{
    NSString *pb_diss_JSString = nil;
    NSError *error;
    if(dictionary == nil){
        return pb_diss_JSString;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error: &error];
    
    if (!data) {
                NSLog(@"Got an error: %@", error);
    } else {
        pb_diss_JSString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return pb_diss_JSString;
}

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
