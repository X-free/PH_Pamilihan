//
//  PPVeContactViewController.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/31.
//

#import "PPVeContactViewController.h"
#import "PPVeContactHrader.h"
#import "PPVeNorInputTableViewCell.h"
#import "PPBaseModel.h"
#import "PPVeContactModel.h"
#import <BRPickerView.h>
#import <ContactsUI/ContactsUI.h>
#import "PPNavigationController.h"


@interface PPVeContactViewController ()<CNContactPickerDelegate>

@property (nonatomic, strong) UIButton *pb_t_de_submitButton;
@property (nonatomic, strong) PPVeContactModel *dataModel;
@property (nonatomic, strong) NSArray <PPVeContactIntegrationistModel *>*dataArr;
@property (nonatomic, strong)  BRStringPickerView *stringPickerView;
@property (nonatomic, strong) NSArray *submitParams;//最终需要提交的参数
@property (nonatomic, assign) NSInteger currentSection;

@property (nonatomic, copy) NSString *pb_t_de_reportStartTime;
@property (nonatomic, copy) NSString *pb_t_de_reportEndTime;
@property (nonatomic, assign) BOOL hasReportContact;
@property (nonatomic, assign) QMUIAlertController *pp_alertVC;


@end

@implementation PPVeContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setShowBackBtn:YES];
    [self setNavTitle:@"Contact Information"];
    self.view.backgroundColor = PB_BgColor;
    [self ppInit];
    
}

