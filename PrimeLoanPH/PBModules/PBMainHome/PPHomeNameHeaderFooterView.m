//
//  PPHomeNameHeaderFooterView.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/1/25.
//

#import "PPHomeNameHeaderFooterView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface PPHomeNameHeaderFooterView ()

@property (nonatomic, strong) UILabel *pb_t_mvpNameLB;
@property (nonatomic, strong) UILabel *pb_t_mvpNameLB2;

@end

@implementation PPHomeNameHeaderFooterView

- (void)pb_initUI {
    self.contentView.backgroundColor = UIColor.clearColor;
    _pb_t_mvpNameLB = [[UILabel alloc] init];
    _pb_t_mvpNameLB.font = UIFontBoldMake(PB_Ratio(18));
    _pb_t_mvpNameLB.textColor = PB_shenBlackColor;
    _pb_t_mvpNameLB.text = @"Order Center";
    [self.contentView addSubview:self.pb_t_mvpNameLB];
    //
    _pb_t_mvpNameLB2 = [[UILabel alloc] init];
    _pb_t_mvpNameLB2.font = UIFontBoldMake(PB_Ratio(18));
    _pb_t_mvpNameLB2.textColor = PB_shenBlackColor;
    _pb_t_mvpNameLB2.text = @"Products Recommended";
    _pb_t_mvpNameLB2.hidden = YES;
    [self.contentView addSubview:self.pb_t_mvpNameLB2];
    
    [self.pb_t_mvpNameLB  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PB_Ratio(15));
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(PB_Ratio(46));
    }];
    [self.pb_t_mvpNameLB2  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PB_Ratio(15));
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(PB_Ratio(46));
    }];
    
    UIView *cardBg = [[UIView alloc] initWithFrame:CGRectMake(PB_Ratio(15), PB_Ratio(46), SCREEN_WIDTH - PB_Ratio(15)*2, PB_Ratio(110))];
    cardBg.layer.cornerRadius = PB_Ratio(15);
    cardBg.backgroundColor = [UIColor whiteColor];
    cardBg.layer.masksToBounds = YES;
    [self.contentView addSubview:cardBg];
    
    NSArray *iconNames = @[@"Group 1171275258",@"Group 1171275259",@"Group 1171275260",@"Group 1171275261"];
    NSArray *menuNames = @[@"All",@"Applying",@"Repayment",@"Finished"];
    
    CGFloat _left = PB_Ratio(7);
    CGFloat _width = (CGRectGetWidth(cardBg.frame) - _left*2)/4.0;
    
    for (int i = 0; i < iconNames.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(_left + _width * i, 0, _width, CGRectGetHeight(cardBg.frame))];
        UIImageView *iconImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconNames[i]]];
        [btn addSubview:iconImageV];
        [cardBg addSubview:btn];
        [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(PB_Ratio(20));
            make.width.height.mas_equalTo(PB_Ratio(44));
        }];
        UILabel *menuNameLabel = [[UILabel alloc] init];
        menuNameLabel.textColor = PB_yiBanBlackColor;
        menuNameLabel.font = UIFontMediumMake(PB_Ratio(14));
        menuNameLabel.text = menuNames[i];
        [btn addSubview:menuNameLabel];
        [menuNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(iconImageV.mas_bottom).offset(PB_Ratio(6));
        }];
        
        [btn addTarget:self action:@selector(menuButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 200+i;
    }
    SDCycleScrollView *_cycleScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(PB_Ratio(15), PB_Ratio(170), SCREEN_WIDTH - PB_Ratio(15) *2 , PB_Ratio(118))];
    _cycleScrollView.autoScrollTimeInterval = 4;
    _cycleScrollView.showPageControl = YES;
    _cycleScrollView.localizationImageNamesGroup = @[@"Group 1171276120",@"Group 1171276126"];
    _cycleScrollView.backgroundColor = UIColor.clearColor;
    _cycleScrollView.pageDotColor = PB_AlphaColor(@"#2961DC", 0.33);
    _cycleScrollView.currentPageDotColor = PB_Color(@"#2961DC");
    _cycleScrollView.pageControlDotSize = CGSizeMake(5, 5);
    [self.contentView addSubview:_cycleScrollView];
}

- (void)menuButtonTap:(UIButton *)b {
    NSInteger index = b.tag - 100;
    NSLog(@"%ld",index);
    
    NSString *linkStr = [NSString stringWithFormat:@"pml://loan.org/sfd?identical=%ld",index];
    if([PB_APP_Control pb_t_presentLoginVCWithTargetVC:[PB_GetVC pb_to_getCurrentViewController]]){
        [PB_APP_Control pb_t_goToModuleWithJudgeTypeStr:linkStr fromVC:[PB_GetVC pb_to_getCurrentViewController]];
    }
}

- (void)pb_t_mvpTagName:(NSInteger)tag {
    if(tag == 1){
        self.pb_t_mvpNameLB2.hidden = YES;
    }else{
        self.pb_t_mvpNameLB2.hidden = NO;
    }
}

@end
