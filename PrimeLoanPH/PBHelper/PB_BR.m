//
//  PB_BR.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/7.
//

#import "PB_BR.h"
#import <BRPickerView/BRBaseView.h>
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

@interface BRBaseView (PB_InitUI)
- (void)initUI;
@end

/// 图2：optiontitlbg 左右各 36；白卡左右各 16；白卡顶相对顶图顶 76；关闭钮底距顶图顶 5
static CGFloat PBStringPickerHeaderSideInset(void) { return PB_Ratio(36); }
static CGFloat PBStringPickerCardSideInset(void) { return PB_Ratio(16); }
static CGFloat PBStringPickerHeaderWidth(void) { return PB_SW - PBStringPickerHeaderSideInset() * 2; }
static CGFloat PBStringPickerCardWidth(void) { return PB_SW - PBStringPickerCardSideInset() * 2; }
static CGFloat PBStringPickerCardTopFromHeaderTop(void) { return PB_Ratio(76); }
static CGFloat PBStringPickerCloseBottomToHeaderTop(void) { return PB_Ratio(5); }

static const NSInteger kPBStringPickerCloseTag = 921001;
static const NSInteger kPBStringPickerConfirmTag = 921002;
static const NSInteger kPBStringPickerHeaderBgTag = 921005;
static const NSInteger kPBStringPickerHeaderTitleTag = 921006;

static void PBStringPickerApplyConfirmGradient(QMUIButton *btn) {
    if (!btn || CGRectIsEmpty(btn.bounds)) { return; }
    for (CALayer *ly in [btn.layer.sublayers copy]) {
        if ([ly isKindOfClass:[CAGradientLayer class]]) {
            [ly removeFromSuperlayer];
        }
    }
    CAGradientLayer *g = [CAGradientLayer layer];
    g.frame = btn.bounds;
    g.cornerRadius = btn.layer.cornerRadius;
    g.masksToBounds = YES;
    g.colors = @[ (id)PB_Color(@"#5D4037").CGColor, (id)PB_Color(@"#1A1A1A").CGColor ];
    g.startPoint = CGPointMake(0.5, 0);
    g.endPoint = CGPointMake(0.5, 1);
    [btn.layer insertSublayer:g atIndex:0];
    btn.backgroundColor = UIColor.clearColor;
}

@implementation PB_BR

/// 日期选择器专用样式（头部 selcltimetopbg、黄底选中行等）
+ (BRPickerStyle *)pv_to_getDatePickerStyleWithTitleBarHeight:(CGFloat)titleBarH {
    BRPickerStyle *pb_t_pickStyle = [[BRPickerStyle alloc] init];
    pb_t_pickStyle.topCornerRadius = PB_Ratio(20);
    pb_t_pickStyle.alertViewColor = UIColor.whiteColor;
    pb_t_pickStyle.maskColor = PB_AlphaColor(@"#000000", 0.45f);
    pb_t_pickStyle.titleBarHeight = titleBarH;
    pb_t_pickStyle.titleBarColor = UIColor.clearColor;
    pb_t_pickStyle.separatorColor = UIColor.clearColor;
    pb_t_pickStyle.hiddenShadowLine = YES;
    pb_t_pickStyle.hiddenTitleLine = YES;
    pb_t_pickStyle.hiddenTitleLabel = YES;
    pb_t_pickStyle.hiddenDoneBtn = YES;
    pb_t_pickStyle.hiddenCancelBtn = NO;
    pb_t_pickStyle.cancelColor = UIColor.clearColor;
    pb_t_pickStyle.cancelBtnImage = UIImageMake(@"Grosx1276601");
    pb_t_pickStyle.cancelBtnFrame = CGRectMake(PB_Ratio(10), PB_Ratio(10), PB_Ratio(32), PB_Ratio(32));
    pb_t_pickStyle.pickerTextFont = UIFontMediumMake(PB_Ratio(16));
    pb_t_pickStyle.pickerTextColor = PB_Color(@"#333333");
    pb_t_pickStyle.selectRowTextColor = UIColor.whiteColor;
    pb_t_pickStyle.selectRowTextFont = UIFontBoldMake(PB_Ratio(16));
    pb_t_pickStyle.selectRowColor = PB_Color(@"#FFCC16");
    pb_t_pickStyle.rowHeight = PB_Ratio(40);
    pb_t_pickStyle.pickerHeight = PB_Ratio(216);
    pb_t_pickStyle.paddingBottom = PB_Ratio(100);
    pb_t_pickStyle.clearPickerNewStyle = YES;
    return pb_t_pickStyle;
}

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

