//
//  PB_PayReturnAlertView.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/8.
//

#import "PB_PayReturnAlertView.h"

@implementation PB_PayReturnAlertView

- (instancetype)init {
    self = [super init];
    if(self){
        self.backgroundColor = UIColor.clearColor;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.frame = CGRectMake(0, 0, PB_SW - PB_Ratio(36)*2, PB_SH);
    UIView *pb_t_debgView = [PB_UI pb_creat_ViewWithFrame:CGRectZero color:PB_WhiteColor radius:PB_Ratio(20)];
    //
    UIImageView *pb_t_deheaderV = [[UIImageView alloc] initWithImage:UIImageMake(@"payBackTipLogo")];
    //
    NSString *title = @"Payment reminder";
    QMUILabel *pb_t_detitleLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:title color:PB_yiBanBlackColor font:UIFontMediumMake(PB_Ratio(22)) alignment:NSTextAlignmentCenter lines:0];
    //
    NSString *content = @"You have unpaid debt.\n Please pay to time to not affect credit.";
    QMUILabel *pb_t_decontentLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:content color:PB_Color(@"#6D707A") font:UIFontMake(PB_Ratio(14)) alignment:NSTextAlignmentCenter lines:0];
    pb_t_decontentLabel.qmui_lineHeight = PB_Ratio(20);
    //
    QMUIButton *pb_t_desubmitButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
    pb_t_desubmitButton.backgroundColor = PP_AppColor;
    pb_t_desubmitButton.layer.cornerRadius = PB_Ratio(24);
    pb_t_desubmitButton.layer.masksToBounds = YES;
    [pb_t_desubmitButton setTitle:@"Repayment" forState:UIControlStateNormal];
    pb_t_desubmitButton.titleLabel.font = UIFontMediumMake(PB_Ratio(18));
    [pb_t_desubmitButton setTitleColor:PB_WhiteColor forState:UIControlStateNormal];
    [pb_t_desubmitButton addTarget:self action:@selector(buttonSenderTap:) forControlEvents:UIControlEventTouchUpInside];
    pb_t_desubmitButton.tag = 50;
    //
    QMUIButton *pb_t_decloseBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    pb_t_decloseBtn.backgroundColor = UIColor.clearColor;
    [pb_t_decloseBtn setImage:[UIImage imageNamed:@"icon_close_x"] forState:UIControlStateNormal];
    [pb_t_decloseBtn setImage:[UIImage imageNamed:@"icon_close_x"] forState:UIControlStateHighlighted];
    [pb_t_decloseBtn addTarget:self action:@selector(buttonSenderTap:) forControlEvents:UIControlEventTouchUpInside];
    pb_t_decloseBtn.tag = 51;

    
    [self addSubview:pb_t_debgView];
    [self addSubview:pb_t_deheaderV];
    [pb_t_debgView addSubview:pb_t_detitleLabel];
    [pb_t_debgView addSubview:pb_t_decontentLabel];
    [pb_t_debgView addSubview:pb_t_desubmitButton];
    [self addSubview:pb_t_decloseBtn];
    [pb_t_debgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_offset(-PB_Ratio(30));
        make.width.mas_equalTo(PB_SW - PB_Ratio(36) *2);
    }];

    [pb_t_deheaderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pb_t_debgView.mas_top).offset(-PB_Ratio(58));
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(PB_Ratio(196));
        make.height.mas_equalTo(PB_Ratio(150));
    }];
    
    pb_t_detitleLabel.preferredMaxLayoutWidth = PB_SW - PB_Ratio(52)*2;
    [pb_t_decontentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(PB_Ratio(131));
        make.centerX.mas_equalTo(0);
    }];

    pb_t_decontentLabel.preferredMaxLayoutWidth = PB_SW - PB_Ratio(52)*2;
    [pb_t_decontentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pb_t_detitleLabel.mas_bottom).offset(PB_Ratio(11));
        make.centerX.mas_equalTo(0);
    }];
    [pb_t_desubmitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pb_t_decontentLabel.mas_bottom).offset(PB_Ratio(25));
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(PB_Ratio(48));
        make.bottom.mas_offset(0);
    }];
    [pb_t_decloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pb_t_debgView.mas_bottom).offset(PB_Ratio(24));
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(PB_Ratio(34));
    }];
    
}

- (void)buttonSenderTap:(QMUIButton *)button{
    NSInteger tag = button.tag;
    if(_myBlock){
        _myBlock(tag);
    }
}

@end
