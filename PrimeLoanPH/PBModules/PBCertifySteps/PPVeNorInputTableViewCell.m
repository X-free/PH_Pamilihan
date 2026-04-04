//
//  PPVeNorInputTableViewCell.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/11/4.
//

#import "PPVeNorInputTableViewCell.h"
#import "PPVeNorInfoModel.h"
#import "PPVeContactModel.h"

@interface PPVeNorInputTableViewCell ()<QMUITextFieldDelegate>

@property (nonatomic, strong) UIView *pb_t_de_bgView;
@property (nonatomic, strong) QMUILabel *pb_t_de_nameLabel;
@property (nonatomic, strong) QMUITextField *pb_t_de_inputTextField;
@property (nonatomic, strong) UIImageView *pb_t_de_arrowImageView;
@property (nonatomic, strong) PPVeNorInfoMceachronModel *model;
@property (nonatomic, copy) NSString *key;//code

@end



@implementation PPVeNorInputTableViewCell

- (void)pb_initUI {
    self.contentView.backgroundColor = UIColor.clearColor;
    self.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.pb_t_de_bgView];
    [self.pb_t_de_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(PB_Ratio(15), PB_Ratio(35), 0, PB_Ratio(35)));
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
    }
}

///联系人
- (void)pb_configWithCellData:(id)data index:(NSInteger)index {
    if([data isKindOfClass:[PPVeContactIntegrationistModel class]]){
        PPVeContactIntegrationistModel *model = (PPVeContactIntegrationistModel *)data;

        NSString *pleaeSelect = @"Please select";
        self.pb_t_de_nameLabel.text = @"";
        self.pb_t_de_inputTextField.text = @"";
        self.pb_t_de_inputTextField.placeholder = pleaeSelect;
        self.pb_t_de_inputTextField.userInteractionEnabled = NO;
        self.pb_t_de_arrowImageView.hidden = NO;
        if(index == 0){
            self.pb_t_de_nameLabel.text = @"Relationship";
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
            self.pb_t_de_nameLabel.text = @"Phone number";
            NSString *name_phone = @"";
            NSLog(@"%@%@",model.celebrating,model.openly);
            if(![NSString PB_CheckStringIsEmpty:model.openly]){
                name_phone = [NSString stringWithFormat:@"%@ %@",model.celebrating,model.openly];
            }
            self.pb_t_de_inputTextField.text = name_phone;
        }

    }

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
            make.width.mas_lessThanOrEqualTo(PB_SW - PB_Ratio(35)*2);
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


- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self endEditing:YES];
    NSString *value = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(self.delegate && [self.delegate respondsToSelector:@selector(pPVeNorInputTableViewCellEndInput:key:)]){
        [self.delegate pPVeNorInputTableViewCellEndInput:value key:self.key];
    }
}


@end
