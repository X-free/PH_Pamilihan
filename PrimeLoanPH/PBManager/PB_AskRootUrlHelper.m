//
//  PB_AskRootUrlHelper.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/8.
//

#import "PB_AskRootUrlHelper.h"
#import <AFNetworking/AFNetworking.h>
#import "PPLanguageModel.h"

@implementation PB_AskRootUrlHelper

+ (PB_AskRootUrlHelper *)instanceOnly {
    static dispatch_once_t once;
    static PB_AskRootUrlHelper *pb_t_instance;
    dispatch_once(&once, ^{
        pb_t_instance = [self new];
        //测试
//        pb_t_instance.pb_root_url = @"http://8.212.182.12:8846/us/";
        //正式
        pb_t_instance.pb_root_url = @"https://pbt.mjj-atthi-lending.com/us/";
    
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

    [[PB_RequestHelper pb_instance] pb_getRequestWithUrlStr:PBURL_LanguageUrl params:@{} commplete:^(id  _Nullable result, NSInteger statusCode) {
        if(result != nil){
            //下发 instance 字段  1=印度  2=菲律宾
            PPLanguageModel *pb_t_lauMD = [PPLanguageModel yy_modelWithJSON:result];
            [PB_APP_Control instanceOnly].pb_t_serve_set_Language = pb_t_lauMD.theoretical.instance;
            [PB_APP_Control instanceOnly].isCon = pb_t_lauMD.theoretical.isCon;

            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
            
    }];
    


    PMMyWeekSelf
    [QMUITips showLoadingInView:vc.view];
    [self pb_t_getNetwork:self.pb_root_url success:^(id resp) {
//       NSLog(@"init serve response:::%@",resp);
        if ([resp[@"defines"] intValue] == 0) {
            [QMUITips hideAllTips];
            complete();
        }else
        {
            [QMUITips hideAllTips];
            [weakSelf pb_t_updateRootURL:complete];
        }
    } failure:^{
        [QMUITips hideAllTips];
        [weakSelf pb_t_updateRootURL:complete];
    }];
        
}


-(void)pb_t_updateRootURL:(dispatch_block_t)complete {
    
    NSString *dy_pb_url = @"https://ph-credit-peso-ios.oss-ap-southeast-6.aliyuncs.com/pbt.json";
    PMMyWeekSelf
    [self pb_t_getNetwork:dy_pb_url success:^(id list) {
        //NSLog(@"new serve url:::%@",list);
        [QMUITips hideAllTips];
        [weakSelf pb_t_getValidUrl:list index:0 complete:complete];
    } failure:^{
        [QMUITips hideAllTips];
        [QMUITips showError:@"Network error"];
    }];
}

-(void)pb_t_getNetwork:(NSString *)baseUrl success:(void (^)(id resp))success failure:(dispatch_block_t)failure {
    [[self manager]GET:baseUrl parameters:@{} headers:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [QMUITips hideAllTips];
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [QMUITips hideAllTips];
        failure();
    }];
}

-(void)pb_t_getValidUrl:(NSArray *)array index:(NSInteger)index complete:(dispatch_block_t)complete {
    if(array.count <= index){
        [QMUITips hideAllTips];
        [QMUITips showError:@"Network error"];
        return;
    }
    NSString *url = array[index][@"pbt"];
    PMMyWeekSelf
    [self pb_t_getNetwork:url success:^(id resp) {
        if ([resp[@"defines"] intValue] == 0) {
            weakSelf.pb_root_url = url;
            [QMUITips hideAllTips];
            complete();
        } else {
            [QMUITips hideAllTips];
            [weakSelf pb_t_getValidUrl:array index:index+1 complete:complete];
        }
    } failure:^{
        [QMUITips hideAllTips];
        [weakSelf pb_t_getValidUrl:array index:index+1 complete:complete];
    }];
}



@end
