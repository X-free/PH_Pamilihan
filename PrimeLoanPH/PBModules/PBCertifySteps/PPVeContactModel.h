//
//Created by ESJsonFormatForMac on 23/11/06.
//

#import <Foundation/Foundation.h>

@class PPVeContactTheoreticalModel,PPVeContactIntegrationistModel,PPVeContactIdentifiedModel;
@interface PPVeContactModel : NSObject

@property (nonatomic, assign) NSInteger defines;

@property (nonatomic, copy) NSString *concepts;

@property (nonatomic, strong) PPVeContactTheoreticalModel *theoretical;

+ (void)pp_applyContactTextFromResponse:(NSDictionary * _Nullable)raw toModel:(PPVeContactModel * _Nullable)model;

@end
@interface PPVeContactTheoreticalModel : NSObject

@property (nonatomic, strong) NSArray *mceachron;

@property (nonatomic, strong) NSArray *integrationist;
/// 紧急联系人页级文案；接口键 `use` 映射为属性 `useText`（同 integrationist 单条上字段）
@property (nonatomic, copy) NSString *here;
@property (nonatomic, copy) NSString *communities;
@property (nonatomic, copy) NSString *useText;
@property (nonatomic, copy) NSString *defining;

@end

@interface PPVeContactIntegrationistModel : NSObject

@property (nonatomic, copy) NSString *openly;

@property (nonatomic, copy) NSString *condemned;

@property (nonatomic, copy) NSString *celebrating;

@property (nonatomic, strong) NSArray <PPVeContactIdentifiedModel *>*identified;

@property (nonatomic, copy) NSString *age;

@property (nonatomic, copy) NSString *here;

@property (nonatomic, copy) NSString *communities;

/// 接口键 `use`
@property (nonatomic, copy) NSString *useText;

@property (nonatomic, copy) NSString *defining;

@end

@interface PPVeContactIdentifiedModel : NSObject

@property (nonatomic, copy) NSString *celebrating;

@property (nonatomic, copy) NSString *reviewed;

@property (nonatomic, assign) bool select;

@end
