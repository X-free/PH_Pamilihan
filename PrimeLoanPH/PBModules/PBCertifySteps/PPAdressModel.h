//
//Created by ESJsonFormatForMac on 23/11/06.
//

#import <Foundation/Foundation.h>

@class PPAdressTheoreticalModel,PPAdressDraw1Model,PPAdressDraw2Model,PPAdressDraw3Model;
@interface PPAdressModel : NSObject

@property (nonatomic, copy) NSString *defines;

@property (nonatomic, copy) NSString *concepts;

@property (nonatomic, strong) PPAdressTheoreticalModel *theoretical;

@end
@interface PPAdressTheoreticalModel : NSObject

@property (nonatomic, copy) NSString *DOes6Z;

@property (nonatomic, copy) NSString *Ygb5wP;

@property (nonatomic, assign) NSInteger oyYLuMQE;

@property (nonatomic, copy) NSString *ynAYivVfm;

@property (nonatomic, copy) NSString *HrE4;

@property (nonatomic, copy) NSString *E18w2;

@property (nonatomic, strong) NSArray <PPAdressDraw1Model *>*draw;

@property (nonatomic, copy) NSString *rJuc9cgkjnu;

@property (nonatomic, copy) NSString *XHy6;

@end

@interface PPAdressDraw1Model : NSObject

@property (nonatomic, copy) NSString *pivotal;
@property (nonatomic, copy) NSString *celebrating;

@property (nonatomic, strong) NSArray <PPAdressDraw2Model *>*draw;

@end

@interface PPAdressDraw2Model : NSObject

@property (nonatomic, copy) NSString *pivotal;
@property (nonatomic, copy) NSString *celebrating;

@property (nonatomic, strong) NSArray <PPAdressDraw3Model *>*draw;

@end

@interface PPAdressDraw3Model : NSObject

@property (nonatomic, copy) NSString *pivotal;

@property (nonatomic, copy) NSString *celebrating;

@end

