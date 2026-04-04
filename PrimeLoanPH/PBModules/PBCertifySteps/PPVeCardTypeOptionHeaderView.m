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
        self.frame = CGRectMake(0, 0, PB_SW, PB_Ratio(99));
        self.backgroundColor = PB_BgColor;
        QMUILabel *label = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"select an id to verify your identity" color:PB_Gray_1_Color font:UIFontMake(PB_Ratio(14)) alignment:NSTextAlignmentLeft lines:1];
        [self addSubview:label];
        
        UIView *pb_t_sepLine = [[UIView alloc] init];
        pb_t_sepLine.backgroundColor = PB_Color(@"#FF8100");
        [self addSubview:pb_t_sepLine];
        
        QMUILabel *label1 = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"Recommended ID Type" color:PB_shenBlackColor font:UIFontBoldMake(PB_Ratio(18)) alignment:NSTextAlignmentLeft lines:1];
        [self addSubview:label1];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(PB_Ratio(14));
            make.centerX.mas_equalTo(0);
        }];
        [pb_t_sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(PB_Ratio(19));
            make.top.mas_equalTo(PB_Ratio(61));
            make.size.mas_equalTo(CGSizeMake(PB_Ratio(3), PB_Ratio(12)));
        }];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(pb_t_sepLine.mas_right).offset(PB_Ratio(9));
            make.centerY.mas_equalTo(pb_t_sepLine);
        }];
    }
    return self;
}


@end
