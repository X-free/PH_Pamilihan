//
//  PB_mainInfo_helper.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/8.
//


#import "PB_mainInfo_helper.h"


//device info
#import <mach/mach.h>
#import <mach/mach_host.h>
#include <ifaddrs.h>
#include <net/if.h>
#import <arpa/inet.h>
#import <sys/ioctl.h>

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"


NSString *const KVPNNotification = @"PB_T_vpn_state_change";
NSString *const PB_T_HistoryWifiEnquryKey = @"PB_T_HistoryWifiEnquryKey";



@implementation PB_mainInfo_helper

+ (PB_mainInfo_helper *)instanceOnly {
    static dispatch_once_t once;
    static PB_mainInfo_helper *pb_t_instance;
    dispatch_once(&once, ^{
        pb_t_instance = [self new];
    
    });
    return pb_t_instance;
}


#pragma mark ----- 获取设fsadff备信息 -----
- (NSDictionary *)pb_t_getMainInfoDictData {
    NSMutableDictionary *pb_t_result_dic= [[NSMutableDictionary alloc] init];
    //内存sadasd
    NSDictionary *pb_t_dic1 = @{

        @"consideration":PBStrFormat([self pb_t_getMaxMemoryString]),
        @"taken":PBStrFormat([self pb_t_getAviailableMemoryString]),
        @"homogeneous":PBStrFormat([self pb_t_getMaxDiskString]),//内存ram_total_size
        @"group":PBStrFormat([self pb_t_getAviaiableDiskString]) //可用内存ram_usable_size
    };
    [pb_t_result_dic setValue:pb_t_dic1 forKey:@"access"];
    //电池asdasd
    NSDictionary *pb_t_dic2 = @{
        @"conflated":PBStrFormat([self pb_t_getBatteryLeftPersentString]),
        @"seems":PBStrFormat([self pb_t_getBatteryIsFullString]),
        @"mainstreamed":[[self pb_t_getBatteryIsFullString] isEqualToString:@"Charging"]?@"1":@"0"
    };
    [pb_t_result_dic setValue:pb_t_dic2 forKey:@"seems"];
    //系统版本，尺寸等asdasd
    NSDictionary *pb_t_dic3 = @{
        @"ethno":PBStrFormat([self pb_t_getSystemVersionString]),
        @"removed":PBStrFormat([self pb_t_getCurDeviceInfoTypeNameString]),
        @"distinct":PBStrFormat([PB_getAppInfoHelper pb_t0_getPhoneDeviceTypeNameString]),
        @"difference":PBStrFormat([self pb_t_getPiexHeightString]),
        @"disregarded":PBStrFormat([self pb_t_getPiexWidthString]),
        @"ultimately":PBStrFormat([self pb_t_getDevicePhysicalSizeString]),
        @"cultural":PBStrFormat([self pb_t_getPhysicalSizeString])
    };
    [pb_t_result_dic setValue:pb_t_dic3 forKey:@"identities"];
    //模拟器、越狱asdasd
    NSDictionary *pb_t_dic4 = @{
        @"highlight":PBStrFormat([self pb_t_getIsTheSimulatorString]),
        @"contradictions":PBStrFormat([self pb_t_getDeviceIsJok]),
        @"living":[PB_getAppInfoHelper pb_to_getSignalNum] <= 0 ? @"" : @([PB_getAppInfoHelper pb_to_getSignalNum])
    };
    [pb_t_result_dic setValue:pb_t_dic4 forKey:@"rhetoric"];
    //时区、网络类型等
    NSDictionary *pb_t_dic5 = @{
        @"underpinned":PBStrFormat([self pb_t_getGMTimeZoneString]),
        @"surgeries":PBStrFormat([self pb_t_getHasOpenAndUseProxy]),
        @"doctors":PBStrFormat([self pb_t_getHasUseTheVPN]),
        @"visitor":PBStrFormat([self pb_t_getDeviceMobileCardType]),
        @"conceptualised":PBStrFormat([[PB_idf_helper instanceOnly] pb_t_getIdfvOnlyString]),
        @"via":PBStrFormat([self pb_t_getTheAppLanguage]),
        @"getting":PBStrFormat([self pb_t_toGetNetworkTypeString]),
        @"advise":PBStrFormat([self pb_t_getDeviceTypeNumberString]),
        @"vein":PBStrFormat([self pb_t_getWaiWangNetIPString]),
        @"baker":PBStrFormat([[PB_idf_helper instanceOnly] pb_t_getIDFAOnlyString]),
    };
    [pb_t_result_dic setValue:pb_t_dic5 forKey:@"fundamental"];

    ////当前Wi-Fi数量【获取需要权限，目前不获取】
    //NSString *wifiCount = [self pb_t_getWifiHistoryConnectedCountString];
    NSDictionary *pb_t_dic6 = @{
        
    };
    //当前连接Wi-Fi信息
//    if([[self pb_t_toGetNetworkTypeString] isEqual:@"WIFI"]){
        pb_t_dic6 = [self pb_t_getCurrentConnectWifiInfoDict];
        [pb_t_result_dic setValue:pb_t_dic6 forKey:@"similar"];
//    }
    return pb_t_result_dic;
    
}

