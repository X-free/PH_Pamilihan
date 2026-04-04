//
//  PB_CallCell.h
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PB_CallCell : NSObject


///拨打号码
+ (void)pb_to_callPhone:(NSString *)number;

@end

NS_ASSUME_NONNULL_END
