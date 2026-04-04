//
//  PPHomeTableViewCell.h
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/30.
//

#import "PPTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const PPHomeTableViewCellKey =  @"PPHomeTableViewCellKey";

@protocol PPHomeTableViewBigCellDelegate <NSObject>

- (void)PPHomeTableViewCellTapTag:(NSInteger)indexTag;

@end
@interface PPHomeTableViewCell : PPTableViewCell

@property (nonatomic, weak) id<PPHomeTableViewBigCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
