//
//  PPVeContactHrader.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/11/6.
//

#import "PPVeContactHrader.h"

@interface PPVeContactHrader ()

@property (nonatomic, strong) UIView *pb_t_de_orangeBar;
@property (nonatomic, strong) QMUILabel *pb_t_de_nameLabel;

@end

@implementation PPVeContactHrader

- (void)pb_initUI {
    self.backgroundColor = UIColor.clearColor;
    self.clipsToBounds = NO;
    self.contentView.backgroundColor = UIColor.clearColor;
    self.contentView.clipsToBounds = NO;

    self.pb_t_de_orangeBar = [[UIView alloc] init];
    self.pb_t_de_orangeBar.backgroundColor = PB_Color(@"#FB6E21");
    self.pb_t_de_orangeBar.layer.cornerRadius = PB_Ratio(12);
    self.pb_t_de_orangeBar.layer.masksToBounds = YES;
    if (@available(iOS 11.0, *)) {
        self.pb_t_de_orangeBar.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    }
    [self.contentView addSubview:self.pb_t_de_orangeBar];
    [self.pb_t_de_orangeBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PB_Ratio(15));
        make.right.mas_equalTo(-PB_Ratio(56));
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(PB_Ratio(68));
    }];

    [self.pb_t_de_orangeBar addSubview:self.pb_t_de_nameLabel];
    [self.pb_t_de_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PB_Ratio(14));
        make.top.mas_equalTo(PB_Ratio(9));
        make.right.mas_lessThanOrEqualTo(-PB_Ratio(12));
    }];
}

- (void)pb_confWithSectionData:(id)data{
    if([data isKindOfClass:NSString.class]){
        self.pb_t_de_nameLabel.text = (NSString *)data;
    }
}

- (QMUILabel *)pb_t_de_nameLabel {
    if(!_pb_t_de_nameLabel){
        _pb_t_de_nameLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@" " color:PB_WhiteColor font:UIFontBoldMake(PB_Ratio(16)) alignment:NSTextAlignmentLeft lines:1];
        _pb_t_de_nameLabel.alpha = 1.0;
    }
    return _pb_t_de_nameLabel;
}

@end
