//
//  PPVeCardTypeOptionHeader.h
//  PrimeLoanPH
//
//  Created by MacPing on 2023/11/9.
//

#import "PPTableViewHeaderFooterView.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const PPVeCardTypeOptionHeaderKey =  @"PPVeCardTypeOptionHeaderKey";

@protocol PPVeCardTypeOptionHeaderDelegate <NSObject>

@optional

- (void)pb_t_VeCardTypeOptionHeaderTap_de;

@end

@interface PPVeCardTypeOptionHeader : PPTableViewHeaderFooterView

@property (nonatomic, weak) id<PPVeCardTypeOptionHeaderDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
