//
//  PB_APP_Control.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/8.
//


#import "PB_APP_Control.h"
#import <Adjust.h>
#import "PPNavigationController.h"
#import "PrimeCash-Swift.h"
#import "PPWebViewController.h"
#import "PPDetailModel.h"
#import "PPEnterModel.h"
#import "PPVeCardsViewController.h"
#import "PPVeContactViewController.h"
#import "PPOrderViewController.h"
#import "PB_NativeTipsHelper.h"

static UIView *PBLoginNativeLoadingOverlay = nil;

/// 登录 Loading 铺满整屏：优先取 `hostView.window`，否则取前台 `UIWindowScene` 的 keyWindow / 首窗口
static UIWindow *PB_ApplicationKeyWindowFromHostView(UIView *hostView) {
    if (hostView != nil && hostView.window != nil) {
        return hostView.window;
    }
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if (scene.activationState != UISceneActivationStateForegroundActive &&
                scene.activationState != UISceneActivationStateForegroundInactive) {
                continue;
            }
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *ws = (UIWindowScene *)scene;
                for (UIWindow *w in ws.windows) {
                    if (w.isKeyWindow) { return w; }
                }
                if (ws.windows.count > 0) {
                    return ws.windows.firstObject;
                }
            }
        }
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSArray<UIWindow *> *legacy = UIApplication.sharedApplication.windows;
#pragma clang diagnostic pop
    if (legacy.count > 0) {
        return legacy.firstObject;
    }
    return nil;
}

@implementation PB_APP_Control

+ (PB_APP_Control *)instanceOnly {
    static dispatch_once_t once;
    static PB_APP_Control *pb_t_instance;
    dispatch_once(&once, ^{
        pb_t_instance = [self new];
    
    });
    return pb_t_instance;
}


- (BOOL)pb_t_hasShowLocationTipAlertToday_bt {
    NSString *key = @"PesoBoosShowJinTian_noti_tankuang";
    NSUserDefaults *pb_t_de_userdefault = [NSUserDefaults standardUserDefaults];
    NSString *pb_t_de_oldReslut = [pb_t_de_userdefault objectForKey:key];
    NSString *pb_t_de_newResult = [PB_timeHelper pb_t_getCurrentTimeFormatyyyyMMdd];
    if(self.pb_t_hasLogin){
        pb_t_de_newResult = [NSString stringWithFormat:@"%@&%@",pb_t_de_newResult,self.phoneNum];
    }
    if([pb_t_de_oldReslut isEqualToString:pb_t_de_newResult]){
        return YES;
    }else{
        [pb_t_de_userdefault setObject:pb_t_de_newResult forKey:key];
        [pb_t_de_userdefault synchronize];
        return NO;
    }
}

- (BOOL)pb_t_hasLogin {
    return self.pb_t_loginMD.theoretical.therefore != nil;
}



-(void)setPb_t_loginMD:(PPLoginModel *)pb_t_loginMD {
    [PPLoginModel archiverWithModel:pb_t_loginMD];
}

- (PPLoginModel *)pb_t_loginMD {
    PPLoginModel *pb_t_de_model = [PPLoginModel unArchiver];
    return pb_t_de_model;
}

+ (void)pb_t_toLogoutAntToHomeMyAccount {
    [PB_APP_Control instanceOnly].pb_t_loginMD = nil;
    //回到首页
    [PB_NotificationOfCenter postNotificationName:PB_NotiLogoutThanToHome object:nil];
    [self pb_t_presentLoginVCWithTargetVC:[PB_GetVC pb_to_getCurrentViewController]];
    

}

- (NSString *)phoneNum {
    BOOL pb_t_is_Login = [PB_APP_Control instanceOnly].pb_t_hasLogin;
    if (pb_t_is_Login) {
        return PBStrFormat([PB_APP_Control instanceOnly].pb_t_loginMD.theoretical.literature);
    }else{
        return @"";
    }
}

