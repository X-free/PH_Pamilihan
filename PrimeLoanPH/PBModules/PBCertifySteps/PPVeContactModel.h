//
//Created by ESJsonFormatForMac on 23/11/06.
//

#import <Foundation/Foundation.h>

@class PPVeContactTheoreticalModel,PPVeContactIntegrationistModel,PPVeContactIdentifiedModel;
@interface PPVeContactModel : NSObject

@property (nonatomic, assign) NSInteger defines;

@property (nonatomic, copy) NSString *concepts;

@property (nonatomic, strong) PPVeContactTheoreticalModel *theoretical;

@end
@interface PPVeContactTheoreticalModel : NSObject

@property (nonatomic, strong) NSArray *mceachron;

@property (nonatomic, strong) NSArray *integrationist;

@end

@interface PPVeContactIntegrationistModel : NSObject

@property (nonatomic, copy) NSString *openly;

@property (nonatomic, copy) NSString *condemned;

@property (nonatomic, copy) NSString *celebrating;

@property (nonatomic, strong) NSArray <PPVeContactIdentifiedModel *>*identified;

@end

@interface PPVeContactIdentifiedModel : NSObject

@property (nonatomic, copy) NSString *celebrating;

@property (nonatomic, copy) NSString *reviewed;

@property (nonatomic, assign) bool select;

@end

