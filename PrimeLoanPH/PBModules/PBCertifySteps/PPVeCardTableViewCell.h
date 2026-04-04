//
//  PPVeCardTableViewCell.h
//  PrimeLoanPH
//
//  Created by MacPing on 2023/11/2.
//

#import "PPTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const PPVeCardTableViewCellKey =  @"PPVeCardTableViewCellKey";

@interface PPVeCardTableViewCell : PPTableViewCell

//indexPath == 1 身份证 , indexPath == 2 活体
-  (void)pb_configWithCellData:(id)data indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
