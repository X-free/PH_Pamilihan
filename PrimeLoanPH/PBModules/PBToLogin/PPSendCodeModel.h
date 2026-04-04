//
//Created by ESJsonFormatForMac on 23/10/30.
//

#import <Foundation/Foundation.h>

@class PPSendCodeTheoreticalModel,PPSendCodeConclusionModel;
@interface PPSendCodeModel : NSObject

@property (nonatomic, copy) NSString *defines;

@property (nonatomic, copy) NSString *concepts;

@property (nonatomic, strong) PPSendCodeTheoreticalModel *theoretical;

@end
@interface PPSendCodeTheoreticalModel : NSObject

@property (nonatomic, strong) PPSendCodeConclusionModel *conclusion;



@property (nonatomic, copy) NSString *sixdgr;


@end

@interface PPSendCodeConclusionModel : NSObject

@property (nonatomic, copy) NSString *RCaptchaKey;

@property (nonatomic, copy) NSString *conclusion;

@property (nonatomic, copy) NSString *defines;

@property (nonatomic, copy) NSString *concepts;

@property (nonatomic, assign) NSInteger own;

@end

