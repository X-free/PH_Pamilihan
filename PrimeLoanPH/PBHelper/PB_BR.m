//
//  PB_BR.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/7.
//

#import "PB_BR.h"

@implementation PB_BR


/// 日期选择器自定义样式
+ (BRPickerStyle *)pv_to_getPickerCustomStyle {
    BRPickerStyle *pb_t_pickStyle = [[BRPickerStyle alloc] init];
    pb_t_pickStyle.topCornerRadius = PB_Ratio(20);
    pb_t_pickStyle.titleTextColor = PB_yiBanBlackColor;
    pb_t_pickStyle.separatorColor = [UIColor clearColor];
    pb_t_pickStyle.doneTextColor = PP_AppColor;
    pb_t_pickStyle.cancelTextFont = UIFontMake(PB_Ratio(14));
    pb_t_pickStyle.doneTextFont = UIFontBoldMake(PB_Ratio(14));
    pb_t_pickStyle.pickerTextFont = UIFontMediumMake(PB_Ratio(16));
    
    pb_t_pickStyle.titleTextFont = UIFontMediumMake(PB_Ratio(18));
    pb_t_pickStyle.titleLabelFrame = CGRectMake(PB_Ratio(105), 0, PB_SW - PB_Ratio(105)*2, PB_Ratio(48));
    pb_t_pickStyle.cancelBtnFrame = CGRectMake(PB_Ratio(0), 0, PB_Ratio(100), PB_Ratio(48));
    pb_t_pickStyle.doneBtnFrame = CGRectMake(PB_SW - PB_Ratio(105), 0, PB_Ratio(100), PB_Ratio(48));
    pb_t_pickStyle.hiddenShadowLine = YES; //隐藏顶部线
    pb_t_pickStyle.hiddenTitleLine = YES;  //隐藏标题底部线
    pb_t_pickStyle.hiddenTitleLabel = NO;//隐藏标题
    pb_t_pickStyle.rowHeight = PB_Ratio(48);
    pb_t_pickStyle.selectRowTextColor = PB_yiBanBlackColor;
    pb_t_pickStyle.selectRowColor = UIColor.clearColor;
    pb_t_pickStyle.doneBtnTitle = @"Confirm";
    pb_t_pickStyle.cancelBtnTitle = @"Cancel";
    pb_t_pickStyle.hiddenDoneBtn = YES;
    pb_t_pickStyle.hiddenCancelBtn = YES;
    pb_t_pickStyle.paddingBottom = PB_Ratio(110);
    return pb_t_pickStyle;
}

+ (BRDatePickerView *)pb_to_getCustomDataPickerView {
    BRDatePickerView *pb_t_dataPickerView = [[BRDatePickerView alloc] init];
    //2、设置属性(年月)
    pb_t_dataPickerView.pickerMode = BRDatePickerModeYMD;
    pb_t_dataPickerView.showToday = NO;
    pb_t_dataPickerView.showUnitType = NO;
    pb_t_dataPickerView.customUnit = @{@"year": @"", @"month": @"", @"day": @"", @"hour": @"", @"minute": @"", @"second": @""};
    pb_t_dataPickerView.maxDate = [NSDate date];
    pb_t_dataPickerView.selectDate = [NSDate br_setYear:1995 month:1 day:1];
    BRPickerStyle *style = [self pv_to_getPickerCustomStyle];
//    style.language = @"US";//不设置默认跟随系统
    pb_t_dataPickerView.pickerStyle = style;
    
    //底部确认按钮
    QMUIButton *pb_t_de_button = [[QMUIButton alloc] init];
    [pb_t_de_button setTitle:@"Confirm" forState:UIControlStateNormal];
    [pb_t_de_button setTitleColor:PB_WhiteColor forState:UIControlStateNormal];
    pb_t_de_button.backgroundColor = PP_AppColor;
    pb_t_de_button.layer.cornerRadius = PB_Ratio(22);
    pb_t_de_button.layer.masksToBounds = YES;
    pb_t_de_button.qmui_tapBlock = ^(__kindof UIControl *sender) {
        [pb_t_dataPickerView dismiss];
        if(pb_t_dataPickerView.doneBlock){
            pb_t_dataPickerView.doneBlock();
        }
    };
    [pb_t_dataPickerView.alertView addSubview:pb_t_de_button];
    [pb_t_de_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_offset(-PB_Ratio(48));
        make.size.mas_equalTo(CGSizeMake(PB_SW - PB_Ratio(47)*2, PB_Ratio(44)));
    }];
    
    QMUIButton *pb_t_cancelButton = [[QMUIButton alloc] init];
    [pb_t_cancelButton setImage:UIImageMake(@"icon_return_black") forState:UIControlStateNormal];
    pb_t_cancelButton.qmui_tapBlock = ^(__kindof UIControl *sender) {
        [pb_t_dataPickerView dismiss];
    };
    [pb_t_dataPickerView.alertView addSubview:pb_t_cancelButton];
    [pb_t_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PB_Ratio(10));
        make.top.mas_equalTo(PB_Ratio(10));
        make.width.height.mas_equalTo(PB_Ratio(34));
    }];
    
    //标题
    pb_t_dataPickerView.title = @"Date selection";
    return pb_t_dataPickerView;
}

