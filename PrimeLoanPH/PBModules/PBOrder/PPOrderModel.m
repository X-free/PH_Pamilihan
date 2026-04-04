//
//Created by ESJsonFormatForMac on 23/10/31.
//

#import "PPOrderModel.h"
@implementation PPOrderModel


@end

@implementation PPOrderTheoreticalModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"draw" : [PPOrderDrawModel class]};
}


@end


@implementation PPOrderDrawModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"interpreted" : [PPOrderInterpretedModel class]};
}


@end


@implementation PPOrderInterpretedModel


@end