+ (BOOL)pb_t_presentLoginVCWithTargetVC:(UIViewController *)vc {
    BOOL pb_t_is_Login = [PB_APP_Control instanceOnly].pb_t_hasLogin;
    if (!pb_t_is_Login) {
        if ([[PB_GetVC pb_to_getCurrentViewController] isMemberOfClass:[PPLoginViewController class]] == NO) {
            PPLoginViewController *pb_t_loginVC = [[PPLoginViewController alloc] init];
            PPNavigationController *pb_t_navVC = [[PPNavigationController alloc] initWithRootViewController:pb_t_loginVC];
            pb_t_navVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [vc presentViewController:pb_t_navVC animated:YES completion:nil];
        }else{
            NSLog(@"登录页面已经存在了");
        }
    }else{
        NSLog(@"已经登录了");
    }
    return pb_t_is_Login;
}

/** 登录 */
+ (void)pb_t_requestToLoginWithPhone:(NSString *)phone code:(NSString *)code targetVC:(PPBaseViewController *)vc SuccessBlock:(nonnull void (^)(BOOL))block{

    NSDictionary *pa = @{
        @"literature":PBStrFormat(phone),
        @"relevant":PBStrFormat(code)
    };
    [PB_APP_Control pb_t_showNativeLoginLoadingOnHostView:vc.view];
    [[PB_RequestHelper pb_instance] pb_postRequestWithUrlStr:PBURL_loginUrl params:pa commplete:^(NSDictionary * _Nullable result, NSInteger statusCode) {
        [PB_APP_Control pb_t_hideNativeLoginLoadingOverlay];
        if(result != nil){
            PPLoginModel *model = [PPLoginModel yy_modelWithJSON:result];

            [PB_APP_Control instanceOnly].pb_t_loginMD = model;
            [PB_NotificationOfCenter postNotificationName:PB_NotiLoginThanSuccess object:nil];
            [self dismissLoginViewControllerWithVC:vc];
            if(block){
                block(YES);
            }
        }
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
        [PB_APP_Control pb_t_hideNativeLoginLoadingOverlay];
        [PB_APP_Control pb_t_presentLoginAlertFromViewController:vc message:errorStr];
    }];
}

/** 关闭登录页面 */
+ (void)dismissLoginViewControllerWithVC:(PPBaseViewController *)vc {
    
    for (PPBaseViewController *pb_t_de_loginVC in vc.navigationController.viewControllers){
        if ([pb_t_de_loginVC isKindOfClass:[PPBaseViewController class]]) {
            [pb_t_de_loginVC dismissViewControllerAnimated:YES completion:nil];
            break;
        }
    }
}

- (NSString *)pb_t_addPublicParamsDictKeyToUrlSuff:(NSString *)url{
    //App版本，例如：1.0.0
    NSString *often = [PB_getAppInfoHelper pb_to_getMyAppVersionString];
    //设备名称，例如：iphoneX
    NSString *contact = [PB_getAppInfoHelper pb_t0_getPhoneDeviceTypeNameString];
    //设备ID idfv
    NSString *interpret = [[PB_idf_helper instanceOnly] pb_t_getIdfvOnlyString];
    //设备os版本
    NSString *discusses = [[UIDevice currentDevice] systemVersion];
    //SessionId
    NSString *therefore = @"";
    //gps_adid idfa
    NSString *explicit = [[PB_idf_helper instanceOnly] pb_t_getIDFAOnlyString];
    //session
    if(![NSString PB_CheckStringIsEmpty:self.pb_t_loginMD.theoretical.therefore]){
        therefore = self.pb_t_loginMD.theoretical.therefore;
    }
    NSInteger instance = 1;
    //language
    if(self.pb_t_serve_set_Language != 0){
        instance = self.pb_t_serve_set_Language;
    }
    NSDictionary *dict = @{
        @"often":PBStrFormat(often),
        @"contact":PBStrFormat(contact),
        @"interpret":PBStrFormat(interpret),
        @"discusses":PBStrFormat(discusses),
        @"therefore":PBStrFormat(therefore),
        @"explicit":PBStrFormat(explicit),
        @"instance":@(self.pb_t_serve_set_Language)
    };
    
    __block NSString * pb_t_de_result = [url containsString:@"?"] ? @"&" :  @"?";
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        pb_t_de_result = [NSString stringWithFormat:@"%@%@=%@&",pb_t_de_result,key,obj];
    }];
    if([[pb_t_de_result substringWithRange:NSMakeRange(pb_t_de_result.length - 1, 1)] isEqualToString:@"&"]){
        pb_t_de_result = [pb_t_de_result substringToIndex:pb_t_de_result.length-1];
    }
    pb_t_de_result = [pb_t_de_result stringByReplacingOccurrencesOfString:@" " withString:@""];
    pb_t_de_result = [pb_t_de_result stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *pb_t_de_finalStr = [NSString stringWithFormat:@"%@%@",url,pb_t_de_result];
    return pb_t_de_finalStr;
}


