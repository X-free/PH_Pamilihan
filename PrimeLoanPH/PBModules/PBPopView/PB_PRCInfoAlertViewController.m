//
//  PB_PRCInfoAlertViewController.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/8.
//
#import "PB_PRCInfoAlertViewController.h"
#import "PPVeCardUploadModel.h"
#import <BRDatePickerView.h>

@interface PB_PRCInfoAlertViewController ()

@property (nonatomic, copy) void(^myBlock)(NSDictionary *params);

@property (nonatomic, strong)BRDatePickerView *dataPicker_pb_t_;


@property (nonatomic, assign) QMUITextField *tf1;
@property (nonatomic, assign) QMUITextField *tf2;
@property (nonatomic, assign) QMUITextField *tf3;
@property (nonatomic, strong) PPVeCardUploadModel *mainModel;
@property (nonatomic, copy) NSString *cardType;


@end

@implementation PB_PRCInfoAlertViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = PB_AlphaColor(@"#000000", 0.2f);
    self.showNavBar = NO;

}


- (void)configData:(id)data type:(nonnull NSString *)cardType complete:(nonnull void (^)(NSDictionary * _Nonnull))block {
    _myBlock = block;
    self.cardType = PBStrFormat(cardType);
    [self ppInitWithConfigData:data];
}

