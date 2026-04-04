//
//Created by ESJsonFormatForMac on 23/10/30.
//

#import <Foundation/Foundation.h>

@class PPBaseTheoreticalModel;
@interface PPBaseModel : NSObject

@property (nonatomic, copy) NSString *defines;//code

@property (nonatomic, copy) NSString *concepts;//message

@property (nonatomic, strong) PPBaseTheoreticalModel *theoretical;//data

@end
@interface PPBaseTheoreticalModel : NSObject

@property (nonatomic, assign) NSInteger pivotal;//id

@property (nonatomic, copy) NSString *translated;//调整链接


@end

