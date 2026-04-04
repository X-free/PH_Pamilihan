//
//  PPHomeHeaderView.h
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPHomeHeaderView : UIView

- (instancetype)initTapBlock:(void(^)(NSInteger pId))tapBlock;

- (void)pp_configData:(id)data;

- (void)pp_configAgreeData:(id)data;

- (void)pp_configMsgData:(id)data;

@end

NS_ASSUME_NONNULL_END
