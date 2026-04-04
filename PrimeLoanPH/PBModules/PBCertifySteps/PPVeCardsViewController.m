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
#import "PB_ExampleAlertViewController.h"
#import "FaceCameraViewController.h"
#import "PPVeCardUploadModel.h"
#import "PB_PRCInfoAlertViewController.h"
#import "PPBaseModel.h"
#import "PPVeCardTypeOptionVC.h"




@interface PPVeCardsViewController ()

@property (nonatomic, strong) PPVerifyHeaderView *headerView;
@property (nonatomic, strong) UIButton *pb_t_de_submitButton;
@property (nonatomic, strong) PPVeCardModel *dataModel;

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
    [self setNavTitle:@"Authentication"];
    self.view.backgroundColor = PB_BgColor;
    [self ppInit];
}

- (void)ppInit{
    
    self.pb_t_de_reportStartTime = @"";
    self.pb_t_de_reportEndTime = @"";
    self.cardTypeValue = @"";
    self.pb_t_de_carType_reportStartTime = @"";
    self.view.backgroundColor = PB_BgColor;

    //
    [self.tableView registerClass:PPVeCardTableViewCell.class forCellReuseIdentifier:PPVeCardTableViewCellKey];
    [self.tableView registerClass:PPCardHeader.class forHeaderFooterViewReuseIdentifier:PPCardHeaderKey];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(PB_NaviBa_H, 0, PB_Ratio(100), 0));
    }];
    self.tableView.backgroundColor = PB_BgColor;
    self.tableView.tableHeaderView = [PPVerifyHeaderView new];
    [self.view addSubview:self.pb_t_de_submitButton];
    [self.pb_t_de_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_offset(-PB_Ratio(48));
        make.width.mas_equalTo(PB_SW - PB_Ratio(47)*2);
        make.height.mas_equalTo(PB_Ratio(44));
    }];
    [self setPpShowTableViewHeaderRefresh:YES];
    [self requestMethod];
    
}

///请求页面数据
- (void)requestMethod {
    [QMUITips showLoading:PBLoading_TipMsg inView:self.view];
    NSDictionary *p = @{
        @"foundation":PBStrFormat(self.pId),
    };
    [[PB_RequestHelper pb_instance] pb_postRequestWithUrlStr:PBURL_V1CardInfoUrl params:p commplete:^(NSDictionary * _Nullable result, NSInteger statusCode) {
        [QMUITips hideAllTips];
        if(result != nil){
            self.dataModel = [PPVeCardModel yy_modelWithJSON:result];
        }
        [self ppTableViewEndAllRefresh];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
        [QMUITips showError:errorStr inView:self.view];
        [self ppTableViewEndAllRefresh];
    }];
}

- (void)requestpb_t_toUploadIdCard:(NSDictionary *)dic presentVC:(UIViewController *)presentVC {

    [QMUITips showLoading:PBLoading_TipMsg inView:[UIApplication sharedApplication].delegate.window];

    [[PB_RequestHelper pb_instance] pb_postRequestWithUrlStr:PBURL_V1CardInfoSaveUrl params:dic commplete:^(NSDictionary * _Nullable result, NSInteger statusCode) {
        [QMUITips hideAllTips];

        if(result != nil){
            if(presentVC != nil){
                [presentVC dismissViewControllerAnimated:YES completion:nil];
            }
            PPBaseModel *model= [PPBaseModel yy_modelWithJSON:result];
            [QMUITips showInfo:PBStrFormat(model.concepts) inView:self.view];
            [self requestMethod];
        }
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
        [QMUITips hideAllTips];
        [QMUITips showError:errorStr inView:self.view];
    }];
}

- (void)pb_t_de_TableViewHeaderRefreshMethod {
    [self requestMethod];
}



#pragma mark - UI


- (UIButton *)pb_t_de_submitButton {
    if(!_pb_t_de_submitButton){
        _pb_t_de_submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _pb_t_de_submitButton.backgroundColor = PP_AppColor;
        _pb_t_de_submitButton.layer.cornerRadius = PB_Ratio(22);
        _pb_t_de_submitButton.layer.masksToBounds = YES;
        [_pb_t_de_submitButton setTitle:@"Next" forState:UIControlStateNormal];
        _pb_t_de_submitButton.titleLabel.font = UIFontMediumMake(PB_Ratio(16));
        [_pb_t_de_submitButton setTitleColor:PB_WhiteColor forState:UIControlStateNormal];
        [_pb_t_de_submitButton addTarget:self action:@selector(submitButtonSender:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pb_t_de_submitButton;
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.dataModel && self.dataModel.theoretical.range && self.dataModel.theoretical.sought) ? 2 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PPVeCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PPVeCardTableViewCellKey forIndexPath:indexPath];
    NSString *imgValueStr = @"";
    if(indexPath.section == 0){
        imgValueStr = PBStrFormat(self.dataModel.theoretical.range.translated);
    }else{
        imgValueStr = PBStrFormat(self.dataModel.theoretical.sought.translated);
    }
    [cell pb_configWithCellData:imgValueStr indexPath:indexPath];;
        return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return PB_Ratio(54);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PPCardHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:PPCardHeaderKey];
    NSString *sectionTitle = @"Front of ID card";
    if(section == 1){
        sectionTitle = @"Face recognition";
    }
    [header pb_confWithSectionData:sectionTitle];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PB_Ratio(96);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.dataModel == nil)
        return;

    NSString *imgValueStr = @"";
    NSString *type = @"";
    if(indexPath.section == 0){
        imgValueStr = PBStrFormat(self.dataModel.theoretical.range.translated);
        type = PB_VeIdCard_only_tag;
    }else{
        imgValueStr = PBStrFormat(self.dataModel.theoretical.sought.translated);
        type = PBFaceCard_only_tag;
        //身份证未完成时
        if([NSString PB_CheckStringIsEmpty:PBStrFormat(self.dataModel.theoretical.range.translated)]){
            NSString *tipMsg = @"Please upload Front of ID card !";
            [QMUITips showInfo:tipMsg inView:self.view];
            return;
        }
    }
    if([NSString PB_CheckStringIsEmpty:imgValueStr]){
        [self pp_UploadVeCellUploadButtonTap:type];
    }
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
        PB_ExampleAlertViewController *exampleVC= [[PB_ExampleAlertViewController alloc] initWithType:2];
        exampleVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        exampleVC.finsihCallBlock = ^{
            [weakSelf pb_t_toUploadFace];
        };
        [self presentViewController:exampleVC animated:YES completion:nil];
    }
}

#pragma mark method

- (void)pb_t_toUploadFace{
    [self pp_reloadBeginTime];
//    AppFaceVc *vc = [[AppFaceVc alloc] init];
    FaceCameraViewController *vc = [[FaceCameraViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:^{}];
    PMMyWeekSelf
    vc.faceImage = ^(UIImage * _Nonnull image) {
        [weakSelf requestToUploadImag:image type:10 fromType:@"1"];
    };
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
        [PBCameraAndPhotoHelper pb_to_useCameraFromVC:self isFront:NO finishPicking:^(UIImage * _Nonnull image) {
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
    [QMUITips showLoading:PBLoading_TipMsg inView:self.view];
    [[PB_RequestHelper pb_instance] pb_uploadFileRequestWithUrlStr:PBURL_V1UploadCardInfo params:params file:image success:^(NSDictionary * _Nullable result, NSInteger statusCode) {
        [QMUITips hideAllTips];
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
        [QMUITips showError:errorStr inView:self.view];
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

