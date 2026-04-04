//
//  PB_getAppInfoHelper.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/7.
//

#import "PB_getAppInfoHelper.h"
#import <sys/utsname.h>
#import "Reachability+PP.h"

@implementation PB_getAppInfoHelper

+ (NSString *)pb_to_getMyAppVersionString{
    NSString *pb_t_version_str = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return pb_t_version_str;
}

+ (NSString *)pb_t0_getPhoneDeviceTypeNameString{
    struct utsname _t_systemInfo;
    uname(&_t_systemInfo);
    NSString *pb_t_deviceNameString = [NSString stringWithCString:_t_systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([pb_t_deviceNameString isEqualToString:@"iPhone7,2"]) {
        return @"iPhone6";
    }else if ([pb_t_deviceNameString isEqualToString:@"iPhone7,1"]){
        return @"iPhone6Plus";
    }else if ([pb_t_deviceNameString isEqualToString:@"iPhone8,1"]){
        return @"iPhone6s";
    }else if([pb_t_deviceNameString isEqualToString:@"iPhone8,2"]){
        return @"iPhone6sPlus";
    }else if([pb_t_deviceNameString isEqualToString:@"iPhone8,4"]||[pb_t_deviceNameString isEqualToString:@"iPhone12,8"]||[pb_t_deviceNameString isEqualToString:@"iPhone14,6"]){
        return @"iphoneSE";
    }else if ([pb_t_deviceNameString isEqualToString:@"iPhone9,1"]||[pb_t_deviceNameString isEqualToString:@"iPhone9,3"]){
        return @"iPhone7";
    }else if ([pb_t_deviceNameString isEqualToString:@"iPhone9,2"]||[pb_t_deviceNameString isEqualToString:@"iPhone9,4"]){
        return @"iPhone7Plus";
    }else if ([pb_t_deviceNameString isEqualToString:@"iPhone10,1"]||[pb_t_deviceNameString isEqualToString:@"iPhone10,4"]){
        return @"iPhone8";
    }else if ([pb_t_deviceNameString isEqualToString:@"iPhone10,2"]||[pb_t_deviceNameString isEqualToString:@"iPhone10,5"]){
        return @"iPhone8Plus";
    }else if ([pb_t_deviceNameString isEqualToString:@"iPhone10,3"]||[pb_t_deviceNameString isEqualToString:@"iPhone10,6"]){
        return @"iPhoneX";
    }else if ([pb_t_deviceNameString isEqualToString:@"iPhone11,8"]){
        return @"iPhoneXR";
    }else if ([pb_t_deviceNameString isEqualToString:@"iPhone11,2"]){
        return @"iPhoneXS";
    }else if ([pb_t_deviceNameString isEqualToString:@"iPhone11,4"]||[pb_t_deviceNameString isEqualToString:@"iPhone11,6"]){
        return @"iPhoneXS_MAX";
    }else if ([pb_t_deviceNameString isEqualToString:@"iPhone12,1"]){
        return @"iPhone11";
    }else if ([pb_t_deviceNameString isEqualToString:@"iPhone12,3"]){
        return @"iPhone11Pro";
    }else if ([pb_t_deviceNameString isEqualToString:@"iPhone12,5"]){
        return @"iPhone11ProMax";
    }else if ([pb_t_deviceNameString isEqualToString:@"iPhone13,1"]){
        return @"iPhone12Mini";
    }else if ([pb_t_deviceNameString isEqualToString:@"iPhone13,2"]){
        return @"iPhone12";
    }else if ([pb_t_deviceNameString isEqualToString:@"iPhone13,3"]){
        return @"iPhone12Pro";
    }else if ([pb_t_deviceNameString isEqualToString:@"iPhone13,4"]){
        return @"iPhone12ProMax";
    }else if ([pb_t_deviceNameString isEqualToString:@"iPhone14,4"]){
        return @"iPhone13Mini";
    }else if ([pb_t_deviceNameString isEqualToString:@"iPhone14,5"]){
        return @"iPhone13";
    }else if ([pb_t_deviceNameString isEqualToString:@"iPhone14,2"]){
        return @"iPhone13Pro";
    }else if ([pb_t_deviceNameString isEqualToString:@"iPhone14,3"]){
        return @"iPhone13ProMax";
    }else if ([pb_t_deviceNameString isEqualToString:@"iPhone14,7"]){
        return @"iPhone14";
    }else if ([pb_t_deviceNameString isEqualToString:@"iPhone14,8"]){
        return @"iPhone14Plus";
    }else if ([pb_t_deviceNameString isEqualToString:@"iPhone15,2"]){
        return @"iPhone14Pro";
    }else if ([pb_t_deviceNameString isEqualToString:@"iPhone15,3"]){
        return @"iPhone14ProMax";
    }else if ([pb_t_deviceNameString isEqualToString:@"i386"]||[pb_t_deviceNameString isEqualToString:@"x86_64"]){
        return @"Simulator";
    }else {
        return pb_t_deviceNameString;
    }
}

+ (NSInteger)pb_to_getSignalNum
{
    if(@available(iOS 13.0, *))
    {
        return [self pt_to_signalStrengthThan13];
    }
    else
    {
        return [self signalStrengthLess13];
    }
}

+ (NSInteger )pt_to_signalStrengthThan13{
    
    NSInteger pb_t_signalNum;
    if(@available(iOS 13.0, *))
    {
        NSArray *arr = [UIApplication sharedApplication].connectedScenes.allObjects;
        UIWindowScene *scene = arr.firstObject;
        UIStatusBarManager *_t_statusBarManager = scene.statusBarManager;
        id statusBar =nil;
        if([_t_statusBarManager respondsToSelector:NSSelectorFromString(@"createLocalStatusBar")])
        {
            UIView*localStatusBar = [_t_statusBarManager performSelector:NSSelectorFromString(@"createLocalStatusBar")];
            if([localStatusBar respondsToSelector:NSSelectorFromString(@"statusBar")])
            {
                statusBar = [localStatusBar performSelector:NSSelectorFromString(@"statusBar")];
            }
        }
 
        if(statusBar)
        {
            id currentData = [[statusBar valueForKeyPath:@"_statusBar"]valueForKeyPath:@"currentData"];
            id cellularEntry = [[Reachability pb_t_de_netName] isEqualToString:@"WIFI"]?[currentData valueForKeyPath:@"wifiEntry"]:[currentData valueForKeyPath:@"cellularEntry"];
            if([cellularEntry isKindOfClass:NSClassFromString(@"_UIStatusBarDataWifiEntry")])
            {
                //wifi网络
                pb_t_signalNum = [[cellularEntry valueForKey:@"displayValue"]intValue];
            }
            else if([cellularEntry isKindOfClass:NSClassFromString(@"_UIStatusBarDataIntegerEntry")])
            {
                //运营商流量/网络
                pb_t_signalNum = [[cellularEntry valueForKey:@"displayValue"]intValue];
            }
        }
    }
    
    return pb_t_signalNum;
}
 
 
//13以下
+ (NSInteger)signalStrengthLess13
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSString *dataNetworkItemView = nil;
    NSString *pb_t_signalNum = @"";
    for (id subview in subviews)
    {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]] && [[Reachability pb_t_de_netName] isEqualToString:@"WIFI"] && [Reachability pb_t_de_netName].length>0)
        {
            dataNetworkItemView = subview;
            pb_t_signalNum = [NSString stringWithFormat:@"%@dBm",[dataNetworkItemView valueForKey:@"_wifiStrengthRaw"]];
            break;
        }
        if ([subview isKindOfClass:[NSClassFromString(@"UIStatusBarSignalStrengthItemView") class]] && ![[Reachability pb_t_de_netName] isEqualToString:@"WIFI"] && [Reachability pb_t_de_netName].length>0)
        {
            dataNetworkItemView = subview;
            pb_t_signalNum = [NSString stringWithFormat:@"%@dBm",[dataNetworkItemView valueForKey:@"_signalStrengthRaw"]];
            break;
        }
    }
    
    
    if([NSString PB_CheckStringIsEmpty:pb_t_signalNum]){
        return 0;
    }else{
        return [pb_t_signalNum integerValue];
    }
    
    
}


@end
