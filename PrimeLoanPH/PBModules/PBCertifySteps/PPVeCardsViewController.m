//
//  PPVeCardsViewController.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/31.
//

#import "PPVeCardsViewController.h"
#import "PPVerifyHeaderView.h"
#import "PPCardHeader.h"
#import "PPVeCardTableViewCell.h"
#import "PPVeCardModel.h"
#import "PPVeCardUploadModel.h"
#import "PB_PRCInfoAlertViewController.h"
#import "PPBaseModel.h"
#import "PPVeCardTypeOptionVC.h"




@interface PPVeCardsViewController ()

@property (nonatomic, strong) PPVerifyHeaderView *headerView;
@property (nonatomic, strong) UIButton *pb_t_de_submitButton;
@property (nonatomic, strong) PPVeCardModel *dataModel;
@property (nonatomic, strong) UIView *pb_t_de_uploadCardWrap;
@property (nonatomic, strong) UIButton *pb_t_de_frontTabBtn;
@property (nonatomic, strong) UIButton *pb_t_de_faceTabBtn;
@property (nonatomic, strong) UIView *pb_t_de_tabLineView;
@property (nonatomic, strong) UIImageView *pb_t_de_mainPreviewImgV;
@property (nonatomic, strong) UIImageView *pb_t_de_errorExampleImgV;
@property (nonatomic, assign) NSInteger pb_t_de_selectedTab; // 0: Front of ID photo, 1: Face recognition

@property (nonatomic, copy) NSString *pb_t_de_carType_reportStartTime;
@property (nonatomic, copy) NSString *pb_t_de_reportStartTime;
@property (nonatomic, copy) NSString *pb_t_de_reportEndTime;
@property (nonatomic, copy) NSString *cardTypeValue; //证件类型选择的值

@end

@implementation PPVeCardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setShowBackBtn:YES];
    [self setNavTitle:@"Identity information"];
    self.useDarkNavBackIcon = YES;
    self.view.backgroundColor = PB_BgColor;
    [self ppInit];
}

