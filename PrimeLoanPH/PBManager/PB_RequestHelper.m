//
//  PB_RequestHelper.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/8.
//

#import "PB_RequestHelper.h"
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSInteger, PB_RequestType) {
    PB_GET_RequestType,
    PB_POST_RequestType
};

@interface PB_RequestHelper ()

@property (nonatomic,strong) AFHTTPSessionManager *manager;

@end

@implementation PB_RequestHelper

+ (PB_RequestHelper *)pb_instance {
    static dispatch_once_t once;
    static PB_RequestHelper *instance;
    dispatch_once(&once, ^{
        instance = [self new];
        AFHTTPSessionManager *pb_t_AFNetManager = [AFHTTPSessionManager manager];
        pb_t_AFNetManager.requestSerializer.timeoutInterval =20.f;
        pb_t_AFNetManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        pb_t_AFNetManager.responseSerializer=[AFJSONResponseSerializer serializer];
        pb_t_AFNetManager.responseSerializer=[AFHTTPResponseSerializer serializer];
        pb_t_AFNetManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",@"text/javascript",@"image/jpeg",@"image/png",@"application/octet-stream",@"text/json",nil];
        [pb_t_AFNetManager.requestSerializer setValue:@"application;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [pb_t_AFNetManager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        pb_t_AFNetManager.securityPolicy.allowInvalidCertificates=NO;//1213是否验证证书
        pb_t_AFNetManager.securityPolicy.validatesDomainName=NO; //qweqwe/是否验证域名
        instance.manager = pb_t_AFNetManager;
    });
    return instance;
}

/// GET
- (void)pb_getRequestWithUrlStr:(NSString *)url params:(id)params commplete:(commpleteBlock)block failure:(failureBlock)fblock {
    
    [self pb_t_de_toNetRequestWithType:PB_GET_RequestType url:url params:params commplete:^(id  _Nonnull result, NSInteger statusCode) {
        block(result,statusCode);
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
        fblock(error,errorCode,errorStr);
    }];
    
}

/// POST
-(void)pb_postRequestWithUrlStr:(NSString *)url params:(id)params commplete:(commpleteBlock)block failure:(failureBlock)fblock {

    [self pb_t_de_toNetRequestWithType:PB_POST_RequestType url:url params:params commplete:^(id  _Nonnull result, NSInteger statusCode) {
        block(result,statusCode);
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
        fblock(error,errorCode,errorStr);
    }];
}


///文件上传
- (void)pb_uploadFileRequestWithUrlStr:(NSString *)url params:(nonnull id)params file:(nonnull UIImage *)img success:(nonnull commpleteBlock)successHandler failure:(nonnull failureBlock)failureHandler {
    BOOL vaild = [self pb_t_checkRequestEnableWith:url];
    if (!vaild) {
        return;
    }
    url = [[PB_APP_Control instanceOnly] pb_t_addPublicParamsDictKeyToUrlSuff:url];
    if ([params isKindOfClass:[NSDictionary class]]) {
        NSLog(@"url:%@\n params:%@------\n",url,[NSString PB_getJsonStringFromDictionary:params]);
    }else if ([params isKindOfClass:[NSArray class]]){
        NSLog(@"url:%@\n params:%@------\n",url,[NSString PB_transformJsonStringFromArr:params]);
    }else{
        NSLog(@"url:%@\n params:%@------\n",url,[NSString PB_transformJsonStringFromObject:params]);
    }
    
    NSString *pb_t_uploadImgStr = [NSString stringWithFormat:@"PB_IOS_%@.png",[PB_timeHelper pb_t_getTimeFormatyyyyMMddHHmmss]];
    pb_t_uploadImgStr =  [pb_t_uploadImgStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    //图片压缩至500k后在进行qweqwewqeqwe上传
    NSData *imgData = [self PB_RatioImgToLimitSize:500 targetImg:img];
    NSLog(@"上传图qweqwewqwsac片的大小：%fkb",imgData.length/1024.0);
    [_manager POST:url parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imgData name:@"pokemon" fileName:pb_t_uploadImgStr mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
            
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *responses = (NSHTTPURLResponse *)task.response;
        [self resetSuccess:responseObject code:responses.statusCode url:url successHandler:successHandler];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self resetError:error failureBlock:failureHandler];
    }];
}



/**
 统一请求路径

 @param type 请求类型
 @param url url
 @param params params
 @param block 成功块
 @param fblock 失败块
 */
