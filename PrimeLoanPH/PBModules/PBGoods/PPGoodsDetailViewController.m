//
//  PPGoodsDetailViewController.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/31.
//

#import "PPGoodsDetailViewController.h"
#import "PPGoodsDetailHeader.h"
#import "PPGoodsDetailTableViewCell.h"
#import "PPDetailModel.h"
#import "PB_FunSureAlertView.h"
#import "PPBaseModel.h"

@interface PPGoodsDetailViewController ()

@property (nonatomic, strong) PPDetailModel *dataModel;
@property (nonatomic, strong) NSArray <PPDetailValuingModel *>*dataArray;
@property (nonatomic, copy) NSString *pb_t_de_nextStr;//下一步操作
@property (nonatomic, copy) NSString *pb_t_de_pouductOrderNo;//订单号
@property (nonatomic, assign) QMUIButton *pb_t_de_submitBtn;
@property (nonatomic, assign) QMUIButton *agreeBtn;
@property (nonatomic, assign) QMUIButton *pb_t_de_pAgreebutton;
@property (nonatomic, strong) PPGoodsDetailHeader *pb_t_de_headerView;

@property (nonatomic, assign) BOOL isFirst;

@end

@implementation PPGoodsDetailViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_isFirst == YES){
        [self requestMethod];
    }
    _isFirst = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self ppInit];
    self.navBgColr = UIColor.clearColor;
    [self setShowBackBtn:YES];
    [self setNavTitle:@"Pocket Cash"];
    
}


- (void)ppInit {

    
    self.view.backgroundColor = PB_WhiteColor;
    self.pb_t_de_nextStr = @"";
    self.pb_t_de_pouductOrderNo = @"";
    self.pb_t_de_headerView = [[PPGoodsDetailHeader alloc] init];
    self.tableView.backgroundColor = PB_WhiteColor;
    self.tableView.tableHeaderView = self.pb_t_de_headerView;
    [self.tableView registerClass:[PPGoodsDetailTableViewCell class] forCellReuseIdentifier:PPGoodsDetailTableViewCellKey];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(- StatusBarHeightConstant, 0, PB_Ratio(100), 0));
    }];
    


    QMUIButton *submitButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
    submitButton.backgroundColor = PP_AppColor;
    submitButton.layer.cornerRadius = PB_Ratio(22);
    submitButton.layer.masksToBounds = YES;
    [submitButton setTitle:@"Apply Now" forState:UIControlStateNormal];
    submitButton.titleLabel.font = UIFontMediumMake(PB_Ratio(18));
    [submitButton setTitleColor:PB_WhiteColor forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitButtonSender) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //    
    
    QMUIButton *agreeButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
    agreeButton.backgroundColor = UIColor.clearColor;

    [agreeButton setImage:[UIImage imageNamed:@"signin_icon_select"] forState:UIControlStateNormal];
    [agreeButton setImage:[UIImage imageNamed:@"signin_icon_select"] forState:UIControlStateHighlighted];
    [agreeButton addTarget:self action:@selector(agreeButtonSender:) forControlEvents:UIControlEventTouchUpInside];

    
    [agreeButton setImage:UIImageMake(@"signin_icon_selected") forState:UIControlStateSelected];
    agreeButton.selected = YES;
    //
    NSString *agree = @"I have read and agree to the Loan Agreement ";
    NSString *agree1 = @"Loan Agreement ";
    
    QMUIButton *pb_t_de_pAgreebutton = [QMUIButton buttonWithType:UIButtonTypeCustom];
    pb_t_de_pAgreebutton.backgroundColor = UIColor.clearColor;
    [pb_t_de_pAgreebutton setTitle:agree forState:UIControlStateNormal];
    pb_t_de_pAgreebutton.titleLabel.font = UIFontMake(PB_Ratio(12));
    [pb_t_de_pAgreebutton setTitleColor:PB_Gray_1_Color forState:UIControlStateNormal];
    [pb_t_de_pAgreebutton addTarget:self action:@selector(agreeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    NSAttributedString *attri = [PPTools pb_t_attriStringWithHexString:agree1 totalStr:agree norColor:PB_Gray_1_Color attriColor:PP_AppColor norFont:UIFontMake(PB_Ratio(12)) attriFont:UIFontMake(PB_Ratio(12)) underline:YES];
    [pb_t_de_pAgreebutton setAttributedTitle:attri forState:UIControlStateNormal];
    
    

    [self.view addSubview:submitButton];
    [self.view addSubview:agreeButton];
    [self.view addSubview:pb_t_de_pAgreebutton];
    self.pb_t_de_submitBtn = submitButton;
    self.agreeBtn = agreeButton;
    self.pb_t_de_pAgreebutton = pb_t_de_pAgreebutton;
    self.agreeBtn.hidden = YES;
    self.pb_t_de_pAgreebutton.hidden = YES;
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_offset(-PB_Ratio(50));
        make.width.mas_equalTo(PB_SW - PB_Ratio(47)*2);
        make.height.mas_equalTo(PB_Ratio(44));
    }];
    [agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(PB_Ratio(21));
        make.left.mas_equalTo(PB_Ratio(31));
        make.top.mas_equalTo(submitButton.mas_bottom).offset(PB_Ratio(6));
    }];
    
    [pb_t_de_pAgreebutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(agreeButton);
        make.left.mas_equalTo(agreeButton.mas_right);
        make.width.mas_lessThanOrEqualTo(PB_SW - PB_Ratio(67));
    }];
    [self requestMethod];
    [self setPpShowTableViewHeaderRefresh:YES];
}


