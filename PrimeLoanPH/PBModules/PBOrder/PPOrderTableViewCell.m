//
//  PPOrderTableViewCell.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/31.
//  布局对齐首页「小卡列表」：顶行 logo+标题；中行 额度说明+大额+右侧主按钮；底行 两列 `interpreted`（期限/利率等）；可选协议链
//

#import "PPOrderTableViewCell.h"
#import "PPOrderModel.h"

@interface PPOrderTableViewCell ()

@property (nonatomic, strong) UIView *pb_t_de_cardView;
@property (nonatomic, strong) UIImageView *pb_t_de_logoImageView;
@property (nonatomic, strong) QMUILabel *pb_t_de_productNameLabel;
@property (nonatomic, strong) QMUILabel *pb_t_de_amountCaptionLabel;
@property (nonatomic, strong) QMUILabel *pb_t_de_amountLabel;
@property (nonatomic, strong) UIButton *pb_t_de_actionButton;

@property (nonatomic, strong) UIView *pb_t_de_amountBlock;
@property (nonatomic, strong) QMUILabel *pb_t_de_bottomLeftLabel;
@property (nonatomic, strong) QMUILabel *pb_t_de_bottomRightLabel;

@property (nonatomic, strong) UIButton *pb_t_de_agreeButton;

@property (nonatomic, strong) PPOrderDrawModel *pb_t_de_dataModel;

@end

@implementation PPOrderTableViewCell

- (void)pb_initUI {
    self.contentView.backgroundColor = UIColor.clearColor;
    self.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.pb_t_de_cardView];
    [self.pb_t_de_cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat side = PB_Ratio(12);
        CGFloat vert = PB_Ratio(6);
        make.edges.mas_equalTo(UIEdgeInsetsMake(vert, side, vert, side));
    }];
}

/// 与小卡列表 `listCardFooterLine` 一致：标题 11 `#8C8C8C`，数值 13 semibold `#3B332C`
- (NSAttributedString *)pb_footerLineTitle:(NSString *)title value:(NSString *)value {
    NSString *t = PBStrFormat(title);
    NSString *v = PBStrFormat(value);
    t = [t stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    v = [v stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (t.length == 0 && v.length == 0) {
        return nil;
    }
    UIFont *titleFont = UIFontMake(PB_Ratio(11));
    UIFont *valueFont = [UIFont systemFontOfSize:PB_Ratio(13) weight:UIFontWeightSemibold];
    UIColor *titleColor = PB_Color(@"#8C8C8C");
    UIColor *valueColor = PB_Color(@"#3B332C");
    NSMutableAttributedString *m = [NSMutableAttributedString new];
    if (t.length > 0) {
        [m appendAttributedString:[[NSAttributedString alloc] initWithString:t attributes:@{
            NSFontAttributeName: titleFont,
            NSForegroundColorAttributeName: titleColor
        }]];
        [m appendAttributedString:[[NSAttributedString alloc] initWithString:@":" attributes:@{
            NSFontAttributeName: titleFont,
            NSForegroundColorAttributeName: titleColor
        }]];
        if (v.length > 0) {
            [m appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:@{
                NSFontAttributeName: valueFont,
                NSForegroundColorAttributeName: valueColor
            }]];
        }
    }
    if (v.length > 0) {
        [m appendAttributedString:[[NSAttributedString alloc] initWithString:v attributes:@{
            NSFontAttributeName: valueFont,
            NSForegroundColorAttributeName: valueColor
        }]];
    }
    return m;
}

- (void)pb_configWithCellData:(id)data {
    if (![data isKindOfClass:PPOrderDrawModel.class]) {
        return;
    }
    PPOrderDrawModel *model = (PPOrderDrawModel *)data;
    self.pb_t_de_dataModel = model;
    [PPTools PB_loadUrl_ImageView:self.pb_t_de_logoImageView urlStr:model.networks holdImg:@"pLogo"];

    self.pb_t_de_productNameLabel.text = PBStrFormat(model.courses);
    self.pb_t_de_amountCaptionLabel.text = @"Maximum loan amount";
    self.pb_t_de_amountLabel.text = PBStrFormat(model.constructed);

    NSString *btnTitle = [PBStrFormat(model.lobbying) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    CGFloat pad = PB_Ratio(12);
    if (btnTitle.length > 0) {
        self.pb_t_de_actionButton.hidden = NO;
        [self.pb_t_de_actionButton setTitle:btnTitle forState:UIControlStateNormal];
        [self.pb_t_de_amountBlock mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(pad);
            make.top.mas_equalTo(self.pb_t_de_logoImageView.mas_bottom).offset(PB_Ratio(10));
            make.right.mas_lessThanOrEqualTo(self.pb_t_de_actionButton.mas_left).offset(-PB_Ratio(10));
        }];
        [self.pb_t_de_actionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.pb_t_de_cardView.mas_right).offset(-pad);
            make.width.mas_equalTo(PB_Ratio(115));
            make.height.mas_equalTo(PB_Ratio(38));
            make.centerY.mas_equalTo(self.pb_t_de_amountBlock);
        }];
    } else {
        self.pb_t_de_actionButton.hidden = YES;
        [self.pb_t_de_actionButton setTitle:@"" forState:UIControlStateNormal];
        [self.pb_t_de_amountBlock mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(pad);
            make.top.mas_equalTo(self.pb_t_de_logoImageView.mas_bottom).offset(PB_Ratio(10));
            make.right.mas_equalTo(self.pb_t_de_cardView.mas_right).offset(-pad);
        }];
        [self.pb_t_de_actionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.pb_t_de_cardView.mas_right).offset(-pad);
            make.width.height.mas_equalTo(0);
            make.centerY.mas_equalTo(self.pb_t_de_amountBlock);
        }];
    }

    NSArray *interp = model.interpreted;
    PPOrderInterpretedModel *leftItem = nil;
    PPOrderInterpretedModel *rightItem = nil;
    if ([interp isKindOfClass:NSArray.class] && interp.count > 0) {
        leftItem = interp[0];
    }
    if ([interp isKindOfClass:NSArray.class] && interp.count > 1) {
        rightItem = interp[1];
    }
    NSAttributedString *attrL = [self pb_footerLineTitle:leftItem.age value:leftItem.challenges];
    NSAttributedString *attrR = [self pb_footerLineTitle:rightItem.age value:rightItem.challenges];
    self.pb_t_de_bottomLeftLabel.attributedText = attrL;
    self.pb_t_de_bottomRightLabel.attributedText = attrR;
    BOOL hasBottom = (attrL != nil || attrR != nil);
    self.pb_t_de_bottomLeftLabel.hidden = !hasBottom;
    self.pb_t_de_bottomRightLabel.hidden = !hasBottom;

    BOOL showAgreement = ![NSString PB_CheckStringIsEmpty:model.unifying];
    self.pb_t_de_agreeButton.hidden = !showAgreement;

    if (showAgreement) {
        [self.pb_t_de_agreeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(pad);
            if (hasBottom) {
                make.top.mas_equalTo(self.pb_t_de_bottomLeftLabel.mas_bottom).offset(PB_Ratio(10));
            } else {
                make.top.mas_equalTo(self.pb_t_de_amountBlock.mas_bottom).offset(PB_Ratio(10));
            }
            make.bottom.mas_equalTo(self.pb_t_de_cardView.mas_bottom).offset(-pad);
        }];
    } else {
        [self.pb_t_de_agreeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(pad);
            make.height.mas_equalTo(0);
            if (hasBottom) {
                make.top.mas_equalTo(self.pb_t_de_bottomLeftLabel.mas_bottom).offset(0);
            } else {
                make.top.mas_equalTo(self.pb_t_de_amountBlock.mas_bottom).offset(0);
            }
            make.bottom.mas_equalTo(self.pb_t_de_cardView.mas_bottom).offset(-pad);
        }];
    }
}

