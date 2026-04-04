//
//  PPTableViewController.h
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/27.
//

#import "PPBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPTableViewController : PPBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, assign) NSInteger ppTablViewPageNo;
@property (nonatomic, assign) NSInteger ppTableViewPageSize;


//是否支持上下刷新
@property (nonatomic, assign) BOOL ppShowTableViewHeaderRefresh;
@property (nonatomic, assign) BOOL ppShowTableViewFooterRefresh;
//刷新事件
- (void)pb_t_de_TableViewHeaderRefreshMethod;
- (void)ppTableViewFooterRefreshMethod;
//刷新完成后的回掉
- (void)headerTableViewDidFinishRefresh;
- (void)ppTableViewFooterDidFinishRefresMore:(BOOL)hasMore;
- (void)ppTableViewDidFinishRefreshFail;
- (void)ppTableViewEndAllRefresh;
//初始化
- (instancetype)initWithPBTableViewOfGroupStyle:(BOOL)tableViewIsGroupStyle;


@end

NS_ASSUME_NONNULL_END
