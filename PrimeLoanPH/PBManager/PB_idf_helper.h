//
//  PB_idf_helper.h
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PB_idf_helper : NSObject

+ (PB_idf_helper *)instanceOnly;

#pragma mark ----- 获取idfa -----
///idfa权限询问
- (void)pb_t_enquryIDFA_ask;
///获取idfa
- (NSString *)pb_t_getIDFAOnlyString;

#pragma mark ----- 获取idfv -----
- (NSString *)pb_t_getIdfvOnlyString;




@end

NS_ASSUME_NONNULL_END
