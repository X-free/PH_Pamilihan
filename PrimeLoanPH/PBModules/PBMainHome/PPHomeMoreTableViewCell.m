//
//  PPHomeMoreTableViewCell.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/30.
//

#import "PPHomeMoreTableViewCell.h"
#import "PPHomeModel.h"

@interface PPHomeMoreTableViewCell ()

@property (nonatomic, strong) UIView *pb_t_de_pCardView;
@property (nonatomic, assign) UIImageView *pb_t_de_pLogoV;
@property (nonatomic, assign) QMUILabel *pb_t_de_pTitleLabel;
@property (nonatomic, assign) QMUILabel *pb_t_de_pMoneyLabel;
@property (nonatomic, assign) QMUILabel *pb_t_de_pRateLabel;
@property (nonatomic, assign) UIButton *pb_t_de_pApplyButton;

@end

@implementation PPHomeMoreTableViewCell


- (void)pb_initUI {
    self.contentView.backgroundColor = UIColor.clearColor;
    self.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.pb_t_de_pCardView];
    [self.pb_t_de_pCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, PB_Ratio(15), PB_Ratio(14), PB_Ratio(15)));
    }];
}

- (void)pb_configWithCellData:(id)data {
    if([data isKindOfClass:[PPHomeConclusionModel class]])
    {
        PPHomeConclusionModel *model = (PPHomeConclusionModel *)data;
        [PPTools PB_loadUrl_ImageView:self.pb_t_de_pLogoV urlStr:PBStrFormat(model.networks) holdImg:@"pLogo"];
        self.pb_t_de_pTitleLabel.text = PBStrFormat(model.courses);
        self.pb_t_de_pMoneyLabel.text = PBStrFormat(model.voice);
//        self.pb_t_de_pRateLabel.text = [NSString stringWithFormat:@"%@ | %@",model.naldic,model.announced];
        self.pb_t_de_pRateLabel.text = [NSString stringWithFormat:@"%@",model.announced];
        [self.pb_t_de_pApplyButton setTitle:PBStrFormat(model.lobbying) forState:UIControlStateNormal];
    }
}

