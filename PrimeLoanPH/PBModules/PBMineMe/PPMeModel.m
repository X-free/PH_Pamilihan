//
//Created by ESJsonFormatForMac on 23/10/31.
//

#import "PPMeModel.h"
@implementation PPMeModel


@end

@implementation PPMeTheoreticalModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"draw" : [PPMeDrawModel class]};
}


@end


@implementation PPMeInspiringModel

/// 兼容 `userphone` / `userPhone` / `UserPhone` 及数字类型
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if ([self.userphone length] > 0) {
        return YES;
    }
    NSArray *keys = @[ @"userphone", @"userPhone", @"UserPhone" ];
    for (NSString *key in keys) {
        id v = dic[key];
        if ([v isKindOfClass:[NSString class]] && [(NSString *)v length] > 0) {
            self.userphone = v;
            return YES;
        }
        if ([v isKindOfClass:[NSNumber class]]) {
            self.userphone = [(NSNumber *)v stringValue];
            return YES;
        }
    }
    return YES;
}

@end


@implementation PPMeDrawModel


@end


