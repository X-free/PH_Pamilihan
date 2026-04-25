//
//  PPVeNorInputTableViewCell.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/11/4.
//

#import "PPVeNorInputTableViewCell.h"
#import "PPVeNorInfoModel.h"
#import "PPVeContactModel.h"

static NSString *PBPBContactCopyMerge(NSString * _Nullable fromItem, NSString * _Nullable fromTheo, NSString *def) {
    if (fromItem != nil && [NSString PB_CheckStringIsEmpty:fromItem] == NO) {
        return PBStrFormat(fromItem);
    }
    if (fromTheo != nil && [NSString PB_CheckStringIsEmpty:fromTheo] == NO) {
        return PBStrFormat(fromTheo);
    }
    return def;
}

@interface PPVeNorInputTableViewCell ()<QMUITextFieldDelegate>

@property (nonatomic, strong) UIView *pb_t_de_bgView;
@property (nonatomic, strong) QMUILabel *pb_t_de_nameLabel;
@property (nonatomic, strong) QMUITextField *pb_t_de_inputTextField;
@property (nonatomic, strong) UIImageView *pb_t_de_arrowImageView;
@property (nonatomic, strong) PPVeNorInfoMceachronModel *model;
@property (nonatomic, copy) NSString *key;//code
@property (nonatomic, strong) UIView *pb_t_de_contactOrangeBar;
@property (nonatomic, strong) QMUILabel *pb_t_de_contactOrangeTitleLabel;
/// 设计稿：白卡片叠在橘条上（z 轴在上），与橘条约 22pt 重叠
@property (nonatomic, strong) UIView *pb_t_de_contactWhiteCard;

@end



@implementation PPVeNorInputTableViewCell

- (void)pb_initUI {
    self.contentView.backgroundColor = UIColor.clearColor;
    self.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.pb_t_de_bgView];
    [self.pb_t_de_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(PB_Ratio(15), PB_Ratio(15), 0, PB_Ratio(15)));
    }];
}

- (void)pb_configWithCellData:(id)data{
    if([data isKindOfClass:PPVeNorInfoMceachronModel.class]){
        //        '"blair":"enum"', sea
        //        '"blair":"txt"',  seb
        //        '"blair":"citySelect"', sec
        self.model = (PPVeNorInfoMceachronModel *)data;
        self.pb_t_de_nameLabel.text = PBStrFormat(self.model.age);
        self.pb_t_de_inputTextField.text = @"";
        NSString *pleaseEnter = @"Enter text...";
        NSString *pleaeSelect = @"Please select";
        if([NSString PB_CheckStringIsEmpty:self.model.importance] == NO){
            pleaseEnter = PBStrFormat(self.model.importance);
            pleaeSelect = PBStrFormat(self.model.importance);
        }
        NSString *type = PBStrFormat(self.model.blair);
        if([type isEqualToString:@"sea"]){
            self.pb_t_de_inputTextField.placeholder = pleaseEnter;
        }else{
            self.pb_t_de_inputTextField.placeholder = pleaeSelect;
        }

        self.pb_t_de_inputTextField.userInteractionEnabled = YES;
        self.pb_t_de_arrowImageView.hidden = YES;
        self.pb_t_de_inputTextField.keyboardType = UIKeyboardTypeDefault;

        self.key = PBStrFormat(self.model.defines);
       
        if(self.model.underachieving == 1){//使用数字键盘
            self.pb_t_de_inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        }
        if([type isEqualToString:@"sea"] || [type isEqualToString:@"sec"]){
            self.pb_t_de_inputTextField.userInteractionEnabled = NO;
            self.pb_t_de_arrowImageView.hidden = NO;
        }else if ( [type isEqualToString:@"sec"]){
         
        }
        self.pb_t_de_inputTextField.text = PBStrFormat(self.model.stemming);//取值
        self.pb_t_de_inputTextField.backgroundColor = PB_WhiteColor;
        self.pb_t_de_inputTextField.layer.borderWidth = PB_Ratio(1);
        self.pb_t_de_inputTextField.layer.cornerRadius = PB_Ratio(16);
        if (self.pb_t_de_contactOrangeBar) {
            self.pb_t_de_contactOrangeBar.hidden = YES;
        }
        if (self.pb_t_de_contactWhiteCard) {
            self.pb_t_de_contactWhiteCard.hidden = YES;
        }
        if (self.pb_t_de_bgView.superview != self.contentView) {
            [self.pb_t_de_bgView removeFromSuperview];
            [self.contentView addSubview:self.pb_t_de_bgView];
        }
        [self.contentView bringSubviewToFront:self.pb_t_de_bgView];
        [self.pb_t_de_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(PB_Ratio(15), PB_Ratio(15), 0, PB_Ratio(15)));
        }];
    }
}

