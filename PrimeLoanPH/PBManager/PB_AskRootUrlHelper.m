//
//  PB_AskRootUrlHelper.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/8.
//

#import "PB_AskRootUrlHelper.h"
#import <AFNetworking/AFNetworking.h>
#import "PPLanguageModel.h"
#import "PB_GetVC.h"

/// QMUITips / QMUIToastView 在 iOS 18 上会因 `maskView` 与 `addSubview:` 冲突崩溃，本类改用系统 Loading。
static UIView *pb_t_rootLoadingOverlay = nil;

static UIView *pb_t_tipsHostView(UIViewController *vc) {
    if (vc.view.window) {
        return vc.view.window;
    }
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if (![scene isKindOfClass:[UIWindowScene class]]) {
                continue;
            }
            UIWindowScene *ws = (UIWindowScene *)scene;
            for (UIWindow *win in ws.windows) {
                if (win.isKeyWindow) {
                    return win;
                }
            }
            if (ws.windows.firstObject) {
                return ws.windows.firstObject;
            }
        }
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIWindow *key = [UIApplication sharedApplication].keyWindow;
#pragma clang diagnostic pop
    if (key) {
        return key;
    }
    return vc.view;
}

static void pb_t_hideNativeRootLoadingNoSync(void) {
    [pb_t_rootLoadingOverlay removeFromSuperview];
    pb_t_rootLoadingOverlay = nil;
}

static void pb_t_hideNativeRootLoading(void) {
    if ([NSThread isMainThread]) {
        pb_t_hideNativeRootLoadingNoSync();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            pb_t_hideNativeRootLoadingNoSync();
        });
    }
}

static void pb_t_showNativeRootLoading(UIView *host) {
    void (^work)(void) = ^{
        pb_t_hideNativeRootLoadingNoSync();
        if (!host) {
            return;
        }
        UIView *dim = [[UIView alloc] initWithFrame:host.bounds];
        dim.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        dim.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.22];
        dim.accessibilityIdentifier = @"pb_root_url_loading_dim";
        UIActivityIndicatorView *spin = nil;
        if (@available(iOS 13.0, *)) {
            spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
            spin.color = UIColor.whiteColor;
        } else {
            spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        }
        spin.translatesAutoresizingMaskIntoConstraints = NO;
        [dim addSubview:spin];
        [NSLayoutConstraint activateConstraints:@[
            [spin.centerXAnchor constraintEqualToAnchor:dim.centerXAnchor],
            [spin.centerYAnchor constraintEqualToAnchor:dim.centerYAnchor]
        ]];
        [spin startAnimating];
        [host addSubview:dim];
        pb_t_rootLoadingOverlay = dim;
    };
    if ([NSThread isMainThread]) {
        work();
    } else {
        dispatch_async(dispatch_get_main_queue(), work);
    }
}

static void pb_t_showNetworkErrorAlert(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *vc = [PB_GetVC pb_to_getCurrentViewController];
        if (!vc || vc.presentedViewController) {
            return;
        }
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"Network error" preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [vc presentViewController:ac animated:YES completion:nil];
    });
}

@implementation PB_AskRootUrlHelper

+ (PB_AskRootUrlHelper *)instanceOnly {
    static dispatch_once_t once;
    static PB_AskRootUrlHelper *pb_t_instance;
    dispatch_once(&once, ^{
        pb_t_instance = [self new];
        //测试
//        pb_t_instance.pb_root_url = @"http://8.212.182.12:8846/us/";
        //正式
        pb_t_instance.pb_root_url = @"http://47.236.59.173/shouldall/";
    
    });
    return pb_t_instance;
}


-(AFHTTPSessionManager *)manager
{
    AFHTTPSessionManager *pb_t_shareInstance = [AFHTTPSessionManager manager];
    pb_t_shareInstance.requestSerializer = [AFHTTPRequestSerializer serializer];
    pb_t_shareInstance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"application/xml",@"text/plain",@"multipart/form-data",@"application/octet-stream", nil];
    pb_t_shareInstance.requestSerializer.timeoutInterval = 15;
    pb_t_shareInstance.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    return pb_t_shareInstance;
}

-(void)pb_t_checkRootUrl:(dispatch_block_t)complete withVC:(UIViewController *)vc {
    
    //NSLog(@"%@---",PBURL_LanguageUrl);

    [[PB_RequestHelper pb_instance] pb_getRequestWithUrlStr:PBURL_LanguageUrl params:@{} commplete:^(NSDictionary * _Nullable result, NSInteger statusCode) {
        if(result != nil){
            //下发 instance 字段  1=印度  2=菲律宾
            PPLanguageModel *pb_t_lauMD = [PPLanguageModel yy_modelWithJSON:result];
            [PB_APP_Control instanceOnly].pb_t_serve_set_Language = pb_t_lauMD.theoretical.instance;
            [PB_APP_Control instanceOnly].isCon = pb_t_lauMD.theoretical.isCon;

            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
            
    }];
    


    PMMyWeekSelf
    UIView *tipsHost = pb_t_tipsHostView(vc);
    pb_t_showNativeRootLoading(tipsHost);
    [self pb_t_getNetwork:self.pb_root_url success:^(id resp) {
//       NSLog(@"init serve response:::%@",resp);
        if ([resp[@"defines"] intValue] == 0) {
            pb_t_hideNativeRootLoading();
            complete();
        }else
        {
            pb_t_hideNativeRootLoading();
            [weakSelf pb_t_updateRootURL:complete];
        }
    } failure:^{
        pb_t_hideNativeRootLoading();
        [weakSelf pb_t_updateRootURL:complete];
    }];
        
}


-(void)pb_t_updateRootURL:(dispatch_block_t)complete {
    
    NSString *dy_pb_url = @"https://ph-credit-peso-ios.oss-ap-southeast-6.aliyuncs.com/pbt.json";
    PMMyWeekSelf
    [self pb_t_getNetwork:dy_pb_url success:^(id list) {
        //NSLog(@"new serve url:::%@",list);
        pb_t_hideNativeRootLoading();
        [weakSelf pb_t_getValidUrl:list index:0 complete:complete];
    } failure:^{
        pb_t_hideNativeRootLoading();
        pb_t_showNetworkErrorAlert();
    }];
}

-(void)pb_t_getNetwork:(NSString *)baseUrl success:(void (^)(id resp))success failure:(dispatch_block_t)failure {
    [[self manager]GET:baseUrl parameters:@{} headers:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        pb_t_hideNativeRootLoading();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        pb_t_hideNativeRootLoading();
        failure();
    }];
}

-(void)pb_t_getValidUrl:(NSArray *)array index:(NSInteger)index complete:(dispatch_block_t)complete {
    if(array.count <= index){
        pb_t_hideNativeRootLoading();
        pb_t_showNetworkErrorAlert();
        return;
    }
    NSString *url = array[index][@"pbt"];
    PMMyWeekSelf
    [self pb_t_getNetwork:url success:^(id resp) {
        if ([resp[@"defines"] intValue] == 0) {
            weakSelf.pb_root_url = url;
            pb_t_hideNativeRootLoading();
            complete();
        } else {
            pb_t_hideNativeRootLoading();
            [weakSelf pb_t_getValidUrl:array index:index+1 complete:complete];
        }
    } failure:^{
        pb_t_hideNativeRootLoading();
        [weakSelf pb_t_getValidUrl:array index:index+1 complete:complete];
    }];
}



@end
