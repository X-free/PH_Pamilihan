//
//  PB_idf_helper.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/8.
//

#import "PB_idf_helper.h"

//idfa相关
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

static NSString *const key_idfv = @"PeraBoost_idfv_key";


@implementation PB_idf_helper


+ (PB_idf_helper *)instanceOnly {
    static dispatch_once_t once;
    static PB_idf_helper *pb_t_instance;
    dispatch_once(&once, ^{
        pb_t_instance = [self new];
    
    });
    return pb_t_instance;
}

#pragma mark ----- 获取idfa -----

///idfa权限询问
- (void)pb_t_enquryIDFA_ask {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (@available(iOS 14, *)) {
            ATTrackingManagerAuthorizationStatus pb_t_authorZhuangTai = ATTrackingManager.trackingAuthorizationStatus;
            if (pb_t_authorZhuangTai != ATTrackingManagerAuthorizationStatusAuthorized) {
                [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {}];
            }
            
        } else {
            if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {}
        }
    });
}

- (NSString *)pb_t_getIDFAOnlyString{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}


#pragma mark - private

- (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

- (void)pb_t_save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *pb_t_keychain_Query = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)pb_t_keychain_Query);
    //Add new object to search dictionary(Attention:the data format)
    [pb_t_keychain_Query setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)pb_t_keychain_Query, NULL);
}

- (id)pb_t_load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *pb_t_keychain_Query = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [pb_t_keychain_Query setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [pb_t_keychain_Query setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    OSStatus status =  SecItemCopyMatching((CFDictionaryRef)pb_t_keychain_Query, (CFTypeRef *)&keyData);
    if (status == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
            return @"解析设备错误，请返回页面重新获取";
        } @finally {
        }
    } else if (status != errSecItemNotFound) {
        return @"查询设备错误，请返回页面重新获取";
    }
    if (keyData)
    CFRelease(keyData);
    return ret;
}



#pragma mark ----- 获取idfv -----
- (NSString *)pb_t_getIdfvOnlyString {
    //获取
    NSString *pb_t_idfvOnlyString = [self pb_t_load:key_idfv];
    if ((!pb_t_idfvOnlyString) || (pb_t_idfvOnlyString.length == 0) || [pb_t_idfvOnlyString isEqual:@""]) {
        pb_t_idfvOnlyString = [[UIDevice currentDevice].identifierForVendor UUIDString];
        [self pb_t_save:key_idfv data:pb_t_idfvOnlyString];
    }
    //NSLog(@"--获取到idfv：%@--",pb_t_idfvOnlyString);
    return pb_t_idfvOnlyString;
}



@end