- (void)requestMethod{

    if(_isFirst == NO){
        [QMUITips showLoading:PBLoading_TipMsg inView:self.view];
    }
    NSDictionary *p = @{
        @"foundation":PBStrFormat(self.goodsId)
    };
    [[PB_RequestHelper pb_instance] pb_postRequestWithUrlStr:PBURL_productDetailInfoUrl params:p commplete:^(NSDictionary * _Nullable result, NSInteger statusCode) {
        [QMUITips hideAllTips];
        if(result != nil){
            self.dataModel = [PPDetailModel yy_modelWithJSON:result];
            [self.pb_t_de_headerView pp_configData:self.dataModel];
            self.dataArray = @[];
            if(self.dataModel && self.dataModel.theoretical.valuing.count > 0){
                self.dataArray = self.dataModel.theoretical.valuing;
            }
            if(self.dataModel.theoretical.grant != nil){
                self.pb_t_de_nextStr = PBStrFormat(self.dataModel.theoretical.grant.availability);
            }else{
                self.pb_t_de_nextStr = @"";
            }
            if(![NSString PB_CheckStringIsEmpty:self.dataModel.theoretical.addressed.courses]){
                self.navTitle = self.dataModel.theoretical.addressed.courses;
            }
            self.pb_t_de_pouductOrderNo = PBStrFormat(self.dataModel.theoretical.addressed.enough);
            self.pb_t_de_submitBtn.hidden = self.dataArray.count > 0 ? NO : YES;
            if(![NSString PB_CheckStringIsEmpty:self.dataModel.theoretical.addressed.lobbying]){
                [self.pb_t_de_submitBtn setTitle:self.dataModel.theoretical.addressed.lobbying forState:UIControlStateNormal];
            }
            if([NSString PB_CheckStringIsEmpty:self.dataModel.theoretical.ethnic.age]){
                self.agreeBtn.hidden = YES;
                self.pb_t_de_pAgreebutton.hidden = YES;
            }else{
                self.agreeBtn.hidden = NO;
                self.pb_t_de_pAgreebutton.hidden = NO;
            }
        }
        [self.tableView reloadData];
        [self ppTableViewEndAllRefresh];
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
        [QMUITips showError:errorStr inView:self.view];
        [self ppTableViewEndAllRefresh];
    }];
}

- (void)requestToBorrow{
    [QMUITips showLoading:PBLoading_TipMsg inView:self.view];
//    NSDictionary *params = @{
//        @"medicinal":orderNo,//订单号
//        @"develop":PHStringForm(self.dataModel.should.level.develop),//金额
//        @"reveals":PHStringForm(self.dataModel.should.level.reveals),//借款期限
//        @"unique":@(self.dataModel.should.level.unique),//期限类型
//    };
    NSString *goodsOrderId = PBStrFormat(self.dataModel.theoretical.addressed.enough);
    NSString *goodsAmount = PBStrFormat(self.dataModel.theoretical.addressed.issue);
    NSString *goodsTerm = PBStrFormat(self.dataModel.theoretical.addressed.narratives);
    NSString *l_oanType = PBStrFormat(self.dataModel.theoretical.addressed.drury);

    NSDictionary *params = @{
        @"aged":goodsOrderId,//订单号
        @"issue":goodsAmount,//金额
        @"narratives":goodsTerm,//借款期限
        @"drury":l_oanType,//借款类型
    };

    [[PB_RequestHelper pb_instance] pb_postRequestWithUrlStr:PBURL_myOrderListItemLinkUrl params:params commplete:^(NSDictionary * _Nullable result, NSInteger statusCode) {
        [QMUITips hideAllTips];
        if(result != nil){
            PPBaseModel *model = [PPBaseModel yy_modelWithJSON:result];
            NSString *linkStr = PBStrFormat(model.theoretical.translated);
            [PB_APP_Control pb_t_goToModuleWithJudgeTypeStr:linkStr fromVC:self];
            [self pb_t_toRePortRiskDataToServeFromStep];
            [PB_GetVC pb_to_removeViewController:self];
        }
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
        [QMUITips showError:errorStr];
    }];
}


- (void)pb_t_de_TableViewHeaderRefreshMethod {
    [self requestMethod];
}


#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PPGoodsDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PPGoodsDetailTableViewCellKey forIndexPath:indexPath];
    [cell pb_configWithCellData:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PB_Ratio(70);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.dataArray.count == 0)
        return;

    /**
     1、未完成--可点击
     2、已完成--可查看结果
     3、认证需要按照顺序
     */
    PPDetailValuingModel *model = self.dataArray[indexPath.row];
