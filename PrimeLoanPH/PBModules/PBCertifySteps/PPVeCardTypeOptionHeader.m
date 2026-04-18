//
//  PPVeCardTypeOptionHeader.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/11/9.
//

#import "PPVeCardTypeOptionHeader.h"

@interface PPVeCardTypeOptionHeader ()

@property (nonatomic, strong) UIView *pb_t_de_bgView;
@property (nonatomic, assign) UIImageView *pb_t_de_moreImgVI;

@end

@implementation PPVeCardTypeOptionHeader


- (void)pb_initUI {
    self.contentView.backgroundColor = PB_Color(@"#FFFFFF");
    [self.contentView addSubview:self.pb_t_de_bgView];
    [self.pb_t_de_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)pb_confWithSectionData:(id)data {
    if([data isKindOfClass:NSString.class]){
        NSString *value = PBStrFormat(data);
        if([value isEqualToString:@"1"]){
            self.pb_t_de_bgView.backgroundColor = UIColor.clearColor;
            self.pb_t_de_moreImgVI.image = UIImageMake(@"FrameUp");
        }else{
            self.pb_t_de_bgView.backgroundColor = UIColor.clearColor;
            self.pb_t_de_moreImgVI.image = UIImageMake(@"FrameDown");
        }
    }
}


- (UIView *)pb_t_de_bgView {
    if(!_pb_t_de_bgView){
        _pb_t_de_bgView = [[UIView alloc] init];
        _pb_t_de_bgView.backgroundColor = UIColor.clearColor;
        QMUILabel *pb_t_nameLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"Other ID Type" color:[UIColor blackColor] font:UIFontBoldMake(PB_Ratio(16)) alignment:NSTextAlignmentLeft lines:1];
        [_pb_t_de_bgView addSubview:pb_t_nameLabel];
        UIImageView *pb_t_de_moreImgVI = [[UIImageView alloc] initWithImage:UIImageMake(@"FrameDown")];
        [_pb_t_de_bgView addSubview:pb_t_de_moreImgVI];
        pb_t_nameLabel.preferredMaxLayoutWidth = PB_SW - 150;
        [pb_t_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(PB_Ratio(16));
            make.centerY.mas_equalTo(0);
        }];
        [pb_t_de_moreImgVI mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-PB_Ratio(16));
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(PB_Ratio(20));
        }];
        _pb_t_de_moreImgVI = pb_t_de_moreImgVI;
        [_pb_t_de_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pb_t_de_bgViewTap)]];
    }
    return _pb_t_de_bgView;
}

- (void)pb_t_de_bgViewTap{
    if(self.delegate && [self.delegate respondsToSelector:@selector(pb_t_VeCardTypeOptionHeaderTap_de)]){
        [self.delegate pb_t_VeCardTypeOptionHeaderTap_de];
    }
}


@end