///获取设备dsgfadsfgdsaf可用存储大小
- (NSString *)pb_t_getAviailableMemoryString {

    mach_port_t pb_t_host_port = mach_host_self();
    mach_msg_type_number_t count = HOST_VM_INFO64_COUNT;
 
    vm_size_t page_sizepp;
    vm_statistics64_data_t vminfo;
    host_page_size(pb_t_host_port, &page_sizepp);
    host_statistics64(pb_t_host_port, HOST_VM_INFO64, (host_info64_t)&vminfo,&count);
 
    uint64_t free_sizepp = (vminfo.free_count + vminfo.external_page_count + vminfo.purgeable_count - vminfo.speculative_count) * page_sizepp;
    return [NSString stringWithFormat:@"%llu",free_sizepp];

}

///获取设备sdfsdfaf总存储大小asd
- (NSString *)pb_t_getMaxMemoryString{
    int64_t pb_t_totalMemorypps = [[NSProcessInfo processInfo] physicalMemory];
    if (pb_t_totalMemorypps < -1) pb_t_totalMemorypps = -1;
    return [NSString stringWithFormat:@"%lld",pb_t_totalMemorypps];
}

///获取设备fsadfsdfs总内存大小ad
- (NSString *)pb_t_getMaxDiskString{
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return @"-1";
    int64_t spaceppp =  [[attrs objectForKey:NSFileSystemSize] longLongValue];
    if (spaceppp < 0) spaceppp = -1;
    return [NSString stringWithFormat:@"%lld",spaceppp];
}

///获取设备asd内存可用大小asd
- (NSString *)pb_t_getAviaiableDiskString{

    NSURL *fileUrl_pb_st = [[NSURL alloc] initFileURLWithPath:NSTemporaryDirectory()];
    NSDictionary *results = [fileUrl_pb_st resourceValuesForKeys:@[NSURLVolumeAvailableCapacityForImportantUsageKey] error:nil];
    double deviceFreeMemory_pb_st = [results[NSURLVolumeAvailableCapacityForImportantUsageKey] floatValue];
    return [NSString stringWithFormat:@"%ld",(long)deviceFreeMemory_pb_st];
}

