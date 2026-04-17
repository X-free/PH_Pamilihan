//
//  AppDelegate.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/27.
//

#import "AppDelegate.h"
#import "PPStartViewController.h"
#import "PPTabBarController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "PPLanguageModel.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // QMUI DEBUG 会向 qmuiteam.com 上报；该域名当前 TLS 证书与主机不匹配，会刷 NSURLErrorDomain -1202。
    [QMUIConfiguration sharedInstance].sendAnalyticsToQMUITeam = NO;

    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [PB_APP_Control instanceOnly].pb_t_serve_set_Language = 1;
    PMMyWeekSelf
    PPStartViewController *vc = [[PPStartViewController alloc] init];
    self.window.rootViewController = vc;
    vc.finishCallBlock = ^{
        weakSelf.window.rootViewController = [[PPTabBarController alloc] init];
    };
    [self.window makeKeyAndVisible];
    
    [[PB_RequestHelper pb_instance] pb_getRequestWithUrlStr:PBURL_LanguageUrl params:@{} commplete:^(NSDictionary * _Nullable result, NSInteger statusCode) {
        if(result != nil){
            PPLanguageModel *pb_t_lauMD = [PPLanguageModel yy_modelWithJSON:result];
//            "interpretml" : {
//              "interpretpqow" : "4c3140b03330aa8c220ac312cddb2677",
//              "interpretnahsd" : "Pamilihan Peso",
//              "interpretlaoa" : "fb538358828521993",
//              "interpretmans" : "538358828521993"
//            }
//
            [PB_APP_Control instanceOnly].pb_t_serve_set_Language = pb_t_lauMD.theoretical.instance;
            [PB_APP_Control instanceOnly].isCon = pb_t_lauMD.theoretical.isCon;
            
            NSString *facebookAppID = PBStrFormat(pb_t_lauMD.theoretical.interpretml.interpretmans);
            NSString *appName = PBStrFormat(pb_t_lauMD.theoretical.interpretml.interpretnahsd);
            NSString *clientToken = PBStrFormat(pb_t_lauMD.theoretical.interpretml.interpretpqow);
            NSString *cFBundleURLScheme = PBStrFormat(pb_t_lauMD.theoretical.interpretml.interpretlaoa);
            [[FBSDKSettings sharedSettings] setAppID:facebookAppID];
            [[FBSDKSettings sharedSettings] setClientToken:clientToken];
            [[FBSDKSettings sharedSettings] setDisplayName:appName];
            [[FBSDKSettings sharedSettings] setAppURLSchemeSuffix:cFBundleURLScheme];
            [[FBSDKSettings sharedSettings] setIsAdvertiserTrackingEnabled:YES];
            [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

        }
        
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
            
    }];
    
    
    
    return YES;
}




@end