///根据标识跳转到对sdfsdfsad应的模块页面sdfsa
+ (void)pb_t_goToModuleWithJudgeTypeStr:(NSString *)typeStr fromVC:(PPBaseViewController *)fromVC {
    if([NSString PB_CheckStringIsEmpty:typeStr]){
        NSLog(@"dfsdfsdfjump params is emptysfdas");
        return;
    }
    NSString *pb_t_de_JudgeStr = typeStr;
    if([pb_t_de_JudgeStr hasPrefix:@"pml://loan.org/sfe?foundation"]){//产品详情
        NSString *productID = [PPTools pb_to_getUrlParamWithOnlyKey:@"foundation" URLString:pb_t_de_JudgeStr];
        PPGoodsDetailViewController *vc = [[PPGoodsDetailViewController alloc] initWithPBTableViewOfGroupStyle:YES];
        vc.goodsId = productID;
        [fromVC.navigationController pushViewController:vc animated:YES];
    }else if ([pb_t_de_JudgeStr hasPrefix:@"pml://loan.org/sfa"]){//设置
        PPSettingViewController *vc = [[PPSettingViewController alloc] init];
        [fromVC.navigationController pushViewController:vc animated:YES];
    }else if ([pb_t_de_JudgeStr hasPrefix:@"pml://loan.org/sfb"]){//首页
        fromVC.tabBarController.selectedIndex = 0;
        [fromVC.navigationController popToRootViewControllerAnimated:YES];
    }else if ([pb_t_de_JudgeStr hasPrefix:@"pml://loan.org/sfc"]){//登录
        [PB_APP_Control pb_t_toLogoutAntToHomeMyAccount];
    }else if ([pb_t_de_JudgeStr hasPrefix:@"pml://loan.org/sfd?identical"]){//订单
        NSString *index = [PPTools pb_to_getUrlParamWithOnlyKey:@"identical" URLString:pb_t_de_JudgeStr];
        int indexNo = 0;
        if(![NSString PB_CheckStringIsEmpty:index]){
            indexNo = [index intValue];
        }
        [self pb_t_selectOrderTabWithSegment:indexNo fromVC:fromVC];
    }else if ([pb_t_de_JudgeStr hasPrefix:@"https://"] ||[pb_t_de_JudgeStr hasPrefix:@"http://"]){//web
        PPWebViewController *vc = [[PPWebViewController alloc] init];
        vc.url = [[PB_APP_Control instanceOnly] pb_t_addPublicParamsDictKeyToUrlSuff:pb_t_de_JudgeStr];
        [fromVC.navigationController pushViewController:vc animated:YES];
    }
}