/// 字符串选择（图2）：居中卡整圆角在 apply 内绘制故 topCornerRadius=0；蒙层 45%；列表黄条；标题区宽度按顶图左右 36
+ (BRPickerStyle *)pv_to_getStringPickerStyleWithTitleBarHeight:(CGFloat)titleBarH {
    CGFloat headerW = PBStringPickerHeaderWidth();
    BRPickerStyle *s = [[BRPickerStyle alloc] init];
    s.topCornerRadius = 0;
    s.alertViewColor = UIColor.whiteColor;
    s.maskColor = PB_AlphaColor(@"#000000", 0.45f);
    s.titleBarHeight = titleBarH;
    s.titleBarColor = UIColor.clearColor;
    s.separatorColor = UIColor.clearColor;
    s.hiddenShadowLine = YES;
    s.hiddenTitleLine = YES;
    s.hiddenTitleLabel = NO;
    s.hiddenDoneBtn = YES;
    s.hiddenCancelBtn = YES;
    s.pickerTextFont = UIFontMediumMake(PB_Ratio(16));
    s.pickerTextColor = PB_Color(@"#333333");
    s.selectRowTextColor = UIColor.whiteColor;
    s.selectRowTextFont = UIFontBoldMake(PB_Ratio(16));
    s.selectRowColor = PB_Color(@"#FFCC16");
    s.rowHeight = PB_Ratio(48);
    s.pickerHeight = PB_Ratio(216);
    s.paddingBottom = PB_Ratio(110);
    s.clearPickerNewStyle = YES;
    s.titleTextFont = UIFontBoldMake(PB_Ratio(18));
    s.titleTextColor = PB_Color(@"#5D4037");
    s.titleLabelFrame = CGRectMake(PB_Ratio(18), 0, headerW - PB_Ratio(36), titleBarH);
    return s;
}

+ (BRStringPickerView *)pb_to_getCustomStringPickerView {
    BRStringPickerView *pb_t_stringPickerView = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
    pb_t_stringPickerView.title = @"";
    pb_t_stringPickerView.selectIndex = 0;

    UIImage *optionBg = UIImageMake(@"optiontitlbg");
    CGFloat headerW = PBStringPickerHeaderWidth();
    CGFloat titleBarH = PB_Ratio(76);
    if (optionBg && optionBg.size.width > 1.f) {
        CGFloat scaled = optionBg.size.height * (headerW / optionBg.size.width);
        if (scaled >= PB_Ratio(52) && scaled <= PB_Ratio(140)) {
            titleBarH = scaled;
        }
    }
    pb_t_stringPickerView.pickerStyle = [self pv_to_getStringPickerStyleWithTitleBarHeight:titleBarH];

    QMUIButton *button = [[QMUIButton alloc] init];
    button.tag = kPBStringPickerConfirmTag;
    [button setTitle:@"Confirm" forState:UIControlStateNormal];
    [button setTitleColor:PB_WhiteColor forState:UIControlStateNormal];
    button.titleLabel.font = UIFontBoldMake(PB_Ratio(16));
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
        make.left.mas_equalTo(PB_Ratio(24));
        make.right.mas_offset(-PB_Ratio(24));
        make.height.mas_equalTo(PB_Ratio(44));
    }];

    QMUIButton *cancelButton = [[QMUIButton alloc] init];
    cancelButton.tag = kPBStringPickerCloseTag;
    [cancelButton setImage:UIImageMake(@"Grosx1276601") forState:UIControlStateNormal];
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

+ (void)pb_applyStringPickerOptionTitleUI:(BRStringPickerView *)picker {
    if (!picker) { return; }
    [UIView performWithoutAnimation:^{
        [self pb_applyStringPickerFigure2CardLayout:picker];
    }];
}

