//
//  PPHomeHeaderView.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/30.
//

#import "PPHomeHeaderView.h"
#import "PPHomeModel.h"
#import <SDCycleScrollView/SDCycleScrollView.h>


@interface PPHomeHeaderView ()

@property (nonatomic, copy) void(^tapBack)(NSInteger pId);
@property (nonatomic, strong) UIImageView *cardImgV;
@property (nonatomic, assign) UILabel *pb_t_MoneyLabel;
@property (nonatomic, assign) UILabel *pb_t_RateLabel;
@property (nonatomic, assign) UILabel *pb_t_TermLabel;
@property (nonatomic, assign) UILabel *pb_t_AmountTitleLabel;


@property (nonatomic, assign) UIButton *pb_t_EnterButton;
@property (nonatomic, strong) PPHomeConclusionModel *pModel;
@property (nonatomic, strong) PPHomeEthnicModel *pAgreeModel;


@end

@implementation PPHomeHeaderView

- (instancetype)initTapBlock:(void (^)(NSInteger))tapBlock {
    self = [super init];
    if(self){
        _tapBack = tapBlock;
        [self ppInit];
    }
    return self;
    
}

- (void)pp_configMsgData:(id)data {
    if([data isKindOfClass:PPHomeModel.class]){
        PPHomeModel *pb_t_de_model = (PPHomeModel *)data;
    }
}

- (void)pp_configAgreeData:(id)data {
    
    if([data isKindOfClass:PPHomeEthnicModel.class]){
        PPHomeEthnicModel *pb_t_de_model = (PPHomeEthnicModel *)data;

    }
}

- (void)pp_configData:(id)data {
    if([data isKindOfClass:[PPHomeConclusionModel class]])
    {
        PPHomeConclusionModel *pb_t_de_model = (PPHomeConclusionModel *)data;
        self.pModel = pb_t_de_model;
        NSString *amountStr = PBStrFormat(pb_t_de_model.voice);
        NSString *amountUnit = @"₱";
        if([amountStr containsString:@"₱"]){
            NSAttributedString *attri = [PPTools pb_t_attriStringWithHexString:amountUnit totalStr:amountStr norColor:PB_TitleColor attriColor:PB_TitleColor norFont:UIFontBoldMake(PB_Ratio(46)) attriFont:UIFontBoldMake(PB_Ratio(32)) underline:NO];
            self.pb_t_MoneyLabel.attributedText = attri;
        }else{
            self.pb_t_MoneyLabel.text = amountStr;
        }
        self.pb_t_TermLabel.text = [NSString stringWithFormat:@"%@",pb_t_de_model.naldic];
        self.pb_t_RateLabel.text = [NSString stringWithFormat:@"%@",pb_t_de_model.opposition];
        [self.pb_t_EnterButton setTitle:PBStrFormat(pb_t_de_model.lobbying) forState:UIControlStateNormal];
        self.pb_t_AmountTitleLabel.text = PBStrFormat(pb_t_de_model.powerful);
    }
    
}

- (void)ppInit {
    
    CGFloat bgImgOfH =  (PB_SW *426/375.0  - 44 + PBStatusBar_H);
    UIImageView *bgGradientImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rectangle 3641"]];
    [self addSubview:bgGradientImgV];
    bgGradientImgV.frame = CGRectMake(0, 0, PB_SW, bgImgOfH);
    
    self.backgroundColor = PB_Color(@"#F4F5F9");
    self.frame = CGRectMake(0, 0, PB_SW, bgImgOfH);
    //
    UIImageView *iconV = [[UIImageView alloc] initWithImage:UIImageMake(@"Group 1171275880")];
    iconV.mj_size = CGSizeMake(PB_Ratio(125), PB_Ratio(30));
    iconV.center = CGPointMake(PB_SW/2, PBStatusBar_H + PB_Ratio(25));
    [self addSubview:iconV];

    [self addSubview:self.cardImgV];
}