+ (void)pb_t_selectOrderTabWithSegment:(NSInteger)segment fromVC:(UIViewController *)fromVC {
    NSInteger seg = segment;
    if (seg < 0 || seg > 2) {
        seg = 0;
    }
    UITabBarController *tbc = fromVC.tabBarController;
    if (!tbc || tbc.viewControllers.count < 2) {
        UINavigationController *nav = fromVC.navigationController;
        if (nav) {
            PPOrderViewController *vc = [[PPOrderViewController alloc] init];
            vc.currentSelIndex = (int)seg;
            [nav pushViewController:vc animated:YES];
        }
        return;
    }
    UIViewController *second = tbc.viewControllers[1];
    if (![second isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = fromVC.navigationController;
        if (nav) {
            PPOrderViewController *vc = [[PPOrderViewController alloc] init];
            vc.currentSelIndex = (int)seg;
            [nav pushViewController:vc animated:YES];
        }
        return;
    }
    UINavigationController *orderNav = (UINavigationController *)second;
    UIViewController *root = orderNav.viewControllers.firstObject;
    if (![root isKindOfClass:[PPOrderViewController class]]) {
        UINavigationController *nav = fromVC.navigationController;
        if (nav) {
            PPOrderViewController *vc = [[PPOrderViewController alloc] init];
            vc.currentSelIndex = (int)seg;
            [nav pushViewController:vc animated:YES];
        }
        return;
    }
    PPOrderViewController *order = (PPOrderViewController *)root;
    [orderNav popToRootViewControllerAnimated:NO];
    order.currentSelIndex = (int)seg;
    tbc.selectedIndex = 1;
}

///产品sdfasd准入请求asdasd
+ (void)pb_t_toRequestProductIsCanEnterAllowWithProductID:(NSInteger)pId fromVC:(PPBaseViewController *)fromVC {
    
    //非英语语言要求：位置权限拒绝时，首页点击产品，弹框引导开启权限，进入权限设置，每天仅弹一次。已开启或者已经展示的直接调用准入
//    if(([PB_APP_Control instanceOnly].pb_t_serve_set_Language == 2) && [[PB_location_helper instanceOnly]  pb_t_askLocationAllowIsEnable] == NO &&  [PB_APP_Control instanceOnly].pb_t_hasShowLocationTipAlertToday_bt == NO)
    //123
    if(([PB_APP_Control instanceOnly].isCon == 1) && [[PB_location_helper instanceOnly]  pb_t_askLocationAllowIsEnable] == NO){
        
            QMUIAlertController *pb_t_de_alertController =[QMUIAlertController alertControllerWithTitle:@"Tip" message:PBPositionSettingTipContent preferredStyle:QMUIAlertControllerStyleAlert];
            [pb_t_de_alertController addAction:[QMUIAlertAction actionWithTitle:@"Cancel" style:QMUIAlertActionStyleCancel handler:nil]];
            [pb_t_de_alertController addAction:[QMUIAlertAction actionWithTitle:@"Settings" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
                NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [PB_OpenUrl pb_to_openUrl:url];
            }]];
            [pb_t_de_alertController showWithAnimated:YES];
        return;
    }
    
    NSDictionary *pa = @{
        @"foundation":@(pId),
        @"sets":@"",
        @"eyfs":@"",
        @"stage":@""
    };
    [PB_NativeTipsHelper pb_showLoadingInView:fromVC.view];
    [[PB_RequestHelper pb_instance] pb_postRequestWithUrlStr:PBURL_productCanApplyUrl params:pa commplete:^(NSDictionary * _Nullable result, NSInteger statusCode) {
        [PB_NativeTipsHelper pb_hideAllLoading];
        if(result != nil){
            PPEnterModel *model = [PPEnterModel yy_modelWithJSON:result];
            NSString *pb_t_de_linkStr = PBStrFormat(model.theoretical.translated);
            [self pb_t_goToModuleWithJudgeTypeStr:pb_t_de_linkStr fromVC:fromVC];
        }
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
        [PB_NativeTipsHelper pb_presentAlertWithMessage:errorStr];
    }];
}