///联系人
- (void)pb_configWithCellData:(id)data index:(NSInteger)index section:(NSInteger)section {
    [self pb_configWithCellData:data index:index section:section pageCopy:nil];
}

- (void)pb_configWithCellData:(id)data index:(NSInteger)index section:(NSInteger)section pageCopy:(PPVeContactTheoreticalModel *)pageCopy {
    if([data isKindOfClass:[PPVeContactIntegrationistModel class]]){
        PPVeContactIntegrationistModel *model = (PPVeContactIntegrationistModel *)data;
        PPVeContactTheoreticalModel *p = pageCopy;
        NSString *relTitle = PBPBContactCopyMerge(model.here, p.here, @"Please choose a relationship");
        NSString *relPlaceholder = PBPBContactCopyMerge(model.communities, p.communities, @"Please select");
        NSString *phoneTitle = PBPBContactCopyMerge(model.useText, p.useText, @"Phone number");
        NSString *phonePlaceholder = PBPBContactCopyMerge(model.defining, p.defining, @"Please select");

        self.pb_t_de_nameLabel.text = @"";
        self.pb_t_de_inputTextField.text = @"";
        self.pb_t_de_inputTextField.userInteractionEnabled = NO;
        self.pb_t_de_arrowImageView.hidden = NO;
        if(index == 0){
            self.pb_t_de_nameLabel.text = relTitle;
            self.pb_t_de_inputTextField.placeholder = relPlaceholder;
            NSString *relationName = @"";
            NSArray <PPVeContactIdentifiedModel *>*optionArr = model.identified;
            for (NSInteger i = 0; i < optionArr.count; i++) {
                if([optionArr[i].reviewed isEqualToString:model.condemned]){
                    relationName = optionArr[i].celebrating;
                    break;
                }
            }
            self.pb_t_de_inputTextField.text = relationName;
        }else if (index == 1){
            self.pb_t_de_nameLabel.text = phoneTitle;
            self.pb_t_de_inputTextField.placeholder = phonePlaceholder;
            NSString *name_phone = @"";
            NSLog(@"%@%@",model.celebrating,model.openly);
            if(![NSString PB_CheckStringIsEmpty:model.openly]){
                name_phone = [NSString stringWithFormat:@"%@ %@",model.celebrating,model.openly];
            }
            self.pb_t_de_inputTextField.text = name_phone;
        }

        UIColor *fieldBg = PB_Color(@"#F5F5F5");
        self.pb_t_de_inputTextField.backgroundColor = fieldBg;
        self.pb_t_de_inputTextField.layer.borderWidth = 0;
        /// 设计稿：偏深绿灰标题字
        self.pb_t_de_nameLabel.textColor = PB_Color(@"#2F3D38");
        self.pb_t_de_inputTextField.textColor = PB_Color(@"#2F3D38");
        self.pb_t_de_inputTextField.placeholderColor = PB_Color(@"#C4C4C4");

        [self pb_t_de_ensureContactOrangeViews];
        CGFloat contactFieldH = PB_Ratio(45);
        CGFloat contactFieldRadius = MIN(PB_Ratio(12), contactFieldH / 2.0);
        self.pb_t_de_inputTextField.layer.cornerRadius = contactFieldRadius;

        if (index == 0) {
            self.pb_t_de_contactOrangeBar.hidden = NO;
            self.pb_t_de_contactWhiteCard.hidden = NO;
            self.pb_t_de_contactOrangeTitleLabel.text = [NSString stringWithFormat:@"Emergency Contact-%ld", (long)(section + 1)];
            [self pb_t_de_attachBgViewToContactWhiteCard];
            [self.contentView bringSubviewToFront:self.pb_t_de_contactWhiteCard];
            [self.contentView bringSubviewToFront:self.pb_t_de_bgView];
            CGFloat overlap = PB_Ratio(22);
            [self.pb_t_de_contactWhiteCard mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(PB_Ratio(15));
                make.right.mas_equalTo(-PB_Ratio(15));
                make.bottom.mas_equalTo(0);
                make.top.mas_equalTo(self.pb_t_de_contactOrangeBar.mas_bottom).offset(-overlap);
            }];
            [self.pb_t_de_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(PB_Ratio(5), PB_Ratio(15), PB_Ratio(5), PB_Ratio(15)));
            }];
        } else {
            self.pb_t_de_contactOrangeBar.hidden = YES;
            self.pb_t_de_contactWhiteCard.hidden = YES;
            if (self.pb_t_de_bgView.superview != self.contentView) {
                [self.pb_t_de_bgView removeFromSuperview];
                [self.contentView addSubview:self.pb_t_de_bgView];
            }
            [self.contentView bringSubviewToFront:self.pb_t_de_bgView];
            /// 与首行白卡内字段同起点与宽度：外 15 + 内 15；输入框底距 cell 底 15
            CGFloat contactInnerInset = PB_Ratio(15) + PB_Ratio(15);
            [self.pb_t_de_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(PB_Ratio(4));
                make.left.mas_equalTo(contactInnerInset);
                make.right.mas_equalTo(-contactInnerInset);
                make.bottom.mas_equalTo(-PB_Ratio(15));
            }];
        }
        [self.pb_t_de_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(PB_Ratio(6));
            make.width.mas_lessThanOrEqualTo(PB_SW - PB_Ratio(30) - PB_Ratio(30));
        }];
        [self.pb_t_de_inputTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(contactFieldH);
        }];
    }

}