//    if([model.availability isEqualToString:@"ste"]){//第五步，绑卡H5
//        if([NSString PB_CheckStringIsEmpty:model.translated]){
//            [self submitButtonSender];
//        }else{
//            [PB_APP_Control pb_t_goToModuleWithJudgeTypeStr:model.translated fromVC:self];
//        }
//
//    }else{
//        if(model.acknowledges != 1){ //未完成
//            [self submitButtonSender];
//        }else{ //查看
//            NSString *currentStep = PBStrFormat(model.availability);
//            [self toAuthVCWithSetpId:currentStep];
//        }
//    }
    
    if(model.acknowledges != 1){ //未完成
        [self submitButtonSender];
    }else{ //查看
        if([model.availability isEqualToString:@"ste"]){//第五步，绑卡H5
            if([NSString PB_CheckStringIsEmpty:model.translated]){
                //详情查看链接为空，那么直接进行认证H5
                [self submitButtonSender];
            }else{
                //已经从H5认证过，那么进行查看H5详情
                [PB_APP_Control pb_t_goToModuleWithJudgeTypeStr:model.translated fromVC:self];
            }
        }else{
            NSString *currentStep = PBStrFormat(model.availability);
            [self toAuthVCWithSetpId:currentStep];
        }
    }

}

//进入认证页面的唯一入口
- (void)toAuthVCWithSetpId:(NSString *)stepId {
    NSString *productId = PBStrFormat(self.dataModel.theoretical.addressed.pivotal);
    NSString *orderNo = PBStrFormat(self.dataModel.theoretical.addressed.enough);
    //获取当前步骤属于第几步
    [PB_APP_Control pb_t_toCertifyStepIndexWithProductId:productId oId:orderNo stepStr:stepId fromVC:self];
}


#pragma mark - click

- (void)agreeButtonAction:(QMUIButton *)button {
    NSString *agreeUrlString = PBStrFormat(self.dataModel.theoretical.ethnic.funds);
    [PB_APP_Control pb_t_goToModuleWithJudgeTypeStr:agreeUrlString fromVC:self];
}

- (void)submitButtonSender {
    if(self.dataModel == nil){
        return;
    }
    if(self.dataModel.theoretical.valuing && self.dataModel.theoretical.valuing.count == 0){
        NSLog(@"认证项为空，不能 take order");
        return;
    }else{
        BOOL hasAllComplete = YES;
        //判断是否进行下单
        for (NSInteger i = 0; i < self.dataModel.theoretical.valuing.count; i++) {
            PPDetailValuingModel *model = self.dataModel.theoretical.valuing[i];
            if(model.acknowledges == 0){
                hasAllComplete = NO;
                break;
            }
        }
        if(hasAllComplete == YES){
            
            //下单操作
            QMUIModalPresentationViewController *qmAlert = [[QMUIModalPresentationViewController alloc] init];
            qmAlert.animationStyle = QMUIModalPresentationAnimationStylePopup;

            PB_FunSureAlertView *tipView = [[PB_FunSureAlertView alloc] init];
            qmAlert.contentView = tipView;
            //关闭点击背景自动隐藏
            qmAlert.modal = YES;
            [qmAlert showWithAnimated:YES completion:nil];
            PMMyWeekSelf
            tipView.myBlock = ^(NSInteger buttonIndex) {
                [qmAlert hideWithAnimated:YES completion:nil];
                if(buttonIndex == 50){
                    [weakSelf requestToBorrow];
                }
            };
            return;
        }
    }
    
    if([NSString PB_CheckStringIsEmpty:self.pb_t_de_nextStr]){
        NSLog(@"next auth is empty");
    }else{
        if([self.pb_t_de_nextStr isEqualToString:@"ste"]){ //h5
            if([NSString PB_CheckStringIsEmpty:self.dataModel.theoretical.grant.translated] == NO){
                NSString *url = PBStrFormat(self.dataModel.theoretical.grant.translated);
                [PB_APP_Control pb_t_goToModuleWithJudgeTypeStr:url fromVC:self];
            }
        }else{
           [self toAuthVCWithSetpId:self.pb_t_de_nextStr];
        }
    }
}

- (void)agreeButtonSender:(QMUIButton *)button {
    button.selected = !button.selected;
    self.pb_t_de_submitBtn.enabled = button.selected;
}



//#pragma mark - risk
- (void)pb_t_toRePortRiskDataToServeFromStep {
    NSString *goodsOrderId = PBStrFormat(self.dataModel.theoretical.addressed.enough);
    NSDictionary *riskDict = @{
        @"speak":PBStrFormat([PB_timeHelper pb_t_getCurrentStampTimeString]),
        @"advantage":PBStrFormat([PB_timeHelper pb_t_getCurrentStampTimeString]),
        @"rejection":@"9",
        @"constraining":PBStrFormat(goodsOrderId)
    };
    [[PB_APP_Control instanceOnly] pb_t_toRePortRiskDataToServe:riskDict];
}

@end
