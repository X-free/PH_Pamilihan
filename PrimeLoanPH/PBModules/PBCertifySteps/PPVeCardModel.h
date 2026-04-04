//
//Created by ESJsonFormatForMac on 23/11/02.
//

#import <Foundation/Foundation.h>

@class PPVeCardTheoreticalModel,PPVeCardRangeModel,PPVeCardSoughtModel;
@interface PPVeCardModel : NSObject

@property (nonatomic, copy) NSString *defines;

@property (nonatomic, copy) NSString *concepts;

@property (nonatomic, strong) PPVeCardTheoreticalModel *theoretical;

@end
@interface PPVeCardTheoreticalModel : NSObject

@property (nonatomic, strong) PPVeCardRangeModel *range;

@property (nonatomic, strong) NSArray *strand;

@property (nonatomic, copy) NSString *IMwo0NdZe;

@property (nonatomic, strong) NSArray *pan;

@property (nonatomic, copy) NSString *gqnQ8Kw;

@property (nonatomic, assign) NSInteger rutter;

@property (nonatomic, strong) NSArray *demie;

@property (nonatomic, copy) NSString *gaKABTo9D3UW;

@property (nonatomic, copy) NSString *RHjE4r;

@property (nonatomic, copy) NSString *iDlxuRwMxNt;

@property (nonatomic, copy) NSString *ge4XbP;

@property (nonatomic, copy) NSString *xI68fb;

@property (nonatomic, strong) PPVeCardSoughtModel *sought;

@end

@interface PPVeCardRangeModel : NSObject

@property (nonatomic, assign) NSInteger acknowledges;
@property (nonatomic, copy) NSString *translated;
@property (nonatomic, copy) NSString *explain;

@end

@interface PPVeCardSoughtModel : NSObject

@property (nonatomic, assign) NSInteger acknowledges;
@property (nonatomic, copy) NSString *translated;


@end