- (void)ppInitWithConfigData:(id)data {
    if([data isKindOfClass:PPVeCardUploadModel.class]){
        PPVeCardUploadModel *model = (PPVeCardUploadModel *)data;
        self.mainModel = model;
        self.view.frame = CGRectMake(0, 0, PB_SW, PB_SH);

        /// 设计：`idinfofconfirm` 距屏幕左右 36；白卡片距左右 15；切图、卡片、关闭同层级，卡片盖在切图上
        const CGFloat kHeaderSide = PB_Ratio(36);
        const CGFloat kCardSide = PB_Ratio(15);
        const CGFloat kHeaderCardOverlap = PB_Ratio(28);

        UIView *contentWrap = [[UIView alloc] init];
        contentWrap.backgroundColor = UIColor.clearColor;
        [self.view addSubview:contentWrap];
        [contentWrap mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
            make.centerY.mas_offset(-PB_Ratio(30));
        }];

        /// 蒙层区域可点，仅收键盘，不关闭弹窗；弹窗内容盖在上方，点击内容区仍正常
        UIView *dimTouchShield = [[UIView alloc] init];
        dimTouchShield.backgroundColor = UIColor.clearColor;
        dimTouchShield.userInteractionEnabled = YES;
        [self.view insertSubview:dimTouchShield belowSubview:contentWrap];
        [dimTouchShield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        UITapGestureRecognizer *dimTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pb_dimAreaTapOnlyDismissKeyboard:)];
        [dimTouchShield addGestureRecognizer:dimTap];

        UIImage *headerImg = [UIImage imageNamed:@"idinfofconfirm"];
        UIImageView *headerImgV = [[UIImageView alloc] initWithImage:headerImg];
        headerImgV.contentMode = UIViewContentModeScaleAspectFill;
        headerImgV.clipsToBounds = YES;
        [contentWrap addSubview:headerImgV];
        CGFloat headerW = PB_SW - kHeaderSide * 2;
        CGFloat headerH = headerImg ? (headerImg.size.height / MAX(headerImg.size.width, 1.0)) * headerW : PB_Ratio(96);
        [headerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kHeaderSide);
            make.right.mas_equalTo(-kHeaderSide);
            make.top.mas_equalTo(contentWrap.mas_top);
            make.height.mas_equalTo(MIN(headerH, PB_Ratio(120)));
        }];

        UIView *cardView = [PB_UI pb_creat_ViewWithFrame:CGRectZero color:PB_WhiteColor radius:PB_Ratio(16)];
        [contentWrap addSubview:cardView];
        [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kCardSide);
            make.right.mas_equalTo(-kCardSide);
            make.top.mas_equalTo(headerImgV.mas_bottom).offset(-kHeaderCardOverlap);
        }];

        QMUIButton *pb_t_decloseBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        pb_t_decloseBtn.backgroundColor = UIColor.clearColor;
        [pb_t_decloseBtn setImage:[UIImage imageNamed:@"Grosx1276601"] forState:UIControlStateNormal];
        [pb_t_decloseBtn setImage:[UIImage imageNamed:@"Grosx1276601"] forState:UIControlStateHighlighted];
        [pb_t_decloseBtn addTarget:self action:@selector(buttonSenderTap:) forControlEvents:UIControlEventTouchUpInside];
        pb_t_decloseBtn.tag = 51;
        [contentWrap addSubview:pb_t_decloseBtn];
        [pb_t_decloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cardView.mas_left);
            /// 关闭按钮 bottom 相对切图 top 向下 15px
            make.bottom.mas_equalTo(headerImgV.mas_top).offset(PB_Ratio(15));
            make.width.height.mas_equalTo(PB_Ratio(36));
        }];

        /// 层级：切图在下，卡片盖住切图重叠区，关闭键最上
        [contentWrap bringSubviewToFront:cardView];
        [contentWrap bringSubviewToFront:pb_t_decloseBtn];

        NSArray *names = @[ @"Name", @"ID number", @"Birthday" ];
        NSArray *values = @[
            PBStrFormat(model.theoretical.celebrating),
            PBStrFormat(model.theoretical.gillborn),
            PBStrFormat(model.theoretical.creates),
        ];
        NSString *pleaseEnter = @"Enter text...";
        NSString *pleaeSelect = @"Please select";
        NSArray *holds = @[ pleaseEnter, pleaseEnter, pleaeSelect ];
        UIColor *labelGreen = PB_Color(@"#1B5E20");
        CGFloat item_height = PB_Ratio(72);
        UIView *lastFieldView = nil;
        for (NSInteger i = 0; i < names.count; i++) {
            UIView *itemView = [[UIView alloc] init];
            [cardView addSubview:itemView];
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(PB_Ratio(15));
                make.right.mas_offset(-PB_Ratio(15));
                if (lastFieldView) {
                    make.top.mas_equalTo(lastFieldView.mas_bottom);
                } else {
                    make.top.mas_equalTo(cardView.mas_top).offset(PB_Ratio(18));
                }
                make.height.mas_equalTo(item_height);
            }];
            lastFieldView = itemView;

            QMUILabel *pb_t_depTitleLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:names[i] color:labelGreen font:UIFontMediumMake(PB_Ratio(14)) alignment:NSTextAlignmentLeft lines:1];

            QMUITextField *pb_t_depTextField = [PB_UI pb_create_textFieldWithFrame:CGRectZero bgColor:PB_Color(@"#F5F5F5") placeholder:pleaseEnter textColor:PB_yiBanBlackColor font:UIFontMediumMake(PB_Ratio(16)) cornerRadius:PB_Ratio(10) keyboardType:UIKeyboardTypeDefault];
            pb_t_depTextField.placeholder = holds[i];
            pb_t_depTextField.textInsets = UIEdgeInsetsMake(0, PB_Ratio(14), 0, PB_Ratio(14));
            pb_t_depTextField.text = values[i];
            pb_t_depTextField.userInteractionEnabled = (i != (names.count - 1));
            [itemView addSubview:pb_t_depTitleLabel];
            [itemView addSubview:pb_t_depTextField];
            [pb_t_depTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.mas_equalTo(0);
            }];
            [pb_t_depTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(PB_Ratio(26), 0, 0, 0));
            }];
            if(i == 0){
                _tf1 = pb_t_depTextField;
            }else if (i == 1){
                _tf2 = pb_t_depTextField;
            }else if (i == 2){
                _tf3 = pb_t_depTextField;
                QMUIButton *pb_t_dedatePickButton = [[QMUIButton alloc] init];
                [pb_t_dedatePickButton addTarget:self action:@selector(datePickbuttonSenderTap:) forControlEvents:UIControlEventTouchUpInside];
                [itemView addSubview:pb_t_dedatePickButton];
                [pb_t_dedatePickButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(pb_t_depTextField);
                }];
            }
        }

        QMUILabel *hintLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"Please check your ID information correctly, once submitted it is not changed again" color:PB_Color(@"#FB6E21") font:UIFontMake(PB_Ratio(12)) alignment:NSTextAlignmentLeft lines:0];
        [cardView addSubview:hintLabel];
        [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(PB_Ratio(15));
            make.right.mas_offset(-PB_Ratio(15));
            make.top.mas_equalTo(lastFieldView.mas_bottom).offset(PB_Ratio(8));
        }];

        QMUIButton *pb_t_desubmitButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        pb_t_desubmitButton.backgroundColor = UIColor.clearColor;
        [pb_t_desubmitButton setBackgroundImage:[UIImage imageNamed:@"Rec626999"] forState:UIControlStateNormal];
        [pb_t_desubmitButton setBackgroundImage:[UIImage imageNamed:@"Rec626999"] forState:UIControlStateHighlighted];
        [pb_t_desubmitButton setTitle:@"Confirm" forState:UIControlStateNormal];
        pb_t_desubmitButton.titleLabel.font = UIFontBoldMake(PB_Ratio(17));
        [pb_t_desubmitButton setTitleColor:PB_WhiteColor forState:UIControlStateNormal];
        [pb_t_desubmitButton addTarget:self action:@selector(buttonSenderTap:) forControlEvents:UIControlEventTouchUpInside];
        pb_t_desubmitButton.tag = 50;
        pb_t_desubmitButton.layer.cornerRadius = PB_Ratio(10);
        pb_t_desubmitButton.layer.masksToBounds = YES;
        [cardView addSubview:pb_t_desubmitButton];
        [pb_t_desubmitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(PB_Ratio(15));
            make.right.mas_offset(-PB_Ratio(15));
            make.bottom.mas_offset(-PB_Ratio(16));
            make.height.mas_equalTo(PB_Ratio(50));
            make.top.mas_equalTo(hintLabel.mas_bottom).offset(PB_Ratio(16));
        }];

        [contentWrap mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headerImgV.mas_top);
            make.bottom.mas_equalTo(cardView.mas_bottom);
        }];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)pb_dimAreaTapOnlyDismissKeyboard:(UITapGestureRecognizer *)gr {
    [self.view endEditing:YES];
}

