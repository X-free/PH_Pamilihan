//
//  PB_timeHelper.h
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PB_timeHelper : NSObject

///获取当前时间  yyyy-MM-dd HH:mm:ss  sadsasdvcsvdscv]]]
+ (NSString*)pb_t_getTimeFormatyyyyMMddHHmmss;

///获取当前日期  yyyy-MM-dd sadasdasd
+ (NSString*)pb_t_getCurrentTimeFormatyyyyMMdd;

///获取当前时间asdasdas戳
+ (NSString *)pb_t_getCurrentStampTimeString;

@end

NS_ASSUME_NONNULL_END
