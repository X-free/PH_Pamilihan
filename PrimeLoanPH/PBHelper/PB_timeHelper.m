//
//  PB_timeHelper.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/7.
//

#import "PB_timeHelper.h"

@implementation PB_timeHelper


+ (NSString*)pb_t_getTimeFormatyyyyMMddHHmmss{
    NSDateFormatter* pb_t_format = [NSDateFormatter new];
    pb_t_format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [pb_t_format stringFromDate:[NSDate date]];
}

+ (NSString*)pb_t_getCurrentTimeFormatyyyyMMdd{
    NSDateFormatter* pb_t_format = [NSDateFormatter new];
    pb_t_format.dateFormat = @"yyyy-MM-dd";
    return [pb_t_format stringFromDate:[NSDate date]];
}

+ (NSString *)pb_t_getCurrentStampTimeString{
    NSDate *pb_t_dateNow =[NSDate date];
    NSString *pb_t_result = [NSString stringWithFormat:@"%ld", (long)[pb_t_dateNow timeIntervalSince1970]];
    return pb_t_result;
}


@end
