//
//  PPVeCardTypeOptionVC.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/11/9.
//

#import "PPVeCardTypeOptionVC.h"
#import "PPVeCardTypeOptionCell.h"
#import "PPVeCardTypeOptionHeader.h"
#import "PPVeCardTypeOptionHeaderView.h"
#import "PB_ExampleAlertViewController.h"

@interface PPVeCardTypeOptionVC ()<PPVeCardTypeOptionHeaderDelegate>
@property (nonatomic, assign)  BOOL showMore;
@property (nonatomic, copy) NSString *cardType;

@end

@implementation PPVeCardTypeOptionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setShowBackBtn:YES];
    [self setNavTitle:@"Authentication"];
    self.view.backgroundColor = PB_BgColor;
    self.cardType = @"PRC";
    [self ppInit];
}

- (void)ppInit{
    

    self.view.backgroundColor = PB_BgColor;
    //
    [self.tableView registerClass:PPVeCardTypeOptionCell.class forCellReuseIdentifier:PPVeCardTypeOptionCellKey];
    [self.tableView registerClass:PPVeCardTypeOptionHeader.class forHeaderFooterViewReuseIdentifier:PPVeCardTypeOptionHeaderKey];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(PB_NaviBa_H, 0, 0, 0));
    }];
    self.tableView.backgroundColor = PB_BgColor;
    self.tableView.tableHeaderView = [PPVeCardTypeOptionHeaderView new];
    
}


#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return self.pDataArray[0].count;
    }else{
        if(_showMore){
            return self.pDataArray[1].count;
        }else{
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PPVeCardTypeOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:PPVeCardTypeOptionCellKey forIndexPath:indexPath];
    [cell pb_configWithCellData:self.pDataArray[indexPath.section][indexPath.row]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 1){
        return PB_Ratio(48);
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return PB_Ratio(24);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PPVeCardTypeOptionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:PPVeCardTypeOptionHeaderKey];
    header.delegate = self;
    [header pb_confWithSectionData:self.showMore ? @"1" : @"0"];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PB_Ratio(48);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.cardType = PBStrFormat(self.pDataArray[indexPath.section][indexPath.row]);
    NSLog(@"---%@---",self.cardType);
    PMMyWeekSelf
    PB_ExampleAlertViewController *exampleVC= [[PB_ExampleAlertViewController alloc] initWithType:1];
    exampleVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    exampleVC.finsihCallBlock = ^{
        //callBack
        [weakSelf callBackTypeResult];
    };
    [self presentViewController:exampleVC animated:YES completion:nil];

}


//header delegate
- (void)pb_t_VeCardTypeOptionHeaderTap_de {
    self.showMore = !self.showMore;
    [self.tableView reloadData];
}

// value callBack
- (void)callBackTypeResult{
    
    if(_ppBlock){
        _ppBlock(self.cardType);
    }
    PMMyWeekSelf
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf popController];
    });
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
