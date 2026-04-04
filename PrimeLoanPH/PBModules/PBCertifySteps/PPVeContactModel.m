//
//Created by ESJsonFormatForMac on 23/11/06.
//

#import "PPVeContactModel.h"
@implementation PPVeContactModel


@end

@implementation PPVeContactTheoreticalModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"integrationist" : [PPVeContactIntegrationistModel class]};
}


@end


@implementation PPVeContactIntegrationistModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"identified" : [PPVeContactIdentifiedModel class]};
}


@end


@implementation PPVeContactIdentifiedModel


@end


