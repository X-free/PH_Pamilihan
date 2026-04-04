//
//  PB_PRCInfoAlertViewController.h
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/8.
//

#import "PPBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PB_PRCInfoAlertViewController : PPBaseViewController

- (void)configData:(id)data type:(NSString *)cardType complete:(void(^)(NSDictionary *params))block;


@end

NS_ASSUME_NONNULL_END
