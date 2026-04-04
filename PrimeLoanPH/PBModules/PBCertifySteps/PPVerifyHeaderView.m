//
//  PPVerifyHeaderView.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/11/2.
//

#import "PPVerifyHeaderView.h"

@implementation PPVerifyHeaderView

- (instancetype)init {
    self = [super init];
    if(self){
        [self ppInit];
    }
    return self;
}

- (void)ppInit {
    self.backgroundColor = UIColor.clearColor;
    CGFloat pb_t_img_width = (PB_SW - PB_Ratio(15)*2);
    CGFloat pb_t_img_height = pb_t_img_width * 232/345.0;
    UIImageView *imgView = [[UIImageView alloc] initWithImage:UIImageMake(@"auth_cardTip")];
    self.frame = CGRectMake(0, 0, PB_SW, pb_t_img_height + PB_Ratio(15));
    [self addSubview:imgView];
    imgView.frame = CGRectMake(PB_Ratio(15), PB_Ratio(15), pb_t_img_width, pb_t_img_height);
}


@end
