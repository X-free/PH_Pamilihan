//
//Created by ESJsonFormatForMac on 23/10/31.
//

#import <Foundation/Foundation.h>

@class PPDetailTheoreticalModel,PPDetailInspiringModel,PPDetailAddressedModel,PPDetailRichModel,PPDetailCanModel,PPDetailSubtractiveModel,PPDetailSettlingModel,PPDetailEthnicModel,PPDetailGrantModel,PPDetailValuingModel;
@interface PPDetailModel : NSObject

@property (nonatomic, copy) NSString *defines;

@property (nonatomic, copy) NSString *concepts;

@property (nonatomic, strong) PPDetailTheoreticalModel *theoretical;

@end
@interface PPDetailTheoreticalModel : NSObject

@property (nonatomic, strong) PPDetailEthnicModel *ethnic;

@property (nonatomic, assign) NSInteger centralised;

@property (nonatomic, strong) PPDetailGrantModel *grant;

@property (nonatomic, strong) PPDetailInspiringModel *inspiring;

@property (nonatomic, strong) PPDetailAddressedModel *addressed;


@property (nonatomic, strong) NSArray *valuing;

@end

@interface PPDetailInspiringModel : NSObject

@property (nonatomic, copy) NSString *offers;

@property (nonatomic, copy) NSString *celebrating;

@property (nonatomic, copy) NSString *questions;

@end

@interface PPDetailAddressedModel : NSObject

@property (nonatomic, copy) NSString *lobbying;

@property (nonatomic, copy) NSString *issue;

@property (nonatomic, copy) NSString *narratives;

@property (nonatomic, strong) NSArray *high;

@property (nonatomic, copy) NSString *aiming;

@property (nonatomic, copy) NSString *networks;

@property (nonatomic, copy) NSString *enough;

@property (nonatomic, strong) NSArray *currently;

@property (nonatomic, copy) NSString *pivotal;

@property (nonatomic, strong) PPDetailRichModel *rich;

@property (nonatomic, copy) NSString *drury;

@property (nonatomic, copy) NSString *trend;

@property (nonatomic, copy) NSString *reflected;

@property (nonatomic, copy) NSString *courses;

@property (nonatomic, assign) NSInteger confident;

@property (nonatomic, strong) PPDetailSettlingModel *settling;

@property (nonatomic, copy) NSString *translated;

@property (nonatomic, copy) NSString *examples;

@property (nonatomic, copy) NSString *reveal;

@end

@interface PPDetailRichModel : NSObject

@property (nonatomic, strong) PPDetailCanModel *can;

@property (nonatomic, strong) PPDetailSubtractiveModel *subtractive;

@end

@interface PPDetailCanModel : NSObject

@property (nonatomic, copy) NSString *age;

@property (nonatomic, copy) NSString *view;

@end

@interface PPDetailSubtractiveModel : NSObject

@property (nonatomic, copy) NSString *age;

@property (nonatomic, copy) NSString *view;

@end

@interface PPDetailSettlingModel : NSObject

@property (nonatomic, copy) NSString *stemming;

@end

@interface PPDetailEthnicModel : NSObject

@property (nonatomic, copy) NSString *age;

@property (nonatomic, copy) NSString *funds;

@end

@interface PPDetailGrantModel : NSObject

@property (nonatomic, copy) NSString *age;

@property (nonatomic, assign) NSInteger reviewed;

@property (nonatomic, copy) NSString *availability;

@property (nonatomic, copy) NSString *translated;

@end

@interface PPDetailValuingModel : NSObject

@property (nonatomic, assign) NSInteger narrow;

@property (nonatomic, copy) NSString *emag;

@property (nonatomic, copy) NSString *age;

@property (nonatomic, assign) NSInteger choice;

@property (nonatomic, assign) NSInteger variable;

@property (nonatomic, copy) NSString *highly;

@property (nonatomic, copy) NSString *goals;

@property (nonatomic, copy) NSString *importance;

@property (nonatomic, copy) NSString *availability;

@property (nonatomic, assign) NSInteger reviewed;

@property (nonatomic, assign) NSInteger acknowledges;

@property (nonatomic, copy) NSString *translated;

@end

