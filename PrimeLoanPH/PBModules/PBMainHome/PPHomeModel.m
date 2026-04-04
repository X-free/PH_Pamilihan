//
//Created by ESJsonFormatForMac on 23/10/30.
//

#import "PPHomeModel.h"
@implementation PPHomeModel


@end

@implementation PPHomeTheoreticalModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"draw" : [PPHomeDrawModel class]};
}


@end


@implementation PPHomeShapesModel


@end

@implementation PPHomeEthnicModel


@end


@implementation PPHomeDrawModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"conclusion" : [PPHomeConclusionModel class]};
}


@end


@implementation PPHomeConclusionModel


@end