- (void)prepareForReuse {
    [super prepareForReuse];
    if (self.pb_t_de_bgView.superview != self.contentView) {
        [self.pb_t_de_bgView removeFromSuperview];
        [self.contentView addSubview:self.pb_t_de_bgView];
    }
    [self pb_t_de_resetContactChromeVisibility];
}

- (void)pb_t_de_resetContactChromeVisibility {
    if (self.pb_t_de_contactOrangeBar) {
        self.pb_t_de_contactOrangeBar.hidden = YES;
    }
    if (self.pb_t_de_contactWhiteCard) {
        self.pb_t_de_contactWhiteCard.hidden = YES;
    }
}

- (void)pb_t_de_attachBgViewToContactWhiteCard {
    if (!self.pb_t_de_contactWhiteCard) {
        return;
    }
    [self.pb_t_de_bgView removeFromSuperview];
    [self.pb_t_de_contactWhiteCard addSubview:self.pb_t_de_bgView];
}

- (UIView *)pb_t_de_bgView{
    if(!_pb_t_de_bgView){
        _pb_t_de_bgView = [PB_UI pb_creat_ViewWithFrame:CGRectZero color:UIColor.clearColor];
        _pb_t_de_nameLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"--" color:PB_morenHoldColor font:UIFontMediumMake(PB_Ratio(15)) alignment:NSTextAlignmentLeft lines:1];
        _pb_t_de_inputTextField = [PB_UI pb_create_textFieldWithFrame:CGRectZero bgColor:PB_WhiteColor placeholder:@"Enter text..." textColor:PB_shenBlackColor font:UIFontMake(PB_Ratio(16)) cornerRadius:PB_Ratio(16) keyboardType:UIKeyboardTypeDefault];
        _pb_t_de_inputTextField.placeholderColor = PB_Line_1_Color;
        _pb_t_de_inputTextField.backgroundColor = PB_WhiteColor;
        _pb_t_de_inputTextField.layer.cornerRadius = PB_Ratio(16);
        _pb_t_de_inputTextField.layer.masksToBounds = YES;
        _pb_t_de_inputTextField.layer.borderWidth =PB_Ratio(1);
        _pb_t_de_inputTextField.layer.borderColor = PB_Color(@"#E8E8E8").CGColor;
        
        _pb_t_de_inputTextField.textInsets = UIEdgeInsetsMake(5, PB_Ratio(16), 5, PB_Ratio(20));
        // 字体自适应属性
        _pb_t_de_inputTextField.adjustsFontSizeToFitWidth = YES;
        // 自适应最小字体缩放比例
        _pb_t_de_inputTextField.contentScaleFactor = 0.4f;
        _pb_t_de_inputTextField.delegate = self;
        [_pb_t_de_bgView addSubview:self.pb_t_de_inputTextField];
        [_pb_t_de_bgView addSubview:self.pb_t_de_nameLabel];
        [self.pb_t_de_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(PB_Ratio(15));
            make.width.mas_lessThanOrEqualTo(PB_SW - PB_Ratio(15) - PB_Ratio(15));
        }];
        [self.pb_t_de_inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(PB_Ratio(48));
        }];
        _pb_t_de_arrowImageView = [[UIImageView alloc] initWithImage:UIImageMake(@"icon_more_gray")];
        [self.pb_t_de_inputTextField addSubview:self.pb_t_de_arrowImageView];
        self.pb_t_de_arrowImageView.hidden = YES;
        [self.pb_t_de_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-PB_Ratio(16));
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(PB_Ratio(16), PB_Ratio(16)));
        }];
    }
    return _pb_t_de_bgView;
}

