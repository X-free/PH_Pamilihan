//
//  PPTableViewController.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/27.
//

#import "PPTableViewController.h"

@interface PPTableViewController ()



@property (nonatomic, assign) BOOL tableViewIsGroupStyle;


@end

@implementation PPTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _ppTablViewPageNo = 1;
    _ppTableViewPageSize = 10;
    _ppShowTableViewHeaderRefresh = NO;
    _ppShowTableViewFooterRefresh = NO;
    self.view.backgroundColor = PB_BgColor;
    [self.view addSubview:self.tableView];
}

- (instancetype)initWithPBTableViewOfGroupStyle:(BOOL)tableViewIsGroupStyle {
    if(self = [super init]){
        _tableViewIsGroupStyle = tableViewIsGroupStyle;
    }
    return self;
}


- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:_tableViewIsGroupStyle ? UITableViewStyleGrouped : UITableViewStylePlain];
        
        _tableView.backgroundColor = PB_BgColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  [[UIScreen mainScreen] bounds].size.width, 34)];
        _tableView.keyboardDismissMode =  UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.estimatedSectionFooterHeight = CGFLOAT_MIN;
        _tableView.estimatedSectionHeaderHeight = CGFLOAT_MIN;
//        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) {
//             if (@available(iOS 11.0, *)) {
//                 _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//             }
//         }else {
//             self.automaticallyAdjustsScrollViewInsets = NO;
//         }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = UIColor.clearColor;
        
        NSLog(@"-----------------------");
        //iOS 15z之后。sectionHeaderTopPadding 默认值为22，头部出现空白
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}

- (void)setPpShowTableViewHeaderRefresh:(BOOL)ppShowTableViewHeaderRefresh {
    if(_ppShowTableViewHeaderRefresh != ppShowTableViewHeaderRefresh)
        _ppShowTableViewHeaderRefresh = ppShowTableViewHeaderRefresh;
    
    __weak typeof(self) _self = self;
    if(_ppShowTableViewHeaderRefresh) {
        [self headerRefreshWithTableView:self.tableView complete:^{
            [_self pb_t_de_TableViewHeaderRefreshMethod];
        }];
        self.tableView.mj_header.accessibilityIdentifier = @"refresh_PH";
    }else{
        [self.tableView setMj_header:nil];
    }
}

- (void)setppShowTableViewFooterRefresh:(BOOL)ppShowTableViewFooterRefresh {
    if(_ppShowTableViewHeaderRefresh != ppShowTableViewFooterRefresh)
        _ppShowTableViewHeaderRefresh = ppShowTableViewFooterRefresh;
    
    __weak typeof(self) _self = self;
    if(_ppShowTableViewFooterRefresh){
        [self footerRefreshWithTableView:self.tableView complete:^{
            [_self ppTableViewFooterRefreshMethod];
        }];
        self.tableView.mj_footer.accessibilityIdentifier = @"refresh_PF";
    }else{
        [self.tableView setMj_footer:nil];
    }

}

- (void)headerRefreshWithTableView:(UITableView *)tableview complete:(void (^)(void))complete{

    
    MJRefreshNormalHeader *ppHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        complete();
     }];
    ppHeader.lastUpdatedTimeLabel.hidden= YES;
    ppHeader.stateLabel.hidden = NO;
    NSString *str11 = @"Pulldown to roload";
    NSString *str22 = @"Release to reload";
    NSString *str33 = @"Refreshing....";
    [ppHeader setTitle:str11 forState:MJRefreshStateIdle];
    [ppHeader setTitle:str22 forState:MJRefreshStatePulling];
    [ppHeader setTitle:str33 forState:MJRefreshStateRefreshing];
    tableview.mj_header = ppHeader;

}

- (void)footerRefreshWithTableView:(UITableView *)tableview complete:(void (^)(void))complete{
    
    MJRefreshBackStateFooter *ppFooter = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        complete();
    }];
    tableview.mj_footer = ppFooter;
}


#pragma mark - refresh finish
- (void)headerTableViewDidFinishRefresh {
    __weak typeof(self) _self = self;
    [_self.tableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_self.tableView.mj_header endRefreshing];
        if (_self.ppShowTableViewFooterRefresh) {
             [_self.tableView.mj_footer endRefreshing];
        }
    });
}

- (void)ppTableViewFooterDidFinishRefresMore:(BOOL)hasMore {
    __weak typeof(self) _self = self;
    [_self.tableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (hasMore) {
            [_self.tableView.mj_footer endRefreshing];
        }else{
            [_self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    });
}

- (void)ppTableViewDidFinishRefreshFail {
    if (self.ppTablViewPageNo > 1) {
        self.ppTablViewPageNo--;
    }
    [self headerTableViewDidFinishRefresh];
    [self ppTableViewFooterDidFinishRefresMore:YES];
}

- (void)ppTableViewEndAllRefresh{
    if(self.tableView.mj_header.isRefreshing){
        [self.tableView.mj_header endRefreshing];
    }
    if(self.tableView.mj_footer.isRefreshing){
        [self.tableView.mj_footer endRefreshing];
    }
}





#pragma mark - refresh method
- (void)pb_t_de_TableViewHeaderRefreshMethod {
    
}

- (void)ppTableViewFooterRefreshMethod {
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"pp_cellKey";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"pp_headerKey"];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"pp_footerKey"];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}




@end
