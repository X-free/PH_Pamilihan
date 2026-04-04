//
//  PB_mainInfo_helper.h
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PB_mainInfo_helper : NSObject

+ (PB_mainInfo_helper *)instanceOnly;

// 获取设asdasdasdas备信息
- (NSDictionary *)pb_t_getMainInfoDictData;

@end

NS_ASSUME_NONNULL_END