- (void)pb_t_de_toNetRequestWithType:(PB_RequestType)type
                    url:(NSString *)url
                 params:(id)params
              commplete:(commpleteBlock)block
                failure:(failureBlock)fblock {
    
    BOOL vaild = [self pb_t_checkRequestEnableWith:url];
    if (!vaild) {
        return;
    }
    url = [[PB_APP_Control instanceOnly] pb_t_addPublicParamsDictKeyToUrlSuff:url];
    if ([params isKindOfClass:[NSDictionary class]]) {
        NSLog(@"url:%@\n params:%@------\n",url,[NSString PB_getJsonStringFromDictionary:params]);
    }else if ([params isKindOfClass:[NSArray class]]){
        NSLog(@"url:%@\n params:%@------\n",url,[NSString PB_transformJsonStringFromArr:params]);
    }else{
        NSLog(@"url:%@\n params:%@------\n",url,[NSString PB_transformJsonStringFromObject:params]);
    }
    switch (type) {
        case PB_GET_RequestType:
        {
            [_manager GET:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSHTTPURLResponse *responses = (NSHTTPURLResponse *)task.response;
                [self resetSuccess:responseObject code:responses.statusCode url:url successHandler:block];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self resetError:error failureBlock:fblock];
            }];
        }
            break;
        case PB_POST_RequestType:
        {
            [_manager POST:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSHTTPURLResponse *responses = (NSHTTPURLResponse *)task.response;
                [self resetSuccess:responseObject code:responses.statusCode url:url successHandler:block];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //过滤上报报的错误
                if([url containsString:@"off/powerful"] ||
                   [url containsString:@"off/lobbying"] ||
                   [url containsString:@"off/naldic"] ||
                   [url containsString:@"credit-info/upload-contacts-ios"] ||
                   [url containsString:@"off/questioning"]){
                    [QMUITips hideAllTips];
                }else{
                    [self resetError:error failureBlock:fblock];
                }
            }];
        }
            break;


            
        default:
            break;
    }
}

/** 检查请求是否可用 */
- (BOOL)pb_t_checkRequestEnableWith:(NSString *)url {
    if (!url) {
        [QMUITips showWithText:@"url is empty"];
        return NO;
    }
    NSString *str = @" ";
    if ([url rangeOfString:str].location != NSNotFound) {
        [url stringByReplacingOccurrencesOfString:str withString:@""];
    }
    return YES;
}

/** 重置成功code */
- (void)resetSuccess:(id)resp code:(NSInteger)code url:(NSString *)url successHandler:(commpleteBlock)successHandler {
    NSDictionary *pb_t_de_dic=[NSJSONSerialization JSONObjectWithData:resp options:NSJSONReadingMutableContainers error:nil];
    //NSLog(@"resp ::: %@",dic);
    NSLog(@"请求结果%ld::%@:::%@",code,url,[NSString PB_getJsonStringFromDictionary:pb_t_de_dic]);
    if ( [resp isKindOfClass:[NSNull class]] || [resp isEqual:[NSNull null]] || resp == nil) {
        NSLog(@"responseObject***:%@***code:%zd",pb_t_de_dic,code);
        NSLog(@"成功--但是返回是个空");
    }else{
        //NSString *jsonStr =  [NSString PB_getJsonStringFromDictionary:resp];
        //NSLog(@"jsonStr:######%@######code:%zd",dic,code);
    }
    if (code == 200 || code == 201 || code == 204 || code == 205) {
        //0或00表示成功；-1系统通用错误未指定具体错误码；-2未登录；其他
        if(![NSString PB_CheckStringIsEmpty:pb_t_de_dic[@"defines"]]){
            NSString *stateCode = PBStrFormat(pb_t_de_dic[@"defines"]);
            NSString *pb_t_de_tipMsg = PBStrFormat(pb_t_de_dic[@"concepts"]);

            if([stateCode isEqualToString:@"0"] || [stateCode isEqualToString:@"00"] ){
                successHandler(resp,code);
            }else if ([stateCode isEqualToString:@"-2"]){
                NSLog(@"未登录");
                successHandler(nil,code);
                [self pb_t_de_requestHasNotLogin];
                [self performSelector:@selector(showTipMsg:) withObject:pb_t_de_tipMsg afterDelay:1];
            }else{
                NSLog(@"其他错误");
                successHandler(nil,code);
                if(![NSString PB_CheckStringIsEmpty:pb_t_de_tipMsg]){
                    [QMUITips showWithText:pb_t_de_tipMsg];
                };
            }
        }else{
            successHandler(nil,code);
        }
    }else {
        successHandler(nil,code);
        NSLog(@"errcode:%zd",code);
    }
}

