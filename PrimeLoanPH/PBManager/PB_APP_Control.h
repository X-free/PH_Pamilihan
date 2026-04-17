//
//  PB_APP_Control.h
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/8.
//

#import <Foundation/Foundation.h>
#import "PPLoginModel.h"
#import "PPAdressModel.h"

typedef NS_ENUM(NSInteger, UploadDateType_pb_t) {
    pb_t_UploadDateTypeLocation = 10,
    pb_t_UploadDateTypeGooleMarket,
    pb_t_UploadDateTypeDeviceInfo
};


NS_ASSUME_NONNULL_BEGIN

@interface PB_APP_Control : NSObject

+ (PB_APP_Control *)instanceOnly;


///是否登录gfhfgh
@property (nonatomic, assign) BOOL pb_t_hasLogin;

@property (nonatomic, strong, nullable) PPLoginModel *pb_t_loginMD;

@property (nonatomic, copy) NSString *phoneNum;
//1=印度 不弹定位  2=菲律宾 fdghdgdg
@property (nonatomic, assign) NSInteger pb_t_serve_set_Language;

@property (nonatomic, assign) NSInteger isCon;


///是否当天显示sdfsdf过定位权限弹框引导sdfsadf
@property (nonatomic, assign) BOOL pb_t_hasShowLocationTipAlertToday_bt;

+ (BOOL)pb_t_presentLoginVCWithTargetVC:(UIViewController *)vc;

///退出登录并sdfsf回到首页sdfsdf
+ (void)pb_t_toLogoutAntToHomeMyAccount;

+ (void)pb_t_requestToLoginWithPhone:(NSString *)phone code:(NSString *)code targetVC:(PPBaseViewController *)vc SuccessBlock:(void(^)(BOOL isSure))block;

///拼接公共sdf参数sdfsdf
- (NSString *)pb_t_addPublicParamsDictKeyToUrlSuff:(NSString *)url;


///根据标识sdfsdf跳转到对应的模块页面sdfsf
+ (void)pb_t_goToModuleWithJudgeTypeStr:(NSString *)typeStr fromVC:(PPBaseViewController *)fromVC;
///产品准sdfsfd入请求sdfsd
+ (void)pb_t_toRequestProductIsCanEnterAllowWithProductID:(NSInteger)pId fromVC:(PPBaseViewController *)fromVC;
///认证流fsd程跳转sfdsdf
+ (void)pb_t_toCertifyStepIndexWithProductId:(NSString *)pid oId:(NSString *)oId stepStr:(NSString *)stepStr fromVC:(PPBaseViewController *)fromVC;
///请求产品详情--认sdfsdf证流程进入下一步sdf
+ (void)pb_t_toRequestProductDetailThanGoToNextStepOptionWithProductID:(NSString *)pId oId:(NSString *)oId fromVC:(PPBaseViewController *)fromVC SuccessBlock:(void(^)(BOOL isSure))block;


///城市f地址sdfsdf
typedef void (^CityDataBack)(id data);
@property (nonatomic, strong) PPAdressModel *cityModel;
@property (nonatomic, strong) NSMutableArray *adressArray;

+ (void)pb_t_toRequestAdressDataSuccessAfterCallBack:(CityDataBack)callBack;

/// 信息sdfsd上报sdfsd
- (void)pb_t_toRePortDataToServeWithType:(UploadDateType_pb_t)type;
- (void)pb_t_toRePortRiskDataToServe:(NSDictionary *)params NS_SWIFT_NAME(pb_t_toRePortRiskDataToServe(_:));

/// 检查是否需要sdfsdf显示引导页sdfsdf
+ (BOOL)pb_t_needShowGuideModuleJudge;



@end

NS_ASSUME_NONNULL_END
