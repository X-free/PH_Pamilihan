//
//  PB_RequestHelper.h
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PB_RequestHelper : NSObject

+ (PB_RequestHelper *)pb_instance;

typedef void(^commpleteBlock)(_Nullable id result,NSInteger statusCode);

typedef void(^failureBlock)(NSError *error,NSInteger errorCode,NSString *errorStr);

/**
 Get 请求 dsfdsaf
 @param url     url sdfdsaf
 @param params params sadfadfg
 @param block   成功块 dsf
 @param fblock  失败块 df
 */
- (void)pb_getRequestWithUrlStr:(NSString *)url
                   params:(id)params
                 commplete:(commpleteBlock)block
                   failure:(failureBlock)fblock;

/**
 Post 请求 dsfsdaf
 
 @param url     url sdfsd
 @param params params sdfsd
 @param block   成功块 sdfsad
 @param fblock  失败块 dsfa
 */
- (void)pb_postRequestWithUrlStr:(NSString *)url
                   params:(id)params
                 commplete:(commpleteBlock)block
                   failure:(failureBlock)fblock;


/**
 文件上传 sdfd
fdsa
 @param url             url sdfsdf
 @param params          params sdfasf
 @param img 上传的文件 sdf
 @param successHandler  成功块 dsfsd af
 @param failureHandler  失败块 sdfsdf
 */
- (void)pb_uploadFileRequestWithUrlStr:(NSString *)url
               params:(id)params
      file:(UIImage *)img
              success:(commpleteBlock)successHandler
              failure:(failureBlock)failureHandler;

@end

NS_ASSUME_NONNULL_END
