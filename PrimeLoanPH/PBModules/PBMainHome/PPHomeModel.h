//
//Created by ESJsonFormatForMac on 23/10/30.
//

#import <Foundation/Foundation.h>

@class PPHomeTheoreticalModel,PPHomeShapesModel,PPHomeEthnicModel,PPHomeDrawModel,PPHomeConclusionModel;
@interface PPHomeModel : NSObject

@property (nonatomic, copy) NSString *defines;

@property (nonatomic, copy) NSString *concepts;

@property (nonatomic, strong) PPHomeTheoreticalModel *theoretical;

@end
@interface PPHomeTheoreticalModel : NSObject

@property (nonatomic, strong) PPHomeShapesModel *shapes;

@property (nonatomic, strong) NSArray *finding;

@property (nonatomic, strong) NSArray *draw;

@property (nonatomic, strong) PPHomeEthnicModel *ethnic;

@end

@interface PPHomeEthnicModel : NSObject

@property (nonatomic, copy) NSString *age;

@property (nonatomic, copy) NSString *funds;

@end


@interface PPHomeShapesModel : NSObject

@property (nonatomic, copy) NSString *chapters;

@property (nonatomic, copy) NSString *experiences;

@end

@interface PPHomeDrawModel : NSObject

@property (nonatomic, strong) NSArray *conclusion;

@property (nonatomic, copy) NSString *reviewed;

@end

@interface PPHomeConclusionModel : NSObject

@property (nonatomic, copy) NSString *examine;

@property (nonatomic, copy) NSString *translated;


@property (nonatomic, copy) NSString *lobbying;

@property (nonatomic, copy) NSString *opposition;
@property (nonatomic, copy) NSString *announced;

@property (nonatomic, copy) NSString *networks;

@property (nonatomic, assign) NSInteger pivotal;

@property (nonatomic, copy) NSString *simply;

@property (nonatomic, copy) NSString *naldic;

@property (nonatomic, copy) NSString *powerful;

@property (nonatomic, copy) NSString *courses;

@property (nonatomic, copy) NSString *questioning;

@property (nonatomic, copy) NSString *discourage;

@property (nonatomic, copy) NSString *voice;

@property (nonatomic, copy) NSString *consequently;

@end

