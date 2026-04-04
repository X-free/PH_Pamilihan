//
//  PB_location_helper.h
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PB_location_helper : NSObject



@property (nonatomic, copy)NSString *pb_t_country;
@property (nonatomic, copy)NSString *pb_t_province;
@property (nonatomic, copy)NSString *pb_t_city;
@property (nonatomic, copy)NSString *pb_t_subCity;
@property (nonatomic, copy)NSString *pb_t_street;
@property (nonatomic, copy)NSString *pb_t_longitude;
@property (nonatomic, copy)NSString *pb_t_latitude;
@property (nonatomic, copy)NSString *pb_t_countryCode;

- (void)pb_t_toBeginLocationMethod;

/** 定位权限处fgdsgdg理 */
- (BOOL) pb_t_askLocationAllowIsEnable;



+ (PB_location_helper *)instanceOnly;



@end

NS_ASSUME_NONNULL_END
