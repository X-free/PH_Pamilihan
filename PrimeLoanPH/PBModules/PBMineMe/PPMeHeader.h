//
//  PPMeHeader.h
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPMeHeader : UIView

- (instancetype)initWithTapBack:(void(^)(NSInteger index))block;

- (void)pp_configData:(id)data;

@end

NS_ASSUME_NONNULL_END
