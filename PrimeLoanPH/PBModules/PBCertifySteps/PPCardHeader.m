//
//  PPCardHeader.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/11/2.
//

#import "PPCardHeader.h"

@interface PPCardHeader ()

@property (nonatomic, strong) QMUILabel *pb_t_de_pTitleLabel;

@end

@implementation PPCardHeader


- (void)pb_initUI {
    self.contentView.backgroundColor = PB_BgColor;
    [self.contentView addSubview:self.pb_t_de_pTitleLabel];
    [self.pb_t_de_pTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PB_Ratio(15));
        make.bottom.mas_offset(-PB_Ratio(10));
    }];
    
}

- (void)pb_confWithSectionData:(id)data {
    if([data isKindOfClass:NSString.class]){
        self.pb_t_de_pTitleLabel.text = PBStrFormat(data);
    }
}

- (QMUILabel *)pb_t_de_pTitleLabel {
    if(!_pb_t_de_pTitleLabel){
        _pb_t_de_pTitleLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@" " color:PB_yiBanBlackColor font:UIFontMediumMake(PB_Ratio(15)) alignment:NSTextAlignmentLeft lines:1];
    }
    return _pb_t_de_pTitleLabel;
}


@end