- (void)ppInit{
    
    self.pb_t_de_reportStartTime = [PB_timeHelper pb_t_getCurrentStampTimeString];
    self.pb_t_de_reportEndTime = @"";
    
    self.currentSection = 0;
    self.view.backgroundColor = PB_BgColor;
    //
    [self.tableView registerClass:PPVeNorInputTableViewCell.class forCellReuseIdentifier:PPVeNorInputTableViewCellKey];
    [self.tableView registerClass:PPVeContactHrader.class forHeaderFooterViewReuseIdentifier:PPVeContactHraderKey];
    self.tableView.backgroundColor = PB_BgColor;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(PB_NaviBa_H, 0, PB_Ratio(100), 0));
    }];
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
    NSDictionary *p = @{
        @"foundation":PBStrFormat(self.pId),
        @"dramatically":PBStrFormat([PB_APP_Control instanceOnly].phoneNum)
    };
    [[PB_RequestHelper pb_instance] pb_postRequestWithUrlStr:PBURL_V4ContactInfoUrl params:p commplete:^(id  _Nullable result, NSInteger statusCode) {
        [QMUITips hideAllTips];
        if(result != nil){
            self.dataModel = [PPVeContactModel yy_modelWithJSON:result];
            self.dataArr = @[];
            if(self.dataModel.theoretical.integrationist.count > 0){
                self.dataArr = self.dataModel.theoretical.integrationist;
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
           // NSLog(@"%@--%zd",resultModel.value,resultModel.index);
            for (NSInteger i = 0; i < self.dataArr.count; i++) {
                PPVeContactIntegrationistModel *itemModel = weakSelf.dataArr[i];
                if(self.currentSection == i){
                    for (NSInteger j = 0; j < itemModel.identified.count; j++) {
                        if(j == resultModel.index){
                            weakSelf.dataArr[i].identified[j].select = YES;
                            weakSelf.dataArr[i].condemned = weakSelf.dataArr[i].identified[j].reviewed;
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


#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PPVeNorInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PPVeNorInputTableViewCellKey forIndexPath:indexPath];
    [cell pb_configWithCellData:self.dataArr[indexPath.section] index:indexPath.row];
    return cell;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PPVeContactHrader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:PPVeContactHraderKey];
    NSString *sectionName = [NSString stringWithFormat:@"%@ %ld",@"Emergency contact",section + 1];
    [header pb_confWithSectionData:sectionName];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return PB_Ratio(61);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PB_Ratio(105);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    PPVeContactIntegrationistModel *model = self.dataArr[indexPath.section];
    self.currentSection = indexPath.section;
    if(indexPath.row == 0){//关系选择
        
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
        self.stringPickerView.title = @"Relationship";
        [self.stringPickerView show];
    }else{

        //当前，已经上传了，说明获取了权限
        if(self.hasReportContact == YES){
            [self showContactVC];
            
        }else{
            //权限获取成功后直接上传
            if([self getAddressBookPermission] == YES){
                [self showContactVC];
            }else{
                //弹框提示开启权限
                QMUIAlertController *pp_alertVC =[QMUIAlertController alertControllerWithTitle:@"Tip" message:PBContactTipContent preferredStyle:QMUIAlertControllerStyleAlert];
                [pp_alertVC addAction:[QMUIAlertAction actionWithTitle:@"Cancel" style:QMUIAlertActionStyleCancel handler:nil]];
                [pp_alertVC addAction:[QMUIAlertAction actionWithTitle:@"Confirm" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
                    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [PB_OpenUrl pb_to_openUrl:url];
                }]];
                [pp_alertVC showWithAnimated:YES];
                _pp_alertVC = pp_alertVC;
            }
        }
        
//        [self showContactVC];
//        if(self.hasReportContact == NO){
//            [self getAddressBookPermission];
//        }
        
    }

}



#pragma mark - 更新提交参数
- (void)refreshSubmitParams {
    NSMutableArray *paramArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        PPVeContactIntegrationistModel *model = self.dataArr[i];
        NSString *phone = PBStrFormat(model.openly);
        NSString *name = PBStrFormat(model.celebrating);
        NSString *relation = PBStrFormat(model.condemned);
        if([NSString isEqual:phone])
        {
            phone = @"";
        }
        if([NSString isEqual:name])
        {
            name = @"";
        }
        if([NSString isEqual:relation])
        {
            relation = @"";
        }
        NSDictionary *dict = @{
            @"celebrating":name,
            @"openly":phone,
            @"condemned":relation
        };
        [paramArray addObject:dict];
    }
    self.submitParams = paramArray;
    NSLog(@"self.submitParams===%@",self.submitParams);
    
}


#pragma mark - Click
- (void)pb_t_de_submitButtonSender:(QMUIButton *)button{

    PMMyWeekSelf
    [self.view endEditing:YES];
    [QMUITips showLoading:PBLoading_TipMsg inView:self.view];
    NSDictionary *dict = @{
        @"foundation":PBStrFormat(self.pId),
        @"theoretical":self.submitParams.count > 0 ? [PPTools pb_t_jsonStrFormatForNSArray:self.submitParams] : @""
    };
    [[PB_RequestHelper pb_instance] pb_postRequestWithUrlStr:PBURL_V4ContactInfoSubUrl params:dict commplete:^(id  _Nullable result, NSInteger statusCode) {
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

#pragma mark - CNContact
- (void)showContactVC{
    
    PMMyWeekSelf
    CNContactPickerViewController *vc = [[CNContactPickerViewController alloc] init];
    vc.delegate = self;
    if(@available(iOS 13.0, *)){
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
    }else{
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    // 确保在主线程上调用presentViewController
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self presentViewController:vc animated:YES completion:nil];

    });
//

}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    //givenName + familyName
//    NSLog(@"familyName：%@",contact.familyName);
//    NSLog(@"givenName：%@",contact.givenName);
//    NSLog(@"organizationName：%@",contact.organizationName);
//    NSLog(@"phoneNumbers：%@",[contact.phoneNumbers.firstObject.value stringValue]);
    NSString *nameStr = [NSString stringWithFormat:@"%@ %@",contact.givenName,contact.familyName];
    if(nameStr.length <= 0 && ![NSString PB_CheckStringIsEmpty:contact.organizationName]){
        nameStr = contact.organizationName;
    }
    NSString *phoneStr = PBStrFormat([contact.phoneNumbers.firstObject.value stringValue]);
    for(NSInteger i = 0; i < self.dataArr.count; i++){
        if(i == self.currentSection){
            self.dataArr[i].celebrating = nameStr;
            self.dataArr[i].openly = phoneStr;
        }
    }
    [self.tableView reloadData];
    [self refreshSubmitParams];
}

#pragma mark - risk
- (void)pb_t_toRePortRiskDataToServeFromStep {
    self.pb_t_de_reportEndTime = [PB_timeHelper pb_t_getCurrentStampTimeString];
    NSDictionary *riskDict = @{
        @"speak":PBStrFormat(self.pb_t_de_reportStartTime),
        @"advantage":PBStrFormat(self.pb_t_de_reportEndTime),
        @"rejection":@"7"
    };
    [[PB_APP_Control instanceOnly] pb_t_toRePortRiskDataToServe:riskDict];
}


#pragma mark 点击获取通讯录权限
- (BOOL)getAddressBookPermission{
    __block BOOL result = NO;
    PMMyWeekSelf
    if (@available(iOS 9.0, *)){
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (status == CNAuthorizationStatusNotDetermined) {
            CNContactStore *store = [[CNContactStore alloc] init];
            [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
                if (error) {
                    NSLog(@"授权失败");
                }else {
                    NSLog(@"成功授权");
                    result = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //更新UI的代码
                        if(weakSelf.pp_alertVC != nil){
                            [weakSelf.pp_alertVC hideWithAnimated:NO];
                            [weakSelf getContact];
                            [weakSelf showContactVC];
                        }
                    });
                    
                }
            }];
        }
        else if(status == CNAuthorizationStatusRestricted)
        {
            NSLog(@"用户拒绝");
            
        }
        else if (status == CNAuthorizationStatusDenied)
        {
            NSLog(@"用户拒绝");
        }
        else if (status == CNAuthorizationStatusAuthorized)
        {
            NSLog(@"已经授权");
            result = YES;
            [self getContact];
        }
    }else{
        NSLog(@"iOS 9之前使用其他方法获取");
    }
    return result;
    
}
 
- (void)getContact{
    self.hasReportContact = YES;
    // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    CNContactStore *contactStore = [CNContactStore new];
    NSArray *keys = @[
        CNContactPhoneNumbersKey,
        CNContactGivenNameKey,
        CNContactFamilyNameKey,
        CNContactOrganizationNameKey,
        CNContactBirthdayKey,
        //CNContactNoteKey,
        CNContactEmailAddressesKey
    ];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
         // 获取通讯录中所有的联系人
         CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
         __block  NSMutableArray *contactArr = [[NSMutableArray alloc] init];
         [contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
             
             //givenName + familyName
     //        NSLog(@"familyName：%@",contact.familyName);
     //        NSLog(@"organizationName：%@",contact.organizationName);
     //        NSLog(@"phoneNumbers：%@",[contact.phoneNumbers.firstObject.value stringValue]);
      
             NSString *givenName = [NSString stringWithFormat:@"%@ %@",contact.givenName,contact.familyName];
             if(givenName.length <= 0 && ![NSString PB_CheckStringIsEmpty:contact.organizationName]){
                 givenName = contact.organizationName;
             }


             NSArray *phoneNumbers = contact.phoneNumbers;
             NSString *phones = @"";
             //一个人有多个电话号码
             for (CNLabeledValue *labelValue in phoneNumbers) {

                 CNPhoneNumber *phoneNumber = labelValue.value;

                 NSString * string = phoneNumber.stringValue ;

                 if(phones.length == 0){
                     phones = string;
                 }else{
                     phones = [NSString stringWithFormat:@"%@,%@",phones,string];
                 }
             }
             NSString *birthDay = @"";
             if(contact.birthday){
                 birthDay = [NSString stringWithFormat:@"%ld-%ld-%ld",contact.birthday.day,contact.birthday.month,contact.birthday.year];
             }
             NSString *note = @"";
             NSString *email = @"";
             if(contact.emailAddresses.count > 0){
                 for (CNLabeledValue *labelValue in contact.emailAddresses) {
                     NSString * string = labelValue.value ;
                     if(string.length > 0){
                         email = [NSString stringWithFormat:@"%@",string];
                         break;
                     }
                 }
             }
             NSLog(@"name:%@ \n phone:%@ \n birthday:%@ \n email:%@",givenName,phones,birthDay,email);
             NSDictionary *contactDic = @{
                 @"questions": phones,//手机号，可以多个，英文逗号隔开
                 @"spend": @"", //更新时间
                 @"urging": @"", //备注
                 @"creates": birthDay, //生日
                 @"particular": email,    //邮箱
                 @"likely": @"", //创建时间
                 @"celebrating": givenName   //姓名
             };
             [contactArr addObject:contactDic];
         }];
         
         NSDictionary *dict = @{
             @"theoretical":contactArr.count > 0 ? [PPTools pb_t_jsonStrFormatForNSArray:contactArr] : @""
         };
         [[PB_RequestHelper pb_instance] pb_postRequestWithUrlStr:PBURL_reportConnectInfoUrl params:dict commplete:^(id  _Nullable result, NSInteger statusCode) {

         } failure:^(NSError * _Nonnull error, NSInteger errorCode, NSString * _Nonnull errorStr) {
             
         }];
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
