//
//  PPVeCardTableViewCell.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/11/2.
//

#import "PPVeCardTableViewCell.h"

@interface PPVeCardTableViewCell ()

@property (nonatomic, strong) UIImageView *pb_t_de_pCardImgV;
@property (nonatomic, strong) QMUIButton *pb_t_de_pStateButton;
@property (nonatomic, strong) UIView *pb_t_de_pBgView;

@end

@implementation PPVeCardTableViewCell



- (void)pb_initUI {
    self.contentView.backgroundColor = PB_BgColor;
    [self.contentView addSubview:self.pb_t_de_pBgView];
    [self.pb_t_de_pBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, PB_Ratio(15), 0, PB_Ratio(15)));
    }];
}

-  (void)pb_configWithCellData:(id)data indexPath:(nonnull NSIndexPath *)indexPath{
    if([data isKindOfClass:NSString.class]){
        if(indexPath.section == 0){
            if([NSString PB_CheckStringIsEmpty:data]){
                self.pb_t_de_pCardImgV.image = UIImageMake(@"PRC");
                self.pb_t_de_pStateButton.selected = NO;
            }else{
                [PPTools PB_loadUrl_ImageView:self.pb_t_de_pCardImgV urlStr:PBStrFormat(data) holdImg:@"PRC"];
                self.pb_t_de_pStateButton.selected = YES;
            }
        }else{
            if([NSString PB_CheckStringIsEmpty:data]){
                self.pb_t_de_pCardImgV.image = UIImageMake(@"Face recognition");
                self.pb_t_de_pStateButton.selected = NO;
            }else{
                [PPTools PB_loadUrl_ImageView:self.pb_t_de_pCardImgV urlStr:PBStrFormat(data) holdImg:@"Face recognition"];
                self.pb_t_de_pStateButton.selected = YES;
            }
        }
       
    }
}


- (UIView *)pb_t_de_pBgView {
    if(!_pb_t_de_pBgView){
        _pb_t_de_pBgView = [PB_UI pb_creat_ViewWithFrame:CGRectZero color:PB_WhiteColor radius:PB_Ratio(12)];
        _pb_t_de_pCardImgV = [PB_UI pb_create_imageViewWhihFrame:CGRectZero imgName:@"PRC" cornerRadius:PB_Ratio(10)];
        _pb_t_de_pCardImgV.contentMode = UIViewContentModeScaleAspectFill;
        
        _pb_t_de_pStateButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
        _pb_t_de_pStateButton.backgroundColor = UIColor.clearColor ;
        [_pb_t_de_pStateButton setTitle:@"Upload" forState:UIControlStateNormal];
        _pb_t_de_pStateButton.titleLabel.font = UIFontMediumMake(PB_Ratio(15));
        [_pb_t_de_pStateButton setTitleColor:PP_AppColor forState:UIControlStateNormal];
        [_pb_t_de_pStateButton setImagePosition:QMUIButtonImagePositionRight];
        [_pb_t_de_pStateButton addTarget:self action:@selector(nullAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_pb_t_de_pStateButton setImage:UIImageMake(@"icon_more_blue") forState:UIControlStateNormal];
        
        [_pb_t_de_pStateButton setTitle:@"Completed" forState:UIControlStateSelected];
        [_pb_t_de_pStateButton setImage:UIImageMake(@"icon_completed") forState:UIControlStateSelected];
        [_pb_t_de_pStateButton setTitleColor:PB_AlphaColor(@"#000000", 0.2f) forState:UIControlStateSelected];
        _pb_t_de_pStateButton.userInteractionEnabled = NO;
        
        [_pb_t_de_pBgView addSubview:self.pb_t_de_pCardImgV];
        [_pb_t_de_pBgView addSubview:self.pb_t_de_pStateButton];
        [self.pb_t_de_pCardImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(PB_Ratio(15));
            make.top.mas_equalTo(PB_Ratio(12));
            make.bottom.mas_offset(-PB_Ratio(12));
            make.width.mas_equalTo(PB_Ratio(118));
        }];
        [self.pb_t_de_pStateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_offset(-PB_Ratio(14));
        }];
        
    }
    return _pb_t_de_pBgView;
}

- (void)nullAction{
    
}

@end