+ (BRStringPickerView *)pb_to_getCustomStringPickerView {
    BRStringPickerView *pb_t_stringPickerView = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
    pb_t_stringPickerView.title = @"";
    pb_t_stringPickerView.selectIndex = 0;
    pb_t_stringPickerView.pickerStyle = [self pv_to_getPickerCustomStyle];
    
    
    //底部确认按钮
    QMUIButton *button = [[QMUIButton alloc] init];
    [button setTitle:@"Confirm" forState:UIControlStateNormal];
    [button setTitleColor:PB_WhiteColor forState:UIControlStateNormal];
    button.backgroundColor = PP_AppColor;
    button.layer.cornerRadius = PB_Ratio(22);
    button.layer.masksToBounds = YES;
    button.qmui_tapBlock = ^(__kindof UIControl *sender) {
        [pb_t_stringPickerView dismiss];
        if(pb_t_stringPickerView.doneBlock){
            pb_t_stringPickerView.doneBlock();
        }
    };
    [pb_t_stringPickerView.alertView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_offset(-PB_Ratio(48));
        make.size.mas_equalTo(CGSizeMake(PB_SW - PB_Ratio(47)*2, PB_Ratio(44)));
    }];
    
    QMUIButton *cancelButton = [[QMUIButton alloc] init];
    [cancelButton setImage:UIImageMake(@"icon_return_black") forState:UIControlStateNormal];
    cancelButton.qmui_tapBlock = ^(__kindof UIControl *sender) {
        [pb_t_stringPickerView dismiss];
    };
    [pb_t_stringPickerView.alertView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PB_Ratio(10));
        make.top.mas_equalTo(PB_Ratio(10));
        make.width.height.mas_equalTo(PB_Ratio(34));
    }];
    
    
    
    return pb_t_stringPickerView;
}

+ (BRAddressPickerView *)pb_to_getAdressCustomPickerView {
    BRAddressPickerView *pb_t_picker = [[BRAddressPickerView alloc] initWithPickerMode:BRAddressPickerModeArea];
    pb_t_picker.pickerStyle = [self pv_to_getPickerCustomStyle];
    
    //底部确认按钮
    QMUIButton *button = [[QMUIButton alloc] init];
    [button setTitle:@"Confirm" forState:UIControlStateNormal];
    [button setTitleColor:PB_WhiteColor forState:UIControlStateNormal];
    button.backgroundColor = PP_AppColor;
    button.layer.cornerRadius = PB_Ratio(22);
    button.layer.masksToBounds = YES;
    button.qmui_tapBlock = ^(__kindof UIControl *sender) {
        [pb_t_picker dismiss];
        if(pb_t_picker.doneBlock){
            pb_t_picker.doneBlock();
        }
    };
    [pb_t_picker.alertView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_offset(-PB_Ratio(48));
        make.size.mas_equalTo(CGSizeMake(PB_SW - PB_Ratio(47)*2, PB_Ratio(44)));
    }];
    
    QMUIButton *pb_t_cancelButton = [[QMUIButton alloc] init];
    [pb_t_cancelButton setImage:UIImageMake(@"icon_return_black") forState:UIControlStateNormal];
    pb_t_cancelButton.qmui_tapBlock = ^(__kindof UIControl *sender) {
        [pb_t_picker dismiss];
    };
    [pb_t_picker.alertView addSubview:pb_t_cancelButton];
    [pb_t_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PB_Ratio(10));
        make.top.mas_equalTo(PB_Ratio(10));
        make.width.height.mas_equalTo(PB_Ratio(34));
    }];
    
    
    return pb_t_picker;
}


@end
