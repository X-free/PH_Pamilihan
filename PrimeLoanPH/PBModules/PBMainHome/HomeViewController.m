//
//  HomeViewController.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/27.
//

#import "HomeViewController.h"
#import "PPHomeHeaderView.h"
#import "PPHomeMoreHeaderView.h"
#import "PPHomeTableViewCell.h"
#import "PPHomeMoreTableViewCell.h"
#import "PPHomeNotiHeader.h"
#import "PPHomeNameHeaderFooterView.h"
#import "PBSmallTableHeaderSectionView.h"
#import "PPHomeModel.h"
#import "PBBorrGuideVC.h"

@interface HomeViewController ()<PPHomeTableViewBigCellDelegate>

@property (nonatomic, assign) BOOL isBigType;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) PPHomeHeaderView *pb_t_de_largeHeaderView;
@property (nonatomic, strong) PPHomeMoreHeaderView *smallHeaderView;
@property (nonatomic, strong) PPHomeModel *dataModel;
@property (nonatomic, strong) NSMutableArray <PPHomeConclusionModel *>*pb_t_de_smallArray;
@property (nonatomic, strong) PPHomeConclusionModel *pb_t_de_largeCardModel;
@property (nonatomic, strong) PPHomeConclusionModel *pb_t_de_smallCardModel;


@end

@implementation HomeViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_isFirst == YES){
        [self requestMethod];
        [self pb_t_de_toReportAllInfomationToServe];
    }
    _isFirst = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self ppStart];
    [self requestMethod];
}

- (void)ppStart {
    

    self.showNavBar = NO;    
    self.pb_t_de_smallArray = [[NSMutableArray alloc] init];
    
    [self.tableView registerClass:[PPHomeTableViewCell class] forCellReuseIdentifier:PPHomeTableViewCellKey];
    [self.tableView registerClass:[PPHomeMoreTableViewCell class] forCellReuseIdentifier:PPHomeMoreTableViewCellKey];
    [self.tableView registerClass:[PPHomeNotiHeader class] forHeaderFooterViewReuseIdentifier:PPHomeNotiHeaderKey];
    [self.tableView registerClass:PPHomeNameHeaderFooterView.class forHeaderFooterViewReuseIdentifier:PPHomeNameHeaderFooterViewKey];
    [self.tableView registerClass:PBSmallTableHeaderSectionView.class forHeaderFooterViewReuseIdentifier:PBSmallTableHeaderSectionViewKey_de];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(- StatusBarHeightConstant, 0, 0, 0));
    }];
    self.tableView.tableHeaderView = self.pb_t_de_largeHeaderView;
    self.tableView.backgroundColor = PB_Color(@"#F4F5F9");
    //[self.view bringSubviewToFront:self.tableView];
    [self setPpShowTableViewHeaderRefresh:YES];
    [self uploadLocationInfo];
    [PB_NotificationOfCenter addObserver:self selector:@selector(loginSuccess:) name:PB_NotiLoginThanSuccess object:nil];
    [PB_NotificationOfCenter addObserver:self selector:@selector(loginOut:) name:PB_NotiLogoutThanToHome object:nil];
    
    [self performSelector:@selector(uploadLocationInfo) withObject:nil afterDelay:5];
    [self performSelector:@selector(uploadDevicetInfo) withObject:nil afterDelay:3];
    [self performSelector:@selector(uploadGoogleMarketInfo) withObject:nil afterDelay:6];
    [self performSelector:@selector(requestAdressData) withObject:nil afterDelay:7];
}

- (void)requestAdressData{
    [PB_APP_Control pb_t_toRequestAdressDataSuccessAfterCallBack:^(id  _Nonnull data) {
            
    }];
}

- (void)requestMethod {

    if(_isFirst == NO){
        [QMUITips showLoading:PBLoading_TipMsg inView:self.view];
    }
    [[PB_RequestHelper pb_instance] pb_getRequestWithUrlStr:PBURL_appHomeUrl params:@{} commplete:^(id  _Nullable result, NSInteger statusCode) {
        [QMUITips hideAllTips];
        if(result != nil){
            self.dataModel = [PPHomeModel yy_modelWithJSON:result];
            [self refreshUIWithPageData];
        }
        [self ppTableViewEndAllRefresh];
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
        [QMUITips showError:errorStr inView:self.view];
        [self ppTableViewEndAllRefresh];
    }];
}

