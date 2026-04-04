//
//Created by ESJsonFormatForMac on 23/10/31.
//

#import <Foundation/Foundation.h>

@class PPOrderTheoreticalModel,PPOrderDrawModel,PPOrderInterpretedModel;
@interface PPOrderModel : NSObject

@property (nonatomic, copy) NSString *defines;

@property (nonatomic, strong) PPOrderTheoreticalModel *theoretical;

@property (nonatomic, copy) NSString *concepts;

@end
@interface PPOrderTheoreticalModel : NSObject

@property (nonatomic, strong) NSArray *draw;

@property (nonatomic, assign) NSInteger integrate;

@end

@interface PPOrderDrawModel : NSObject

@property (nonatomic, assign) NSInteger bourne;

@property (nonatomic, assign) NSInteger will;

@property (nonatomic, copy) NSString *narratives;

@property (nonatomic, copy) NSString *ethos;

@property (nonatomic, copy) NSString *consequences;

@property (nonatomic, copy) NSString *lobbying;

@property (nonatomic, copy) NSString *allocated;

@property (nonatomic, copy) NSString *risk;

@property (nonatomic, strong) NSArray *interpreted;

@property (nonatomic, copy) NSString *networks;

@property (nonatomic, copy) NSString *unifying;

@property (nonatomic, copy) NSString *reveal;

@property (nonatomic, copy) NSString *unable;

@property (nonatomic, copy) NSString *monolingualising;

@property (nonatomic, copy) NSString *actors;

@property (nonatomic, assign) NSInteger cameron;

@property (nonatomic, copy) NSString *cohesion;

@property (nonatomic, copy) NSString *nation;

@property (nonatomic, copy) NSString *confident;

@property (nonatomic, copy) NSString *deficit;

@property (nonatomic, copy) NSString *constructed;

@property (nonatomic, copy) NSString *heller;

@property (nonatomic, copy) NSString *courses;

@property (nonatomic, copy) NSString *cases;

@end

@interface PPOrderInterpretedModel : NSObject

@property (nonatomic, copy) NSString *age;

@property (nonatomic, copy) NSString *challenges;

@end