///认证流程
+ (void)pb_t_toCertifyStepIndexWithProductId:(NSString *)pid oId:(nonnull NSString *)oId stepStr:(NSString *)stepStr fromVC:(PPBaseViewController *)fromVC {
    
    NSLog(@"step==%@",stepStr);
    NSString *pb_t_de_stepStr = stepStr;
    if([pb_t_de_stepStr isEqualToString:@"sta"]){//public认证
        PPVeCardsViewController *vc = [[PPVeCardsViewController alloc] initWithPBTableViewOfGroupStyle:NO];
        vc.pId = pid;
        vc.oId = oId;
        [fromVC.navigationController pushViewController:vc animated:YES];
    }else if ([pb_t_de_stepStr isEqualToString:@"stb"]){//personal个人信息
        PPVeInfoViewController *vc = [[PPVeInfoViewController alloc] initWithPBTableViewOfGroupStyle:NO];
        vc.pId = pid;
        vc.oId = oId;
        [fromVC.navigationController pushViewController:vc animated:YES];
    }else if ([pb_t_de_stepStr isEqualToString:@"stc"]){//job工作信息
        PPVeWorkInfoViewController *vc = [[PPVeWorkInfoViewController alloc] initWithPBTableViewOfGroupStyle:YES];
        vc.pId = pid;
        vc.oId = oId;
        [fromVC.navigationController pushViewController:vc animated:YES];
    }else if ([pb_t_de_stepStr isEqualToString:@"std"]){//ext紧急联系人
        PPVeContactViewController *vc = [[PPVeContactViewController alloc] initWithPBTableViewOfGroupStyle:NO];
        vc.pId = pid;
        vc.oId = oId;
        [fromVC.navigationController pushViewController:vc animated:YES];
    }
}

+ (void)pb_t_toRequestAdressDataSuccessAfterCallBack:(CityDataBack)callBack{

    if([PB_APP_Control instanceOnly].cityModel != nil){
        if(callBack){
            callBack([PB_APP_Control instanceOnly].cityModel);
        }
        NSLog(@"已经请求过地址信息");
        return;
    }
    [[PB_RequestHelper pb_instance] pb_getRequestWithUrlStr:PBURL_selAdressUrl params:@{} commplete:^(NSDictionary * _Nullable result, NSInteger statusCode) {
        [PB_NativeTipsHelper pb_hideAllLoading];
        if(result != nil){
            PPAdressModel *model = [PPAdressModel yy_modelWithJSON:result];
            [PB_APP_Control instanceOnly].cityModel = model;
            if(model.theoretical.draw.count > 0){
                NSMutableArray *provinceArray = NSMutableArray.new;
                for (NSInteger i = 0; i < model.theoretical.draw.count; i++) {//省
                    PPAdressDraw1Model *itemModel1 = model.theoretical.draw[i];

                    NSMutableArray *cityArray = NSMutableArray.new;
                    for (NSInteger j = 0; j < itemModel1.draw.count; j++) {//市
                        PPAdressDraw2Model *itemModel2 = itemModel1.draw[j];
                        NSMutableArray *areaArray = NSMutableArray.new;
                        for (NSInteger k = 0; k < itemModel2.draw.count; k++) {//区
                            PPAdressDraw3Model *itemModel3 = itemModel2.draw[k];
                            NSDictionary *dic = @{
                                @"code":PBStrFormat(itemModel3.pivotal),
                                @"name":PBStrFormat(itemModel3.celebrating)
                            };
                            [areaArray addObject:dic];
                        }
                        NSDictionary *dic = @{
                            @"code":PBStrFormat(itemModel2.pivotal),
                            @"name":PBStrFormat(itemModel2.celebrating),
                            @"areaList":areaArray
                        };
                        [cityArray addObject:dic];
                    }
                    NSDictionary *dic = @{
                        @"code":PBStrFormat(itemModel1.pivotal),
                        @"name":PBStrFormat(itemModel1.celebrating),
                        @"cityList":cityArray
                    };
                    [provinceArray addObject:dic];
                }
                [PB_APP_Control instanceOnly].adressArray = provinceArray;
                if(callBack){
                    callBack(provinceArray);
                }
            }
        }
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
        
    }];
}

