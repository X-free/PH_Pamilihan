//
//  PBBorrGuideVC.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/6.
//

#import "PBBorrGuideVC.h"

@interface PBBorrGuideVC ()

@end

@implementation PBBorrGuideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = PB_Color(@"#F4F5F9");
    self.navTitle = @"Borrowing Guide";
    self.showBackBtn = YES;
    UIScrollView *pb_t_sc = [[UIScrollView alloc] initWithFrame:CGRectMake(0, PB_NaviBa_H, SCREEN_WIDTH, SCREEN_HEIGHT - PB_NaviBa_H - PB_BottomBarXH - PB_Ratio(65))];
    pb_t_sc.backgroundColor = PB_Color(@"#F4F5F9");
    pb_t_sc.alwaysBounceVertical = YES;
    [self.view addSubview:pb_t_sc];
    
    CGFloat _w = (SCREEN_WIDTH - PB_Ratio(15)*2);
    CGFloat _h = _w * 1464/1035;
    UIImageView *v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 1171276136"]];
    v.frame = CGRectMake(PB_Ratio(15), PB_Ratio(15), _w, _h);
    [pb_t_sc addSubview:v];
    pb_t_sc.contentSize = CGSizeMake(_w, _h * 1.2);

    
    QMUIButton *pb_t_button = [QMUIButton buttonWithType:UIButtonTypeCustom];
    pb_t_button.backgroundColor = PP_AppColor;
    pb_t_button.layer.cornerRadius = PB_Ratio(22);
    pb_t_button.layer.masksToBounds = YES;
    [pb_t_button setTitle:@"Go to home page" forState:UIControlStateNormal];
    pb_t_button.titleLabel.font = UIFontBoldMake(PB_Ratio(16));
    [pb_t_button setTitleColor:PB_WhiteColor forState:UIControlStateNormal];
    [pb_t_button addTarget:self action:@selector(pb_t_goHomeBtnTap) forControlEvents:UIControlEventTouchUpInside];
    
    
    pb_t_button.frame = CGRectMake(PB_Ratio(47), SCREEN_HEIGHT - PB_BottomBarXH - PB_Ratio(64), PB_SW - PB_Ratio(47)*2, PB_Ratio(44));
    [self.view addSubview:pb_t_button];

    
    
}

- (void)pb_t_goHomeBtnTap{
    [self.navigationController popToRootViewControllerAnimated:YES];
}





@end
