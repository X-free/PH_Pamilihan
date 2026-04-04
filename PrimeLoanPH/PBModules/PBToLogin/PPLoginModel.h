//
//Created by ESJsonFormatForMac on 23/10/30.
//

#import <Foundation/Foundation.h>

@class PPLoginTheoreticalModel;
@interface PPLoginModel : NSObject

@property (nonatomic, copy) NSString *defines;

@property (nonatomic, copy) NSString *concepts;

@property (nonatomic, strong) PPLoginTheoreticalModel *theoretical;

/** 归档 */
+ (void)archiverWithModel:(PPLoginModel *)model;

/** 解档*/
+ (PPLoginModel *)unArchiver;

/** 删除 */
+(BOOL)removeRootObject;

@end
@interface PPLoginTheoreticalModel : NSObject

@property (nonatomic, copy) NSString *hyTaoa2l;

@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, copy) NSString *therefore;

@property (nonatomic, copy) NSString *e7xk;

@property (nonatomic, copy) NSString *literature;//phone

@property (nonatomic, copy) NSString *lWHpwWFuTSY;

@property (nonatomic, assign) NSInteger reviews;

@property (nonatomic, copy) NSString *IhBJOQNft;

@property (nonatomic, copy) NSString *rfyip7;

@property (nonatomic, copy) NSString *OwZdwKaXD;

@property (nonatomic, copy) NSString *oP0uFS;

@property (nonatomic, copy) NSString *differentiation;

@end