- (void)ppInit{
    
    self.pb_t_de_reportStartTime = @"";
    self.pb_t_de_reportEndTime = @"";
    self.cardTypeValue = @"";
    self.pb_t_de_carType_reportStartTime = @"";
    self.view.backgroundColor = PB_BgColor;
    self.pb_t_de_selectedTab = 0;
    self.tableView.hidden = YES;
    
    UIImageView *topBg = [[UIImageView alloc] initWithImage:UIImageMake(@"ordtopbg")];
    topBg.contentMode = UIViewContentModeScaleAspectFill;
    topBg.clipsToBounds = YES;
    [self.view addSubview:topBg];
    [topBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(PB_Ratio(220) + StatusBarHeightConstant);
    }];
    [self.view sendSubviewToBack:topBg];

    UIView *contentWrap = [PB_UI pb_creat_ViewWithFrame:CGRectZero color:UIColor.clearColor];
    [self.view addSubview:contentWrap];
    [contentWrap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(PB_NaviBa_H + PB_Ratio(14));
        make.left.mas_equalTo(PB_Ratio(15));
        make.right.mas_equalTo(-PB_Ratio(15));
        make.bottom.mas_equalTo(-PB_Ratio(120));
    }];

    UIView *titleBg = [PB_UI pb_creat_ViewWithFrame:CGRectZero color:PB_Color(@"#FB6E21") radius:PB_Ratio(12)];
    [contentWrap addSubview:titleBg];
    [titleBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(PB_Ratio(220));
        make.height.mas_equalTo(PB_Ratio(52));
    }];
    QMUILabel *titleLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"Upload information" color:UIColor.whiteColor font:UIFontBoldMake(PB_Ratio(32*0.5)) alignment:NSTextAlignmentLeft lines:1];
    [titleBg addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PB_Ratio(14));
        make.top.mas_equalTo(PB_Ratio(8));
    }];

    self.pb_t_de_uploadCardWrap = [PB_UI pb_creat_ViewWithFrame:CGRectZero color:UIColor.whiteColor radius:PB_Ratio(12)];
    [contentWrap addSubview:self.pb_t_de_uploadCardWrap];
    [self.pb_t_de_uploadCardWrap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(titleBg.mas_bottom).offset(-PB_Ratio(10));
    }];

    self.pb_t_de_frontTabBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self.pb_t_de_frontTabBtn setTitle:@"Front of ID photo" forState:UIControlStateNormal];
    self.pb_t_de_frontTabBtn.titleLabel.font = UIFontBoldMake(PB_Ratio(16));
    [self.pb_t_de_frontTabBtn setTitleColor:PB_Color(@"#8C8C8C") forState:UIControlStateNormal];
    [self.pb_t_de_frontTabBtn setTitleColor:PB_yiBanBlackColor forState:UIControlStateSelected];
    [self.pb_t_de_frontTabBtn addTarget:self action:@selector(pb_t_de_tabAction:) forControlEvents:UIControlEventTouchUpInside];
    self.pb_t_de_frontTabBtn.tag = 700;
    [self.pb_t_de_uploadCardWrap addSubview:self.pb_t_de_frontTabBtn];

    self.pb_t_de_faceTabBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self.pb_t_de_faceTabBtn setTitle:@"Face recognition" forState:UIControlStateNormal];
    self.pb_t_de_faceTabBtn.titleLabel.font = UIFontBoldMake(PB_Ratio(16));
    [self.pb_t_de_faceTabBtn setTitleColor:PB_Color(@"#8C8C8C") forState:UIControlStateNormal];
    [self.pb_t_de_faceTabBtn setTitleColor:PB_yiBanBlackColor forState:UIControlStateSelected];
    [self.pb_t_de_faceTabBtn addTarget:self action:@selector(pb_t_de_tabAction:) forControlEvents:UIControlEventTouchUpInside];
    self.pb_t_de_faceTabBtn.tag = 701;
    [self.pb_t_de_uploadCardWrap addSubview:self.pb_t_de_faceTabBtn];

    self.pb_t_de_tabLineView = [PB_UI pb_creat_ViewWithFrame:CGRectZero color:PB_Color(@"#FB6E21") radius:0];
    [self.pb_t_de_uploadCardWrap addSubview:self.pb_t_de_tabLineView];

    self.pb_t_de_mainPreviewImgV = [PB_UI pb_create_imageViewWhihFrame:CGRectZero imgName:@"Frame 39" cornerRadius:PB_Ratio(12)];
    self.pb_t_de_mainPreviewImgV.contentMode = UIViewContentModeScaleAspectFit;
    [self.pb_t_de_uploadCardWrap addSubview:self.pb_t_de_mainPreviewImgV];
    UIButton *previewTap = [UIButton buttonWithType:UIButtonTypeCustom];
    previewTap.backgroundColor = UIColor.clearColor;
    [previewTap addTarget:self action:@selector(pb_t_de_mainPreviewTapAction) forControlEvents:UIControlEventTouchUpInside];
    [self.pb_t_de_mainPreviewImgV addSubview:previewTap];
    [previewTap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.pb_t_de_errorExampleImgV = [PB_UI pb_create_imageViewWhihFrame:CGRectZero imgName:@"Grouerror9900502" cornerRadius:PB_Ratio(10)];
    self.pb_t_de_errorExampleImgV.contentMode = UIViewContentModeScaleAspectFit;
    [self.pb_t_de_uploadCardWrap addSubview:self.pb_t_de_errorExampleImgV];

    [self.pb_t_de_frontTabBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PB_Ratio(12));
        make.top.mas_equalTo(PB_Ratio(8));
        make.height.mas_equalTo(PB_Ratio(38));
        make.width.mas_equalTo(PB_Ratio(145));
    }];
    [self.pb_t_de_faceTabBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pb_t_de_frontTabBtn.mas_right).offset(PB_Ratio(8));
        make.centerY.mas_equalTo(self.pb_t_de_frontTabBtn);
        make.height.width.mas_equalTo(self.pb_t_de_frontTabBtn);
    }];
    [self.pb_t_de_tabLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.pb_t_de_frontTabBtn.mas_bottom).offset(-PB_Ratio(2));
        make.left.mas_equalTo(self.pb_t_de_frontTabBtn);
        make.width.mas_equalTo(PB_Ratio(135));
        make.height.mas_equalTo(PB_Ratio(4));
    }];
    [self.pb_t_de_mainPreviewImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PB_Ratio(12));
        make.right.mas_equalTo(-PB_Ratio(12));
        make.top.mas_equalTo(self.pb_t_de_frontTabBtn.mas_bottom).offset(PB_Ratio(10));
        make.height.mas_equalTo(PB_Ratio(182));
    }];
    [self.pb_t_de_errorExampleImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PB_Ratio(12));
        make.right.mas_equalTo(-PB_Ratio(12));
        make.top.mas_equalTo(self.pb_t_de_mainPreviewImgV.mas_bottom).offset(PB_Ratio(10));
        make.bottom.mas_equalTo(-PB_Ratio(10));
        make.height.mas_equalTo(PB_Ratio(102));
    }];

    [self.view addSubview:self.pb_t_de_submitButton];
    [self.pb_t_de_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_offset(-PB_Ratio(48));
        make.width.mas_equalTo(PB_SW - PB_Ratio(47)*2);
        make.height.mas_equalTo(PB_Ratio(44));
    }];
    [self requestMethod];
    
}

