//
//  Reachability+PP.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/11/14.
//

#import "Reachability+PP.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation Reachability (PP)

+ (NSString *)pb_t_de_netName
{
    Reachability *pb_t_de_reachability   = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus pb_t_de_internetStatus = [pb_t_de_reachability currentReachabilityStatus];
    NSString *pb_t_de_net = @"WIFI";
    switch (pb_t_de_internetStatus)
    {
        case ReachableViaWiFi:
        {
            pb_t_de_net = @"WIFI";
            break;
        }
        case ReachableViaWWAN:
        {
//            net = @"蜂窝数据";
            pb_t_de_net = [self pb_t_de_getNetType];   //判断具体类型
            break;
        }
        case NotReachable:
            pb_t_de_net = @"";
            
        default:
            break;
    }
    return pb_t_de_net;
}
 
+ (NSString *)pb_t_de_getNetType{
 
    NSString *pb_t_de_result_network = @"";
    static CTTelephonyNetworkInfo *netinfo = nil;
    NSString *pb_t_de_currentRadioAccessTechnology = nil;
    
    if (!netinfo) {
        netinfo = [[CTTelephonyNetworkInfo alloc] init];
    }
#ifdef __IPHONE_12_0
    if (@available(iOS 12.1, *)) {
        pb_t_de_currentRadioAccessTechnology = netinfo.serviceCurrentRadioAccessTechnology.allValues.lastObject;
    }
#endif
    //测试发现存在少数 12.0 和 12.0.1 的机型 serviceCurrentRadioAccessTechnology 返回空
    if (!pb_t_de_currentRadioAccessTechnology) {
        pb_t_de_currentRadioAccessTechnology = netinfo.currentRadioAccessTechnology;
    }
    
    if ([pb_t_de_currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS]) {
        pb_t_de_result_network = @"2G";
    } else if ([pb_t_de_currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge]) {
        pb_t_de_result_network = @"2G";
    } else if ([pb_t_de_currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyWCDMA]) {
        pb_t_de_result_network = @"3G";
    } else if ([pb_t_de_currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSDPA]) {
        pb_t_de_result_network = @"3G";
    } else if ([pb_t_de_currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSUPA]) {
        pb_t_de_result_network = @"3G";
    } else if ([pb_t_de_currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
        pb_t_de_result_network = @"3G";
    } else if ([pb_t_de_currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]) {
        pb_t_de_result_network = @"3G";
    } else if ([pb_t_de_currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]) {
        pb_t_de_result_network = @"3G";
    } else if ([pb_t_de_currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]) {
        pb_t_de_result_network = @"3G";
    } else if ([pb_t_de_currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyeHRPD]) {
        pb_t_de_result_network = @"3G";
    } else if ([pb_t_de_currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
        pb_t_de_result_network = @"4G";
    } else {
        if (@available(iOS 14.1, *)) {
            if ([pb_t_de_currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyNRNSA]){
                pb_t_de_result_network = @"5G NSA";
            }else if ([pb_t_de_currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyNR]){
                pb_t_de_result_network = @"5G";
            }
        }else{
            pb_t_de_result_network = @"UNKNOWN";
        }
    }
    return pb_t_de_result_network;

}

@end
