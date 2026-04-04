//
//  PPVeInfoViewController.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/31.
//

#import "PPVeInfoViewController.h"
#import "PPVeNorInfoModel.h"
#import "PPBaseModel.h"
#import "PPVeNorInputTableViewCell.h"
#import <BRPickerView.h>

@interface PPVeInfoViewController ()<PPVeNorInputTableViewCellDelegate>

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

@implementation PPVeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setShowBackBtn:YES];
    [self setNavTitle:@"Personal Information"];
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
    [[PB_RequestHelper pb_instance] pb_postRequestWithUrlStr:PBURL_V2UserInfoUrl params:params commplete:^(NSDictionary * _Nullable result, NSInteger statusCode) {
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
    [QMUITips showLoading:PBLoading_TipMsg inView:self.view];
    [[PB_RequestHelper pb_instance] pb_postRequestWithUrlStr:PBURL_V2UserInfoSubUrl params:self.submitParams commplete:^(NSDictionary * _Nullable result, NSInteger statusCode) {
        [QMUITips hideAllTips];
        if(result != nil){
            //上报风险
            [self pb_t_toRePortRiskDataToServeFromStep];
            //请求下一个认证步骤
            [PB_APP_Control pb_t_toRequestProductDetailThanGoToNextStepOptionWithProductID:self.pId oId:self.oId fromVC:self SuccessBlock:^(BOOL isSure) {
                [PB_GetVC pb_to_removeViewController:weakSelf];
            }];
        }
    } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
        [QMUITips showError:errorStr inView:self.view];
    }];
}

#pragma mark - risk
- (void)pb_t_toRePortRiskDataToServeFromStep {
    self.pb_t_de_reportEndTime = [PB_timeHelper pb_t_getCurrentStampTimeString];
    NSDictionary *riskDict = @{
        @"speak":PBStrFormat(self.pb_t_de_reportStartTime),
        @"advantage":PBStrFormat(self.pb_t_de_reportEndTime),
        @"rejection":@"5"
    };
    [[PB_APP_Control instanceOnly] pb_t_toRePortRiskDataToServe:riskDict];
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
    bounds = CGRectInset(CGRectMake(PB_Ratio(15), PB_Ratio(15), cell.bounds.size.width - PB_Ratio(15)*2, cell.bounds.size.height), width, 0);
    
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



@end
