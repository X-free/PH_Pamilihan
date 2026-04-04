//
//  PPLoginViewController.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/27.
//

#import "PPLoginViewController.h"
#import "PPSendCodeModel.h"

@interface PPLoginViewController ()

@property (nonatomic, copy) NSTimer *pb_t_de_timer;
@property (nonatomic, assign) NSInteger pb_t_de_timeAll;
@property (nonatomic, assign) QMUITextField *pb_t_de_codeTextField;
@property (nonatomic, assign) QMUITextField *pb_t_de_phoneTextField;
@property (nonatomic, assign) QMUIButton *pb_t_de_agreeButton;
@property (nonatomic, assign) QMUIButton *pb_t_de_loginButton;
@property (nonatomic, assign) QMUIButton *pb_t_de_smCodeButton;

@property (nonatomic, copy) NSString *pb_t_de_reportStartTime;
@property (nonatomic, copy) NSString *pb_t_de_reportEndTime;

@end

@implementation PPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self ppInit];
}



- (void)ppInit {
 
    [self setUI];
    [self setShowBackBtn:YES];
    [self setNavTitle:@"Login"];
    [[PB_idf_helper instanceOnly] pb_t_enquryIDFA_ask];
    
}

- (void)popController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - click
- (void)codeButtonClick:(QMUIButton *)button{
    [self sendCodeWithUrl:PBURL_loginMessageUrl];
}

- (void)sendCodeWithUrl:(NSString *)url {
    if(self.pb_t_de_phoneTextField.text.length == 0){
        [QMUITips showInfo:@"Please Fill in the phone number" inView:self.view hideAfterDelay:2];
        return;
    }
    NSDictionary *ppDic = @{
        @"questions":PBStrFormat(self.pb_t_de_phoneTextField.text)
    };

    [QMUITips showLoading:PBLoading_TipMsg inView:self.view];
    [[PB_RequestHelper pb_instance] pb_postRequestWithUrlStr:url params:ppDic commplete:^(NSDictionary * _Nullable result, NSInteger statusCode) {
        [self pp_reloadBeginTime];
        [QMUITips hideAllTips];
        if(result != nil){
            PPSendCodeModel *model = [PPSendCodeModel yy_modelWithJSON:result];
            if(model.theoretical.conclusion.own > 0){
                [self updateMsgCount:model.theoretical.conclusion.own];
            }else{
                [self updateMsgCount:60];
            }
            
            if(![NSString PB_CheckStringIsEmpty:model.concepts]){
                [QMUITips showSucceed:model.concepts inView:self.view];
            }
        }
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
        [QMUITips showError:errorStr inView:self.view];
        [self pp_reloadBeginTime];
    }];
}

- (void)pb_t_de_agreeButtonClick:(QMUIButton *)button {
    button.selected = !button.selected;
    [self updatepb_t_de_loginButtonState];
}

- (void)voiceButtonClick:(QMUIButton *)button{
    [self sendCodeWithUrl:PBURL_loginVoiceMessageUrl];
}

- (void)pb_t_de_loginButtonClick:(QMUIButton *)button {
    [self.view endEditing:YES];
    PMMyWeekSelf;
    [PB_APP_Control pb_t_requestToLoginWithPhone:self.pb_t_de_phoneTextField.text code:self.pb_t_de_codeTextField.text targetVC:self SuccessBlock:^(BOOL isSure) {
        //上传risk
        [weakSelf pb_t_toRePortRiskDataToServeFromStep];
    }];
}

- (void)pp_agreeShow {
    [PB_APP_Control pb_t_goToModuleWithJudgeTypeStr:url_h5Agree fromVC:self];
}

#pragma mark - risk
- (void)pp_reloadBeginTime {
    self.pb_t_de_reportStartTime = [PB_timeHelper pb_t_getCurrentStampTimeString];
}

- (void)pb_t_toRePortRiskDataToServeFromStep {
    self.pb_t_de_reportEndTime = [PB_timeHelper pb_t_getCurrentStampTimeString];
    NSDictionary *riskDict = @{
        @"speak":PBStrFormat(self.pb_t_de_reportStartTime),
        @"advantage":PBStrFormat(self.pb_t_de_reportEndTime),
        @"rejection":@"1"
    };
    [[PB_APP_Control instanceOnly] pb_t_toRePortRiskDataToServe:riskDict];
}



#pragma mark - lazy