///请求页面数据
- (void)requestMethod {
    [PB_NativeTipsHelper pb_showLoadingInView:self.view];
    NSDictionary *p = @{
        @"foundation":PBStrFormat(self.pId),
    };
    [[PB_RequestHelper pb_instance] pb_postRequestWithUrlStr:PBURL_V1CardInfoUrl params:p commplete:^(NSDictionary * _Nullable result, NSInteger statusCode) {
        [PB_NativeTipsHelper pb_hideAllLoading];
        if(result != nil){
            self.dataModel = [PPVeCardModel yy_modelWithJSON:result];
            NSInteger idAck = self.dataModel.theoretical.range.acknowledges;
            self.pb_t_de_selectedTab = idAck == 1 ? 1 : 0;
            [self pb_t_de_refreshTabUI];
        }
        [self ppTableViewEndAllRefresh];
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
        [PB_NativeTipsHelper pb_presentAlertWithMessage:errorStr];
        [self ppTableViewEndAllRefresh];
    }];
}

- (void)requestpb_t_toUploadIdCard:(NSDictionary *)dic presentVC:(UIViewController *)presentVC {

    UIWindow *pb_win = [UIApplication sharedApplication].delegate.window;
    if (pb_win) {
        [PB_NativeTipsHelper pb_showLoadingInView:pb_win];
    }

    [[PB_RequestHelper pb_instance] pb_postRequestWithUrlStr:PBURL_V1CardInfoSaveUrl params:dic commplete:^(NSDictionary * _Nullable result, NSInteger statusCode) {
        [PB_NativeTipsHelper pb_hideAllLoading];

        if(result != nil){
            if(presentVC != nil){
                [presentVC dismissViewControllerAnimated:YES completion:nil];
            }
            PPBaseModel *model= [PPBaseModel yy_modelWithJSON:result];
            [PB_NativeTipsHelper pb_presentAlertWithMessage:PBStrFormat(model.concepts)];
            [self requestMethod];
        }
        [self pb_t_de_refreshTabUI];
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
        [PB_NativeTipsHelper pb_hideAllLoading];
        [PB_NativeTipsHelper pb_presentAlertWithMessage:errorStr];
    }];
}

- (void)pb_t_de_TableViewHeaderRefreshMethod {
    [self requestMethod];
}



#pragma mark - UI


- (UIButton *)pb_t_de_submitButton {
    if(!_pb_t_de_submitButton){
        _pb_t_de_submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pb_t_de_submitButton setBackgroundImage:UIImageMake(@"Roundedrectangle") forState:UIControlStateNormal];
        _pb_t_de_submitButton.layer.cornerRadius = PB_Ratio(22);
        _pb_t_de_submitButton.layer.masksToBounds = YES;
        [_pb_t_de_submitButton setTitle:@"Next" forState:UIControlStateNormal];
        _pb_t_de_submitButton.titleLabel.font = UIFontMediumMake(PB_Ratio(16));
        [_pb_t_de_submitButton setTitleColor:PB_WhiteColor forState:UIControlStateNormal];
        [_pb_t_de_submitButton addTarget:self action:@selector(submitButtonSender:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pb_t_de_submitButton;
}

#pragma mark - Card UI

- (void)pb_t_de_tabAction:(UIButton *)sender {
    self.pb_t_de_selectedTab = sender.tag == 700 ? 0 : 1;
    [self pb_t_de_refreshTabUI];
}

- (void)pb_t_de_refreshTabUI {
    BOOL isFront = self.pb_t_de_selectedTab == 0;
    self.pb_t_de_frontTabBtn.selected = isFront;
    self.pb_t_de_faceTabBtn.selected = !isFront;
    [self.pb_t_de_tabLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.pb_t_de_frontTabBtn.mas_bottom).offset(-PB_Ratio(2));
        make.left.mas_equalTo(isFront ? self.pb_t_de_frontTabBtn : self.pb_t_de_faceTabBtn);
        make.width.mas_equalTo(PB_Ratio(135));
        make.height.mas_equalTo(PB_Ratio(4));
    }];

    if (isFront) {
        NSString *frontUrl = PBStrFormat(self.dataModel.theoretical.range.translated);
        if([NSString PB_CheckStringIsEmpty:frontUrl]){
            self.pb_t_de_mainPreviewImgV.image = UIImageMake(@"Framefront38");
        }else{
            [PPTools PB_loadUrl_ImageView:self.pb_t_de_mainPreviewImgV urlStr:frontUrl holdImg:@"Framefront38"];
        }
        self.pb_t_de_errorExampleImgV.image = UIImageMake(@"Grouerror9900502");
    } else {
        NSString *faceUrl = PBStrFormat(self.dataModel.theoretical.sought.translated);
        if([NSString PB_CheckStringIsEmpty:faceUrl]){
            self.pb_t_de_mainPreviewImgV.image = UIImageMake(@"Frame 39");
        }else{
            [PPTools PB_loadUrl_ImageView:self.pb_t_de_mainPreviewImgV urlStr:faceUrl holdImg:@"Frame 39"];
        }
        self.pb_t_de_errorExampleImgV.image = UIImageMake(@"Grou990050");
    }
}

