//
//  PPVeCardTypeOptionCell.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/11/9.
//

#import "PPVeCardTypeOptionCell.h"

@interface PPVeCardTypeOptionCell ()

@property (nonatomic, strong) UIView *pb_t_de_bgView;
@property (nonatomic, assign) QMUILabel *pb_t_de_nameLabel;
@property (nonatomic, strong) UIView *pb_t_de_radioOuter;
@property (nonatomic, strong) UIView *pb_t_de_radioInner;

@end

@implementation PPVeCardTypeOptionCell

- (void)pb_initUI {
    self.contentView.backgroundColor = PB_BgColor;
    [self.contentView addSubview:self.pb_t_de_bgView];
    [self.pb_t_de_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, PB_Ratio(15), 0, PB_Ratio(15)));
    }];
}

- (void)pb_configWithCellData:(id)data {
    [self pb_configWithCellData:data selected:NO];
}

- (void)pb_configWithCellData:(id)data selected:(BOOL)selected {
    if([data isKindOfClass:NSString.class]){
        NSString *value = PBStrFormat(data);
        self.pb_t_de_nameLabel.text = value;
    }
    self.pb_t_de_radioOuter.layer.borderColor = (selected ? PB_Color(@"#FB6E21") : PB_Color(@"#CFCFCF")).CGColor;
    self.pb_t_de_radioInner.hidden = !selected;
}


- (UIView *)pb_t_de_bgView {
    if(!_pb_t_de_bgView){
        _pb_t_de_bgView = [[UIView alloc] init];
        _pb_t_de_bgView.backgroundColor = PB_WhiteColor;
        _pb_t_de_bgView.layer.cornerRadius = PB_Ratio(10);
        QMUILabel *pb_t_de_nameLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"--" color:PB_Color(@"#262626") font:UIFontMake(PB_Ratio(16)) alignment:NSTextAlignmentLeft lines:1];
        [_pb_t_de_bgView addSubview:pb_t_de_nameLabel];
        _pb_t_de_nameLabel = pb_t_de_nameLabel;

        _pb_t_de_radioOuter = [[UIView alloc] init];
        _pb_t_de_radioOuter.backgroundColor = UIColor.clearColor;
        _pb_t_de_radioOuter.layer.cornerRadius = PB_Ratio(8);
        _pb_t_de_radioOuter.layer.borderWidth = PB_Ratio(1.5);
        _pb_t_de_radioOuter.layer.borderColor = PB_Color(@"#CFCFCF").CGColor;
        [_pb_t_de_bgView addSubview:_pb_t_de_radioOuter];
        _pb_t_de_radioInner = [[UIView alloc] init];
        _pb_t_de_radioInner.backgroundColor = PB_Color(@"#FB6E21");
        _pb_t_de_radioInner.layer.cornerRadius = PB_Ratio(4);
        [_pb_t_de_radioOuter addSubview:_pb_t_de_radioInner];
        _pb_t_de_radioInner.hidden = YES;
        pb_t_de_nameLabel.preferredMaxLayoutWidth = PB_SW - 150;
        [pb_t_de_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(PB_Ratio(16));
            make.centerY.mas_equalTo(0);
        }];
        [_pb_t_de_radioOuter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-PB_Ratio(16));
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(PB_Ratio(16));
        }];
        [_pb_t_de_radioInner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.width.height.mas_equalTo(PB_Ratio(8));
        }];
    }
    return _pb_t_de_bgView;
}


@end
