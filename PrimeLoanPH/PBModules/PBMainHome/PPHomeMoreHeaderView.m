//
//  PPHomeMoreHeaderView.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/30.
//

#import "PPHomeMoreHeaderView.h"
#import "PPHomeModel.h"

@interface PPHomeMoreHeaderView ()

@property (nonatomic, copy) void(^tapBack)(NSInteger pId);
@property (nonatomic, strong) UIImageView *pb_t_cardImgV;

@property (nonatomic, assign) QMUILabel *pb_t_moneyLabel;
@property (nonatomic, assign) QMUILabel *pb_t_rateLabel;
@property (nonatomic, assign) UIButton *pb_t_enterButton;
@property (nonatomic, assign) UIImageView *pb_t_rateImgV;
@property (nonatomic, strong) PPHomeConclusionModel *pModel;
@property (nonatomic, strong) PPHomeEthnicModel *pAgreeModel;

@property (nonatomic, assign) QMUIButton *pb_t_agreebutton;



@end

@implementation PPHomeMoreHeaderView

- (instancetype)initTapBlock:(void (^)(NSInteger))tapBlock {
    self = [super init];
    if(self){
        _tapBack = tapBlock;
        [self ppInit];
    }
    return self;
    
}

- (void)pp_configAgreeData:(id)data {
    
    if([data isKindOfClass:PPHomeEthnicModel.class]){
        PPHomeEthnicModel *model = (PPHomeEthnicModel *)data;
        self.pAgreeModel = model;
        self.pb_t_agreebutton.hidden = YES;
        if([NSString PB_CheckStringIsEmpty:model.funds] == NO){
            self.pb_t_agreebutton.hidden = NO;
        }
    }
}

- (void)pp_configData:(id)data {
    if([data isKindOfClass:[PPHomeConclusionModel class]])
    {
        PPHomeConclusionModel *model = (PPHomeConclusionModel *)data;
        self.pModel = model;
        
        NSString *pb_t_amountStr = PBStrFormat(model.voice);
        NSString *amountUnit = @"₱";
        if([pb_t_amountStr containsString:@"₱"]){
            NSAttributedString *attri = [PPTools pb_t_attriStringWithHexString:amountUnit totalStr:pb_t_amountStr norColor:PB_TitleColor attriColor:PB_TitleColor norFont:UIFontBoldMake(PB_Ratio(46)) attriFont:UIFontBoldMake(PB_Ratio(32)) underline:NO];
            self.pb_t_moneyLabel.attributedText = attri;
        }else{
            self.pb_t_moneyLabel.text = pb_t_amountStr;
        }
        [self.pb_t_enterButton setTitle:PBStrFormat(model.lobbying) forState:UIControlStateNormal];
        NSString *rate =  PBStrFormat(model.opposition);
        CGFloat pb_t_rate_width = [PPTools pb_to_getStrWidth:rate height:PB_Ratio(20) font:PB_Ratio(12)];
        self.pb_t_rateLabel.text = rate;
        [self.pb_t_rateImgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(pb_t_rate_width + PB_Ratio(14));
        }];
    }
}

- (void)ppInit {
    self.backgroundColor = PB_HomeBackColor;
    CGFloat pb_t_height = PB_SW * 414/375.0;
    self.frame = CGRectMake(0, 0, PB_SW, pb_t_height);
    [self addSubview:self.pb_t_cardImgV];
}

