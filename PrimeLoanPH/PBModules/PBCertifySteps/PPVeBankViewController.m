//
//  PPVeBankViewController.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/31.
//

#import "PPVeBankViewController.h"
#import "PPVeNorInfoModel.h"
#import "PPBaseModel.h"
#import "PPVeNorInputTableViewCell.h"
#import "PB_BankNoAlertView.h"
#import "PPGoodsDetailViewController.h"
#import <BRPickerView.h>

@interface PPVeBankViewController ()<PPVeNorInputTableViewCellDelegate>

@property (nonatomic, strong) UIButton *pb_t_de_submitButton;
@property (nonatomic, strong) PPVeNorInfoModel *dataModel;
@property (nonatomic, strong) NSArray <PPVeNorInfoMceachronModel *>*dataArr;
@property (nonatomic, strong)  BRStringPickerView *stringPickerView;
@property (nonatomic, strong) BRAddressPickerView *adressPickerView;
@property (nonatomic, copy) NSString *currentKeyCode;//当前cell 的code
@property (nonatomic, strong) NSMutableArray *adressSelArr;
@property (nonatomic, strong) NSMutableDictionary *submitParams;//最终需要提交的参数

@property (nonatomic, copy) NSString *pb_t_de_reportStartTime;
@property (nonatomic, copy) NSString *pb_t_de_reportEndTime;

@end

@implementation PPVeBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setShowBackBtn:YES];
    [self setNavTitle:@"Bank Card Info"];
    self.view.backgroundColor = PB_BgColor;
    [self ppInit];
}

- (void)ppInit{
    
    self.pb_t_de_reportStartTime = [PB_timeHelper pb_t_getCurrentStampTimeString];
    self.pb_t_de_reportEndTime = @"";
    
    self.submitParams = [NSMutableDictionary dictionaryWithDictionary:@{@"foundation":self.pId}];
    self.currentKeyCode = @"";
    self.adressSelArr = [[NSMutableArray alloc] initWithArray:@[@(0),@(0),@(0)]];
    self.view.backgroundColor = PB_BgColor;
    //
    [self.tableView registerClass:PPVeNorInputTableViewCell.class forCellReuseIdentifier:PPVeNorInputTableViewCellKey];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(PB_NaviBa_H, 0, PB_Ratio(100), 0));
    }];
    self.tableView.backgroundColor = PB_BgColor;
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
    [QMUITips showLoading:PBLoading_TipMsg inView:self.view];
    NSDictionary *params = @{
        @"foundation":PBStrFormat(self.pId),
    };
    [[PB_RequestHelper pb_instance] pb_postRequestWithUrlStr:PBURL_V5BankInfoUrl params:params commplete:^(NSDictionary * _Nullable result, NSInteger statusCode) {
        [QMUITips hideAllTips];
        if(result != nil){
            self.dataModel = [PPVeNorInfoModel yy_modelWithJSON:result];
            self.dataArr = @[];
            if(self.dataModel.theoretical.mceachron.count > 0){
                self.dataArr = self.dataModel.theoretical.mceachron;
            }
        }
        [self refreshSubmitParams];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
        [QMUITips showError:errorStr inView:self.view];
    }];
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
        [_pb_t_de_submitButton addTarget:self action:@selector(pb_t_de_submitButtonSender:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pb_t_de_submitButton;
}

- (BRStringPickerView *)stringPickerView{
    if(!_stringPickerView){
        _stringPickerView = [PB_BR pb_to_getCustomStringPickerView];
        _stringPickerView.isAutoSelect = YES;
        PMMyWeekSelf
        _stringPickerView.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
            //NSLog(@"%@--%zd",resultModel.value,resultModel.index);
            for (NSInteger i = 0; i < self.dataArr.count; i++) {
                PPVeNorInfoMceachronModel *itemModel = weakSelf.dataArr[i];
                if([weakSelf.currentKeyCode isEqualToString:itemModel.defines]){
                    for (NSInteger j = 0; j < itemModel.identified.count; j++) {
                        if(j == resultModel.index){
                            weakSelf.dataArr[i].identified[j].select = YES;
                            weakSelf.dataArr[i].stemming = resultModel.value;
                            itemModel.choice = weakSelf.dataArr[i].identified[j].reviewed;
                        }else{
                            weakSelf.dataArr[i].identified[j].select = NO;
                        }
                    }
                }
            }
            [weakSelf.tableView reloadData];
            [weakSelf refreshSubmitParams];
        };
    }
    return _stringPickerView;
}

