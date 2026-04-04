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
    if([data isKindOfClass:NSString.class]){
        NSString *value = PBStrFormat(data);
        self.pb_t_de_nameLabel.text = value;
    }
}


- (UIView *)pb_t_de_bgView {
    if(!_pb_t_de_bgView){
        _pb_t_de_bgView = [[UIView alloc] init];
        _pb_t_de_bgView.backgroundColor = PB_WhiteColor;
        _pb_t_de_bgView.layer.cornerRadius = PB_Ratio(10);
        QMUILabel *pb_t_de_nameLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"--" color:PB_Color(@"#262626") font:UIFontMake(PB_Ratio(16)) alignment:NSTextAlignmentLeft lines:1];
        [_pb_t_de_bgView addSubview:pb_t_de_nameLabel];
        _pb_t_de_nameLabel = pb_t_de_nameLabel;
        UIImageView *moreImgVI = [[UIImageView alloc] initWithImage:UIImageMake(@"icon_more_gray")];
        [_pb_t_de_bgView addSubview:moreImgVI];
        pb_t_de_nameLabel.preferredMaxLayoutWidth = PB_SW - 150;
        [pb_t_de_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(PB_Ratio(16));
            make.centerY.mas_equalTo(0);
        }];
        [moreImgVI mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-PB_Ratio(16));
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(PB_Ratio(20));
        }];
    }
    return _pb_t_de_bgView;
}


@end
