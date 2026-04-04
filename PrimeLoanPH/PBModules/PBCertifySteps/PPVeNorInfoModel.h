//
//Created by ESJsonFormatForMac on 23/11/05.
//

#import <Foundation/Foundation.h>

@class PPVeNorInfoTheoreticalModel,PPVeNorInfoMceachronModel,PPVeNorInfoIdentifiedModel;
@interface PPVeNorInfoModel : NSObject

@property (nonatomic, copy) NSString *defines;

@property (nonatomic, copy) NSString *concepts;

@property (nonatomic, strong) PPVeNorInfoTheoreticalModel *theoretical;

@end
@interface PPVeNorInfoTheoreticalModel : NSObject

@property (nonatomic, copy) NSString *gxT85KcqJ;

@property (nonatomic, copy) NSString *NwCpQEuj;

@property (nonatomic, copy) NSString *Cz00pW4L;

@property (nonatomic, copy) NSString *F5txkdqccq;

@property (nonatomic, assign) NSInteger BQ7YO7GVtC6;

@property (nonatomic, strong) NSArray *mceachron;

@end

@interface PPVeNorInfoMceachronModel : NSObject

@property (nonatomic, copy) NSString *stemming;

@property (nonatomic, assign) NSInteger underachieving;

@property (nonatomic, copy) NSString *defines;

@property (nonatomic, copy) NSString *age;

@property (nonatomic, assign) BOOL fits;

@property (nonatomic, assign) NSInteger choice;

@property (nonatomic, assign) NSInteger pivotal;

@property (nonatomic, copy) NSString *highly;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, copy) NSString *importance;

@property (nonatomic, strong) NSArray <PPVeNorInfoIdentifiedModel *>*identified;

@property (nonatomic, copy) NSString *blair;

@property (nonatomic, assign) NSInteger acknowledges;

@end

@interface PPVeNorInfoIdentifiedModel : NSObject

@property (nonatomic, copy) NSString *celebrating;

@property (nonatomic, assign) NSInteger reviewed;

@property (nonatomic, assign) bool select;

@end