- (void)pb_t_de_mainPreviewTapAction {
    if(self.pb_t_de_selectedTab == 0){
        [self pp_UploadVeCellUploadButtonTap:PB_VeIdCard_only_tag];
        return;
    }
    if([NSString PB_CheckStringIsEmpty:PBStrFormat(self.dataModel.theoretical.range.translated)]){
        [PB_NativeTipsHelper pb_presentAlertWithMessage:@"Please upload Front of ID card !"];
        return;
    }
    [self pp_UploadVeCellUploadButtonTap:PBFaceCard_only_tag];
}

#pragma mark - Click
- (void)submitButtonSender:(QMUIButton *)button{
    if([NSString PB_CheckStringIsEmpty:self.dataModel.theoretical.range.translated]){
        [self pp_UploadVeCellUploadButtonTap:PB_VeIdCard_only_tag];
        return;
    }else if ([NSString PB_CheckStringIsEmpty:self.dataModel.theoretical.sought.translated]){
        [self pp_UploadVeCellUploadButtonTap:PBFaceCard_only_tag];
        return;
    }
    PMMyWeekSelf
    [PB_APP_Control pb_t_toRequestProductDetailThanGoToNextStepOptionWithProductID:self.pId oId:self.oId fromVC:self SuccessBlock:^(BOOL isSure) {
        [PB_GetVC pb_to_removeViewController:weakSelf];
    }];
}


- (void)pp_UploadVeCellUploadButtonTap:(NSString *)tag{
    //1# 展示示例图
    PMMyWeekSelf
    if([tag isEqualToString:PB_VeIdCard_only_tag]){
        
        
        NSArray *arr1 = @[];
        NSArray *arr2 = @[];
        NSArray *combineArr;
        if(self.dataModel.theoretical.demie.count > 0){
            arr1 = self.dataModel.theoretical.demie;
        }
        if(self.dataModel.theoretical.strand.count > 0){
            arr2 = self.dataModel.theoretical.strand;
        }
        combineArr = @[arr1,arr2];
        self.pb_t_de_carType_reportStartTime = [PB_timeHelper pb_t_getCurrentStampTimeString];
        PPVeCardTypeOptionVC *vc = [[PPVeCardTypeOptionVC alloc] initWithPBTableViewOfGroupStyle:YES];
        vc.pDataArray = combineArr;
        vc.ppBlock = ^(NSString * _Nonnull value) {
            weakSelf.cardTypeValue = PBStrFormat(value);
            // report card type
            [weakSelf pb_t_toRePortRiskDataToServeFromStep];
            [weakSelf pb_t_toUploadIdCard];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([tag isEqualToString:PBFaceCard_only_tag]){
        [self pb_t_toUploadFace];
    }
}

#pragma mark method

- (void)pb_t_toUploadFace{
    [self pp_reloadBeginTime];
    
    [self pickImageWithPickType:1 cardType:10];

//    AppFaceVc *vc = [[AppFaceVc alloc] init];
//    FaceCameraViewController *vc = [[FaceCameraViewController alloc] init];
//    vc.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:vc animated:YES completion:^{}];
//    PMMyWeekSelf
//    vc.faceImage = ^(UIImage * _Nonnull image) {
//    };
}

- (void)pb_t_toUploadIdCard{
    [self pp_reloadBeginTime];
    PMMyWeekSelf
    QMUIAlertController *alertVC =[QMUIAlertController alertControllerWithTitle:@"Tip" message:PB_PhotoTipContent preferredStyle:QMUIAlertControllerStyleAlert];
    [alertVC addAction:[QMUIAlertAction actionWithTitle:@"Cancel" style:QMUIAlertActionStyleCancel handler:nil]];
    [alertVC addAction:[QMUIAlertAction actionWithTitle:@"Camera" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        [weakSelf pickImageWithPickType:1 cardType:11];
        
    }]];
    [alertVC addAction:[QMUIAlertAction actionWithTitle:@"Photo Album" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        
        [weakSelf pickImageWithPickType:2 cardType:11];

    }]];
    [alertVC showWithAnimated:YES];
}