///请求产品详情--认证流程进入下一步
+ (void)pb_t_toRequestProductDetailThanGoToNextStepOptionWithProductID:(NSString *)pId oId:(NSString *)oId fromVC:(PPBaseViewController *)fromVC SuccessBlock:(void (^)(BOOL))block{
    [PB_NativeTipsHelper pb_showLoadingInView:fromVC.view];
    NSDictionary *p = @{
        @"foundation":PBStrFormat(pId)
    };
    [[PB_RequestHelper pb_instance] pb_postRequestWithUrlStr:PBURL_productDetailInfoUrl params:p commplete:^(NSDictionary * _Nullable result, NSInteger statusCode) {
        [PB_NativeTipsHelper pb_hideAllLoading];
        if(result != nil){
            PPDetailModel *dataModel = [PPDetailModel yy_modelWithJSON:result];
        
            NSString *pb_t_de_nextStepStr = @"";
            if(dataModel.theoretical.grant != nil){
                pb_t_de_nextStepStr = PBStrFormat(dataModel.theoretical.grant.availability);
            }
            if([pb_t_de_nextStepStr isEqualToString:@"ste"]){//绑卡
                if([NSString PB_CheckStringIsEmpty:dataModel.theoretical.grant.translated] == NO){
                    NSString *url = PBStrFormat(dataModel.theoretical.grant.translated);
                    [self pb_t_goToModuleWithJudgeTypeStr:url fromVC:(PPBaseViewController *)[PB_GetVC pb_to_getCurrentViewController]];
                }
            }else{
                [PB_APP_Control pb_t_toCertifyStepIndexWithProductId:pId oId:(NSString *)oId stepStr:pb_t_de_nextStepStr fromVC:fromVC];
            }
           
            if(block){
                block(YES);
            }
        }
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
        [PB_NativeTipsHelper pb_presentAlertWithMessage:errorStr];
    }];
}


/// 信息上报
-(void)pb_t_toRePortDataToServeWithType:(UploadDateType_pb_t)type {
    if(type == pb_t_UploadDateTypeLocation){
        [[PB_location_helper instanceOnly]  pb_t_toBeginLocationMethod];
//        if(PB_APP_Control.instanceOnly.pb_t_serve_set_Language == 2){
//
//        }
//
        
    }else if (type == pb_t_UploadDateTypeGooleMarket){
        NSString *pb_t_de_idfa = [[PB_idf_helper instanceOnly] pb_t_getIDFAOnlyString];
        NSString *pb_t_de_idfv = [[PB_idf_helper instanceOnly] pb_t_getIdfvOnlyString];
        NSDictionary *params = @{
            @"conceptualised":PBStrFormat(pb_t_de_idfv),//idfv
            @"baker":PBStrFormat(pb_t_de_idfa),//idfa
        };
        [[PB_RequestHelper pb_instance] pb_postRequestWithUrlStr:PBURL_reportGoogleMarkInfoUrl params:params commplete:^(NSDictionary * _Nullable result, NSInteger statusCode) {
            if (result != nil) {
                NSDictionary *pb_t_de_resp = result;
                if ([pb_t_de_resp[@"defines"] intValue] == 0) {
                    NSString *pb_t_de_adjustId = pb_t_de_resp[@"theoretical"][@"second"];
                    if(pb_t_de_adjustId.length != 0){
                        
#if DEBUG
            ADJConfig *pb_t_de_adjustConfig = [ADJConfig configWithAppToken:pb_t_de_adjustId environment:ADJEnvironmentSandbox allowSuppressLogLevel:NO];
            [pb_t_de_adjustConfig setLogLevel:ADJLogLevelVerbose];
            [pb_t_de_adjustConfig setUrlStrategy:ADJUrlStrategyIndia];
            [Adjust appDidLaunch:pb_t_de_adjustConfig];
#else
            ADJConfig *pb_t_de_adjustConfig = [ADJConfig configWithAppToken:pb_t_de_adjustId environment:ADJEnvironmentProduction allowSuppressLogLevel:YES];
            [pb_t_de_adjustConfig setUrlStrategy:ADJUrlStrategyIndia];
            [Adjust appDidLaunch:pb_t_de_adjustConfig];
#endif
                    }
                }
            }
        } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
                    
        }];

    } else if (type == pb_t_UploadDateTypeDeviceInfo) {
        [PBOffNaldicDeviceReporter uploadCollectedDeviceInfo];
    }
}

