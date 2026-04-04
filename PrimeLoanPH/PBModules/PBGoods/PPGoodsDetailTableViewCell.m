//
//  PPGoodsDetailTableViewCell.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/31.
//

#import "PPGoodsDetailTableViewCell.h"
#import "PPDetailModel.h"


@interface PPGoodsDetailTableViewCell ()

@property (nonatomic, strong) UIView *pb_t_de_bgView;
@property (nonatomic, strong) UIImageView *pb_t_de_pLogoImgV;
@property (nonatomic, strong) QMUILabel *pb_t_de_pTitleLabel;
@property (nonatomic, strong) UIImageView *pb_t_de_pStateImgV;

@end

@implementation PPGoodsDetailTableViewCell

- (void)pb_initUI {
    [self.contentView addSubview:self.pb_t_de_bgView];
    [self.pb_t_de_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}


- (void)pb_configWithCellData:(id)data {
    //产品详情
    if([data isKindOfClass:PPDetailValuingModel.class]){
        PPDetailValuingModel *model = (PPDetailValuingModel *)data;
        [PPTools PB_loadUrl_ImageView:self.pb_t_de_pLogoImgV urlStr:PBStrFormat(model.goals) holdImg:@"logo_Group"];
        self.pb_t_de_pTitleLabel.text = PBStrFormat(model.age);
        if(model.acknowledges == 1){
            self.pb_t_de_pStateImgV.image = UIImageMake(@"signin_icon_selected");
        }else{
            self.pb_t_de_pStateImgV.image = UIImageMake(@"icon_more_gray");
        }
    }
}

- (UIView *)pb_t_de_bgView {
    if(!_pb_t_de_bgView){
        _pb_t_de_bgView = [PB_UI pb_creat_ViewWithFrame:CGRectZero color:PB_WhiteColor];
        //
        _pb_t_de_pLogoImgV = [[UIImageView alloc] initWithImage:UIImageMake(@"logo_Group")];
        _pb_t_de_pLogoImgV.layer.cornerRadius = PB_Ratio(8);
        _pb_t_de_pLogoImgV.layer.masksToBounds = YES;
        [_pb_t_de_bgView addSubview:self.pb_t_de_pLogoImgV];
        //
        _pb_t_de_pTitleLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"" color:PB_Color(@"#262626") font:UIFontMake(PB_Ratio(16)) alignment:NSTextAlignmentLeft lines:1];
        [_pb_t_de_bgView addSubview:self.pb_t_de_pTitleLabel];
        //
        _pb_t_de_pStateImgV = [[UIImageView alloc] initWithImage:UIImageMake(@"icon_more_gray")];
        [_pb_t_de_bgView addSubview:self.pb_t_de_pStateImgV];
        
        [self.pb_t_de_pLogoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(PB_Ratio(30));
            make.top.mas_equalTo(PB_Ratio(7));
            make.width.height.mas_equalTo(PB_Ratio(44));
        }];
        self.pb_t_de_pTitleLabel.preferredMaxLayoutWidth = PB_SW - PB_Ratio(153);
        [self.pb_t_de_pTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.pb_t_de_pLogoImgV.mas_right).offset(PB_Ratio(15));
            make.centerY.mas_equalTo(self.pb_t_de_pLogoImgV);
        }];
        [self.pb_t_de_pStateImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-PB_Ratio(30));
            make.centerY.mas_equalTo(self.pb_t_de_pLogoImgV);
            make.width.mas_equalTo(PB_Ratio(24));
            make.height.mas_equalTo(PB_Ratio(24));
        }];
    }
    return _pb_t_de_bgView;
}

@end