//1 拍照 2 相册
- (void)pickImageWithPickType:(NSInteger)pickType cardType:(NSInteger)cardType{
    PMMyWeekSelf
    if(pickType == 1){//拍照 //身份证拍照使用后置
        [PBCameraAndPhotoHelper pb_to_useCameraFromVC:self isFront:cardType == 10 finishPicking:^(UIImage * _Nonnull image) {
            
            [weakSelf requestToUploadImag:image type:cardType fromType:@"1"];
        }];
    }else if (pickType == 2){//相册
        PMMyWeekSelf
        [PBCameraAndPhotoHelper pb_to_useAlbumFromVC:self finishPicking:^(UIImage * _Nonnull image) {
            [weakSelf requestToUploadImag:image type:cardType fromType:@"2"];
        }];
    }
}


//上传照片到服务器10:人像,11身份证正面 12:身份证反面 fromType 1,拍照，2相册
- (void)requestToUploadImag:(UIImage *)image type:(NSInteger)type fromType:(NSString *)fromType{
    NSDictionary *params = @{};
    if(type == 10){//人脸
        params = @{
            @"type":@(type),
            @"mirza":fromType
        };
    }else if (type == 11){//正面
        params = @{
            @"type":@(type),
            @"mirza":fromType,
            @"explain":PBStrFormat(self.cardTypeValue)
        };
    }
    PMMyWeekSelf
    [PB_NativeTipsHelper pb_showLoadingInView:self.view];
    [[PB_RequestHelper pb_instance] pb_uploadFileRequestWithUrlStr:PBURL_V1UploadCardInfo params:params file:image success:^(NSDictionary * _Nullable result, NSInteger statusCode) {
        [PB_NativeTipsHelper pb_hideAllLoading];
        if(result != nil){
            PPVeCardUploadModel *model = [PPVeCardUploadModel yy_modelWithJSON:result];
            //显示确认弹框
            if(type == 11){//正面
                [self pb_t_toRePortRiskDataToServeFromStep:@"3"];
                PB_PRCInfoAlertViewController *vcp = [[PB_PRCInfoAlertViewController alloc] init];
                [vcp configData:model type:self.cardTypeValue complete:^(NSDictionary * _Nonnull params) {
                    if(params.count == 0){
                        [vcp dismissViewControllerAnimated:YES completion:nil];
                    }else{
                        [weakSelf requestpb_t_toUploadIdCard:params presentVC:vcp];
                    }
                }];
                vcp.modalPresentationStyle = UIModalPresentationOverFullScreen;
                [self.navigationController presentViewController:vcp animated:YES completion:nil];
            }else{//人脸
                [self pb_t_toRePortRiskDataToServeFromStep:@"4"];
                [self requestMethod];
            }
        }
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
        [PB_NativeTipsHelper pb_presentAlertWithMessage:errorStr];
    } ];
}

#pragma mark - risk
- (void)pp_reloadBeginTime {
    self.pb_t_de_reportStartTime = [PB_timeHelper pb_t_getCurrentStampTimeString];
}

- (void)pb_t_toRePortRiskDataToServeFromStep:(NSString *)riskType {
    self.pb_t_de_reportEndTime = [PB_timeHelper pb_t_getCurrentStampTimeString];
    NSDictionary *riskDict = @{
        @"speak":PBStrFormat(self.pb_t_de_reportStartTime),
        @"advantage":PBStrFormat(self.pb_t_de_reportEndTime),
        @"rejection":PBStrFormat(riskType)
    };
    [[PB_APP_Control instanceOnly] pb_t_toRePortRiskDataToServe:riskDict];
}

- (void)pb_t_toRePortRiskDataToServeFromStep {
    NSDictionary *riskDict = @{
        @"speak":PBStrFormat(self.pb_t_de_carType_reportStartTime),
        @"advantage":PBStrFormat([PB_timeHelper pb_t_getCurrentStampTimeString]),
        @"rejection":@"2"
    };
    [[PB_APP_Control instanceOnly] pb_t_toRePortRiskDataToServe:riskDict];
}

@end