/** 重置失败的code */
- (void)resetError:(NSError *)error failureBlock:(failureBlock)failureBlock {
    [QMUITips hideAllTips];
    NSLog(@"errorInfo:%@",error.userInfo);
    NSInteger pb_t_error_code = [[error userInfo][@"statusCode"] integerValue];
    if (pb_t_error_code == 200 || pb_t_error_code == 201 || pb_t_error_code == 204 || pb_t_error_code == 205)  {
        [QMUITips hideAllTips];
        return;
    }
    NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
    NSString *error_str = @"";
    if (data) {
        NSLog(@"存在");
        NSError *JSONSerializationError;
        NSDictionary *errorDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&JSONSerializationError];
        NSString *message = [NSString stringWithFormat:@"%@",errorDic[@"message"]];
//        [MBProgressHUD showWarnMessage:[NSString stringWithFormat:@"%@",message]];
        error_str = message;
        NSLog(@"***%@***%ld",errorDic,pb_t_error_code);
        if (pb_t_error_code == 0) {
            pb_t_error_code = [PBStrFormat(errorDic[@"code"]) integerValue];
        }
//        pb_t_error_code = [PBStrFormat(errorDic[@"statusCode"]) integerValue];
    }else{
        NSLog(@"不存在-");
        failureBlock(error,pb_t_error_code,error_str);
    }

}

- (void)showTipMsg:(NSString *)msg{
    [QMUITips showWithText:msg];
}

///未登录
- (void)pb_t_de_requestHasNotLogin{
    NSLog(@"未登录");
    [PB_APP_Control pb_t_toLogoutAntToHomeMyAccount];
    [PB_APP_Control pb_t_presentLoginVCWithTargetVC:[PB_GetVC pb_to_getCurrentViewController]];


}


- (NSData *)PB_RatioImgToLimitSize:(CGFloat)limitMaxSize targetImg:(UIImage *)tarImg{
    NSData *imageData = UIImageJPEGRepresentation(tarImg, 1);
    CGFloat imgDataSize = imageData.length/1024;
    //NSLog(@"1.0压缩后 = %fkb",imageData.length/1024.0);
    if (imgDataSize <= limitMaxSize) {
        //原图本来已经小于目标大小 直接返回
        return imageData;
    }
    NSData *PB_ImageDataP01 = UIImageJPEGRepresentation(tarImg, 0.1);
    CGFloat PB_ImgDataSizeP01 = PB_ImageDataP01.length/1024;
    UIImage *image01 = [UIImage imageWithData:PB_ImageDataP01];
    //NSLog(@"0.1压缩后 = %fkb",PB_ImgDataSizeP01);
    
    if (PB_ImgDataSizeP01 <= limitMaxSize) {
        //0.1压缩后已经符合需求 返回0.1压缩后的图片
        return PB_ImageDataP01;
    }
    //死循环 一直循环压缩 直至小于目标大小为止
    UIImage *newImage_PB = image01;
    NSData *PB_ResultmageData = PB_ImageDataP01;
    CGFloat width  = newImage_PB.size.width;
    CGFloat height = newImage_PB.size.height;
    CGSize size;
    
    for (int i = 0; i < 1; ) {
        size = CGSizeMake(width/1.2, height/1.2);
        UIGraphicsBeginImageContext(size);
        [newImage_PB drawInRect:CGRectMake(0,0, size.width, size.height)];
        newImage_PB = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //更新压缩后的图片size
        width = newImage_PB.size.width;
        height = newImage_PB.size.height;
        PB_ResultmageData = UIImageJPEGRepresentation(newImage_PB, 0.1);
        //NSLog(@"再次压缩后 = %fkb",PB_ResultmageData.length/1024.0);
        if (PB_ResultmageData.length / 1024 <= limitMaxSize) {
            //符合目标大小
            i = 1;
        } else {
            //尚未符合目标大小 继续压缩
            i = 0;
        }
    }
    if (!newImage_PB) {
        NSLog(@"压缩的图片不见了");
        return PB_ResultmageData;;
    }
    return PB_ResultmageData;
}




@end