- (BRAddressPickerView *)adressPickerView {
    if(!_adressPickerView){
        _adressPickerView = [PB_BR pb_to_getAdressCustomPickerView];
        _adressPickerView.isAutoSelect = YES;
        PMMyWeekSelf
        _adressPickerView.resultBlock = ^(BRProvinceModel * _Nullable province, BRCityModel * _Nullable city, BRAreaModel * _Nullable area) {
            NSString *result = @"";
            //NSLog(@"选择的地址：%@",result);
            if(province){
                weakSelf.adressSelArr[0] = @(province.index);
                result = [NSString stringWithFormat:@"%@",province.name];
            }
            if(city){
                weakSelf.adressSelArr[1] = @(city.index);
                result = [NSString stringWithFormat:@"%@|%@",result,city.name];
            }
            if(area){
                weakSelf.adressSelArr[2] = @(area.index);
                result = [NSString stringWithFormat:@"%@|%@",result,area.name];
            }

            for (NSInteger i = 0; i < self.dataArr.count; i++) {
                PPVeNorInfoMceachronModel *itemModel = weakSelf.dataArr[i];
                if([weakSelf.currentKeyCode isEqualToString:itemModel.defines]){
                    weakSelf.dataArr[i].stemming = result;
                }
            }
            [weakSelf.tableView reloadData];
            [weakSelf refreshSubmitParams];
        };
    }
    return _adressPickerView;
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PPVeNorInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PPVeNorInputTableViewCellKey forIndexPath:indexPath];
    [cell pb_configWithCellData:self.dataArr[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PB_Ratio(105);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    PPVeNorInfoMceachronModel *model = self.dataArr[indexPath.row];
    self.currentKeyCode = PBStrFormat(model.defines);
    NSString *type = PBStrFormat(model.blair);
    if([type isEqualToString:@"sea"]){//enum
        NSMutableArray <NSString *>*stringArray = [[NSMutableArray alloc] init];
        NSInteger selectIndex = 0;
        for (NSInteger i = 0; i < model.identified.count; i++) {
            [stringArray addObject:PBStrFormat(model.identified[i].celebrating)];
            if(model.identified[i].select == YES){
                selectIndex = i;
            }
        }
        self.stringPickerView.dataSourceArr = stringArray;
        self.stringPickerView.selectIndex = selectIndex;
        self.stringPickerView.title = PBStrFormat(model.age);
        [self.stringPickerView show];
        
    }else if ([type isEqualToString:@"seb"]){//txt
     
    }else if ([type isEqualToString:@"sec"]){//citySelect
        self.adressPickerView.title = PBStrFormat(model.age);
        if([PB_APP_Control instanceOnly].adressArray.count == 0){
            [QMUITips showInfo:@"city adress is on request..." inView:self.view];
            PMMyWeekSelf
            [PB_APP_Control pb_t_toRequestAdressDataSuccessAfterCallBack:^(id  _Nonnull data) {
                [weakSelf showAdressPickerView];
            }];
        }else{
            [self showAdressPickerView];
        }
    }
}

- (void)showAdressPickerView {
   
    self.adressPickerView.dataSourceArr = [PB_APP_Control instanceOnly].adressArray;
    self.adressPickerView.selectIndexs = self.adressSelArr;
    [self.adressPickerView show];
}

#pragma mark - delegate
- (void)pPVeNorInputTableViewCellEndInput:(NSString *)value key:(NSString *)key {
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        PPVeNorInfoMceachronModel *model = self.dataArr[i];
        if([model.defines isEqualToString:key]){//匹配到code
            self.dataArr[i].stemming = PBStrFormat(value);
            break;
        }
    }
    [self.tableView reloadData];
    [self refreshSubmitParams];
}

