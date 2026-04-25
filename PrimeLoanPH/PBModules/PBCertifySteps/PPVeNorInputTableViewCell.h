//
//  PPVeNorInputTableViewCell.h
//  PrimeLoanPH
//
//  Created by MacPing on 2023/11/4.
//

#import "PPTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class PPVeContactTheoreticalModel;

static NSString *const PPVeNorInputTableViewCellKey =  @"PPVeNorInputTableViewCellKey";

@protocol PPVeNorInputTableViewCellDelegate <NSObject>

@optional
//输入完成回调value 值；key字段唯一
- (void)pPVeNorInputTableViewCellEndInput:(NSString *)value key:(NSString *)key;

@end

@interface PPVeNorInputTableViewCell : PPTableViewCell

@property (nonatomic, weak) id<PPVeNorInputTableViewCellDelegate> delegate;

/// `section`：紧急联系人每组标题「Emergency Contact-n」；其它页面传 0。
/// `pageCopy`：theoretical 页级 `here/communities/use/defining`；与每条 integrationist 上同名字段优先合并（单条非空优先）
- (void)pb_configWithCellData:(id)data index:(NSInteger)index section:(NSInteger)section pageCopy:(PPVeContactTheoreticalModel * _Nullable)pageCopy;
- (void)pb_configWithCellData:(id)data index:(NSInteger)index section:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