//刷新页面数据
- (void)refreshUIWithPageData {
    
    if(self.dataModel.theoretical.draw.count > 0){
        //移除旧数据
        if(self.pb_t_de_smallArray.count > 0)
           [self.pb_t_de_smallArray removeAllObjects];
        for (NSInteger i = 0; i < self.dataModel.theoretical.draw.count; i++) {
            PPHomeDrawModel *model = self.dataModel.theoretical.draw[i];
            NSString *typeStr = PBStrFormat(model.reviewed);
            if([typeStr isEqualToString:@"sra"]){//广告图BANNER
                
            }else if ([typeStr isEqualToString:@"srb"]){//大卡LARGE_CARD
                _isBigType = YES;
                if(model.conclusion.count > 0){
                    self.pb_t_de_largeCardModel = model.conclusion[0];
                    [self.pb_t_de_largeHeaderView pp_configData:self.pb_t_de_largeCardModel];
                    [self.pb_t_de_largeHeaderView pp_configAgreeData:self.dataModel.theoretical.ethnic];
                    [self.pb_t_de_largeHeaderView pp_configMsgData:self.dataModel];
//                    if(self.tableView.tableHeaderView != self.pb_t_de_largeHeaderView){
//                        self.tableView.tableHeaderView = nil;
//                        self.tableView.tableHeaderView = self.pb_t_de_largeHeaderView;
//                    }
                }
            }else if ([typeStr isEqualToString:@"src"]){//小卡SMALL_CARD
                _isBigType = NO;
                if(model.conclusion.count > 0){
                    self.pb_t_de_smallCardModel = model.conclusion[0];
                    
                    
                    [self.pb_t_de_largeHeaderView pp_configData:self.pb_t_de_smallCardModel];
                    [self.pb_t_de_largeHeaderView pp_configAgreeData:self.dataModel.theoretical.ethnic];
                    [self.pb_t_de_largeHeaderView pp_configMsgData:self.dataModel];
                    
//                    [self.smallHeaderView pp_configData:self.pb_t_de_smallCardModel];
//                    [self.pb_t_de_largeHeaderView pp_configAgreeData:self.dataModel.theoretical.ethnic];
                }
//                if(self.tableView.tableHeaderView != self.smallHeaderView){
//                    self.tableView.tableHeaderView = nil;
//                    self.tableView.tableHeaderView = self.smallHeaderView;
//                }
            }else if ([typeStr isEqualToString:@"srd"]){//极速PRODUCT_LIST
                _isBigType = NO;
                [self.pb_t_de_smallArray addObjectsFromArray:model.conclusion];
            }
        }        
        [self.tableView reloadData];
    }
}

#pragma mark - refresh method
- (void)pb_t_de_TableViewHeaderRefreshMethod {
    [self requestMethod];
}



#pragma mark - tableView method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_isBigType){
        return 1;
    }
    return self.pb_t_de_smallArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_isBigType){
        PPHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PPHomeTableViewCellKey forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }else{
        PPHomeMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PPHomeMoreTableViewCellKey forIndexPath:indexPath];
        [cell pb_configWithCellData:self.pb_t_de_smallArray[indexPath.row]];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    
