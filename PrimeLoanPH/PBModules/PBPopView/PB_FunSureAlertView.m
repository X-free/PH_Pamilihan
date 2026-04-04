//
//  PB_FunSureAlertView.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/8.
//


#import "PB_FunSureAlertView.h"

@implementation PB_FunSureAlertView

- (instancetype)init {
    self = [super init];
    if(self){
        self.backgroundColor = UIColor.clearColor;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.frame = CGRectMake(0, 0, PB_SW - PB_Ratio(36)*2, PB_SH);
    UIView *pb_t_de_bgView = [PB_UI pb_creat_ViewWithFrame:CGRectZero color:PB_WhiteColor radius:PB_Ratio(20)];
    //
    UIImageView *pb_t_de_headerV = [[UIImageView alloc] initWithImage:UIImageMake(@"loa_n_pop_sample")];

    //
    NSString *pb_t_content = @"Are you sure about taking this loan?";
    QMUILabel *pb_t_de_contentLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:pb_t_content color:PB_yiBanBlackColor font:UIFontMediumMake(PB_Ratio(22)) alignment:NSTextAlignmentCenter lines:0];
    pb_t_de_contentLabel.qmui_lineHeight = PB_Ratio(26);
    //
    QMUIButton *pb_t_de_submitButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
    pb_t_de_submitButton.backgroundColor = PP_AppColor;
    [pb_t_de_submitButton setTitle:@"Confirm" forState:UIControlStateNormal];
    pb_t_de_submitButton.titleLabel.font = UIFontMediumMake(PB_Ratio(18));
    [pb_t_de_submitButton setTitleColor:PB_WhiteColor forState:UIControlStateNormal];
    [pb_t_de_submitButton addTarget:self action:@selector(buttonSenderTap:) forControlEvents:UIControlEventTouchUpInside];
    
    
    pb_t_de_submitButton.tag = 50;
    //
    QMUIButton *pb_t_de_closeBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    pb_t_de_closeBtn.backgroundColor = UIColor.clearColor;
    [pb_t_de_closeBtn setImage:[UIImage imageNamed:@"icon_close_x"] forState:UIControlStateNormal];
    [pb_t_de_closeBtn setImage:[UIImage imageNamed:@"icon_close_x"] forState:UIControlStateHighlighted];
    [pb_t_de_closeBtn addTarget:self action:@selector(buttonSenderTap:) forControlEvents:UIControlEventTouchUpInside];
    pb_t_de_closeBtn.tag = 51;

    
    [self addSubview:pb_t_de_bgView];
    [self addSubview:pb_t_de_headerV];
    [pb_t_de_bgView addSubview:pb_t_de_contentLabel];
    [pb_t_de_bgView addSubview:pb_t_de_submitButton];
    [self addSubview:pb_t_de_closeBtn];
    [pb_t_de_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_offset(-PB_Ratio(30));
        make.width.mas_equalTo(PB_SW - PB_Ratio(36) *2);
    }];

    [pb_t_de_headerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pb_t_de_bgView.mas_top).offset(-PB_Ratio(59));
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(PB_Ratio(178));
        make.height.mas_equalTo(PB_Ratio(155));
    }];

    pb_t_de_contentLabel.preferredMaxLayoutWidth = PB_SW - PB_Ratio(52)*2;
    [pb_t_de_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(PB_Ratio(138));
        make.centerX.mas_equalTo(0);
    }];
    [pb_t_de_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pb_t_de_contentLabel.mas_bottom).offset(PB_Ratio(48));
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(PB_Ratio(48));
        make.bottom.mas_offset(0);
    }];
    [pb_t_de_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pb_t_de_bgView.mas_bottom).offset(PB_Ratio(24));
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(PB_Ratio(34));
    }];
    
}

- (void)buttonSenderTap:(QMUIButton *)button{
    NSInteger tag = button.tag;
    if(_myBlock){
        _myBlock(tag);
    }
}


@end
