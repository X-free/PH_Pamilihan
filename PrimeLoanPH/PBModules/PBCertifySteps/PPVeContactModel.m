//
//Created by ESJsonFormatForMac on 23/11/06.
//

#import "PPVeContactModel.h"
#import "NSString+PB1.h"

@interface PPVeContactModel (PBContactText)
@end

@implementation PPVeContactModel (PBContactText)

+ (nullable NSString *)pp_t_nonEmptyString:(id)obj {
    if (obj == nil || obj == (id)kCFNull) {
        return nil;
    }
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *t = [(NSString *)obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        return t.length > 0 ? t : nil;
    }
    NSString *s = [NSString stringWithFormat:@"%@", obj];
    s = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (s.length == 0 || [s isEqualToString:@"(null)"] || [s isEqualToString:@"<null>"]) {
        return nil;
    }
    return s;
}

+ (void)pp_applyContactTextFromResponse:(nullable NSDictionary *)raw toModel:(nullable PPVeContactModel *)m {
    if (raw == nil || m == nil) {
        return;
    }
    PPVeContactTheoreticalModel *t = m.theoretical;
    if (t == nil) {
        t = [PPVeContactTheoreticalModel new];
        m.theoretical = t;
    }
    NSDictionary *theo = [raw[@"theoretical"] isKindOfClass:[NSDictionary class]] ? raw[@"theoretical"] : nil;
    NSDictionary *m0 = nil;
    id mce = theo ? theo[@"mceachron"] : nil;
    if (mce == nil) {
        mce = raw[@"mceachron"];
    }
    if ([mce isKindOfClass:[NSArray class]] && [(NSArray *)mce count] > 0) {
        id f = [(NSArray *)mce firstObject];
        if ([f isKindOfClass:[NSDictionary class]]) {
            m0 = (NSDictionary *)f;
        }
    }
    if (m0 == nil && t.mceachron.count) {
        id f = t.mceachron.firstObject;
        if ([f isKindOfClass:[NSDictionary class]]) {
            m0 = (NSDictionary *)f;
        }
    }
#define PBPull(k) ([PPVeContactModel pp_t_nonEmptyString:theo[k]] \
    ?: [PPVeContactModel pp_t_nonEmptyString:raw[k]] \
    ?: [PPVeContactModel pp_t_nonEmptyString:m0[k]])

    NSString *sH = PBPull(@"here");
    if ([NSString PB_CheckStringIsEmpty:t.here] && sH) {
        t.here = sH;
    }
    NSString *sC = PBPull(@"communities");
    if ([NSString PB_CheckStringIsEmpty:t.communities] && sC) {
        t.communities = sC;
    }
    NSString *sU = PBPull(@"use");
    if ([NSString PB_CheckStringIsEmpty:t.useText] && sU) {
        t.useText = sU;
    }
    NSString *sD = PBPull(@"defining");
    if ([NSString PB_CheckStringIsEmpty:t.defining] && sD) {
        t.defining = sD;
    }
#undef PBPull
}

@end

@implementation PPVeContactModel

@end

@implementation PPVeContactTheoreticalModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"integrationist" : [PPVeContactIntegrationistModel class]};
}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"useText" : @"use"};
}

@end


@implementation PPVeContactIntegrationistModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"identified" : [PPVeContactIdentifiedModel class]};
}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"useText" : @"use"};
}

@end


@implementation PPVeContactIdentifiedModel

@end
