//
//  PPMeHeader.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/31.
//

#import "PPMeHeader.h"
#import "PPMeModel.h"

@interface PPMeHeader ()

@property (nonatomic, copy) void(^tapBack)(NSInteger index);
@property (nonatomic, strong) UIImageView *pb_t_cardImgV;
@property (nonatomic, assign) QMUILabel *pb_t_phoneLabel;
@property (nonatomic, assign) CGFloat pb_t_bg_height;



@end

@implementation PPMeHeader

- (instancetype)initWithTapBack:(void (^)(NSInteger))block {
    self = [super init];
    if(self){
        _tapBack = block;
        [self ppInit];
    }
    return self;
}

- (void)pp_configData:(id)data {
    if([data isKindOfClass:[PPMeModel class]])
    {
        PPMeModel *model = (PPMeModel *)data;
        if(model.theoretical.inspiring){
            PPMeInspiringModel *inspiringModel = model.theoretical.inspiring;
            //self.pNameLabel.text = PBStrFormat(inspiringModel.literature);
            self.pb_t_phoneLabel.text = PBStrFormat(inspiringModel.userphone);
        }
    }
}

- (void)ppInit {
    self.backgroundColor = PB_Color(@"#F5F5F5");
    _pb_t_bg_height = PB_SW * 260/375.0;
    self.frame = CGRectMake(0, 0, PB_SW, _pb_t_bg_height + PB_Ratio(76 + 46));
    [self addSubview:self.pb_t_cardImgV];
    
    UIImageView *pb_t_descImv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 1171276133"]];
    [self addSubview:pb_t_descImv];
    [pb_t_descImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH - PB_Ratio(15)*2);
        make.height.mas_equalTo(PB_Ratio(118));
        make.bottom.mas_offset(-PB_Ratio(46));
    }];
    
   UILabel *pb_t_nameLB = [[UILabel alloc] init];
    pb_t_nameLB.font = UIFontBoldMake(PB_Ratio(18));
    pb_t_nameLB.textColor = PB_shenBlackColor;
    pb_t_nameLB.text = @"My Services";
    [self addSubview:pb_t_nameLB];
    [pb_t_nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(PB_Ratio(15));
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(PB_Ratio(46));
    }];
}


- (UIImageView *)pb_t_cardImgV {
    if(!_pb_t_cardImgV){
        _pb_t_cardImgV = [PB_UI pb_create_imageViewWhihFrame:CGRectMake(0, 0, PB_SW, _pb_t_bg_height) imgName:@"Mask group" cornerRadius:0];
        _pb_t_cardImgV.userInteractionEnabled = YES;
        //
        UIImageView *pb_t_avaterImgV= [[UIImageView alloc] initWithImage:UIImageMake(@"icn_head")];
        //
//        QMUILabel *pNameLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@" " color:PB_WhiteColor font:UIFontBoldMake(PB_Ratio(16)) alignment:NSTextAlignmentLeft lines:1];
        //
        QMUILabel *pb_t_phoneLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@" " color:PB_WhiteColor font:UIFontBoldMake(PB_Ratio(14)) alignment:NSTextAlignmentLeft lines:1];
 

        [_pb_t_cardImgV addSubview:pb_t_avaterImgV];
        [_pb_t_cardImgV addSubview:pb_t_phoneLabel];
        _pb_t_phoneLabel = pb_t_phoneLabel;
        [pb_t_avaterImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(PB_Ratio(82));
            make.width.height.mas_equalTo(PB_Ratio(70));
        }];
        [pb_t_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(pb_t_avaterImgV.mas_bottom).offset(PB_Ratio(12));
        }];
        
        
        
    }
    return _pb_t_cardImgV;
}
//
//- (void)menuButtonAction:(QMUIButton *)button {
//    NSInteger index = button.tag - 10;
//    if(_tapBack){
//        _tapBack(index);
//    }
//}




@end
