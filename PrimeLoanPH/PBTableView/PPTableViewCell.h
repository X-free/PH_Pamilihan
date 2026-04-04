//
//  PPTableViewCell.h
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const PBCustomTableViewCellOnlyKey = @"PBCustomTableViewCellOnlyKey";

@interface PPTableViewCell : UITableViewCell

- (void)pb_initUI;

- (void)pb_configWithCellData:(id)data;

@end

NS_ASSUME_NONNULL_END