- (void)setUI {
    
    self.pb_t_de_reportStartTime = @"";
    self.pb_t_de_reportEndTime = @"";
    self.view.backgroundColor = PB_WhiteColor;
    //
    UIView *pb_t_bg1 = [PB_UI pb_creat_ViewWithFrame:CGRectMake(PB_Ratio(15), PB_NaviBa_H + PB_Ratio(70), PB_SW - PB_Ratio(15)*2, PB_Ratio(48)) color:PB_WhiteColor radius:10];
    pb_t_bg1.layer.borderWidth = 1;
    pb_t_bg1.layer.borderColor = PB_Line_1_Color.CGColor;
    UIView *pb_t_bg2 = [PB_UI pb_creat_ViewWithFrame:CGRectMake(PB_Ratio(15), pb_t_bg1.qmui_bottom + PB_Ratio(30), PB_SW - PB_Ratio(15)*2, PB_Ratio(48)) color:PB_WhiteColor radius:10];
    pb_t_bg2.layer.borderWidth = 1;
    pb_t_bg2.layer.borderColor = PB_Line_1_Color.CGColor;
    [self.view addSubview:pb_t_bg1];
    [self.view addSubview:pb_t_bg2];
    //
    NSString *pb_t_phoneHeader = @"+63";
    if([PB_APP_Control instanceOnly].pb_t_serve_set_Language == 1){
        pb_t_phoneHeader = @"+91";
    }
    QMUILabel *phonePreLB = [PB_UI pb_create_LabelWithFrame:CGRectMake(0, 0, PB_Ratio(45), PB_Ratio(48)) title:pb_t_phoneHeader color:PB_shenBlackColor font:UIFontMake(PB_Ratio(16)) alignment:NSTextAlignmentRight lines:1];
    [pb_t_bg1 addSubview:phonePreLB];
    UIView *pb_t_lineV = [[UIView alloc] initWithFrame:CGRectMake(PB_Ratio(55), PB_Ratio(10), 1, PB_Ratio(28))];
    pb_t_lineV.backgroundColor = PB_Line_1_Color;
     
    [pb_t_bg1 addSubview:pb_t_lineV];
    QMUITextField *pb_t_phoneTF = [PB_UI pb_create_textFieldWithFrame:CGRectMake(PB_Ratio(67), 0, pb_t_bg1.qmui_width -PB_Ratio(82) , PB_Ratio(48)) bgColor:UIColor.clearColor placeholder:@"Fill in the phone number" textColor:PB_shenBlackColor font:UIFontMake(PB_Ratio(15)) cornerRadius:10 keyboardType:UIKeyboardTypePhonePad];
    [pb_t_bg1 addSubview:pb_t_phoneTF];
    //
    QMUITextField *pb_t_codeTF = [PB_UI pb_create_textFieldWithFrame:CGRectMake(PB_Ratio(16), 0, pb_t_bg1.qmui_width - PB_Ratio(145)-20 , PB_Ratio(48)) bgColor:UIColor.clearColor placeholder:@"Please enter the code" textColor:PB_shenBlackColor font:UIFontMake(PB_Ratio(15)) cornerRadius:10 keyboardType:UIKeyboardTypeNumberPad];
    [pb_t_bg2 addSubview:pb_t_codeTF];
    
    QMUIButton *pb_t_codeBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    pb_t_codeBtn.backgroundColor = PB_WhiteColor;
    [pb_t_codeBtn setTitle:@"Get a Code" forState:UIControlStateNormal];
    pb_t_codeBtn.titleLabel.font = UIFontMake(PB_Ratio(14));
    [pb_t_codeBtn setTitleColor:PP_AppColor forState:UIControlStateNormal];
    [pb_t_codeBtn addTarget:self action:@selector(codeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    pb_t_codeBtn.frame = CGRectMake(pb_t_bg1.qmui_width - PB_Ratio(145), 0, PB_Ratio(145), PB_Ratio(48));
    [pb_t_bg2 addSubview:pb_t_codeBtn];
    //
    QMUIButton *pb_t_voiceBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    pb_t_voiceBtn.backgroundColor = UIColor.clearColor;
    [pb_t_voiceBtn setTitle:@"VOZ？" forState:UIControlStateNormal];
    pb_t_voiceBtn.titleLabel.font = UIFontMake(PB_Ratio(16));
    [pb_t_voiceBtn setTitleColor:PP_AppColor forState:UIControlStateNormal];
    [pb_t_voiceBtn addTarget:self action:@selector(voiceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [pb_t_voiceBtn setImage:UIImageMake(@"icon_VOZ") forState:UIControlStateNormal];
    [pb_t_voiceBtn setImagePosition:QMUIButtonImagePositionLeft];
    [pb_t_voiceBtn setSpacingBetweenImageAndTitle:4];
    [self.view addSubview:pb_t_voiceBtn];
    [pb_t_voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pb_t_bg1);
        make.top.mas_equalTo(pb_t_bg2.mas_bottom).offset(10);
    }];


    QMUIButton *pb_t_de_loginButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
    pb_t_de_loginButton.layer.cornerRadius = PB_Ratio(22);
    pb_t_de_loginButton.layer.masksToBounds = YES;
    pb_t_de_loginButton.backgroundColor = PP_AppColor;

    [pb_t_de_loginButton setTitle:@"Login" forState:UIControlStateNormal];
    pb_t_de_loginButton.titleLabel.font = UIFontBoldMake(PB_Ratio(16));
    [pb_t_de_loginButton setTitleColor:PB_WhiteColor forState:UIControlStateNormal];
    [pb_t_de_loginButton addTarget:self action:@selector(pb_t_de_loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    pb_t_de_loginButton.frame = CGRectMake(PB_Ratio(25), pb_t_bg2.qmui_bottom + PB_Ratio(119), PB_SW - PB_Ratio(25)*2, PB_Ratio(44));
    [self.view addSubview:pb_t_de_loginButton];
    //    
    QMUIButton *pb_t_de_agreeButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
    pb_t_de_agreeButton.backgroundColor = UIColor.clearColor;
    pb_t_de_agreeButton.frame = CGRectMake(PB_Ratio(26), pb_t_de_loginButton.qmui_bottom + 8, PB_Ratio(20), PB_Ratio(20));

    [pb_t_de_agreeButton setImage:[UIImage imageNamed:@"signin_icon_select"] forState:UIControlStateNormal];
    [pb_t_de_agreeButton setImage:[UIImage imageNamed:@"signin_icon_select"] forState:UIControlStateHighlighted];
    [pb_t_de_agreeButton setImage:UIImageMake(@"signin_icon_selected") forState:UIControlStateSelected];

    [pb_t_de_agreeButton addTarget:self action:@selector(pb_t_de_agreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:pb_t_de_agreeButton];
    
    QMUIButton *pb_t_agreeShowButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
    NSString *agreeStr = @"I have read and agree to the Loan Agreement ";
    NSString *agreeStr1 = @"Loan Agreement";
    NSAttributedString *attri = [PPTools pb_t_attriStringWithHexString:agreeStr1 totalStr:agreeStr norColor:PB_Gray_1_Color attriColor:PP_AppColor norFont:UIFontMake(PB_Ratio(12)) attriFont:UIFontMake(PB_Ratio(12)) underline:YES];
    pb_t_agreeShowButton.titleLabel.numberOfLines = 0;
    [pb_t_agreeShowButton setAttributedTitle:attri forState:UIControlStateNormal];
    [pb_t_agreeShowButton addTarget:self action:@selector(pp_agreeShow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pb_t_agreeShowButton];
    [pb_t_agreeShowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pb_t_de_agreeButton.mas_right);
        make.top.mas_equalTo(pb_t_de_agreeButton.mas_top).offset(PB_Ratio(4));
        make.width.mas_lessThanOrEqualTo(PB_SW - PB_Ratio(60));
        make.height.mas_equalTo(60);
    }];
    pb_t_agreeShowButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    pb_t_agreeShowButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [pb_t_phoneTF addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    [pb_t_codeTF addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    self.pb_t_de_codeTextField = pb_t_codeTF;
    self.pb_t_de_phoneTextField = pb_t_phoneTF;
    self.pb_t_de_agreeButton = pb_t_de_agreeButton;
    self.pb_t_de_loginButton = pb_t_de_loginButton;
    self.pb_t_de_smCodeButton = pb_t_codeBtn;
    self.pb_t_de_agreeButton.selected = YES;
    
    [self updatepb_t_de_loginButtonState];
}


- (void)updatepb_t_de_loginButtonState{

    if(self.pb_t_de_agreeButton.selected && (self.pb_t_de_phoneTextField.text.length > 0) && (self.pb_t_de_codeTextField.text.length > 0)){
        self.pb_t_de_loginButton.enabled = YES;
    }else{
        self.pb_t_de_loginButton.enabled = NO;
    }
    if(_pb_t_de_timeAll > 0){
        self.pb_t_de_smCodeButton.enabled = NO;
    }else{
        self.pb_t_de_smCodeButton.enabled = YES;
    }
}

#pragma mark - textField value change
- (void)textFieldValueChange:(QMUITextField *)textField{
    textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self updatepb_t_de_loginButtonState];
}

#pragma mark - update main UI
- (void)updateMsgCount:(NSInteger)time{
    _pb_t_de_timeAll = time;
    [self resetRefreshTime];
}

- (void)resetRefreshTime {
    [self startTimer];
}

- (void)startTimer {
    
    [self stopTimer];
    if (_pb_t_de_timer == nil) {
        _pb_t_de_timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshLessTime) userInfo:nil repeats:YES];
    }
}

- (void)refreshLessTime { //刷新倒计时
    
    _pb_t_de_timeAll = _pb_t_de_timeAll - 1;
    if (_pb_t_de_timeAll > 0) {
        NSString *timeStr = [NSString stringWithFormat:@"%ld s",_pb_t_de_timeAll];
        [self.pb_t_de_smCodeButton setTitle:timeStr forState:UIControlStateNormal];
        self.pb_t_de_smCodeButton.enabled = NO;
    }else{
        [self.pb_t_de_smCodeButton setTitle:@"Get a Code" forState:UIControlStateNormal];
        [self stopTimer];
        [self updatepb_t_de_loginButtonState];
    }
}

- (void)stopTimer {
    if (_pb_t_de_timer) {
        [_pb_t_de_timer invalidate];
        _pb_t_de_timer = nil;
    }
}

- (void)dealloc {
    [self stopTimer];
}




@end
