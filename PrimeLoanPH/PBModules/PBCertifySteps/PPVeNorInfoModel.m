//
//Created by ESJsonFormatForMac on 23/11/05.
//

#import "PPVeNorInfoModel.h"
@implementation PPVeNorInfoModel


@end

@implementation PPVeNorInfoTheoreticalModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"mceachron" : [PPVeNorInfoMceachronModel class]};
}


@end


@implementation PPVeNorInfoMceachronModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"identified" : [PPVeNorInfoIdentifiedModel class]};
}


@end


@implementation PPVeNorInfoIdentifiedModel


@end


