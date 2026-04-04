//
//  PPStartViewController.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/28.
//

#import "PPStartViewController.h"

@interface PPStartViewController (){
    UIButton *jinRuBtn;
}


@end

@implementation PPStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    jinRuBtn = [[UIButton alloc] initWithFrame:CGRectMake(47, PB_SH - 150, PB_SW - 47*2, 44)];
    jinRuBtn.layer.cornerRadius = 22;
    jinRuBtn.layer.masksToBounds = YES;
    jinRuBtn.backgroundColor = PP_AppColor;
    [jinRuBtn addTarget:self action:@selector(jinRuAction) forControlEvents:UIControlEventTouchUpInside];
    [jinRuBtn setTitle:@"Try again" forState:UIControlStateNormal];
    [jinRuBtn setTitleColor:PB_WhiteColor forState:UIControlStateNormal];
    jinRuBtn.titleLabel.font = UIFontMediumMake(16);
    [self.view addSubview:jinRuBtn];
    [self jinRuAction];
}

- (void)jinRuAction{
    [[PB_AskRootUrlHelper instanceOnly] pb_t_checkRootUrl:self.finishCallBlock withVC:self];
}


@end