///获取设备剩asd余电量（百分比）asdas
- (NSString *)pb_t_getBatteryLeftPersentString{
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    return [[NSString stringWithFormat:@"%.f",[UIDevice currentDevice].batteryLevel * 100] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

///获取设备当asdas前电池状态asdas
- (NSString *)pb_t_getBatteryIsFullString{
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    switch ([[UIDevice currentDevice] batteryState]) {
        case UIDeviceBatteryStateCharging:
            if ([UIDevice currentDevice].batteryLevel == 1) {
                return @"Fully charged";
            } else {
                return @"Charging";
            }
            break;
        case UIDeviceBatteryStateFull:
            return @"Fully charged";
            break;
        case UIDeviceBatteryStateUnplugged:
            return @"Unplugged";
            break;
        default:
            return @"Unknown";
    }
}


///获取设dfgdfsg备系统版本dgsfg
- (NSString *)pb_t_getSystemVersionString{
    NSString *result_pb_st = [[UIDevice currentDevice] systemVersion];
    return result_pb_st;
}

///获取设fdsaf备品牌sdf
- (NSString *)pb_t_getCurDeviceInfoTypeNameString{
    
    NSString *resultValue_pb_st = @"";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        resultValue_pb_st = @"iPhone";
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        resultValue_pb_st = @"iPad";
    } else {
        resultValue_pb_st = @"diomOther";
    }
    return resultValue_pb_st;
}

///
///获取设备asdasd分辨率高asdas
- (NSString *)pb_t_getPiexHeightString{
    CGSize screen_size_pb_st = [[UIScreen mainScreen] bounds].size;
    CGFloat screen_scale_pb_st = [UIScreen mainScreen].scale;
    return [NSString stringWithFormat:@"%.0f", screen_size_pb_st.height * screen_scale_pb_st];
}

///获取设备分asdasd辨率kuan
- (NSString *)pb_t_getPiexWidthString{
    CGSize screen_size_pb_st = [[UIScreen mainScreen] bounds].size;
    CGFloat screen_scale_pb_st = [UIScreen mainScreen].scale;
    return [NSString stringWithFormat:@"%.0f", screen_size_pb_st.width * screen_scale_pb_st];
}

///获取设备分sdfsdf物理尺寸【XX寸】
- (NSString *)pb_t_getPhysicalSizeString{

    NSString *deviceTName_pb_st = [PB_getAppInfoHelper pb_t0_getPhoneDeviceTypeNameString];
        if ([deviceTName_pb_st isEqualToString:@"iphoneSE"]) {
            return @"4";
        } else if([deviceTName_pb_st isEqualToString:@"iPhone6"]||[deviceTName_pb_st isEqualToString:@"iPhone6s"]||[deviceTName_pb_st isEqualToString:@"iPhone7"]||[deviceTName_pb_st isEqualToString:@"iPhone8"]||[deviceTName_pb_st isEqualToString:@"iphoneSE2"]){
            return @"4.7";
        } else if([deviceTName_pb_st isEqualToString:@"iPhone12Mini"]||[deviceTName_pb_st isEqualToString:@"iPhone13Mini"]){
            return @"5.4";
        }  else if([deviceTName_pb_st isEqualToString:@"iPhone6Plus"]||[deviceTName_pb_st isEqualToString:@"iPhone6sPlus"]||[deviceTName_pb_st isEqualToString:@"iPhone7Plus"]||[deviceTName_pb_st isEqualToString:@"iPhone8Plus"]){
            return @"5.5";
        } else if([deviceTName_pb_st isEqualToString:@"iPhoneX"]||[deviceTName_pb_st isEqualToString:@"iPhoneXS"]||[deviceTName_pb_st isEqualToString:@"iPhone11Pro"]){
            return @"5.8";
        } else if([deviceTName_pb_st isEqualToString:@"iPhoneXR"]||[deviceTName_pb_st isEqualToString:@"iPhone11"]||[deviceTName_pb_st isEqualToString:@"iPhone12"]||[deviceTName_pb_st isEqualToString:@"iPhone12Pro"]||[deviceTName_pb_st isEqualToString:@"iPhone13"]||[deviceTName_pb_st isEqualToString:@"iPhone13Pro"]||[deviceTName_pb_st isEqualToString:@"iPhone14"]||[deviceTName_pb_st isEqualToString:@"iPhone14Pro"]){
            return @"6.1";
        } else if([deviceTName_pb_st isEqualToString:@"iPhoneXS_MAX"]||[deviceTName_pb_st isEqualToString:@"iPhone11ProMax"]){
            return @"6.5";
        } else if([deviceTName_pb_st isEqualToString:@"iPhone12ProMax"]||[deviceTName_pb_st isEqualToString:@"iPhone13ProMax"]||[deviceTName_pb_st isEqualToString:@"iPhone14Plus"]||[deviceTName_pb_st isEqualToString:@"iPhone14ProMax"]){
            return @"6.7";
        } else{
            float scale = [[UIScreen mainScreen] scale];
            float ppi = scale * ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 132 : 163);
            float width = ([[UIScreen mainScreen] bounds].size.width * scale);
            float height = ([[UIScreen mainScreen] bounds].size.height * scale);
            float horizontal = width / ppi, vertical = height / ppi;
            float diagonal_pb_st = sqrt(pow(horizontal, 2) + pow(vertical, 2));
            return [NSString stringWithFormat:@"%.1f", diagonal_pb_st];
        }

}