//    NSInteger judge = [PB_APP_Control instanceOnly].pb_t_serve_set_Language;
    if(_isBigType){
        PPHomeNameHeaderFooterView *pb_t_mvpV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:PPHomeNameHeaderFooterViewKey];
        [pb_t_mvpV pb_t_mvpTagName:1];
        return pb_t_mvpV;
        
    }else{
        PBSmallTableHeaderSectionView *pb_samllSectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:PBSmallTableHeaderSectionViewKey_de];
        return pb_samllSectionView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(_isBigType){
        return  PB_Ratio(290);
    }else{
        return PB_Ratio(290 + 46 - 128);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_isBigType){
        return PB_Ratio(127);
    }else{        
        return PB_Ratio(140);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if(_isBigType == NO && self.pb_t_de_smallArray.count > 0){
        PPHomeConclusionModel *model = self.pb_t_de_smallArray[indexPath.row];
        [self productPermissionWithPid:model.pivotal];
    }else{
        //大卡专用Id
        //[self productPermissionWithPid:self.pb_t_de_largeCardModel.pivotal];
        
//        PBBorrGuideVC *vc = [[PBBorrGuideVC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)PPHomeTableViewCellTapTag:(NSInteger)indexTag {
    if(indexTag == 1){
        PBBorrGuideVC *vc = [[PBBorrGuideVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexTag == 2){
        if([PB_APP_Control pb_t_presentLoginVCWithTargetVC:self] == NO){
            return;
        }
        NSString *url_pb_link = PBStrFormat(self.dataModel.theoretical.shapes.chapters);
        [PB_APP_Control pb_t_goToModuleWithJudgeTypeStr:url_pb_link fromVC:self];
    }
}

///根据产品ID判断产品准入
- (void)productPermissionWithPid:(NSInteger)pId {
    
    if([PB_APP_Control pb_t_presentLoginVCWithTargetVC:self] == NO){
        return;
    }
    [PB_APP_Control pb_t_toRequestProductIsCanEnterAllowWithProductID:pId fromVC:self];
}

- (PPHomeHeaderView *)pb_t_de_largeHeaderView {
    if(!_pb_t_de_largeHeaderView){
        PMMyWeekSelf
        _pb_t_de_largeHeaderView = [[PPHomeHeaderView alloc] initTapBlock:^(NSInteger pId) {
            [weakSelf productPermissionWithPid:pId];
        }];
    }
    return _pb_t_de_largeHeaderView;
}

- (PPHomeMoreHeaderView *)smallHeaderView {
    if(!_smallHeaderView){
        PMMyWeekSelf
        _smallHeaderView = [[PPHomeMoreHeaderView alloc] initTapBlock:^(NSInteger pId) {
            [weakSelf productPermissionWithPid:pId];
        }];
    }
    return _smallHeaderView;
}

#pragma mark - upload data
//上报位置信息
- (void)uploadLocationInfo {
    
    [[PB_APP_Control instanceOnly] pb_t_toRePortDataToServeWithType:pb_t_UploadDateTypeLocation];
}

//上报设备信息
- (void)uploadDevicetInfo{
    [[PB_idf_helper instanceOnly] pb_t_enquryIDFA_ask];
    [[PB_APP_Control instanceOnly] pb_t_toRePortDataToServeWithType:pb_t_UploadDateTypeDeviceInfo];
}

//上报googel market 信息
- (void)uploadGoogleMarketInfo{
    [[PB_APP_Control instanceOnly]  pb_t_toRePortDataToServeWithType:pb_t_UploadDateTypeGooleMarket];
}


#pragma mark - noti

- (void)loginSuccess:(NSNotification *)noti{
    [self requestMethod];
    [self pb_t_de_toReportAllInfomationToServe];
}

- (void)pb_t_de_toReportAllInfomationToServe{
    //上报信息
    [self performSelector:@selector(uploadLocationInfo) withObject:nil afterDelay:2];
    [self performSelector:@selector(uploadDevicetInfo) withObject:nil afterDelay:3];
    [self performSelector:@selector(uploadGoogleMarketInfo) withObject:nil afterDelay:4];
}

- (void)loginOut:(NSNotification *)noti {
    [self requestMethod];
}

- (void)dealloc {
    [PB_NotificationOfCenter removeObserver:self name:PB_NotiLoginThanSuccess object:nil];
    [PB_NotificationOfCenter removeObserver:self name:PB_NotiLogoutThanToHome object:nil];
}




@end


/*
动态域名：https://ph-credit-peso-ios.oss-ap-southeast-6.aliyuncs.com/pbt.json
默认接口：https://pbt.mjj-atthi-lending.com/us/
官网：https://mjj-atthi-lending.com/
隐私协议：https://mjj-atthi-lending.com/PB-PrivacyPolicy.html
*/
