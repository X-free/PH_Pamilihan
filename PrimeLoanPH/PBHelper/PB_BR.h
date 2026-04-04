//
//  PB_BR.h
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PB_BR : NSObject

///选择器样式sadsaf
+ (BRPickerStyle *)pv_to_getPickerCustomStyle;
///日期选dsf择器
+ (BRDatePickerView *)pb_to_getCustomDataPickerView;
///字符串选dsffdg择器
+ (BRStringPickerView *)pb_to_getCustomStringPickerView;

///地址sdfksldfjsldkfj选择器
+ (BRAddressPickerView *)pb_to_getAdressCustomPickerView;

@end

NS_ASSUME_NONNULL_END
