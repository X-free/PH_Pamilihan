//
//  PPSettingViewController.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/11/1.
//

#import "PPSettingViewController.h"
#import "PB_LogoutAlertView.h"
#import "PPResignViewController.h"

@interface PPSettingViewController ()



@end

@implementation PPSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self ppInit];
    self.showNavBar = YES;
    self.navTitle = @"Settings";
    self.showBackBtn = YES;
}

- (void)ppInit{
    UIView *pb_t_bgView = [PB_UI pb_creat_ViewWithFrame:CGRectZero color:PB_WhiteColor radius:PB_Ratio(10)];
    pb_t_bgView.layer.masksToBounds = YES;
    UIImageView *pb_t_logoImgV = [[UIImageView alloc] initWithImage:UIImageMake(@"logo_mvp80")];
    pb_t_logoImgV.layer.cornerRadius = PB_Ratio(20);
    pb_t_logoImgV.layer.masksToBounds = YES;
    
    [self.view addSubview:pb_t_bgView];
    [pb_t_bgView addSubview:pb_t_logoImgV];
    [pb_t_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PB_Ratio(15));
        make.right.mas_offset(-PB_Ratio(15));
        make.top.mas_equalTo(PB_NaviBa_H + PB_Ratio(15));
        make.height.mas_equalTo(PB_Ratio(455));
    }];
    
    [pb_t_logoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(PB_Ratio(21));
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(PB_Ratio(91));
    }];
    
    NSArray *names = @[@"Version",@"Account cancellation",@"Logout"];
    for (NSInteger i = 0; i < names.count; i++) {
        QMUIButton *btn = [[QMUIButton alloc] init];
        btn.layer.cornerRadius = PB_Ratio(10);
        btn.layer.borderColor = PB_Color(@"#E8E8E8").CGColor;
        btn.layer.borderWidth = PB_Ratio(1);
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(pb_t_menuButtonSenderAction_de:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + i;
        [pb_t_bgView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(PB_Ratio(20));
            make.right.mas_offset(-PB_Ratio(20));
            make.height.mas_equalTo(PB_Ratio(48));
            make.top.mas_equalTo(PB_Ratio(127) + i *(PB_Ratio(48 + 30)));
        }];
        
        QMUILabel *pb_t_nameLbel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:names[i] color:PB_yiBanBlackColor font:UIFontMake(PB_Ratio(16)) alignment:NSTextAlignmentLeft lines:1];
        [btn addSubview:pb_t_nameLbel];
        [pb_t_nameLbel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(PB_Ratio(15));
            make.centerY.mas_equalTo(0);
        }];
        if(i == 0){
            QMUILabel *pb_t_versionLbel = [PB_UI pb_create_LabelWithFrame:CGRectZero title: [PB_getAppInfoHelper pb_to_getMyAppVersionString] color:PB_Gray_1_Color font:UIFontMake(PB_Ratio(18)) alignment:NSTextAlignmentLeft lines:1];
            [btn addSubview:pb_t_versionLbel];
            [pb_t_versionLbel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_offset(-PB_Ratio(19));
                make.centerY.mas_equalTo(0);
            }];
            btn.userInteractionEnabled = NO;
        }else{
            UIImageView *pb_t_moreImgV = [[UIImageView alloc] initWithImage:UIImageMake(@"icon_more_gray")];
            [btn addSubview:pb_t_moreImgV];
            [pb_t_moreImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_offset(-PB_Ratio(19));
                make.centerY.mas_equalTo(0);
                make.width.height.mas_equalTo(PB_Ratio(16));
            }];
        }
        
    }
}


- (void)pb_t_menuButtonSenderAction_de:(QMUIButton *)button{
    NSInteger tag = button.tag;
    if(tag == 100){
        
    }else if (tag ==101){//注销
        PPResignViewController *vc = [[PPResignViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (tag ==102){//退出
        [self ppLogout];
        
    }else if (tag == 103){
        
    }
}

- (void)ppLogout {
    QMUIModalPresentationViewController *qmAlert = [[QMUIModalPresentationViewController alloc] init];
    qmAlert.animationStyle = QMUIModalPresentationAnimationStyleSlide;
    PB_LogoutAlertView *popView = [[PB_LogoutAlertView alloc] init];
    qmAlert.contentView = popView;
    //关闭点击背景自动隐藏
    qmAlert.modal = YES;
    [qmAlert showWithAnimated:YES completion:nil];
    PMMyWeekSelf
    popView.myBlock = ^(NSInteger buttonIndex) {
        [qmAlert hideWithAnimated:YES completion:nil];
        NSLog(@"buttonIndex = %ld",buttonIndex);
        if (buttonIndex == 50) {
            [weakSelf pb_t_requestLogout];
        }
    };
}

#pragma mark - request

- (void)pb_t_requestLogout{
    [QMUITips showLoading:PBLoading_TipMsg inView:self.view];
    [[PB_RequestHelper pb_instance] pb_getRequestWithUrlStr:PBURL_logoutUrl params:@{} commplete:^(id  _Nullable result, NSInteger statusCode) {
        [QMUITips hideAllTips];
        [PB_APP_Control pb_t_toLogoutAntToHomeMyAccount];
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
        [QMUITips showError:errorStr inView:self.view];
        [PB_APP_Control pb_t_toLogoutAntToHomeMyAccount];
    }];
}


@end