/// 图2：`optiontitlbg`、白卡、关闭均为 `picker` 子视图同级；顶图左右 36、白卡左右 16；白卡盖顶图顶距 76；关闭底距顶图顶 5、左与白卡左对齐
+ (void)pb_applyStringPickerFigure2CardLayout:(BRStringPickerView *)picker {
    CGFloat headerInset = PBStringPickerHeaderSideInset();
    CGFloat cardInset = PBStringPickerCardSideInset();
    CGFloat headerW = PBStringPickerHeaderWidth();
    CGFloat cardW = PBStringPickerCardWidth();
    CGFloat titleBarH = picker.pickerStyle.titleBarHeight;
    CGFloat pickerH = picker.pickerStyle.pickerHeight;
    CGFloat padBottom = picker.pickerStyle.paddingBottom;
    CGFloat cardTopGap = PBStringPickerCardTopFromHeaderTop();
    CGFloat alertH = pickerH + padBottom;
    CGFloat closeGap = PBStringPickerCloseBottomToHeaderTop();
    CGFloat closeSz = PB_Ratio(36);

    CGFloat extendAbove = closeGap + closeSz;
    CGFloat blockBottomRel = MAX(titleBarH, cardTopGap + alertH);
    CGFloat groupH = extendAbove + blockBottomRel;
    CGFloat closeTopY = (PB_SH - groupH) * 0.5f;
    if (closeTopY < PB_Ratio(16)) {
        closeTopY = PB_Ratio(16);
    }
    CGFloat clusterTopY = closeTopY + extendAbove;

    UIView *alert = picker.alertView;
    CGFloat cardY = clusterTopY + cardTopGap;

    alert.layer.cornerRadius = PB_Ratio(20);
    alert.layer.masksToBounds = YES;
    alert.frame = CGRectMake(cardInset, cardY, cardW, alertH);

    UIView *tb = nil;
    @try {
        tb = [picker valueForKey:@"titleBarView"];
    } @catch (__unused NSException *e) {}
    if (!tb && alert) {
        for (UIView *child in alert.subviews) {
            if ([child isKindOfClass:[UIPickerView class]]) { continue; }
            if (fabs(child.bounds.size.height - titleBarH) < 3.f && child.frame.origin.y < 3.f) {
                tb = child;
                break;
            }
        }
    }
    if (tb) {
        tb.hidden = YES;
    }

    for (UIView *sub in alert.subviews) {
        if ([sub isKindOfClass:[UIPickerView class]]) {
            sub.frame = CGRectMake(0, 0, cardW, pickerH);
            break;
        }
    }

    UIImageView *headerBg = [picker viewWithTag:kPBStringPickerHeaderBgTag];
    if (![headerBg isKindOfClass:[UIImageView class]]) {
        headerBg = [[UIImageView alloc] init];
        headerBg.tag = kPBStringPickerHeaderBgTag;
        [picker addSubview:headerBg];
    }
    headerBg.image = UIImageMake(@"optiontitlbg");
    headerBg.frame = CGRectMake(headerInset, clusterTopY, headerW, titleBarH);
    headerBg.contentMode = UIViewContentModeScaleAspectFill;
    headerBg.clipsToBounds = YES;
    headerBg.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;

    [picker insertSubview:headerBg belowSubview:alert];

    UILabel *titleLab = [headerBg viewWithTag:kPBStringPickerHeaderTitleTag];
    if (![titleLab isKindOfClass:[UILabel class]]) {
        titleLab = [[UILabel alloc] init];
        titleLab.tag = kPBStringPickerHeaderTitleTag;
        [headerBg addSubview:titleLab];
    }
    CGFloat labW = headerW - PB_Ratio(36);
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = UIFontBoldMake(PB_Ratio(18));
    titleLab.textColor = PB_Color(@"#5D4037");
    titleLab.adjustsFontSizeToFitWidth = YES;
    titleLab.minimumScaleFactor = 0.85f;
    titleLab.text = picker.title;
    titleLab.frame = CGRectMake(PB_Ratio(18), 0, labW, titleBarH);
    [headerBg bringSubviewToFront:titleLab];

    QMUIButton *confirm = [alert viewWithTag:kPBStringPickerConfirmTag];
    if ([confirm isKindOfClass:[QMUIButton class]]) {
        [confirm mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_offset(-PB_Ratio(24));
            make.left.mas_equalTo(PB_Ratio(24));
            make.right.mas_offset(-PB_Ratio(24));
            make.height.mas_equalTo(PB_Ratio(44));
        }];
    }

    QMUIButton *closeBtn = [alert viewWithTag:kPBStringPickerCloseTag];
    if (![closeBtn isKindOfClass:[QMUIButton class]]) {
        UIView *v = [picker viewWithTag:kPBStringPickerCloseTag];
        if ([v isKindOfClass:[QMUIButton class]]) {
            closeBtn = (QMUIButton *)v;
        }
    }
    if ([closeBtn isKindOfClass:[QMUIButton class]]) {
        [closeBtn removeFromSuperview];
        [picker addSubview:closeBtn];
        [closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(alert.mas_left);
            make.bottom.mas_equalTo(headerBg.mas_top).mas_offset(-closeGap);
            make.width.height.mas_equalTo(closeSz);
        }];
    }

    if ([confirm isKindOfClass:[QMUIButton class]]) {
        [alert bringSubviewToFront:confirm];
    }
    [picker bringSubviewToFront:alert];
    if ([closeBtn isKindOfClass:[QMUIButton class]]) {
        [picker bringSubviewToFront:closeBtn];
    }

    [alert layoutIfNeeded];
    if ([confirm isKindOfClass:[QMUIButton class]]) {
        PBStringPickerApplyConfirmGradient(confirm);
    }
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