- (void)pb_t_toRePortRiskDataToServe:(NSDictionary *)params{
    
//    if(PB_APP_Control.instanceOnly.pb_t_serve_set_Language == 2){
//
//    }
    [[PB_location_helper instanceOnly]  pb_t_toBeginLocationMethod];
    //经度
    NSString *pb_t_longitude = PBStrFormat([PB_location_helper instanceOnly].pb_t_longitude);
    //纬度
    NSString *pb_t_latitude = PBStrFormat([PB_location_helper instanceOnly].pb_t_latitude);
    if([NSString PB_CheckStringIsEmpty:pb_t_longitude]){
        pb_t_longitude = @"";
    }
    if([NSString PB_CheckStringIsEmpty:pb_t_latitude]){
        pb_t_latitude = @"";
    }
    //idfv
    NSString *pb_t_de_idfv = PBStrFormat([[PB_idf_helper instanceOnly] pb_t_getIdfvOnlyString]);
    //idfa
    NSString *pb_t_de_idfa = PBStrFormat([[PB_idf_helper instanceOnly] pb_t_getIDFAOnlyString]);
    
    NSMutableDictionary *_pb_deDic = [NSMutableDictionary dictionaryWithDictionary:params];
    [_pb_deDic setValue:pb_t_latitude forKey:@"ball"];
    [_pb_deDic setValue:pb_t_longitude forKey:@"pride"];
    [_pb_deDic setValue:pb_t_de_idfv forKey:@"already"];
    [_pb_deDic setValue:pb_t_de_idfa forKey:@"since"];
    [_pb_deDic setValue:@"2" forKey:@"know"];
    [[PB_RequestHelper pb_instance] pb_postRequestWithUrlStr:PBURL_reportRiskInfoUrl params:_pb_deDic commplete:^(NSDictionary * _Nullable result, NSInteger statusCode) {
            
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
            
    }];
}

/// 检查是否需要显示引导页
#pragma mark - Native loading (avoid QMUITips maskView crash on iOS 18+)

+ (void)pb_t_showNativeLoginLoadingOnHostView:(UIView *)hostView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [PB_APP_Control pb_t_hideNativeLoginLoadingOverlay];
        UIWindow *window = PB_ApplicationKeyWindowFromHostView(hostView);
        if (!window) { return; }
        UIView *dim = [[UIView alloc] initWithFrame:window.bounds];
        dim.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        dim.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.22];
        dim.userInteractionEnabled = YES;
        UIActivityIndicatorView *spin;
        if (@available(iOS 13.0, *)) {
            spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
            spin.color = [UIColor whiteColor];
        } else {
            spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        }
        spin.translatesAutoresizingMaskIntoConstraints = NO;
        [dim addSubview:spin];
        [NSLayoutConstraint activateConstraints:@[
            [spin.centerXAnchor constraintEqualToAnchor:dim.centerXAnchor],
            [spin.centerYAnchor constraintEqualToAnchor:dim.centerYAnchor],
        ]];
        [spin startAnimating];
        [window addSubview:dim];
        PBLoginNativeLoadingOverlay = dim;
    });
}

+ (void)pb_t_hideNativeLoginLoadingOverlay {
    dispatch_async(dispatch_get_main_queue(), ^{
        [PBLoginNativeLoadingOverlay removeFromSuperview];
        PBLoginNativeLoadingOverlay = nil;
    });
}

+ (void)pb_t_presentLoginAlertFromViewController:(UIViewController *)vc message:(NSString *)message {
    if (message.length == 0) { return; }
    [PB_NativeTipsHelper pb_presentAlertWithMessage:message];
}

+ (BOOL)pb_t_needShowGuideModuleJudge{
    static NSString *versionKey_pb_de = @"PrimeLoanPH_AppVersion_key";
    NSUserDefaults *userDefault_pb_de = [NSUserDefaults standardUserDefaults] ;
    NSString *lastVersion = PBStrFormat([userDefault_pb_de objectForKey:versionKey_pb_de]);
    NSString *currentVersion =  [PB_getAppInfoHelper pb_to_getMyAppVersionString];
    if([lastVersion isEqualToString:currentVersion]){ //版本号相同
        return NO;
    }else{//版本号不同
        [userDefault_pb_de setObject:currentVersion forKey:versionKey_pb_de];
        [userDefault_pb_de synchronize];
        return YES;
    }
}



@end
