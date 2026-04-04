//
//Created by ESJsonFormatForMac on 23/11/06.
//

#import "PPAdressModel.h"
@implementation PPAdressModel


@end

@implementation PPAdressTheoreticalModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"draw" : [PPAdressDraw1Model class]};
}


@end


@implementation PPAdressDraw1Model

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"draw" : [PPAdressDraw2Model class]};
}


@end


@implementation PPAdressDraw2Model

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"draw" : [PPAdressDraw3Model class]};
}


@end


@implementation PPAdressDraw3Model


@end