///获取设备分物sdfsdaf理尺寸【逻辑分辨率(point)】sdfsdf
- (NSString *)pb_t_getDevicePhysicalSizeString{
    CGRect rect_screen_pb_st = [UIScreen mainScreen].bounds;
    CGSize size_screen = rect_screen_pb_st.size;

    NSString *result_pb_st = [NSString stringWithFormat:@"%.0fX%.0f",size_screen.width,size_screen.height];
    return result_pb_st;
}


///获取设备是否asdasd为模拟器asdasd
- (NSString *)pb_t_getIsTheSimulatorString{
    NSString *result_pb_st;
    if (TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1) {
        result_pb_st =  @"1";
    }else{
        result_pb_st =  @"0";
    }
    return  result_pb_st;
}

///获取设备是否越狱
- (NSString *)pb_t_getDeviceIsJok{
    NSArray *jail_paths_pb_st = @[
        @"/Applications/Cydia.app",
        @"/Library/MobileSubstrate/MobileSubstrate.dylib",
        @"/bin/bash",
        @"/usr/sbin/sshd",
        @"/etc/apt"
    ];
    for (NSString*path in jail_paths_pb_st) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            return @"1";
        }
    }
    return @"0";
}

///获取设备时区asdads的 ID(缩写)asd
- (NSString *)pb_t_getGMTimeZoneString{
    NSTimeZone *zone_pb_st = [NSTimeZone localTimeZone];
    NSString *strZoneName_pb_st = [zone_pb_st name]; //名称 Asia/Shanghai
//    NSString *strZoneAbbreviation = [zone abbreviation]; //缩写 GMT+8
    return strZoneName_pb_st;

}

//////获取设备asdasd是否代理asdasd
- (NSString *)pb_t_getHasOpenAndUseProxy{
    NSDictionary *proxySettings_pb_st =  (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
        NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings_pb_st)));
        NSDictionary *settings_pb_st = [proxies objectAtIndex:0];
        if ([[settings_pb_st objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]){
            return @"0";
        }else{
            return @"1";
        }
}

///获取设备asdasd是使用VPNasdasd
- (NSString *)pb_t_getHasUseTheVPN {
    NSDictionary *dict = CFBridgingRelease(CFNetworkCopySystemProxySettings());
    NSArray *keys = [dict[@"__SCOPED__"] allKeys];
    for (NSString *keyId in keys) {
        if ([keyId rangeOfString:@"tap"].location != NSNotFound ||
            [keyId rangeOfString:@"tun"].location != NSNotFound ||
            [keyId rangeOfString:@"ipsec"].location != NSNotFound ||
            [keyId rangeOfString:@"ppp"].location != NSNotFound){
            return @"1";
            break;
        }
    }
  return @"0";
}


