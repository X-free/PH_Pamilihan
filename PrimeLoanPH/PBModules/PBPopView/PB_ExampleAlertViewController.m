//
//  PB_ExampleAlertViewController.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/8.
//

#import "PB_ExampleAlertViewController.h"

@interface PB_ExampleAlertViewController ()

@end

@implementation PB_ExampleAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithType:(NSInteger)type{
    self = [super init];
    if(self){
        [self ppInitWithType:type];
    }
    return self;
}

- (void)ppInitWithType:(NSInteger)type {
    
    NSString *desc = @"Please make sure the PRC is clear, smooth in all corners, without reflections or obstructions.";

    NSString *pb_t_deexampleImg = @"PAN_pop_sample_right";
    NSString *pb_t_deexampleErrorImg = @"PAN_pop_sample_wrong";
    CGFloat example_width = (PB_SW - PB_Ratio(88)*2);
    CGFloat example_height = example_width * 141/198.0;
    CGFloat exampleError_width = (PB_SW - PB_Ratio(39)*2);
    CGFloat exampleError_height = exampleError_width * 77/298.0;
    if(type == 2){
        desc = @"Please put your face inside the frame and do not block it and face the camera directly.";
        pb_t_deexampleImg = @"face_pop_sample_right";
        pb_t_deexampleErrorImg = @"face_pop_sample_wrong";
        example_width = (PB_SW - PB_Ratio(98)*2);
        example_height = example_width * 146/178.0;
        exampleError_width = (PB_SW - PB_Ratio(30)*2);
        exampleError_height = exampleError_width * 77/315.0;
    }
    
    
    self.showNavBar = NO;
    self.view.backgroundColor = PB_AlphaColor(@"#000000", 0.5f);
    UIView *pb_t_decontentView = [PB_UI pb_creat_ViewWithFrame:CGRectZero color:PB_WhiteColor radius:PB_Ratio(21)];
        
    QMUIButton *pb_t_debackButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
    pb_t_debackButton.backgroundColor = UIColor.clearColor;

    [pb_t_debackButton setImage:[UIImage imageNamed:@"icon_return_black"] forState:UIControlStateNormal];
    [pb_t_debackButton setImage:[UIImage imageNamed:@"icon_return_black"] forState:UIControlStateHighlighted];
    [pb_t_debackButton addTarget:self action:@selector(cancelSenderAction) forControlEvents:UIControlEventTouchUpInside];

    
    
    
    QMUILabel *pb_t_detitleLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"Upload example" color:PB_yiBanBlackColor font:UIFontMediumMake(PB_Ratio(18)) alignment:NSTextAlignmentLeft lines:1];
    UIImageView *pb_t_detipImgV = [[UIImageView alloc] initWithImage:UIImageMake(@"icon_warn_red")];
   
    QMUILabel *pb_t_dedescLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:desc color:PB_Color(@"#EB021D") font:UIFontMake(PB_Ratio(12)) alignment:NSTextAlignmentLeft lines:0];
    pb_t_dedescLabel.qmui_lineHeight = PB_Ratio(18);
    UIImageView *pb_t_deexampleImgV = [[UIImageView alloc] initWithImage:UIImageMake(pb_t_deexampleImg)];
    UIImageView *pb_t_deexampleErrorImgV = [[UIImageView alloc] initWithImage:UIImageMake(pb_t_deexampleErrorImg)];

    //
    QMUIButton *pb_t_desureButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
    pb_t_desureButton.backgroundColor = PP_AppColor;
    pb_t_desureButton.layer.cornerRadius = PB_Ratio(22);
    pb_t_desureButton.layer.masksToBounds = YES;
    [pb_t_desureButton setTitle:@"Upload" forState:UIControlStateNormal];
    pb_t_desureButton.titleLabel.font = UIFontMediumMake(PB_Ratio(15));
    [pb_t_desureButton setTitleColor:PB_WhiteColor forState:UIControlStateNormal];
    [pb_t_desureButton addTarget:self action:@selector(backSenderAction) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:pb_t_decontentView];
    [pb_t_decontentView addSubview:pb_t_debackButton];
    [pb_t_decontentView addSubview:pb_t_detitleLabel];
    [pb_t_decontentView addSubview:pb_t_detipImgV];
    [pb_t_decontentView addSubview:pb_t_dedescLabel];
    [pb_t_decontentView addSubview:pb_t_deexampleImgV];
    [pb_t_decontentView addSubview:pb_t_deexampleErrorImgV];
    [pb_t_decontentView addSubview:pb_t_desureButton];
    
    [pb_t_decontentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(PB_Ratio(21));
        make.left.right.mas_equalTo(0);
    }];
    [pb_t_debackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PB_Ratio(10));
        make.top.mas_equalTo(PB_Ratio(21));
        make.width.height.mas_equalTo(PB_Ratio(29));
    }];
    [pb_t_detitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(pb_t_debackButton);
    }];
    [pb_t_detipImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pb_t_debackButton.mas_bottom).offset(PB_Ratio(8));
        make.left.mas_equalTo(PB_Ratio(25));
        make.width.height.mas_equalTo(PB_Ratio(16));
    }];
    pb_t_dedescLabel.preferredMaxLayoutWidth = PB_SW - PB_Ratio(71);
    [pb_t_dedescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pb_t_detipImgV.mas_top);
        make.left.mas_equalTo(pb_t_detipImgV.mas_right).offset(PB_Ratio(4));
    }];
    
    
    [pb_t_deexampleImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(pb_t_dedescLabel.mas_bottom).offset(PB_Ratio(45));
        make.size.mas_equalTo(CGSizeMake(example_width, example_height));
    }];
    
    [pb_t_deexampleErrorImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(pb_t_deexampleImgV.mas_bottom).offset(PB_Ratio(32));
        make.size.mas_equalTo(CGSizeMake(exampleError_width, exampleError_height));
    }];
    [pb_t_desureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PB_Ratio(47));
        make.right.mas_offset(-PB_Ratio(47));
        make.top.mas_equalTo(pb_t_deexampleErrorImgV.mas_bottom).offset(PB_Ratio(40));
        make.height.mas_equalTo(PB_Ratio(44));
        make.bottom.mas_offset(-PB_Ratio(48)-PB_Ratio(31));
    }];
    

    
}

- (void)cancelSenderAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backSenderAction{
    PMMyWeekSelf
    [self dismissViewControllerAnimated:YES completion:^{
        if(weakSelf.finsihCallBlock){
            weakSelf.finsihCallBlock();
        }
    }];
}


@end
