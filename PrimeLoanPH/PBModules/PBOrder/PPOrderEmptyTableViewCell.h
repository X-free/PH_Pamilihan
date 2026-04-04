//
//  PPOrderEmptyTableViewCell.h
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/31.
//

#import "PPTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const PB_T_OrderEmptyTableViewCellKey_de =  @"PB_T_OrderEmptyTableViewCellKey_de";

@protocol PPOrderEmptyTableViewCell <NSObject>

@optional
- (void)PB_T_OrderEmptyTableViewCellTapAction_de;

@end

@interface PPOrderEmptyTableViewCell : PPTableViewCell

@property (nonatomic, weak) id<PPOrderEmptyTableViewCell>delegate;


@end

NS_ASSUME_NONNULL_END
