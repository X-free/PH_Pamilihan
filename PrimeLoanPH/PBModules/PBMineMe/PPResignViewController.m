//
//  PPResignViewController.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/11/1.
//

#import "PPResignViewController.h"

@interface PPResignViewController ()

@property (nonatomic, assign) UIButton *pb_t_resignButton;
@property (nonatomic, assign) UIButton *pb_t_agreeButton;

@end

@implementation PPResignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self ppInit];
    self.showNavBar = YES;
    self.navTitle = @"Account cancellation";
    self.showBackBtn = YES;
}

- (void)ppInit {
    
    NSString *descStr = @"The account cannot be restored after cancellation. \n To ensure the safety of your account please confirm that the services related to the account are in order before the application and pay attention to the following conditions:";
    QMUILabel *pb_t_descLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:descStr color:PB_yiBanBlackColor font:UIFontMake(PB_Ratio(15)) alignment:NSTextAlignmentLeft lines:0];
    pb_t_descLabel.contentEdgeInsets = UIEdgeInsetsMake(PB_Ratio(24), PB_Ratio(20), PB_Ratio(24), PB_Ratio(20));
    pb_t_descLabel.layer.cornerRadius = PB_Ratio(12);
    pb_t_descLabel.layer.masksToBounds = YES;
    pb_t_descLabel.qmui_lineHeight = PB_Ratio(25);
    pb_t_descLabel.backgroundColor = PB_WhiteColor;
    [self.view addSubview:pb_t_descLabel];
    [pb_t_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(PB_NaviBa_H + PB_Ratio(15));
        make.left.mas_equalTo(PB_Ratio(15));
        make.right.mas_offset(-PB_Ratio(15));
    }];
    
    UIView *pb_t_tipBgView = [PB_UI pb_creat_ViewWithFrame:CGRectZero color:PB_WhiteColor radius:PB_Ratio(12)];
    [self.view addSubview:pb_t_tipBgView];
    [pb_t_tipBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(pb_t_descLabel);
        make.top.mas_equalTo(pb_t_descLabel.mas_bottom).offset(PB_Ratio(15));
        make.height.mas_equalTo(PB_Ratio(68));
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = UIColor.clearColor;
    btn.layer.cornerRadius = PB_Ratio(10);
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"All loans are settled" forState:UIControlStateNormal];
    btn.titleLabel.font = UIFontMake(PB_Ratio(15));
    [btn setTitleColor:PB_Color(@"#BC6B2B") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(nullAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [btn setImage:UIImageMake(@"icon_warn_brown") forState:UIControlStateNormal];
    btn.layer.cornerRadius = PB_Ratio(10);
    btn.layer.borderColor = PB_Color(@"#E8E8E8").CGColor;
    btn.layer.borderWidth = PB_Ratio(1);
    btn.layer.masksToBounds = YES;
    btn.userInteractionEnabled = NO;

    [pb_t_tipBgView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(PB_Ratio(10), PB_Ratio(20), PB_Ratio(10), PB_Ratio(20)));
    }];
    
    UIButton *pb_t_resignButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pb_t_resignButton.backgroundColor = PP_AppColor;
    pb_t_resignButton.layer.cornerRadius = PB_Ratio(22);
    pb_t_resignButton.layer.masksToBounds = YES;
    [pb_t_resignButton setTitle:@"Account cancellation" forState:UIControlStateNormal];
    pb_t_resignButton.titleLabel.font = UIFontMediumMake(PB_Ratio(16));
    [pb_t_resignButton setTitleColor:PB_WhiteColor forState:UIControlStateNormal];
    [pb_t_resignButton addTarget:self action:@selector(pb_t_resignButtonSendAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:pb_t_resignButton];
    _pb_t_resignButton = pb_t_resignButton;
    [pb_t_resignButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-PB_BottomBarXH - PB_Ratio(48));
        make.left.mas_equalTo(PB_Ratio(47));
        make.right.mas_offset(-PB_Ratio(47));
        make.height.mas_equalTo(PB_Ratio(44));
    }];
    //    
    QMUIButton *pb_t_agreeButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
    pb_t_agreeButton.backgroundColor = UIColor.clearColor;

    [pb_t_agreeButton setImage:[UIImage imageNamed:@"signin_icon_select"] forState:UIControlStateNormal];
    [pb_t_agreeButton setImage:[UIImage imageNamed:@"signin_icon_select"] forState:UIControlStateHighlighted];
    [pb_t_agreeButton addTarget:self action:@selector(pb_t_agreeButtonSendAction:) forControlEvents:UIControlEventTouchUpInside];

    [pb_t_agreeButton setImage:UIImageMake(@"signin_icon_selected") forState:UIControlStateSelected];
    pb_t_agreeButton.spacingBetweenImageAndTitle = PB_Ratio(10);
    [self.view addSubview:pb_t_agreeButton];
    [pb_t_agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pb_t_resignButton);
        make.top.mas_equalTo(pb_t_resignButton.mas_bottom).offset(PB_Ratio(5));
        make.width.height.mas_equalTo(PB_Ratio(21));
    }];
    pb_t_agreeButton.selected = NO;
    _pb_t_agreeButton = pb_t_agreeButton;
    
    QMUIButton *pb_t_agreeShowButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
    NSString *agreeStr = @"I have read and agree to the above. ";
    NSString *agreeStr1 = @"Loan Agreement";
    NSAttributedString *attri = [PPTools pb_t_attriStringWithHexString:agreeStr1 totalStr:agreeStr norColor:PB_Gray_1_Color attriColor:PP_AppColor norFont:UIFontMake(PB_Ratio(12)) attriFont:UIFontMake(PB_Ratio(12)) underline:YES];
    pb_t_agreeShowButton.titleLabel.numberOfLines = 0;
    [pb_t_agreeShowButton setAttributedTitle:attri forState:UIControlStateNormal];
    [pb_t_agreeShowButton addTarget:self action:@selector(pp_agreeShow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pb_t_agreeShowButton];
    [pb_t_agreeShowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pb_t_agreeButton.mas_right);
        make.centerY.mas_equalTo(pb_t_agreeButton);
        make.width.mas_lessThanOrEqualTo(PB_SW - PB_Ratio(60));
    }];
    [self pb_t_refreshButtonState_de];
}

- (void)nullAction{
    
}

- (void)pp_agreeShow {
    [PB_APP_Control pb_t_goToModuleWithJudgeTypeStr:url_h5Agree fromVC:self];
}

- (void)pb_t_resignButtonSendAction:(UIButton *)button {
    [QMUITips showLoading:PBLoading_TipMsg inView:self.view];
    [[PB_RequestHelper pb_instance] pb_getRequestWithUrlStr:PBURL_cancelationUrl params:@{} commplete:^(id  _Nullable result, NSInteger statusCode) {
        [QMUITips hideAllTips];
        [PB_APP_Control pb_t_toLogoutAntToHomeMyAccount];
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
        [QMUITips showError:errorStr inView:self.view];
        [PB_APP_Control pb_t_toLogoutAntToHomeMyAccount];
    }];
}


- (void)pb_t_agreeButtonSendAction:(UIButton *)button{
    button.selected = !button.selected;
    [self pb_t_refreshButtonState_de];
}

- (void)pb_t_refreshButtonState_de{
    _pb_t_resignButton.enabled = _pb_t_agreeButton.selected;
}


@end
