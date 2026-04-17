//
//  PPVeCardTypeOptionHeaderView.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/11/9.
//

#import "PPVeCardTypeOptionHeaderView.h"

@implementation PPVeCardTypeOptionHeaderView

- (instancetype)init {
    self = [super init];
    if(self){
        self.frame = CGRectMake(0, 0, PB_SW, PB_Ratio(8));
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}


@end
