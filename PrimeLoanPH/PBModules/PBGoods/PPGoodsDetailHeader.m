//
//  PPGoodsDetailHeader.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/31.
//

#import "PPGoodsDetailHeader.h"
#import "PPDetailModel.h"

@interface PPGoodsDetailHeader ()

@property (nonatomic, strong) UIImageView *pb_t_de_pBgImgV;
@property (nonatomic, assign) CGFloat bg_height;
@property (nonatomic, strong) UIImageView *pb_t_de_pLogoImgV;
@property (nonatomic, strong) QMUILabel *pb_t_de_pTitleLabel;
@property (nonatomic, strong) QMUILabel *pb_t_de_pMoneyLabel;
@property (nonatomic, strong) QMUILabel *pb_t_de_pDetailLabel;




@end

@implementation PPGoodsDetailHeader

- (instancetype)init {
    self = [super init];
    if(self){
        [self ppInit];
    }
    return self;
}

- (void)pp_configData:(id)data {
    if([data isKindOfClass:PPDetailModel.class]){
        PPDetailModel *mainModel = (PPDetailModel *)data;
        if(mainModel.theoretical.addressed){
            PPDetailAddressedModel *detailModel = mainModel.theoretical.addressed;
            [self.pb_t_de_pLogoImgV sd_setImageWithURL:[NSURL URLWithString:PBStrFormat(detailModel.networks)] placeholderImage:UIImageMake(@"logo_Group")];
            self.pb_t_de_pTitleLabel.text = PBStrFormat(detailModel.aiming);
      
            NSString *amountStr = [NSString stringWithFormat:@"%@%@",detailModel.trend,detailModel.issue];
            NSString *amountUnit = PBStrFormat(detailModel.trend);
            if([NSString PB_CheckStringIsEmpty:detailModel.trend] == NO && amountUnit.length > 0){
                NSAttributedString *attri = [PPTools pb_t_attriStringWithHexString:amountUnit totalStr:amountStr norColor:PB_WhiteColor attriColor:PB_WhiteColor norFont:UIFontBoldMake(PB_Ratio(44)) attriFont:UIFontBoldMake(PB_Ratio(32)) underline:NO];
                self.pb_t_de_pMoneyLabel.attributedText = attri;
            }else{
                self.pb_t_de_pMoneyLabel.text = amountStr;
            }
            
            
            if(mainModel.theoretical.addressed.rich && mainModel.theoretical.addressed.rich.can && mainModel.theoretical.addressed.rich.subtractive){
                PPDetailCanModel *canModel = mainModel.theoretical.addressed.rich.can;
                PPDetailSubtractiveModel *subtractiveModel = mainModel.theoretical.addressed.rich.subtractive;
                self.pb_t_de_pDetailLabel.text = [NSString stringWithFormat:@"%@ | %@",[canModel.view stringByReplacingOccurrencesOfString:@" " withString:@""],[subtractiveModel.view stringByReplacingOccurrencesOfString:@" " withString:@""]];
            }
        }
    }
}

- (void)ppInit{
    _bg_height = PB_SW *350/375.0;
    self.frame = CGRectMake(0, 0, PB_SW, _bg_height);
    //
    _pb_t_de_pBgImgV = [[UIImageView alloc] initWithImage:UIImageMake(@"detail_bg")];
    _pb_t_de_pBgImgV.frame = self.bounds;
    [self addSubview:self.pb_t_de_pBgImgV];
    
    _pb_t_de_pLogoImgV = [[UIImageView alloc] initWithImage:UIImageMake(@"logo_Group")];
    _pb_t_de_pLogoImgV.layer.cornerRadius = PB_Ratio(10);
    _pb_t_de_pLogoImgV.layer.masksToBounds = YES;
    [self.pb_t_de_pBgImgV addSubview:self.pb_t_de_pLogoImgV];
    
    _pb_t_de_pTitleLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"Loan amount" color:PB_WhiteColor font:UIFontMediumMake(PB_Ratio(16)) alignment:NSTextAlignmentLeft lines:1];
    [self.pb_t_de_pBgImgV addSubview:self.pb_t_de_pTitleLabel];
    
    UIImageView *moneyBgImgV = [[UIImageView alloc] initWithImage:UIImageMake(@"amount_bg")];
    moneyBgImgV.layer.masksToBounds = YES;
    [self.pb_t_de_pBgImgV addSubview:moneyBgImgV];
    
    _pb_t_de_pMoneyLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@" " color:PB_WhiteColor font:UIFontBoldMake(PB_Ratio(44)) alignment:NSTextAlignmentLeft lines:1];
    [self.pb_t_de_pBgImgV addSubview:self.pb_t_de_pMoneyLabel];
    
    _pb_t_de_pDetailLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@" " color:PB_WhiteColor font:UIFontMake(PB_Ratio(14)) alignment:NSTextAlignmentLeft lines:1];
    [self.pb_t_de_pBgImgV addSubview:self.pb_t_de_pDetailLabel];
    
    [self.pb_t_de_pLogoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PB_Ratio(30));
        make.top.mas_equalTo(PB_Ratio(123));
        make.width.height.mas_equalTo(PB_Ratio(44));
    }];
    self.pb_t_de_pTitleLabel.preferredMaxLayoutWidth = PB_SW - 30;
    [self.pb_t_de_pTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_offset(-PB_Ratio(149));
    }];
    self.pb_t_de_pMoneyLabel.preferredMaxLayoutWidth = PB_SW - 30;
    [self.pb_t_de_pMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.pb_t_de_pTitleLabel.mas_bottom).offset(PB_Ratio(3));
    }];
    [moneyBgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.pb_t_de_pMoneyLabel);
        make.width.mas_equalTo(PB_Ratio(130));
        make.height.mas_equalTo(PB_Ratio(35));
    }];
    [self.pb_t_de_pDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-PB_Ratio(30));
        make.bottom.mas_offset(-PB_Ratio(52));
    }];
}



@end