- (void)datePickbuttonSenderTap:(QMUIButton *)button {
    [self.view endEditing:YES];
    if(![NSString PB_CheckStringIsEmpty:self.mainModel.theoretical.creates]){
        self.dataPicker_pb_t_.selectDate = [NSDate br_setYear:[self.mainModel.theoretical.incomplete integerValue] month:[self.mainModel.theoretical.outperform integerValue] day:[self.mainModel.theoretical.areas integerValue]];
    } else {
        self.dataPicker_pb_t_.selectDate = [NSDate br_setYear:2000 month:01 day:01];
    }
    [self.dataPicker_pb_t_ show];
}

- (void)buttonSenderTap:(QMUIButton *)button{
    [self.view endEditing:YES];
    NSInteger buttonTag = button.tag;
    if(buttonTag == 50){//确认-数据提交请求
        if([NSString PB_CheckStringIsEmpty:self.tf1]){
            return;
        }else if ([NSString PB_CheckStringIsEmpty:self.tf2]){
            return;
        }else if ([NSString PB_CheckStringIsEmpty:self.tf3]){
            return;
        }
        NSDictionary *params = @{
            @"gillborn":self.tf1.text,
            @"celebrating":self.tf2.text,
            @"creates":self.tf3.text,
            @"reviewed":@"11",
            @"explain":[NSString PB_CheckStringIsEmpty:self.cardType] ? @"PRC" : self.cardType
        };
       // NSLog(@"%@",params);
        if(_myBlock){
            _myBlock(params);
        }
    }else if (buttonTag == 51){//取消
        if(_myBlock){
            _myBlock(@{});
        }
    }
}

- (BRDatePickerView *)dataPicker_pb_t_ {
    if (!_dataPicker_pb_t_) {
        _dataPicker_pb_t_ = [PB_BR pb_to_getCustomDataPickerView];
        _dataPicker_pb_t_.isAutoSelect = YES;
        PMMyWeekSelf
        _dataPicker_pb_t_.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            [formatter1 setDateFormat:@"dd"];//样式
            NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
            [formatter2 setDateFormat:@"MM"];//样式
            NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
            [formatter3 setDateFormat:@"yyyy"];//样式
            NSString *value1 = [formatter1 stringFromDate:selectDate];//日
            NSString *value2 = [formatter2 stringFromDate:selectDate];//月
            NSString *value3 = [formatter3 stringFromDate:selectDate];//年
            
//            NSLog(@"选择的值：%@,转换后日期：%@-%@-%@", selectValue,value1,value2,value3);
            weakSelf.tf3.text = [NSString stringWithFormat:@"%@-%@-%@",value3,value2,value1];
            weakSelf.mainModel.theoretical.areas = value1;//日
            weakSelf.mainModel.theoretical.outperform = value2;//月
            weakSelf.mainModel.theoretical.incomplete = value3;//年
        };
    }
    return _dataPicker_pb_t_;
}


@end