- (UIImageView *)pb_t_cardImgV {
    if(!_pb_t_cardImgV){
        
        CGFloat height = PB_SW * 414/375.0;
        _pb_t_cardImgV = [PB_UI pb_create_imageViewWhihFrame:CGRectMake(0, 0, PB_SW, height) imgName:@"home_small_bg" cornerRadius:0];
        _pb_t_cardImgV.userInteractionEnabled = YES;
        [_pb_t_cardImgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardImageViewTap:)]];
        //
        UIImageView *iconV = [[UIImageView alloc] initWithImage:UIImageMake(@"icon_Hi")];
        //
        QMUILabel *pHelloLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"Welcome!" color:PB_WhiteColor font:UIFontBoldMake(PB_Ratio(20)) alignment:NSTextAlignmentLeft lines:1];
        //
        QMUILabel *pTitleLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"Loan amount" color:PB_ShouYeTitleColor font:UIFontMediumMake(PB_Ratio(16)) alignment:NSTextAlignmentLeft lines:1];
        //
        QMUILabel *pb_t_moneyLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@" " color:PB_TitleColor font:UIFontBoldMake(PB_Ratio(46)) alignment:NSTextAlignmentLeft lines:1];
        //
        UIButton *pb_t_enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pb_t_enterButton.backgroundColor = PP_AppColor;
        pb_t_enterButton.layer.cornerRadius = PB_Ratio(24);
        pb_t_enterButton.layer.masksToBounds = YES;
        [pb_t_enterButton setTitle:@"Apply Now" forState:UIControlStateNormal];
        pb_t_enterButton.titleLabel.font = UIFontMediumMake(PB_Ratio(18));
        [pb_t_enterButton setTitleColor:PB_WhiteColor forState:UIControlStateNormal];
        [pb_t_enterButton addTarget:self action:@selector(enterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        pb_t_enterButton.userInteractionEnabled = NO;
        //
        UIImageView *pb_t_rateImgV = [[UIImageView alloc] initWithImage:UIImageMake(@"rate_bg")];
        QMUILabel *pb_t_rateLabel =  [PB_UI pb_create_LabelWithFrame:CGRectZero title:@" " color:PB_ChengSeOrangeColor font:UIFontBoldMake(PB_Ratio(12)) alignment:NSTextAlignmentCenter lines:1];
        //
        NSString *agree = @"I have read and agree to the Loan Agreement ";
        NSString *agree1 = @"Loan Agreement ";
        QMUIButton *pb_t_agreebutton = [[QMUIButton alloc] init];
        [pb_t_agreebutton addTarget:self action:@selector(agreeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        NSAttributedString *attri = [PPTools pb_t_attriStringWithHexString:agree1 totalStr:agree norColor:PB_Gray_1_Color attriColor:PP_AppColor norFont:UIFontMake(PB_Ratio(12)) attriFont:UIFontMake(PB_Ratio(12)) underline:YES];
        pb_t_agreebutton.titleLabel.attributedText = attri;
        
        [_pb_t_cardImgV addSubview:iconV];
        [_pb_t_cardImgV addSubview:pHelloLabel];
        [_pb_t_cardImgV addSubview:pTitleLabel];
        [_pb_t_cardImgV addSubview:pb_t_moneyLabel];
        [_pb_t_cardImgV addSubview:pb_t_enterButton];
        [_pb_t_cardImgV addSubview:pb_t_rateImgV];
        [pb_t_rateImgV addSubview:pb_t_rateLabel];
        [_pb_t_cardImgV addSubview:pb_t_agreebutton];
        _pb_t_agreebutton = pb_t_agreebutton;
        _pb_t_agreebutton.hidden = YES;
        
        _pb_t_moneyLabel = pb_t_moneyLabel;
        _pb_t_enterButton = pb_t_enterButton;
        _pb_t_rateLabel = pb_t_rateLabel;
        _pb_t_rateImgV = pb_t_rateImgV;
        
        [iconV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(PB_Ratio(15));
            make.top.mas_equalTo(PB_Ratio(65));
            make.width.height.mas_equalTo(PB_Ratio(41));
        }];
        [pHelloLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconV.mas_right).offset(PB_Ratio(14));
            make.centerY.mas_equalTo(iconV);
        }];
        [pTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(PB_Ratio(209));
        }];
        [pb_t_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(pTitleLabel.mas_bottom).offset(PB_Ratio(2));
        }];
        [pb_t_enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(-PB_Ratio(48));
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(PB_SW - PB_Ratio(46)*2);
            make.height.mas_equalTo(PB_Ratio(46));
        }];
        [pb_t_agreebutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(pb_t_enterButton.mas_bottom).offset(PB_Ratio(9));
        }];
        
        [pb_t_rateImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(pb_t_enterButton.mas_right);
            make.top.mas_equalTo(pb_t_enterButton.mas_top).offset(-PB_Ratio(15));
            make.width.mas_equalTo(PB_Ratio(51));
            make.height.mas_equalTo(PB_Ratio(35));
        }];
        [pb_t_rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_offset(-PB_Ratio(3));
        }];
        
    }
    return _pb_t_cardImgV;
}

- (void)enterButtonAction:(UIButton *)button {
    
}

- (void)agreeButtonAction:(QMUIButton *)button {
    NSString *url = PBStrFormat(self.pAgreeModel.funds);
    [PB_APP_Control pb_t_goToModuleWithJudgeTypeStr:url fromVC:[PB_GetVC pb_to_getCurrentViewController]];
}

- (void)cardImageViewTap:(UITapGestureRecognizer *)gesture{
    if(_tapBack && self.pModel){
        _tapBack(self.pModel.pivotal);
    }
}


@end