#pragma mark - BRStringPickerView：去掉 BRPickerView 自带上滑/收起动画（不改变布局数值）

@implementation BRBaseView (PB_StringPickerInstantAnimation)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [BRBaseView class];
        SEL selAdd = @selector(addPickerToView:);
        SEL selAddPb = @selector(pb_sp_instant_addPickerToView:);
        SEL selRm = @selector(removePickerFromView:);
        SEL selRmPb = @selector(pb_sp_instant_removePickerFromView:);
        Method mAdd = class_getInstanceMethod(cls, selAdd);
        Method mAddPb = class_getInstanceMethod(cls, selAddPb);
        Method mRm = class_getInstanceMethod(cls, selRm);
        Method mRmPb = class_getInstanceMethod(cls, selRmPb);
        if (mAdd && mAddPb) {
            method_exchangeImplementations(mAdd, mAddPb);
        }
        if (mRm && mRmPb) {
            method_exchangeImplementations(mRm, mRmPb);
        }
    });
}

/// 仅 `BRStringPickerView`：无动画展示（最终 frame / mask 与原版一致）
- (void)pb_sp_instant_addPickerToView:(UIView *)view {
    if (!view && [self isKindOfClass:NSClassFromString(@"BRStringPickerView")]) {
        [self initUI];

        if (self.pickerHeaderView) {
            CGRect rect = self.pickerHeaderView.frame;
            CGFloat titleBarHeight = self.pickerStyle.hiddenTitleBarView ? 0 : self.pickerStyle.titleBarHeight;
            self.pickerHeaderView.frame = CGRectMake(0, titleBarHeight, self.alertView.bounds.size.width, rect.size.height);
            self.pickerHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [self.alertView addSubview:self.pickerHeaderView];
        }
        if (self.pickerFooterView) {
            CGRect rect = self.pickerFooterView.frame;
            self.pickerFooterView.frame = CGRectMake(0, self.alertView.bounds.size.height - self.pickerStyle.paddingBottom - rect.size.height, self.alertView.bounds.size.width, rect.size.height);
            self.pickerFooterView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [self.alertView addSubview:self.pickerFooterView];
        }

        [self.keyView addSubview:self];

        CGFloat accessoryViewHeight = 0;
        if (self.pickerHeaderView) {
            accessoryViewHeight += self.pickerHeaderView.bounds.size.height;
        }
        if (self.pickerFooterView) {
            accessoryViewHeight += self.pickerFooterView.bounds.size.height;
        }
        CGFloat height = self.pickerStyle.titleBarHeight + self.pickerStyle.pickerHeight + self.pickerStyle.paddingBottom + accessoryViewHeight;
        self.alertView.frame = CGRectMake(0, self.keyView.bounds.size.height - height, self.keyView.bounds.size.width, height);

        if (!self.pickerStyle.hiddenMaskView) {
            self.maskView.alpha = 1.f;
        }
        return;
    }
    [self pb_sp_instant_addPickerToView:view];
}

- (void)pb_sp_instant_removePickerFromView:(UIView *)view {
    if (!view && [self isKindOfClass:NSClassFromString(@"BRStringPickerView")]) {
        if (!self.pickerStyle.hiddenMaskView) {
            self.maskView.alpha = 0;
        }
        [self removeFromSuperview];
        return;
    }
    [self pb_sp_instant_removePickerFromView:view];
}

@end