///获取设备sdfsd运营商sdf
- (NSString *)pb_t_getDeviceMobileCardType{
    CTTelephonyNetworkInfo *Info_pb_st = [[CTTelephonyNetworkInfo alloc] init];
    //NSLog(@"info = %@", info);
    CTCarrier *carrier = [Info_pb_st subscriberCellularProvider];
    //NSLog(@"carrier = %@", carrier);
    if (carrier == nil) {
        return @"";
    }
    NSString *code_pb_st = [carrier mobileNetworkCode];
    if (code_pb_st == nil) {
        return @"";
    }
    if ([code_pb_st isEqualToString:@"00"] || [code_pb_st isEqualToString:@"02"] || [code_pb_st isEqualToString:@"07"]) {
        return @"移动运营商";
    } else if ([code_pb_st isEqualToString:@"01"] || [code_pb_st isEqualToString:@"06"]) {
        return @"联通运营商";
    } else if ([code_pb_st isEqualToString:@"03"] || [code_pb_st isEqualToString:@"05"]) {
        return @"电信运营商";
    } else if ([code_pb_st isEqualToString:@"20"]) {
        return @"铁通运营商";
    }
    return @"";

}

///获取设备sdf语言sdfdsf
- (NSString *)pb_t_getTheAppLanguage{
    NSString *lang_pb_st = [NSLocale preferredLanguages].firstObject;
    NSArray  *array_pb_st = [lang_pb_st componentsSeparatedByString:@"-"];
    return array_pb_st.firstObject;
}