- (UIView *)pb_t_de_pCardView {
    if(!_pb_t_de_pCardView){
        _pb_t_de_pCardView = [PB_UI pb_creat_ViewWithFrame:CGRectZero color:[UIColor whiteColor] radius:PB_Ratio(12)];
        //
        UIImageView *pb_t_de_pLogoV = [[UIImageView alloc] initWithImage:UIImageMake(@"pLogo")];
        pb_t_de_pLogoV.layer.cornerRadius = PB_Ratio(4);
        pb_t_de_pLogoV.layer.masksToBounds = YES;
        //
        QMUILabel *pb_t_de_pTitleLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"Marcus Nichols" color:PB_yiBanBlackColor font:UIFontMake(PB_Ratio(15)) alignment:NSTextAlignmentLeft lines:1];

        UIView *sepLine = [[UIView alloc] init];
        sepLine.backgroundColor = PB_Line_1_Color;
        [_pb_t_de_pCardView addSubview:sepLine];
        
        //
        QMUILabel *pb_t_de_pMoneyLabel= [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"₱10.000" color:PB_Color(@"#294A72") font:UIFontMake(PB_Ratio(17)) alignment:NSTextAlignmentLeft lines:1];
        QMUILabel *pb_t_de_pMoneyNameLabel= [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"Termo ng utang" color:PB_DetailTextColor font:UIFontMake(PB_Ratio(12)) alignment:NSTextAlignmentLeft lines:1];
        [_pb_t_de_pCardView addSubview:pb_t_de_pMoneyNameLabel];
        
        //
        QMUILabel *pb_t_de_pRateLabel= [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"0.05%" color:PB_Color(@"#294A72") font:UIFontMake(PB_Ratio(17)) alignment:NSTextAlignmentLeft lines:2];
        QMUILabel *pb_t_de_pRateNameLabel= [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"Interest rate" color:PB_DetailTextColor font:UIFontMake(PB_Ratio(12)) alignment:NSTextAlignmentLeft lines:1];
        [_pb_t_de_pCardView addSubview:pb_t_de_pRateNameLabel];

        
        UIButton *pb_t_de_pApplyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pb_t_de_pApplyButton.backgroundColor = PP_AppColor;
        pb_t_de_pApplyButton.layer.cornerRadius = PB_Ratio(14);
        pb_t_de_pApplyButton.layer.masksToBounds = YES;
        [pb_t_de_pApplyButton setTitle:@"Apply" forState:UIControlStateNormal];
        pb_t_de_pApplyButton.titleLabel.font = UIFontBoldMake(PB_Ratio(14));
        [pb_t_de_pApplyButton setTitleColor:PB_WhiteColor forState:UIControlStateNormal];
        [pb_t_de_pApplyButton addTarget:self action:@selector(applyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        pb_t_de_pApplyButton.contentEdgeInsets = UIEdgeInsetsMake(0, PB_Ratio(15), 0, PB_Ratio(15));
        pb_t_de_pApplyButton.userInteractionEnabled = NO;
        
        
        [_pb_t_de_pCardView addSubview:pb_t_de_pLogoV];
        [_pb_t_de_pCardView addSubview:pb_t_de_pTitleLabel];
        [_pb_t_de_pCardView addSubview:pb_t_de_pMoneyLabel];
        [_pb_t_de_pCardView addSubview:pb_t_de_pRateLabel];
        [_pb_t_de_pCardView addSubview:pb_t_de_pApplyButton];
         _pb_t_de_pLogoV = pb_t_de_pLogoV;
         _pb_t_de_pTitleLabel = pb_t_de_pTitleLabel;
         _pb_t_de_pMoneyLabel = pb_t_de_pMoneyLabel;
         _pb_t_de_pRateLabel = pb_t_de_pRateLabel;
         _pb_t_de_pApplyButton = pb_t_de_pApplyButton;
        
        [pb_t_de_pLogoV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(PB_Ratio(14));
            make.width.height.mas_equalTo(PB_Ratio(20));
        }];
        [pb_t_de_pTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(pb_t_de_pLogoV.mas_right).offset(8);
            make.centerY.mas_equalTo(pb_t_de_pLogoV);
        }];
        
        [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(PB_Ratio(49));
            make.height.mas_equalTo(PB_Ratio(1));
            make.left.mas_equalTo(PB_Ratio(15));
            make.right.mas_offset(-PB_Ratio(15));
        }];
        
        [pb_t_de_pMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(PB_Ratio(15));
            make.top.mas_equalTo(sepLine.mas_bottom).offset(PB_Ratio(12));
        }];
        pb_t_de_pRateLabel.preferredMaxLayoutWidth = PB_Ratio(120);
        pb_t_de_pRateLabel.adjustsFontSizeToFitWidth = YES;
        pb_t_de_pRateLabel.contentScaleFactor = 0.4f;
        
        [pb_t_de_pMoneyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(pb_t_de_pMoneyLabel);
            make.top.mas_equalTo(pb_t_de_pMoneyLabel.mas_bottom).offset(PB_Ratio(7));
        }];
        
        
        [pb_t_de_pRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_offset(+PB_Ratio(15));
            make.centerY.mas_equalTo(pb_t_de_pMoneyLabel);
        }];
        
        [pb_t_de_pRateNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(pb_t_de_pRateLabel);
            make.centerY.mas_equalTo(pb_t_de_pMoneyNameLabel);

        }];
        
        [pb_t_de_pApplyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-PB_Ratio(14));
            make.height.mas_equalTo(PB_Ratio(28));
            make.bottom.mas_offset(-PB_Ratio(22));
        }];
        
        
        
    }
    return _pb_t_de_pCardView;
}


- (void)applyButtonAction:(UIButton *)button {
    
}


@end