#pragma mark - 更新提交参数
- (void)refreshSubmitParams {
    
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        PPVeNorInfoMceachronModel *model = self.dataArr[i];
        NSString *code = PBStrFormat(model.defines);
        NSString *type = PBStrFormat(model.blair);
        NSString *value = @"";
        if([type isEqualToString:@"sea"]){//enum
            //值匹配code
            if(model.choice == 0 && [NSString PB_CheckStringIsEmpty:model.stemming] == NO){
                for (NSInteger j = 0; j < model.identified.count; j++) {
                    if([model.stemming isEqualToString:model.identified[j].celebrating]){
                        model.choice = model.identified[j].reviewed;
                        break;
                    }
                }
            }
            
            value = [NSString stringWithFormat:@"%ld",model.choice];
        }else if ([type isEqualToString:@"seb"]){//txt
            value = PBStrFormat(model.stemming);
        }else if ([type isEqualToString:@"sec"]){//citySelect
            value = PBStrFormat(model.stemming);
        }
        if([NSString PB_CheckStringIsEmpty:value] == NO){
            [self.submitParams setValue:value forKey:code];
        }
    }
    NSLog(@"self.submitParams===%@",self.submitParams);
}

#pragma mark - Click
- (void)pb_t_de_submitButtonSender:(QMUIButton *)button{

    PMMyWeekSelf
    [self.view endEditing:YES];
    __block BOOL hasAllComplete = YES;
    [self.submitParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if([NSString PB_CheckStringIsEmpty:obj]){
                hasAllComplete = NO;
            }
    }];
    if(hasAllComplete == NO){
        [self requestToSubmit];
    }else{
        QMUIModalPresentationViewController *qmAlert = [[QMUIModalPresentationViewController alloc] init];
        qmAlert.animationStyle = QMUIModalPresentationAnimationStylePopup;
        PB_BankNoAlertView *tipView = [[PB_BankNoAlertView alloc] initWithBankNo:self.submitParams[@"help"]];
        qmAlert.contentView = tipView;
        //关闭点击背景自动隐藏
        qmAlert.modal = YES;
        [qmAlert showWithAnimated:YES completion:nil];
        tipView.myBlock = ^(NSInteger buttonIndex) {
            [qmAlert hideWithAnimated:YES completion:nil];
            NSLog(@"buttonIndex = %ld",buttonIndex);
            if (buttonIndex == 50) {
                [weakSelf requestToSubmit];
            }
        };
    }
}



- (void)requestToSubmit{
    
    [QMUITips showLoading:PBLoading_TipMsg inView:self.view];
    [[PB_RequestHelper pb_instance] pb_postRequestWithUrlStr:PBURL_V5BankSubUrl params:self.submitParams commplete:^(NSDictionary * _Nullable result, NSInteger statusCode) {
        [QMUITips hideAllTips];
        if(result != nil){
            [self pb_t_toRePortRiskDataToServeFromStep];
            [self goToProductDetailVC];
        }
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
        [QMUITips showError:errorStr inView:self.view];
    }];
}

- (void)goToProductDetailVC {
    NSMutableArray *vcArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    BOOL exist = NO;
    for (NSInteger i = 0; i < vcArr.count; i++) {
        if ([vcArr[i] isKindOfClass:[PPGoodsDetailViewController class]]){
            exist = YES;
            [self.navigationController popToViewController:vcArr[i] animated:YES];
            break;
        }
    }
    if(exist == NO){
        PPGoodsDetailViewController *vc = [[PPGoodsDetailViewController alloc] init];
        vc.goodsId = self.pId;
        [self.navigationController pushViewController:vc animated:YES];
        [PB_GetVC pb_to_removeViewController:self];
    }
}


#pragma mark - risk
- (void)pb_t_toRePortRiskDataToServeFromStep{
    self.pb_t_de_reportEndTime = [PB_timeHelper pb_t_getCurrentStampTimeString];
    NSDictionary *riskDict = @{
        @"speak":PBStrFormat(self.pb_t_de_reportStartTime),
        @"advantage":PBStrFormat(self.pb_t_de_reportEndTime),
        @"rejection":@"8"
    };
    [[PB_APP_Control instanceOnly] pb_t_toRePortRiskDataToServe:riskDict];
}



@end
