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
        self.view.frame = CGRectMake(0, 0, PB_SW - PB_Ratio(36)*2, PB_SH);
        UIView *bgView = [PB_UI pb_creat_ViewWithFrame:CGRectZero color:PB_WhiteColor radius:PB_Ratio(24)];
        [self.view addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_offset(-PB_Ratio(30));
            make.width.mas_equalTo(PB_SW - PB_Ratio(36) *2);
            make.height.mas_equalTo(PB_Ratio(436));
        }];

        //
        NSString *title = @"Confirm your ID information";
        QMUILabel *titleLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:title color:PB_yiBanBlackColor font:UIFontMediumMake(PB_Ratio(20)) alignment:NSTextAlignmentCenter lines:0];
        [bgView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(PB_Ratio(20));
        }];
        
        NSArray *names = @[
            @"ID No.",
            @"Full Name",
            @"Date Birth"
        ];
        NSArray *values = @[
            PBStrFormat(model.theoretical.gillborn),
            PBStrFormat(model.theoretical.celebrating),
            PBStrFormat(model.theoretical.creates),
        ];
        NSString *pleaseEnter = @"Enter text...";
        NSString *pleaeSelect = @"Please select";
        NSArray *holds = @[
            pleaseEnter,
            pleaseEnter,
            pleaeSelect,
        ];
        CGFloat item_height = PB_Ratio(72);
        for (NSInteger i = 0; i < names.count; i++) {
            UIView *itemView = [[UIView alloc] init];
            [bgView addSubview:itemView];
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(PB_Ratio(15));
                make.right.mas_offset(-PB_Ratio(15));
                make.top.mas_equalTo(PB_Ratio(88) + item_height * i);
                make.height.mas_equalTo(item_height);
            }];
            QMUILabel *pb_t_depTitleLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:names[i] color:PB_morenHoldColor font:UIFontMake(PB_Ratio(15)) alignment:NSTextAlignmentCenter lines:0];
           
            QMUITextField *pb_t_depTextField = [PB_UI pb_create_textFieldWithFrame:CGRectZero bgColor:PB_WhiteColor placeholder:pleaseEnter textColor:PB_yiBanBlackColor font:UIFontMediumMake(PB_Ratio(16)) cornerRadius:PB_Ratio(10) keyboardType:UIKeyboardTypeDefault];
            pb_t_depTextField.placeholder = holds[i];
            pb_t_depTextField.textInsets = UIEdgeInsetsMake(0, PB_Ratio(16), 0, PB_Ratio(16));
            pb_t_depTextField.text = values[i];
            pb_t_depTextField.userInteractionEnabled = i == (names.count - 1) ? NO : YES;
            [itemView addSubview:pb_t_depTitleLabel];
            [itemView addSubview:pb_t_depTextField];
            [pb_t_depTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.mas_equalTo(0);
            }];
            [pb_t_depTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(PB_Ratio(28), 0, 0, 0));
            }];
            if(i == 0){
//                pb_t_depTextField.keyboardType = UIKeyboardTypeNumberPad;
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

        QMUIButton *pb_t_desubmitButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        pb_t_desubmitButton.backgroundColor = PP_AppColor;
        pb_t_desubmitButton.layer.cornerRadius = 0;
        pb_t_desubmitButton.layer.masksToBounds = YES;
        [pb_t_desubmitButton setTitle:@"Confirm" forState:UIControlStateNormal];
        pb_t_desubmitButton.titleLabel.font = UIFontMediumMake(PB_Ratio(18));
        [pb_t_desubmitButton setTitleColor:PB_WhiteColor forState:UIControlStateNormal];
        [pb_t_desubmitButton addTarget:self action:@selector(buttonSenderTap:) forControlEvents:UIControlEventTouchUpInside];
        pb_t_desubmitButton.tag = 50;
        
        //
        QMUIButton *pb_t_decloseBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        pb_t_decloseBtn.backgroundColor = UIColor.clearColor;
        [pb_t_decloseBtn setImage:[UIImage imageNamed:@"icon_close_x"] forState:UIControlStateNormal];
        [pb_t_decloseBtn setImage:[UIImage imageNamed:@"icon_close_x"] forState:UIControlStateHighlighted];
        [pb_t_decloseBtn addTarget:self action:@selector(buttonSenderTap:) forControlEvents:UIControlEventTouchUpInside];
        pb_t_decloseBtn.tag = 51;

        [bgView addSubview:pb_t_desubmitButton];
        [self.view addSubview:pb_t_decloseBtn];
        
        [pb_t_desubmitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(PB_Ratio(48));
        }];
        [pb_t_decloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bgView.mas_bottom).offset(PB_Ratio(24));
            make.centerX.mas_equalTo(0);
            make.width.height.mas_equalTo(PB_Ratio(34));
        }];
        
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)datePickbuttonSenderTap:(QMUIButton *)button {
    [self.view endEditing:YES];
    if(![NSString PB_CheckStringIsEmpty:self.mainModel.theoretical.creates]){
        self.dataPicker_pb_t_.selectDate = [NSDate br_setYear:[self.mainModel.theoretical.incomplete integerValue] month:[self.mainModel.theoretical.outperform integerValue] day:[self.mainModel.theoretical.areas integerValue]];
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
