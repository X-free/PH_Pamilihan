//
//  PPVeContactHrader.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/11/6.
//

#import "PPVeContactHrader.h"

@interface PPVeContactHrader ()

@property (nonatomic, strong) QMUILabel *pb_t_de_nameLabel;

@end

@implementation PPVeContactHrader

- (void)pb_initUI {
    self.contentView.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.pb_t_de_nameLabel];
    [self.pb_t_de_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PB_Ratio(35));
        make.top.mas_equalTo(PB_Ratio(42));
    }];
}

- (void)pb_confWithSectionData:(id)data{
    if([data isKindOfClass:NSString.class]){
        self.pb_t_de_nameLabel.text = (NSString *)data;
    }
}

- (QMUILabel *)pb_t_de_nameLabel {
    if(!_pb_t_de_nameLabel){
        _pb_t_de_nameLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@" " color:PB_yiBanBlackColor font:UIFontBoldMake(PB_Ratio(16)) alignment:NSTextAlignmentLeft lines:1];
    }
    return _pb_t_de_nameLabel;
}



@end
