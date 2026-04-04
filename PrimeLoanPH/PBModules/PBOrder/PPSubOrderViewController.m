//
//  PPSubOrderViewController.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/31.
//

#import "PPSubOrderViewController.h"

#import "PPOrderTableViewCell.h"
#import "PPOrderEmptyTableViewCell.h"
#import "PPOrderModel.h"

@interface PPSubOrderViewController ()<PPOrderEmptyTableViewCell>

@property (nonatomic, strong) NSArray <PPOrderDrawModel *>*pb_t_dataArray;
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation PPSubOrderViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_isFirst == YES && [PB_APP_Control instanceOnly].pb_t_hasLogin){
        [self requestMethod];
    }
    _isFirst = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self start];
    self.showNavBar = NO;
}


- (void)start {
    
    self.tableView.backgroundColor = PB_BgColor;
    [self.tableView registerClass:[PPOrderTableViewCell class] forCellReuseIdentifier:PB_t_OrderTableViewCellKey_de];
    [self.tableView registerClass:[PPOrderEmptyTableViewCell class] forCellReuseIdentifier:PB_T_OrderEmptyTableViewCellKey_de];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self setPpShowTableViewHeaderRefresh:YES];
    [PB_NotificationOfCenter addObserver:self selector:@selector(pb_t_loginSuccessNotiSender_de) name:PB_NotiLoginThanSuccess object:nil];
    [self requestMethod];
}

- (void)pb_t_loginSuccessNotiSender_de {
    [self requestMethod];
}


- (void)requestMethod {
    if(_isFirst == NO){
        [QMUITips showLoading:PBLoading_TipMsg inView:self.view];
    }
    NSDictionary *pb_t_de_params = @{
        @"statutory":@(self.keyId),
        @"statement":@(1),
        @"differentiate":@(1000)
    };
    [[PB_RequestHelper pb_instance] pb_postRequestWithUrlStr:PBURL_myOrderListUrl params:pb_t_de_params commplete:^(id  _Nullable result, NSInteger statusCode) {
        [QMUITips hideAllTips];
        if(result != nil){
            PPOrderModel *model = [PPOrderModel yy_modelWithJSON:result];
            self.pb_t_dataArray = @[];
            if(model.theoretical.draw.count > 0){
                self.pb_t_dataArray = model.theoretical.draw;
            }
        }
        [self ppTableViewEndAllRefresh];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
        [QMUITips showError:errorStr inView:self.view];
        [self ppTableViewEndAllRefresh];
    }];
}

#pragma mark - refresh method
- (void)pb_t_de_TableViewHeaderRefreshMethod {
    [self requestMethod];
}



#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pb_t_dataArray.count > 0 ? self.pb_t_dataArray.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.pb_t_dataArray.count > 0){
        PPOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PB_t_OrderTableViewCellKey_de forIndexPath:indexPath];
        [cell pb_configWithCellData:self.pb_t_dataArray[indexPath.row]];
        return cell;
    }else{
        PPOrderEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PB_T_OrderEmptyTableViewCellKey_de forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat pb_t_de_itemHeight = PB_Ratio(14) * 2 ;
    if(self.pb_t_dataArray.count > 0){
        CGFloat pb_t_de_total_height = PB_Ratio(96) + PB_Ratio(28);
        PPOrderDrawModel *model = self.pb_t_dataArray[indexPath.row];
        //动态内容展示
        if(model.interpreted.count > 0){
            pb_t_de_total_height += model.interpreted.count * pb_t_de_itemHeight;
        }
        //协议展示
        if(![NSString PB_CheckStringIsEmpty:model.unifying]){
            pb_t_de_total_height += pb_t_de_itemHeight;
        }
        return pb_t_de_total_height;
    }else{
        return PB_Ratio(325);
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //检查是否登录
    if([PB_APP_Control pb_t_presentLoginVCWithTargetVC:self] == NO){
        return;
    }

    if(self.pb_t_dataArray.count > 0){
        PPOrderDrawModel *model = self.pb_t_dataArray[indexPath.row];
        NSString *pb_t_de_link = PBStrFormat(model.cases);
        [PB_APP_Control pb_t_goToModuleWithJudgeTypeStr:pb_t_de_link fromVC:self];;
    }
}


- (void)PB_T_OrderEmptyTableViewCellTapAction_de {
    NSLog(@"Get a loan: to home");
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dealloc {
    [PB_NotificationOfCenter removeObserver:self name:PB_NotiLoginThanSuccess object:nil];
}


@end
