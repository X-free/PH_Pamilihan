//
//  PB_LogoutAlertView.h
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PB_LogoutAlertView : UIView

///50 确定 51 取消
@property (nonatomic, copy) void (^myBlock)(NSInteger buttonIndex);

@end

NS_ASSUME_NONNULL_END