- (UIImageView *)cardImgV {
    if(!_cardImgV){
        //背景图片
        CGFloat height = (PB_SW-PB_Ratio(5)*2) * 336/365.0;
        _cardImgV = [[UIImageView alloc] initWithFrame:CGRectMake(PB_Ratio(5), PBStatusBar_H + PB_Ratio(50), PB_SW - PB_Ratio(5)*2, height)];
        _cardImgV.image = [UIImage imageNamed:@"Group 1171276130"];
        _cardImgV.userInteractionEnabled = YES;
        [_cardImgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardImageViewTap:)]];
        //大标题
        UILabel *daBTLabel = [[UILabel alloc] init];
        daBTLabel.text = @"Loan amount(₱)";
        daBTLabel.font = UIFontMediumMake(12);
        daBTLabel.textColor =  [UIColor whiteColor];
        daBTLabel.mj_size = CGSizeMake(200, PB_Ratio(20));
        daBTLabel.center = CGPointMake(CGRectGetWidth(_cardImgV.frame)/2, PB_Ratio(88));
        daBTLabel.textAlignment = NSTextAlignmentCenter;
        [_cardImgV addSubview:daBTLabel];
        _pb_t_AmountTitleLabel = daBTLabel;
        

    
        //
        QMUILabel *pb_t_MoneyLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"0.00" color:[UIColor whiteColor] font:UIFontBoldMake(PB_Ratio(36)) alignment:NSTextAlignmentCenter lines:1];
        pb_t_MoneyLabel.mj_size = CGSizeMake(200, PB_Ratio(59));
        pb_t_MoneyLabel.center = CGPointMake(CGRectGetWidth(_cardImgV.frame)/2, PB_Ratio(134));
        [_cardImgV addSubview:pb_t_MoneyLabel];
        _pb_t_MoneyLabel = pb_t_MoneyLabel;
       
        

        //term name
        {
            UILabel *daBTLabel = [[UILabel alloc] init];
            daBTLabel.text = @"Loan Term";
            daBTLabel.font = UIFontMake(14);
            daBTLabel.textColor =  PB_Color(@"#666666");
            daBTLabel.mj_size = CGSizeMake(SCREEN_WIDTH/2, PB_Ratio(20));
            daBTLabel.center = CGPointMake(CGRectGetWidth(_cardImgV.frame)/4, PB_Ratio(210));

            daBTLabel.textAlignment = NSTextAlignmentCenter;
            [_cardImgV addSubview:daBTLabel];
           
        }
        //term value
        {
            UILabel *daBTLabel = [[UILabel alloc] init];
            daBTLabel.text = @" ";
            daBTLabel.font = UIFontBoldMake(16);
            daBTLabel.textColor =  PB_yiBanBlackColor;
            [_cardImgV addSubview:daBTLabel];
            daBTLabel.textAlignment = NSTextAlignmentCenter;
            daBTLabel.mj_size = CGSizeMake(SCREEN_WIDTH/2, PB_Ratio(22));
            daBTLabel.center = CGPointMake(CGRectGetWidth(_cardImgV.frame)/4, PB_Ratio(230));
            _pb_t_TermLabel = daBTLabel;
        }
        //rate name
        {
            UILabel *daBTLabel = [[UILabel alloc] init];
            daBTLabel.text = @"Interest Rate";
            daBTLabel.font = UIFontMake(14);
            daBTLabel.textColor =  PB_Color(@"#666666");
            daBTLabel.textAlignment = NSTextAlignmentCenter;
            daBTLabel.mj_size = CGSizeMake(SCREEN_WIDTH/2, PB_Ratio(20));
            daBTLabel.center = CGPointMake(CGRectGetWidth(_cardImgV.frame)*3/4, PB_Ratio(210));
            [_cardImgV addSubview:daBTLabel];
            

        }
        // rate vlaue
        {
            UILabel *daBTLabel = [[UILabel alloc] init];
            daBTLabel.text = @" ";
            daBTLabel.font = UIFontBoldMake(16);
            daBTLabel.textColor =  PB_yiBanBlackColor;
            daBTLabel.textAlignment = NSTextAlignmentCenter;
            daBTLabel.mj_size = CGSizeMake(SCREEN_WIDTH/2, PB_Ratio(22));
            daBTLabel.center = CGPointMake(CGRectGetWidth(_cardImgV.frame)*3/4, PB_Ratio(230));
            [_cardImgV addSubview:daBTLabel];
            _pb_t_RateLabel = daBTLabel;
        }

        //
        
        UIButton *pb_t_EnterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pb_t_EnterButton.backgroundColor = UIColor.clearColor;

        [pb_t_EnterButton setTitle:@"Apply Now" forState:UIControlStateNormal];
        pb_t_EnterButton.titleLabel.font = UIFontBoldMake(PB_Ratio(16));
        [pb_t_EnterButton setTitleColor:PB_WhiteColor forState:UIControlStateNormal];
        [pb_t_EnterButton addTarget:self action:@selector(enterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [pb_t_EnterButton setBackgroundImage:[UIImage imageNamed:@"bbbblue"] forState:UIControlStateNormal];
        pb_t_EnterButton = pb_t_EnterButton;
        pb_t_EnterButton.layer.cornerRadius = PB_Ratio(24);
        pb_t_EnterButton.clipsToBounds = YES;
        pb_t_EnterButton.userInteractionEnabled = NO;
        pb_t_EnterButton.frame = CGRectMake(PB_Ratio(47), CGRectGetHeight(_cardImgV.frame) - PB_Ratio(68), SCREEN_WIDTH - PB_Ratio(47)*2, PB_Ratio(48));
        [pb_t_EnterButton bringSubviewToFront:pb_t_EnterButton.titleLabel];
        [_cardImgV addSubview:pb_t_EnterButton];
        _pb_t_EnterButton = pb_t_EnterButton;


        
    }
    return _cardImgV;
}

- (void)enterButtonAction:(UIButton *)button {
    
}



- (void)cardImageViewTap:(UITapGestureRecognizer *)gesture{
    if(_tapBack && self.pModel){
        _tapBack(self.pModel.pivotal);
    }
}

@end