///获取设qweqwe备网络
- (NSString *)pb_t_toGetNetworkTypeString{
    NSString *resultValue_pb_st = @"5G";
    Reachability *reach = [Reachability reachabilityWithHostName:@"https://www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:// 没有网络
        {
            resultValue_pb_st = @"NONE";
        }
            break;
        case ReachableViaWiFi:// Wifi
        {
            resultValue_pb_st = @"WIFI";
        }
            break;
        case ReachableViaWWAN:// 手机自带网络
        {
            // 获取手机网络类型
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
            NSString *currentState = info.currentRadioAccessTechnology;
            if ([currentState isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
                resultValue_pb_st = @"GPRS";
            }else if ([currentState isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
                resultValue_pb_st = @"2.75G EDGE";
            }else if ([currentState isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
                resultValue_pb_st = @"3G";
            }else if ([currentState isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
                resultValue_pb_st = @"3.5G HSDPA";
            }else if ([currentState isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
                resultValue_pb_st = @"3.5G HSUPA";
            }else if ([currentState isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
                resultValue_pb_st = @"2G";
            }else if ([currentState isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
                resultValue_pb_st = @"3G";
            }else if ([currentState isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
                resultValue_pb_st = @"3G";
            }else if ([currentState isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
                resultValue_pb_st = @"3G";
            }else if ([currentState isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
                resultValue_pb_st = @"HRPD";
            }else if ([currentState isEqualToString:@"CTRadioAccessTechnologyLTE"]){
                resultValue_pb_st = @"4G";
            }else if (@available(iOS 14.1, *)) {
                if ([currentState isEqualToString:CTRadioAccessTechnologyNRNSA]){
                    resultValue_pb_st = @"5G NSA";
                }else if ([currentState isEqualToString:CTRadioAccessTechnologyNR]){
                    resultValue_pb_st = @"5G";
                }
            }
        }
            break;
        default:
            break;
    }
    return resultValue_pb_st;
}

///获取设asd备外网ip asd
- (NSString *)pb_t_getWaiWangNetIPString{
    if (self.pb_t_devicewifiIPAdressString.length != 0) {
        return self.pb_t_devicewifiIPAdressString;
    }
    if (self.pb_t_getDeviceIPString.length != 0) {
        return self.pb_t_getDeviceIPString;
    }
    return @"Unknown";
}
- (NSString *)pb_t_devicewifiIPAdressString
{
    NSString *address_pb_st = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address_pb_st = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address_pb_st;
}

//sdfsdfsd
- (NSString *)pb_t_getDeviceIPString
{
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    NSMutableArray *ips = [NSMutableArray array];
    int BUFFERSIZE = 4096;
    struct ifconf ifc;
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    struct ifreq *ifr, ifrcopy;
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            ifr = (struct ifreq *)ptr;
            int len = sizeof(struct sockaddr);
            if (ifr->ifr_addr.sa_len > len) {
                len = ifr->ifr_addr.sa_len;
            }
            ptr += sizeof(ifr->ifr_name) + len;
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            ifrcopy = *ifr;
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            
            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;
            
            NSString *ip = [NSString  stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            [ips addObject:ip];
        }
    }
    close(sockfd);
    NSString *resultDeviceIP_pb_st = @"";
    for (int i=0; i < ips.count; i++) {
        if (ips.count > 0) {
            resultDeviceIP_pb_st = [NSString stringWithFormat:@"%@",ips.lastObject];
        }
    }
    return resultDeviceIP_pb_st;
}


///获取设备sdfsdfdsf保存的wifi数量sdfsd
- (NSString *)pb_t_getWifiHistoryConnectedCountString {
    NSArray *wifyCount_pb_st = CFBridgingRelease(CNCopySupportedInterfaces());
    return [NSString stringWithFormat:@"%@",wifyCount_pb_st];
}

//获取设备当asdasd前连接的wifi信息（如果没有，传空对象）asdasd
- (NSDictionary *)pb_t_getCurrentConnectWifiInfoDict{

    // 获取设备当前wifi信息
    NSArray *ifs = CFBridgingRelease(CNCopySupportedInterfaces());
    NSMutableDictionary *pb_t_finalDic = [NSMutableDictionary dictionary];
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer  id)CNCopyCurrentNetworkInfo((CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    if(info != nil){
        [pb_t_finalDic setValue:(NSDictionary *)info[@"BSSID"] forKey:@"hearing"];
        [pb_t_finalDic setValue:(NSDictionary *)info[@"BSSID"] forKey:@"reading"];
        [pb_t_finalDic setValue:(NSDictionary *)info[@"SSID"] forKey:@"celebrating"];
        [pb_t_finalDic setValue:(NSDictionary *)info[@"SSID"] forKey:@"either"];
    }
    NSLog(@"dicCurrent Wi-Fi = %@",pb_t_finalDic);
    //判断本地
    NSMutableArray *pb_t_historyWifiArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:PB_T_HistoryWifiEnquryKey]];
    if(pb_t_historyWifiArray.count > 0){//有历史数据
        BOOL hasExist = NO;
        for(NSInteger i = 0; i < pb_t_historyWifiArray.count; i++){
            NSString *wifiName = [pb_t_historyWifiArray[i] objectForKey:@"celebrating"];
            NSString *curWifiName = @"";
            if(pb_t_finalDic.allKeys.count > 0){
                curWifiName = [NSString stringWithFormat:@"%@",pb_t_finalDic[@"celebrating"]];
                if([wifiName isEqualToString:curWifiName]){
                    hasExist = YES;
                    break;
                }
            }
        }
        if(hasExist == NO) { //没有存储此wifi
            if(pb_t_finalDic.allKeys.count > 0){
                if(![NSString PB_CheckStringIsEmpty:pb_t_finalDic[@"celebrating"]]){
                    [pb_t_historyWifiArray addObject:pb_t_finalDic];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:pb_t_historyWifiArray] forKey:PB_T_HistoryWifiEnquryKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }

        }
    }else{ //无历史 - 直接存储
        if(pb_t_finalDic.allKeys.count > 0){
            if(![NSString PB_CheckStringIsEmpty:pb_t_finalDic[@"celebrating"]]){
                [pb_t_historyWifiArray addObject:pb_t_finalDic];
            }
            [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:pb_t_historyWifiArray] forKey:PB_T_HistoryWifiEnquryKey];
            [[NSUserDefaults standardUserDefaults] synchronize];

        }
    }
    
    NSDictionary *resultWifiDic = @{
        @"each":@(pb_t_historyWifiArray.count),
        @"minutes":pb_t_finalDic,
        @"read":pb_t_historyWifiArray
    };
    
    
    return resultWifiDic;
}

/* 指示设备电话类型的常量1 手机;2 平板*/
- (NSString *)pb_t_getDeviceTypeNumberString{
    NSString *type_pb_st = @"";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) { //如果当前设备是iphone
        type_pb_st = @"1";
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        type_pb_st = @"2";
    }
    return type_pb_st;
}


@end
