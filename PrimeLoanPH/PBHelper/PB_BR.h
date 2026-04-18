//
//  PB_BR.h
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/7.
//

#import <Foundation/Foundation.h>
#import <BRPickerView/BRPickerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface PB_BR : NSObject

///选择器样式sadsaf
+ (BRPickerStyle *)pv_to_getPickerCustomStyle;
///日期选dsf择器
+ (BRDatePickerView *)pb_to_getCustomDataPickerView;
///字符串选dsffdg择器
+ (BRStringPickerView *)pb_to_getCustomStringPickerView;

/// `BRStringPickerView`：`show` 后立即调用；居中白卡、`optiontitlbg`、标题左对齐、`picker.title`；关闭 `Grosx1276601` 在卡外左上；Confirm 渐变；列表区与白卡叠在顶栏下方（设计稿层级）
+ (void)pb_applyStringPickerOptionTitleUI:(BRStringPickerView *)picker;

///地址sdfksldfjsldkfj选择器
+ (BRAddressPickerView *)pb_to_getAdressCustomPickerView;

@end

NS_ASSUME_NONNULL_END