- (void)pb_t_de_ensureContactOrangeViews {
    if (self.pb_t_de_contactOrangeBar) {
        return;
    }
    UIView *bar = [[UIView alloc] init];
    bar.backgroundColor = PB_Color(@"#FB6E21");
    bar.layer.cornerRadius = PB_Ratio(12);
    bar.layer.masksToBounds = YES;
    if (@available(iOS 11.0, *)) {
        bar.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    }
    self.pb_t_de_contactOrangeBar = bar;

    UIView *card = [[UIView alloc] init];
    card.backgroundColor = UIColor.whiteColor;
    card.layer.cornerRadius = PB_Ratio(12);
    card.layer.masksToBounds = YES;
    self.pb_t_de_contactWhiteCard = card;

    [self.contentView insertSubview:bar atIndex:0];
    [self.contentView insertSubview:card aboveSubview:bar];

    [bar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PB_Ratio(15));
        make.right.mas_equalTo(-PB_Ratio(56));
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(PB_Ratio(68));
    }];
    QMUILabel *lab = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@" " color:PB_WhiteColor font:UIFontBoldMake(PB_Ratio(16)) alignment:NSTextAlignmentLeft lines:1];
    self.pb_t_de_contactOrangeTitleLabel = lab;
    [bar addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PB_Ratio(14));
        make.top.mas_equalTo(PB_Ratio(9));
        make.right.mas_lessThanOrEqualTo(-PB_Ratio(12));
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self endEditing:YES];
    NSString *value = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(self.delegate && [self.delegate respondsToSelector:@selector(pPVeNorInputTableViewCellEndInput:key:)]){
        [self.delegate pPVeNorInputTableViewCellEndInput:value key:self.key];
    }
}


@end
