//
//  PB_AskRootUrlHelper.h
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PB_AskRootUrlHelper : NSObject

@property (copy, nonatomic) NSString *pb_root_url;


+ (PB_AskRootUrlHelper *)instanceOnly;

-(void)pb_t_checkRootUrl:(dispatch_block_t)complete withVC:(UIViewController *)vc;


@end

NS_ASSUME_NONNULL_END
