//
//  PB_location_helper.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/8.
//

#import "PB_location_helper.h"
//定位相关
#import <CoreLocation/CoreLocation.h>

@interface PB_location_helper ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation PB_location_helper

+ (PB_location_helper *)instanceOnly {
    static dispatch_once_t once;
    static PB_location_helper *pb_t_instance;
    dispatch_once(&once, ^{
        pb_t_instance = [self new];
    
    });
    return pb_t_instance;
}

- (void)pb_t_toBeginLocationMethod{
    if([self  pb_t_askLocationAllowIsEnable] == YES){
        [self.locationManager startUpdatingLocation];
    }
}

/** 定位权sdfsf限处理 */
- (BOOL)pb_t_askLocationAllowIsEnable{

    if (@available(iOS 14.0, *)) {
        if ([PB_location_helper instanceOnly].locationManager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse ||[PB_location_helper instanceOnly].locationManager.authorizationStatus == kCLAuthorizationStatusAuthorizedAlways) {
            return YES;
        }else
        {
            [[PB_location_helper instanceOnly].locationManager requestAlwaysAuthorization];
            return NO;
        }
    }else
    {
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways){
            return YES;
        }else
        {
            [[PB_location_helper instanceOnly].locationManager requestAlwaysAuthorization];
            return NO;
        }
    }
}


-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        [self  pb_t_toBeginLocationMethod];
    }
}

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager ;
{
    if (@available(iOS 14.0, *)) {
        CLAuthorizationStatus status = manager.authorizationStatus;
        if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
            [self  pb_t_toBeginLocationMethod];
        }
    } else {
        // Fallback on earlier versions
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (locations.count == 0) {
        return;
    }
    [self.locationManager stopUpdatingLocation];
    //当前所在城市的坐标值
    CLLocation *pb_t_currLocation = [locations lastObject];
    //根据经纬度反编译地址信息
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:pb_t_currLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *pb_t_placeMark = placemarks[0];
//            NSLog(@"当前国家:%@",pb_t_placeMark.country);//当前国家
//            NSLog(@"省:%@", pb_t_placeMark.administrativeArea);//省
//            NSLog(@"当前城市:%@",pb_t_placeMark.locality);//当前城市
//            NSLog(@"当前区、县:%@",pb_t_placeMark.subLocality);//区、县
//            NSLog(@"国家code:%@",pb_t_placeMark.ISOcountryCode);
//            NSLog(@"当前街道:%@",pb_t_placeMark.thoroughfare);//当前街道
            NSString *pb_t_longitude = [NSString stringWithFormat:@"%lf", pb_t_currLocation.coordinate.longitude];
            NSString *pb_t_latitude = [NSString stringWithFormat:@"%lf", pb_t_currLocation.coordinate.latitude];
            self.pb_t_country = PBStrFormat(pb_t_placeMark.country);
            self.pb_t_province = PBStrFormat(pb_t_placeMark.administrativeArea);
            self.pb_t_city = PBStrFormat(pb_t_placeMark.locality);
            self.pb_t_subCity = PBStrFormat(pb_t_placeMark.subLocality);
            self.pb_t_street = PBStrFormat(pb_t_placeMark.thoroughfare);
            self.pb_t_longitude = pb_t_longitude;
            self.pb_t_latitude = pb_t_latitude;
            self.pb_t_countryCode = PBStrFormat(pb_t_placeMark.ISOcountryCode);
            
            NSDictionary *params = @{
                @"gardiner":self.pb_t_country,//
                @"medway":self.pb_t_countryCode,//
                @"capacity":self.pb_t_province,//
                @"promoting":self.pb_t_city,//
                @"ball":self.pb_t_latitude,//
                @"pride":self.pb_t_longitude,//
                @"kenny":self.pb_t_street,
                @"discue":self.pb_t_subCity
            };
            [[PB_RequestHelper pb_instance] pb_postRequestWithUrlStr:PBURL_reportLocationInfoUrl params:params commplete:^(NSDictionary * _Nullable result, NSInteger statusCode) {
                        
            } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
                        
                }];
        } else if (error == nil && placemarks.count == 0) {
            NSLog(@"没有地址返回");
        } else if (error) {
            //NSLog(@"%@",error);
        }
    }];
}

- (CLLocationManager *)locationManager {
    if(!_locationManager){
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

//get方法处理
- (NSString *)pb_t_country {
    return [NSString PB_CheckStringIsEmpty:_pb_t_country] ? @"" : _pb_t_country;
}

- (NSString *)pb_t_province {
    return [NSString PB_CheckStringIsEmpty:_pb_t_province] ? @"" : _pb_t_province;
}

-(NSString *)pb_t_city {
    return [NSString PB_CheckStringIsEmpty:_pb_t_city] ? @"" : _pb_t_city;
}

- (NSString *)pb_t_street {
    return [NSString PB_CheckStringIsEmpty:_pb_t_street] ? @"" : _pb_t_street;
}

- (NSString *)pb_t_longitude {
    return [NSString PB_CheckStringIsEmpty:_pb_t_longitude] ? @"" : _pb_t_longitude;
}

- (NSString *)pb_t_latitude {
    return [NSString PB_CheckStringIsEmpty:_pb_t_latitude] ? @"" : _pb_t_latitude;
}

- (NSString *)pb_t_countryCode {
    return [NSString PB_CheckStringIsEmpty:_pb_t_countryCode] ? @"" : _pb_t_countryCode;
}



@end
