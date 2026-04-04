//
//  NSString+PB3.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/7.
//

#import "NSString+PB3.h"

@implementation NSString (PB3)

/** 字典转换成字符串 */
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

@end
