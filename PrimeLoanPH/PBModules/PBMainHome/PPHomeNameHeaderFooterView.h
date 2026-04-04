//
//  PPHomeNameHeaderFooterView.h
//  PrimeLoanPH
//
//  Created by MacPing on 2024/1/25.
//

#import "PPTableViewHeaderFooterView.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const PPHomeNameHeaderFooterViewKey =  @"PPHomeNameHeaderFooterViewKey";

@interface PPHomeNameHeaderFooterView : PPTableViewHeaderFooterView

//1 大 2 小
- (void)pb_t_mvpTagName:(NSInteger)tag;

@end

NS_ASSUME_NONNULL_END
