//
//Created by ESJsonFormatForMac on 23/10/31.
//

#import <Foundation/Foundation.h>

@class PPMeTheoreticalModel,PPMeInspiringModel,PPMeDrawModel;
@interface PPMeModel : NSObject

@property (nonatomic, copy) NSString *defines;

@property (nonatomic, copy) NSString *concepts;

@property (nonatomic, strong) PPMeTheoreticalModel *theoretical;

@end
@interface PPMeTheoreticalModel : NSObject

@property (nonatomic, copy) NSString *FplW77;

@property (nonatomic, copy) NSString *wPBUFk;

@property (nonatomic, copy) NSString *V87unaNn;

@property (nonatomic, assign) NSInteger certStatus;

@property (nonatomic, strong) PPMeInspiringModel *inspiring;

@property (nonatomic, copy) NSString *S20sDmNnZLTD;

@property (nonatomic, copy) NSString *NwwL9DhDyMtf;

@property (nonatomic, strong) NSArray *draw;

@end

@interface PPMeInspiringModel : NSObject

@property (nonatomic, copy) NSString *userphone;

@property (nonatomic, copy) NSString *literature;

@property (nonatomic, assign) NSInteger isReal;

@end

@interface PPMeDrawModel : NSObject

@property (nonatomic, copy) NSString *age;

@property (nonatomic, copy) NSString *translated;

@property (nonatomic, copy) NSString *shapes;

@end

