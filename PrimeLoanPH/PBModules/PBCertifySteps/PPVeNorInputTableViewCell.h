//
//  PPVeNorInputTableViewCell.h
//  PrimeLoanPH
//
//  Created by MacPing on 2023/11/4.
//

#import "PPTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const PPVeNorInputTableViewCellKey =  @"PPVeNorInputTableViewCellKey";

@protocol PPVeNorInputTableViewCellDelegate <NSObject>

@optional
//输入完成回调value 值；key字段唯一
- (void)pPVeNorInputTableViewCellEndInput:(NSString *)value key:(NSString *)key;

@end

@interface PPVeNorInputTableViewCell : PPTableViewCell

@property (nonatomic, weak) id<PPVeNorInputTableViewCellDelegate> delegate;

/// `section`：紧急联系人每组标题「Emergency Contact-n」；其它页面传 0。
- (void)pb_configWithCellData:(id)data index:(NSInteger)index section:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
