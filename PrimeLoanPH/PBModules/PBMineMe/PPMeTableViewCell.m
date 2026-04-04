//
//  PPMeTableViewCell.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/31.
//

#import "PPMeTableViewCell.h"
#import "PPMeModel.h"

@interface PPMeTableViewCell ()

@property (nonatomic, strong) UIView *pb_t_bgView;
@property (nonatomic, strong) UIImageView *pb_t_logoImgV;
@property (nonatomic, strong) QMUILabel *pb_t_titleLabel;
@property (nonatomic, strong) UIImageView *pb_t_stateImgV;

@end

@implementation PPMeTableViewCell

- (void)pb_initUI {

    [self.contentView addSubview:self.pb_t_bgView];
    [self.pb_t_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, PB_Ratio(15), 0, PB_Ratio(15)));
    }];
    
}


- (void)pb_configWithCellData:(id)data {
    if ([data isKindOfClass:PPMeDrawModel.class]){
        PPMeDrawModel *model = (PPMeDrawModel *)data;
        [PPTools PB_loadUrl_ImageView:self.pb_t_logoImgV urlStr:PBStrFormat(model.shapes) holdImg:@"icon_ID"];
        self.pb_t_titleLabel.text = PBStrFormat(model.age);
        self.pb_t_stateImgV.image = UIImageMake(@"icon_more_gray");
    }
}

- (UIView *)pb_t_bgView {
    if(!_pb_t_bgView){
        _pb_t_bgView = [PB_UI pb_creat_ViewWithFrame:CGRectZero color:UIColor.clearColor];
        
        //
        _pb_t_logoImgV = [[UIImageView alloc] initWithImage:UIImageMake(@"icon_ID")];
        [_pb_t_bgView addSubview:self.pb_t_logoImgV];
        //
        _pb_t_titleLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"" color:PB_Color(@"#262626") font:UIFontMake(PB_Ratio(16)) alignment:NSTextAlignmentLeft lines:1];
        [_pb_t_bgView addSubview:self.pb_t_titleLabel];
        //
        _pb_t_stateImgV = [[UIImageView alloc] initWithImage:UIImageMake(@"icon_more_gray")];
        [_pb_t_bgView addSubview:self.pb_t_stateImgV];
        
        [self.pb_t_logoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(PB_Ratio(30));
            make.top.mas_equalTo(PB_Ratio(18));
            make.width.height.mas_equalTo(PB_Ratio(44));
        }];
        self.pb_t_titleLabel.preferredMaxLayoutWidth = PB_SW - PB_Ratio(153);
        [self.pb_t_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.pb_t_logoImgV.mas_right).offset(PB_Ratio(15));
            make.centerY.mas_equalTo(self.pb_t_logoImgV);
        }];
        [self.pb_t_stateImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-PB_Ratio(15));
            make.centerY.mas_equalTo(self.pb_t_logoImgV);
            make.width.mas_equalTo(PB_Ratio(24));
            make.height.mas_equalTo(PB_Ratio(24));
        }];
    }
    return _pb_t_bgView;
}




@end
