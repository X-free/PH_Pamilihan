//
//  GuideViewController.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/30.
//

#import "GuideViewController.h"

@interface GuideViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *pb_t_de_BigSc;

@property (nonatomic, strong) UIButton *pb_t_de_SubmintBtn;

@property (nonatomic, assign) NSInteger pb_t_de_CurrentPage;

@end

@implementation GuideViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.showNavBar = NO;
    [self toCreatUI];
}


- (void)toCreatUI {
    
    self.pb_t_de_BigSc = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.pb_t_de_BigSc];

    CGFloat logo_w = (PB_SW - PB_Ratio(77)*2);
    self.pb_t_de_SubmintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pb_t_de_SubmintBtn.backgroundColor = PP_AppColor;
    self.pb_t_de_SubmintBtn.layer.cornerRadius = PB_Ratio(20);
    self.pb_t_de_SubmintBtn.layer.masksToBounds = YES;
    [self.pb_t_de_SubmintBtn setTitle:@"Next" forState:UIControlStateNormal];
    self.pb_t_de_SubmintBtn.titleLabel.font = UIFontMediumMake(PB_Ratio(16));
    [self.pb_t_de_SubmintBtn setTitleColor:PB_WhiteColor forState:UIControlStateNormal];
    [self.pb_t_de_SubmintBtn addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:self.pb_t_de_SubmintBtn];
    
    [self.pb_t_de_SubmintBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-(PB_BottomBarXH + PB_Ratio(73)));
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(PB_Ratio(140));
        make.height.mas_equalTo(PB_Ratio(40));
    }];
    
    NSArray *imgs = @[@"Step_logo_1",@"Step_logo_2"];
    NSArray *ppStepImgs = @[@"Step_1",@"Step_2"];
    NSArray *ppTitles = @[@"It's easy to borrow",@"Guaranteed safety"];
    NSArray *pContents = @[
        @"Easy to use, lending can be done with just one certificate",
        @"Ensuring privacy, security, trust and greater trust"
    ];
    for (NSInteger i = 0; i < imgs.count; i++) {
        UIView *pageView = [[UIView alloc] initWithFrame:CGRectMake(PB_SW * i, 0, PB_SW , self.pb_t_de_BigSc.qmui_height)];
        [self.pb_t_de_BigSc addSubview:pageView];
        //
        UIImageView *logoImgV = [[UIImageView alloc] initWithImage:UIImageMake(imgs[i])];
        [pageView addSubview:logoImgV];
        //
        QMUILabel *nameLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:ppTitles[i] color:PB_TitleColor font:UIFontBoldMake(PB_Ratio(24)) alignment:NSTextAlignmentCenter lines:1];
        [pageView addSubview:nameLabel];
        //
        QMUILabel *subNameLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:pContents[i] color:PB_xiaoTitleColor font:UIFontMake(PB_Ratio(12)) alignment:NSTextAlignmentCenter lines:0];
        subNameLabel.qmui_lineHeight = PB_Ratio(20);
        [pageView addSubview:subNameLabel];
        //
        UIImageView *indexImgV = [[UIImageView alloc] initWithImage:UIImageMake(ppStepImgs[i])];
        [pageView addSubview:indexImgV];
        //
        [logoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_offset(-PB_Ratio(160));
            make.width.height.mas_equalTo(logo_w);
        }];
        nameLabel.preferredMaxLayoutWidth = PB_SW - 10;
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(logoImgV.mas_bottom).mas_offset(PB_Ratio(70));
        }];
        subNameLabel.preferredMaxLayoutWidth = PB_SW - PB_Ratio(75) * 2;
        [subNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(nameLabel.mas_bottom).mas_offset(PB_Ratio(6));
        }];
        [indexImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_offset(-(PB_BottomBarXH + PB_Ratio(30)));
            make.size.mas_equalTo(CGSizeMake(PB_Ratio(36), PB_Ratio(10)));
        }];
    }
    _pb_t_de_BigSc.delegate = self;
    _pb_t_de_BigSc.contentSize = CGSizeMake(imgs.count * PB_SW, 0);
    _pb_t_de_BigSc.bounces = NO;
    _pb_t_de_BigSc.pagingEnabled = YES;
    _pb_t_de_BigSc.showsHorizontalScrollIndicator = NO;
    
}

-(void)submitButtonAction:(QMUIButton *)button {
    if(_pb_t_de_CurrentPage == 1){
        [[PB_AskRootUrlHelper instanceOnly] pb_t_checkRootUrl:self.finsihCallBlock withVC:self];

    }else{
        [self.pb_t_de_BigSc setContentOffset:CGPointMake(PB_SW * (_pb_t_de_CurrentPage + 1), 0) animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int pageCount = scrollView.contentOffset.x / self.view.frame.size.width;
    if(pageCount < 1){
        if(![self.pb_t_de_SubmintBtn.titleLabel.text isEqualToString:@"Next"]){
            [self.pb_t_de_SubmintBtn setTitle:@"Next" forState:UIControlStateNormal];
        }
    }else{
        [self.pb_t_de_SubmintBtn setTitle:@"Enter" forState:UIControlStateNormal];
    }
    _pb_t_de_CurrentPage = pageCount;
}

- (void)setpb_t_de_CurrentPage:(NSInteger)pb_t_de_CurrentPage {
    _pb_t_de_CurrentPage = pb_t_de_CurrentPage;
}



@end
