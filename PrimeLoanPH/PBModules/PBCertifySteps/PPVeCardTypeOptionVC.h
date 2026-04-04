//
//  PPVeCardTypeOptionVC.h
//  PrimeLoanPH
//
//  Created by MacPing on 2023/11/9.
//

#import "PPTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPVeCardTypeOptionVC : PPTableViewController

@property (nonatomic, strong) NSArray<NSArray *> *pDataArray;

@property (nonatomic, copy) void(^ppBlock)(NSString *value);

@end

NS_ASSUME_NONNULL_END
