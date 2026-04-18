//
//  PPVeCardTypeOptionVC.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/11/9.
//

#import "PPVeCardTypeOptionVC.h"
#import "PPVeCardTypeOptionCell.h"
#import "PPVeCardTypeOptionHeader.h"

@interface PPVeCardTypeOptionVC ()<PPVeCardTypeOptionHeaderDelegate>
@property (nonatomic, assign)  BOOL showMore;
@property (nonatomic, assign)  BOOL showRecommend;
@property (nonatomic, copy) NSString *cardType;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@end

@implementation PPVeCardTypeOptionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setShowBackBtn:YES];
    [self setNavTitle:@"Identity information"];
    self.useDarkNavBackIcon = YES;
    self.view.backgroundColor = PB_Color(@"#FEF9E7");
    self.cardType = @"PRC";
    self.showMore = YES;
    self.showRecommend = YES;
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self ppInit];
}

- (void)ppInit{
    

    self.view.backgroundColor = PB_Color(@"#FBF6E7");
    UIImageView *topBg = [[UIImageView alloc] initWithImage:UIImageMake(@"ordtopbg")];
    topBg.contentMode = UIViewContentModeScaleAspectFill;
    topBg.clipsToBounds = YES;
    topBg.backgroundColor = PB_Color(@"#FBF6E7");
    [self.view addSubview:topBg];
    [topBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(topBg.mas_width).multipliedBy(PB_OrdtopbgHeightToWidthRatio);
    }];
    [self.view sendSubviewToBack:topBg];

    UIView *titleBg = [PB_UI pb_creat_ViewWithFrame:CGRectZero color:PB_Color(@"#F8742C") radius:PB_Ratio(12)];
    [self.view addSubview:titleBg];
    [titleBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PB_Ratio(15));
        make.top.mas_equalTo(PB_NaviBa_H + PB_Ratio(14));
        make.width.mas_equalTo(PB_Ratio(315));
        make.height.mas_equalTo(PB_Ratio(52));
    }];
    QMUILabel *titleLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"Select an ID to verify your identity" color:UIColor.whiteColor font:UIFontBoldMake(PB_Ratio(15)) alignment:NSTextAlignmentLeft lines:1];
    [titleBg addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PB_Ratio(16));
        make.centerY.mas_equalTo(0);
    }];

    UIView *cardShell = [[UIView alloc] init];
    cardShell.backgroundColor = PB_Color(@"#FFFFFF");
    cardShell.layer.cornerRadius = PB_Ratio(14);
    cardShell.layer.masksToBounds = YES;
    [self.view addSubview:cardShell];

    [cardShell addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.tableView registerClass:PPVeCardTypeOptionCell.class forCellReuseIdentifier:PPVeCardTypeOptionCellKey];
    [self.tableView registerClass:PPVeCardTypeOptionHeader.class forHeaderFooterViewReuseIdentifier:PPVeCardTypeOptionHeaderKey];
    self.tableView.backgroundColor = PB_Color(@"#FFFFFF");
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PB_SW, CGFLOAT_MIN)];

    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setBackgroundImage:UIImageMake(@"Roundedrectangle") forState:UIControlStateNormal];
    [nextBtn setTitle:@"Next" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = UIFontBoldMake(PB_Ratio(17));
    [nextBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = PB_Ratio(10);
    nextBtn.layer.masksToBounds = YES;
    [nextBtn addTarget:self action:@selector(submitSelectionAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [cardShell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PB_Ratio(15));
        make.right.mas_equalTo(-PB_Ratio(15));
        make.top.mas_equalTo(titleBg.mas_bottom).offset(-PB_Ratio(12));
        make.bottom.mas_equalTo(nextBtn.mas_top).offset(-PB_Ratio(16));
    }];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PB_Ratio(15));
        make.right.mas_equalTo(-PB_Ratio(15));
        make.height.mas_equalTo(PB_Ratio(54));
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-PB_Ratio(15));
    }];
}


#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        if(!self.showRecommend){
            return 0;
        }
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
    BOOL selected = (self.selectedIndexPath.section == indexPath.section && self.selectedIndexPath.row == indexPath.row);
    [cell pb_configWithCellData:self.pDataArray[indexPath.section][indexPath.row] selected:selected];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return PB_Ratio(44);
    }
    return PB_Ratio(48);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return PB_Ratio(14);
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section != 0) {
        return nil;
    }
    UIView *wrap = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PB_SW, PB_Ratio(17))];
    wrap.backgroundColor = PB_Color(@"#F6F6F6");
    return wrap;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0){
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PB_SW, PB_Ratio(44))];
        v.backgroundColor = PB_Color(@"#FFFFFF");
        QMUILabel *label = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"Recommended ID Type" color:[UIColor blackColor] font:UIFontBoldMake(PB_Ratio(16)) alignment:NSTextAlignmentLeft lines:1];
        [v addSubview:label];
        UIImageView *arrow = [[UIImageView alloc] initWithImage:UIImageMake(self.showRecommend ? @"FrameUp" : @"FrameDown")];
        arrow.contentMode = UIViewContentModeCenter;
        [v addSubview:arrow];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(PB_Ratio(16));
            make.bottom.mas_offset(-PB_Ratio(10));
        }];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-PB_Ratio(16));
            make.centerY.mas_equalTo(label);
            make.width.height.mas_equalTo(PB_Ratio(20));
        }];
        [v addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleRecommendHeaderTap)]];
        return v;
    }
    PPVeCardTypeOptionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:PPVeCardTypeOptionHeaderKey];
    header.delegate = self;
    [header pb_confWithSectionData:self.showMore ? @"1" : @"0"];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PB_Ratio(40);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    self.cardType = PBStrFormat(self.pDataArray[indexPath.section][indexPath.row]);
    [self.tableView reloadData];
}


//header delegate
- (void)pb_t_VeCardTypeOptionHeaderTap_de {
    self.showMore = !self.showMore;
    [self.tableView reloadData];
}

- (void)handleRecommendHeaderTap {
    self.showRecommend = !self.showRecommend;
    [self.tableView reloadData];
}

- (void)submitSelectionAction {
    if(self.cardType.length == 0){
        self.cardType = @"PRC";
    }
    
    [self.navigationController popViewControllerAnimated:NO];
    
    [self callBackTypeResult];
    
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


@end
