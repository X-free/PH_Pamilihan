//
//  PPOrderEmptyTableViewCell.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/31.
//

#import "PPOrderEmptyTableViewCell.h"

@interface PPOrderEmptyTableViewCell ()

@property (nonatomic, strong) UIImageView *pb_t_de_logoImageView;
@property (nonatomic, strong) QMUILabel *pb_t_de_tipLabel;
@property (nonatomic, strong) UIButton *pb_t_de_funButton;

@end

@implementation PPOrderEmptyTableViewCell

- (void)pb_initUI {
    self.contentView.backgroundColor = PB_BgColor;
    [self.contentView addSubview:self.pb_t_de_logoImageView];
    [self.contentView addSubview:self.pb_t_de_tipLabel];
    [self.contentView addSubview:self.pb_t_de_funButton];
    [self.pb_t_de_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(PB_Ratio(80));
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(PB_Ratio(112), PB_Ratio(110)));
    }];
    [self.pb_t_de_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.pb_t_de_logoImageView.mas_bottom).offset(PB_Ratio(10));
    }];
    [self.pb_t_de_funButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pb_t_de_logoImageView.mas_bottom).offset(PB_Ratio(64));
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(PB_SW - PB_Ratio(86) * 2);
        make.height.mas_equalTo(PB_Ratio(44));
    }];
}

- (UIImageView *)pb_t_de_logoImageView {
    if(!_pb_t_de_logoImageView){
        _pb_t_de_logoImageView = [[UIImageView alloc] initWithImage:UIImageMake(@"icon_no record")];
    }
    return _pb_t_de_logoImageView;
}

- (QMUILabel *)pb_t_de_tipLabel {
    if(!_pb_t_de_tipLabel){
        _pb_t_de_tipLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"No records" color:PB_Gray_1_Color font:UIFontMake(PB_Ratio(16)) alignment:NSTextAlignmentLeft lines:1];
    }
    return _pb_t_de_tipLabel;
}

- (UIButton *)pb_t_de_funButton {
    if(!_pb_t_de_funButton){

        _pb_t_de_funButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        _pb_t_de_funButton.backgroundColor = PP_AppColor;
        _pb_t_de_funButton.layer.cornerRadius = PB_Ratio(22);
        _pb_t_de_funButton.layer.masksToBounds = YES;
        [_pb_t_de_funButton setTitle:@"Apply Now" forState:UIControlStateNormal];
        _pb_t_de_funButton.titleLabel.font = UIFontMediumMake(PB_Ratio(16));
        [_pb_t_de_funButton setTitleColor:PB_WhiteColor forState:UIControlStateNormal];
        [_pb_t_de_funButton addTarget:self action:@selector(pb_t_funcButtonSenderTap:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _pb_t_de_funButton;
}

- (void)pb_t_funcButtonSenderTap:(QMUIButton *)button {
    if(self.delegate && [self.delegate respondsToSelector:@selector(PB_T_OrderEmptyTableViewCellTapAction_de)]){
        [self.delegate PB_T_OrderEmptyTableViewCellTapAction_de];
    }
}

@end