- (void)toShowAgree {
    if (self.pb_t_de_dataModel && [NSString PB_CheckStringIsEmpty:self.pb_t_de_dataModel.unifying] == NO) {
        NSString *urlStr = PBStrFormat(self.pb_t_de_dataModel.nation);
        [PB_APP_Control pb_t_goToModuleWithJudgeTypeStr:urlStr fromVC:[PB_GetVC pb_to_getCurrentViewController]];
    }
}

#pragma mark - Lazy UI（小卡列表结构）

- (UIView *)pb_t_de_cardView {
    if (!_pb_t_de_cardView) {
        _pb_t_de_cardView = [PB_UI pb_creat_ViewWithFrame:CGRectZero color:UIColor.whiteColor radius:PB_Ratio(12)];
        _pb_t_de_cardView.clipsToBounds = YES;

        UIImageView *logo = [PB_UI pb_create_imageViewWhihFrame:CGRectZero imgName:@"pLogo" cornerRadius:PB_Ratio(8)];
        logo.contentMode = UIViewContentModeScaleAspectFill;
        logo.clipsToBounds = YES;
        logo.backgroundColor = PB_Color(@"#F0F0F0");

        QMUILabel *title = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"--" color:PB_Color(@"#26252A") font:[UIFont systemFontOfSize:PB_Ratio(15) weight:UIFontWeightSemibold] alignment:NSTextAlignmentLeft lines:2];

        QMUILabel *cap = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"Maximum loan amount" color:PB_Color(@"#8C8C8C") font:UIFontMake(PB_Ratio(12)) alignment:NSTextAlignmentLeft lines:2];
        cap.lineBreakMode = NSLineBreakByTruncatingTail;
        QMUILabel *amt = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"--" color:PB_Color(@"#26252A") font:[UIFont systemFontOfSize:PB_Ratio(24) weight:UIFontWeightBold] alignment:NSTextAlignmentLeft lines:1];

        UIButton *act = [UIButton buttonWithType:UIButtonTypeCustom];
        /// `lobbying`：设计稿 **115×38**，字号 11、圆角 8、左右内边距 12（内容区在固定尺寸内截断）
        act.titleLabel.font = [UIFont systemFontOfSize:PB_Ratio(11) weight:UIFontWeightSemibold];
        act.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        act.titleLabel.numberOfLines = 2;
        act.titleLabel.textAlignment = NSTextAlignmentCenter;
        [act setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        act.layer.cornerRadius = PB_Ratio(8);
        act.clipsToBounds = YES;
        act.userInteractionEnabled = NO;
        act.contentEdgeInsets = UIEdgeInsetsMake(PB_Ratio(6), PB_Ratio(12), PB_Ratio(6), PB_Ratio(12));
        UIImage *capImg = [UIImage imageNamed:@"Rect34626999"];
        if (!capImg) {
            capImg = [UIImage imageNamed:@"Rec626999"];
        }
        if (capImg) {
            CGFloat inset = capImg.size.width * 0.45;
            UIImage *res = [capImg resizableImageWithCapInsets:UIEdgeInsetsMake(0, inset, 0, inset) resizingMode:UIImageResizingModeStretch];
            [act setBackgroundImage:res forState:UIControlStateNormal];
        } else {
            act.backgroundColor = PB_Color(@"#5C4033");
        }

        UIView *amtBlock = [[UIView alloc] init];
        [amtBlock addSubview:cap];
        [amtBlock addSubview:amt];
        [cap mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
        }];
        [amt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(cap.mas_bottom).offset(PB_Ratio(4));
        }];

        QMUILabel *bl = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"" color:PB_yiBanBlackColor font:UIFontMake(11) alignment:NSTextAlignmentLeft lines:2];
        QMUILabel *br = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"" color:PB_yiBanBlackColor font:UIFontMake(11) alignment:NSTextAlignmentRight lines:2];
        bl.numberOfLines = 2;
        br.numberOfLines = 2;

        UIButton *agree = [UIButton buttonWithType:UIButtonTypeCustom];
        agree.backgroundColor = UIColor.clearColor;
        [agree setTitle:@"Loan Agreement>> " forState:UIControlStateNormal];
        agree.titleLabel.font = UIFontMake(PB_Ratio(12));
        [agree setTitleColor:PP_AppColor forState:UIControlStateNormal];
        [agree addTarget:self action:@selector(toShowAgree) forControlEvents:UIControlEventTouchUpInside];

        [_pb_t_de_cardView addSubview:logo];
        [_pb_t_de_cardView addSubview:title];
        [_pb_t_de_cardView addSubview:amtBlock];
        [_pb_t_de_cardView addSubview:act];
        [_pb_t_de_cardView addSubview:bl];
        [_pb_t_de_cardView addSubview:br];
        [_pb_t_de_cardView addSubview:agree];

        self.pb_t_de_logoImageView = logo;
        self.pb_t_de_productNameLabel = title;
        self.pb_t_de_amountCaptionLabel = cap;
        self.pb_t_de_amountLabel = amt;
        self.pb_t_de_amountBlock = amtBlock;
        self.pb_t_de_actionButton = act;
        self.pb_t_de_bottomLeftLabel = bl;
        self.pb_t_de_bottomRightLabel = br;
        self.pb_t_de_agreeButton = agree;

        CGFloat pad = PB_Ratio(12);
        CGFloat icon = PB_Ratio(40);

        [logo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(pad);
            make.top.mas_equalTo(pad);
            make.width.height.mas_equalTo(icon);
        }];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(logo.mas_right).offset(PB_Ratio(10));
            make.right.mas_lessThanOrEqualTo(_pb_t_de_cardView.mas_right).offset(-pad);
            make.centerY.mas_equalTo(logo);
        }];
        [amtBlock mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(pad);
            make.top.mas_equalTo(logo.mas_bottom).offset(PB_Ratio(10));
            make.right.mas_lessThanOrEqualTo(act.mas_left).offset(-PB_Ratio(10));
        }];
        [act mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_pb_t_de_cardView.mas_right).offset(-pad);
            make.width.mas_equalTo(PB_Ratio(115));
            make.height.mas_equalTo(PB_Ratio(38));
            make.centerY.mas_equalTo(amtBlock);
        }];
        [bl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(pad);
            make.top.mas_equalTo(amtBlock.mas_bottom).offset(PB_Ratio(10));
            make.width.mas_lessThanOrEqualTo(_pb_t_de_cardView.mas_width).multipliedBy(0.48);
        }];
        [br mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-pad);
            make.top.mas_equalTo(bl.mas_top);
            make.left.mas_greaterThanOrEqualTo(bl.mas_right).offset(PB_Ratio(8));
            make.width.mas_lessThanOrEqualTo(_pb_t_de_cardView.mas_width).multipliedBy(0.48);
        }];
        [agree mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(pad);
            make.top.mas_equalTo(bl.mas_bottom).offset(PB_Ratio(10));
            make.bottom.mas_equalTo(_pb_t_de_cardView.mas_bottom).offset(-pad);
        }];
    }
    return _pb_t_de_cardView;
}

@end
