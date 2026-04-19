//
//  PPResignViewController.m
//  PrimeLoanPH
//
//  注销：半透明遮罩 + `noticeacccellation`；勾选同意 + 底部注销热区；未勾选点注销 Toast；同意后可调接口；modal 呈现需 isDismiss
//

#import "PPResignViewController.h"
#import "PB_UI.h"

@interface PPResignViewController ()
@property (nonatomic, strong) QMUIButton *pb_t_agreeButton;
@property (nonatomic, strong) UIButton *pb_t_confirmButton;
@end

@implementation PPResignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showNavBar = NO;
    self.isDismiss = YES;
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.55];
    [self ppInit];
}

- (void)ppInit {
    UIImage *sheetImg = [UIImage imageNamed:@"noticeacccellation"];

    UIView *card = [[UIView alloc] init];
    card.backgroundColor = UIColor.clearColor;
    card.clipsToBounds = YES;
    [self.view addSubview:card];

    UIImageView *dialogIv = [[UIImageView alloc] initWithImage:sheetImg];
    dialogIv.backgroundColor = UIColor.clearColor;
    dialogIv.contentMode = UIViewContentModeScaleAspectFit;
    dialogIv.clipsToBounds = YES;
    dialogIv.userInteractionEnabled = NO;
    [card addSubview:dialogIv];

    CGFloat ar = (sheetImg.size.width > 1.f)
        ? (sheetImg.size.height / sheetImg.size.width)
        : (944.f / 686.f);

    [card mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-PB_Ratio(20));
        make.leading.equalTo(self.view).offset(16);
        make.trailing.equalTo(self.view).offset(-16);
        make.height.equalTo(card.mas_width).multipliedBy(ar);
    }];

    [dialogIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(card);
    }];

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.backgroundColor = UIColor.clearColor;
    closeBtn.accessibilityLabel = @"Close";
    [closeBtn addTarget:self action:@selector(pb_t_closeTapped) forControlEvents:UIControlEventTouchUpInside];

    QMUIButton *agreeCheck = [QMUIButton buttonWithType:UIButtonTypeCustom];
    agreeCheck.backgroundColor = UIColor.clearColor;
    [agreeCheck setImage:UIImageMake(@"Group00734") forState:UIControlStateNormal];
    [agreeCheck setImage:UIImageMake(@"Group00733") forState:UIControlStateSelected];
    [agreeCheck addTarget:self action:@selector(pb_t_agreeButtonSendAction:) forControlEvents:UIControlEventTouchUpInside];
    agreeCheck.selected = NO;
    self.pb_t_agreeButton = agreeCheck;

    QMUILabel *agreeText = [PB_UI pb_create_LabelWithFrame:CGRectZero
                                                      title:@"I have read and agree to the above"
                                                      color:PB_Gray_1_Color
                                                       font:UIFontMake(PB_Ratio(13))
                                                  alignment:NSTextAlignmentLeft
                                                      lines:0];
    agreeText.numberOfLines = 0;
    agreeText.userInteractionEnabled = NO;

    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.backgroundColor = UIColor.clearColor;
    confirmBtn.accessibilityLabel = @"Account cancellation";
    [confirmBtn addTarget:self action:@selector(pb_t_confirmCancellation:) forControlEvents:UIControlEventTouchUpInside];
    self.pb_t_confirmButton = confirmBtn;

    [card addSubview:closeBtn];
    [card addSubview:agreeCheck];
    [card addSubview:agreeText];
    [card addSubview:confirmBtn];

    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(card).offset(8);
        make.top.equalTo(card).offset(8);
        make.width.height.mas_equalTo(44);
    }];

    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(card).offset(PB_Ratio(30));
        make.trailing.equalTo(card).offset(-PB_Ratio(30));
        make.bottom.equalTo(card).offset(-PB_Ratio(14));
        make.height.mas_equalTo(PB_Ratio(56));
    }];

    [agreeCheck mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(card).offset(PB_Ratio(30));
        make.bottom.equalTo(confirmBtn.mas_top).offset(-PB_Ratio(16));
        make.width.height.mas_equalTo(PB_Ratio(14));
    }];

    [agreeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(agreeCheck);
        make.left.equalTo(agreeCheck.mas_right).offset(PB_Ratio(5));
        make.right.lessThanOrEqualTo(card).offset(-PB_Ratio(30));
    }];

    [self pb_t_refreshConfirmAppearance];
}

- (void)pb_t_refreshConfirmAppearance {
    BOOL ok = self.pb_t_agreeButton.selected;
    self.pb_t_confirmButton.alpha = ok ? 1.0 : 0.45;
}

#pragma mark - Actions

- (void)pb_t_closeTapped {
    [self popController];
}

- (void)pb_t_agreeButtonSendAction:(UIButton *)button {
    button.selected = !button.selected;
    [self pb_t_refreshConfirmAppearance];
}

- (void)pb_t_confirmCancellation:(UIButton *)sender {
    if (!self.pb_t_agreeButton.selected) {
        [PB_NativeTipsHelper pb_presentAlertWithMessage:@"please read and agree to the above"];
        return;
    }
    [PB_NativeTipsHelper pb_showLoadingInView:self.view];
    [[PB_RequestHelper pb_instance] pb_getRequestWithUrlStr:PBURL_cancelationUrl params:@{} commplete:^(NSDictionary * _Nullable result, NSInteger statusCode) {
        [PB_NativeTipsHelper pb_hideAllLoading];
        [PB_APP_Control pb_t_toLogoutAntToHomeMyAccount];
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
        [PB_NativeTipsHelper pb_presentAlertWithMessage:errorStr];
        [PB_APP_Control pb_t_toLogoutAntToHomeMyAccount];
    }];
}

@end
