//
//  PB_ExampleAlertViewController.h
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/8.
//

#import "PPBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PB_ExampleAlertViewController : PPBaseViewController

@property (nonatomic, copy) dispatch_block_t finsihCallBlock;


/// 创建示例图
/// - Parameter type: 1 PRC 2人脸
- (instancetype)initWithType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
