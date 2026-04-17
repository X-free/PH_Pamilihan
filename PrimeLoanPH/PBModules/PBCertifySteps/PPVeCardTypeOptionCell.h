//
//  PPVeCardTypeOptionCell.h
//  PrimeLoanPH
//
//  Created by MacPing on 2023/11/9.
//

#import "PPTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const PPVeCardTypeOptionCellKey =  @"PPVeCardTypeOptionCellKey";
@interface PPVeCardTypeOptionCell : PPTableViewCell

- (void)pb_configWithCellData:(id)data selected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
