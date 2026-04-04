//
//  MeViewController.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/27.
//

#import "MeViewController.h"
#import "PPMeTableViewCell.h"
#import "PPMeHeader.h"
#import "PPMeModel.h"

@interface MeViewController ()

@property (nonatomic, strong) PPMeHeader *pb_t_headerView;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) NSArray <PPMeDrawModel *> *dataArray;



@end

@implementation MeViewController

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
    [self setShowNavBar:NO];
    [self ppInit];
    [self requestMethod];
}

- (void)ppInit{
    PMMyWeekSelf
    self.pb_t_headerView = [[PPMeHeader alloc] initWithTapBack:^(NSInteger index) {
        [weakSelf toOrderListWithIndex:index];
    }];
    self.tableView.backgroundColor = PB_Color(@"#F5F5F5");
    self.tableView.tableHeaderView = self.pb_t_headerView;
    [self.tableView registerClass:PPMeTableViewCell.class forCellReuseIdentifier:pb_t_MeTableViewCellKey_de];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(- StatusBarHeightConstant, 0, 0, 0));
    }];
    [self setPpShowTableViewHeaderRefresh:YES];
    [PB_NotificationOfCenter addObserver:self selector:@selector(loginSuccessNotiSender) name:PB_NotiLoginThanSuccess object:nil];
}

- (void)loginSuccessNotiSender {
    [self requestMethod];
}

#pragma mark - Request
- (void)requestMethod {

    if(_isFirst == NO){
        [QMUITips showLoading:PBLoading_TipMsg inView:self.view];
    }
    [[PB_RequestHelper pb_instance] pb_getRequestWithUrlStr:PBURL_appMineMenuUrl params:@{} commplete:^(NSDictionary * _Nullable result, NSInteger statusCode) {
        [QMUITips hideAllTips];
        if(result != nil){
            PPMeModel *model = [PPMeModel yy_modelWithJSON:result];
            if(model.theoretical.draw.count > 0){
                self.dataArray = model.theoretical.draw;
            }
            [self.pb_t_headerView pp_configData:model];
        }
        [self.tableView reloadData];
        [self ppTableViewEndAllRefresh];
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
        [QMUITips showError:errorStr inView:self.view];
        [self ppTableViewEndAllRefresh];
    }];
}

#pragma mark - Refresh
- (void)pb_t_de_TableViewHeaderRefreshMethod {
    [self requestMethod];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PPMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pb_t_MeTableViewCellKey_de forIndexPath:indexPath];
    [cell pb_configWithCellData:self.dataArray[indexPath.row]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PB_Ratio(80);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.dataArray.count > 0){
        //先判断是否登录
        if([PB_APP_Control pb_t_presentLoginVCWithTargetVC:self]){
            NSString *link = PBStrFormat(self.dataArray[indexPath.row].translated);
            [PB_APP_Control pb_t_goToModuleWithJudgeTypeStr:link fromVC:self];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self shearTableViewSection:cell tableView:tableView IndexPath:indexPath cornerRadius:PB_Ratio(12) width:0];
}
#pragma mark TableView Section 切圆角
- (void)shearTableViewSection:(UITableViewCell *)cell tableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath cornerRadius:(CGFloat)radius width:(CGFloat)width
{
    // 圆角弧度半径
    CGFloat cornerRadius = 0.f;
    if (radius == 0) {
        cornerRadius = 12.f;
    }else{
        cornerRadius = radius;
    }
    
    // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
    cell.backgroundColor = UIColor.clearColor;
    cell.contentView.backgroundColor = UIColor.clearColor;
    
    // 创建一个shapeLayer
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
    // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
    CGMutablePathRef pathRef = CGPathCreateMutable();
    // 获取cell的size
    // 第一个参数,是整个 cell 的 bounds, 第二个参数是距左右两端的距离,第三个参数是距上下两端的距离
    CGRect bounds;
    bounds = CGRectInset(CGRectMake(PB_Ratio(15), 0, cell.bounds.size.width - PB_Ratio(15)*2, cell.bounds.size.height), width, 0);
    
    // CGRectGetMinY：返回对象顶点坐标
    // CGRectGetMaxY：返回对象底点坐标
    // CGRectGetMinX：返回对象左边缘坐标
    // CGRectGetMaxX：返回对象右边缘坐标
    // CGRectGetMidX: 返回对象中心点的X坐标
    // CGRectGetMidY: 返回对象中心点的Y坐标
    
    // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
    
    // CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
    
    if ([tableView numberOfRowsInSection:indexPath.section]-1 == 0) {
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMinX(bounds), CGRectGetMidY(bounds), cornerRadius);
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        
        
    }else if (indexPath.row == 0) {
        // 初始起点为cell的左下角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        // 起始坐标为左下角，设为p，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        
        // 初始起点为cell的左上角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
    } else {
        
        // 添加cell的rectangle信息到path中（不包括圆角）
        CGPathAddRect(pathRef, nil, bounds);
    }
    // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
    layer.path = pathRef;
    backgroundLayer.path = pathRef;
    // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
    CFRelease(pathRef);
    // 按照shape layer的path填充颜色，类似于渲染render
    // layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
    layer.fillColor = [UIColor whiteColor].CGColor;
    // view大小与cell一致
    UIView *roundView = [[UIView alloc] initWithFrame:bounds];
    // 添加自定义圆角后的图层到roundView中
    [roundView.layer insertSublayer:layer atIndex:0];
    roundView.backgroundColor = UIColor.clearColor;
    // cell的背景view
    cell.backgroundView = roundView;
}


#pragma mark - link to Order

- (void)toOrderListWithIndex:(NSInteger)indexNo {
    NSLog(@"%ld--",indexNo);
    NSString *linkStr = [NSString stringWithFormat:@"pml://loan.org/sfd?identical=%ld",indexNo + 1];
    if([PB_APP_Control pb_t_presentLoginVCWithTargetVC:self]){
        [PB_APP_Control pb_t_goToModuleWithJudgeTypeStr:linkStr fromVC:self];
    }
    
}

- (void)dealloc {
    [PB_NotificationOfCenter removeObserver:self name:PB_NotiLoginThanSuccess object:nil];
}




@end
