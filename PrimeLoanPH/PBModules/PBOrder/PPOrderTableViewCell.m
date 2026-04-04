//
//  PPOrderTableViewCell.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/31.
//

#import "PPOrderTableViewCell.h"
#import "PPOrderModel.h"

@interface PPOrderTableViewCell ()

@property (nonatomic, strong) UIView *pb_t_de_cardView;
@property (nonatomic, assign) UIImageView *pb_t_de_logoImageView;
@property (nonatomic, strong) QMUILabel *pb_t_de_productNameLabel;
@property (nonatomic, strong) QMUILabel *pb_t_de_stateLabel;

@property (nonatomic, strong) NSMutableArray <QMUILabel *>*pb_t_de_nameLabels;
@property (nonatomic, strong) NSMutableArray <QMUILabel *>*pb_t_de_valueLabels;

@property (nonatomic, strong) UIButton *pb_t_de_agreeButton;

@property (nonatomic, strong) PPOrderDrawModel *pb_t_de_dataModel;

@property (nonatomic, assign) QMUILabel *pb_t_de_amountLabel;

@end

@implementation PPOrderTableViewCell

- (void)pb_initUI {
    self.pb_t_de_nameLabels = NSMutableArray.new;
    self.pb_t_de_valueLabels = NSMutableArray.new;
    self.contentView.backgroundColor = UIColor.clearColor;
    self.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.pb_t_de_cardView];
    [self.pb_t_de_cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(PB_Ratio(8),PB_Ratio(20),PB_Ratio(8),PB_Ratio(20)));
    }];
}

- (void)pb_configWithCellData:(id)data {
    if([data isKindOfClass:PPOrderDrawModel.class]){
        PPOrderDrawModel *model = (PPOrderDrawModel *)data;
        self.pb_t_de_dataModel = model;
        [PPTools PB_loadUrl_ImageView:self.pb_t_de_logoImageView urlStr:model.networks holdImg:@"pLogo"];
        self.pb_t_de_productNameLabel.text = PBStrFormat(model.courses);
        self.pb_t_de_amountLabel.text = PBStrFormat(model.constructed);
        self.pb_t_de_stateLabel.text = PBStrFormat(model.lobbying);
        for (NSInteger i = 0; i < model.interpreted.count; i++) {
            PPOrderInterpretedModel *itemModel = model.interpreted[i];
            if(self.pb_t_de_nameLabels.count >= model.interpreted.count){
                self.pb_t_de_nameLabels[i].text = PBStrFormat(itemModel.age);
                self.pb_t_de_valueLabels[i].text = PBStrFormat(itemModel.challenges);
            }
        }
        for(NSInteger i = 0; i < self.pb_t_de_nameLabels.count;i++){
            if(i < model.interpreted.count){
                self.pb_t_de_nameLabels[i].hidden = NO;
                self.pb_t_de_valueLabels[i].hidden = NO;
            }else{
                self.pb_t_de_nameLabels[i].hidden = YES;
                self.pb_t_de_valueLabels[i].hidden = YES;
            }
        }
        
        if([NSString PB_CheckStringIsEmpty:model.unifying]){
            self.pb_t_de_agreeButton.hidden = YES;
        }else{
            self.pb_t_de_agreeButton.hidden = NO;
        }
    }
}

- (UIView *)pb_t_de_cardView {
    if(!_pb_t_de_cardView){
        _pb_t_de_cardView = [PB_UI pb_creat_ViewWithFrame:CGRectZero color:PB_WhiteColor radius:PB_Ratio(16)];
        //
        UIImageView *pb_t_de_logoImageView = [PB_UI pb_create_imageViewWhihFrame:CGRectZero imgName:@"app_logo" cornerRadius:PB_Ratio(4)];
        QMUILabel *pb_t_de_productNameLabel =  [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"--" color:PB_yiBanBlackColor font:UIFontBoldMake(PB_Ratio(15)) alignment:NSTextAlignmentLeft lines:1];
        QMUILabel *pb_t_de_amountLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"--" color:PB_yiBanBlackColor font:UIFontBoldMake(PB_Ratio(20)) alignment:NSTextAlignmentLeft lines:1];
        QMUILabel *pb_t_de_stateLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"--" color:PB_WhiteColor font:UIFontMediumMake(13) alignment:NSTextAlignmentLeft lines:1];
        
        pb_t_de_stateLabel.layer.cornerRadius = PB_Ratio(10);
        pb_t_de_stateLabel.layer.masksToBounds = YES;
        pb_t_de_stateLabel.backgroundColor = PP_AppColor;
        pb_t_de_stateLabel.contentEdgeInsets = UIEdgeInsetsMake(2, 6, 2, 6);
        //【注】协议内容为空是不显示
        UIButton *pb_t_de_agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pb_t_de_agreeButton.backgroundColor = UIColor.clearColor;
        [pb_t_de_agreeButton setTitle:@"Loan Agreement>> " forState:UIControlStateNormal];
        pb_t_de_agreeButton.titleLabel.font = UIFontMake(PB_Ratio(12));
        [pb_t_de_agreeButton setTitleColor:PP_AppColor forState:UIControlStateNormal];
        [pb_t_de_agreeButton addTarget:self action:@selector(toShowAgree) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_pb_t_de_cardView addSubview:pb_t_de_logoImageView];
        [_pb_t_de_cardView addSubview:pb_t_de_productNameLabel];
        [_pb_t_de_cardView addSubview:pb_t_de_amountLabel];
        [_pb_t_de_cardView addSubview:pb_t_de_stateLabel];
        [_pb_t_de_cardView addSubview:pb_t_de_agreeButton];
        _pb_t_de_amountLabel = pb_t_de_amountLabel;
        
        [pb_t_de_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(PB_Ratio(16));
            make.top.mas_equalTo(PB_Ratio(30));
            make.width.height.mas_equalTo(PB_Ratio(46));
        }];
        pb_t_de_productNameLabel.preferredMaxLayoutWidth = PB_Ratio(180);
        [pb_t_de_productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(pb_t_de_logoImageView.mas_right).offset(PB_Ratio(12));
            make.bottom.mas_equalTo(pb_t_de_logoImageView.mas_bottom).offset(-PB_Ratio(25));
        }];
        [pb_t_de_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(pb_t_de_productNameLabel);
            make.top.mas_equalTo(pb_t_de_productNameLabel.mas_bottom).offset(PB_Ratio(2));
        }];
        pb_t_de_stateLabel.preferredMaxLayoutWidth = PB_Ratio(100);
        [pb_t_de_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-PB_Ratio(12));
            make.centerY.mas_equalTo(pb_t_de_logoImageView).offset(-PB_Ratio(33));
            make.height.mas_equalTo(PB_Ratio(25));
        }];
        
        static QMUILabel *recordLabel;recordLabel = nil;
        for (NSInteger i = 0; i < 20; i++) {
            QMUILabel *nameLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"--" color:PB_morenHoldColor font:UIFontMake(14) alignment:NSTextAlignmentLeft lines:1];
            QMUILabel *valueLabel = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"--" color:PB_yiBanBlackColor font:UIFontBoldMake(14) alignment:NSTextAlignmentLeft lines:1];
            [_pb_t_de_cardView addSubview:nameLabel];
            [_pb_t_de_cardView addSubview:valueLabel];
            nameLabel.preferredMaxLayoutWidth = PB_SW *2/5.0;
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(pb_t_de_logoImageView);
                if(i == 0){
                    make.top.mas_equalTo(pb_t_de_logoImageView.mas_bottom).offset(PB_Ratio(14));
                }else{
                    make.top.mas_equalTo(recordLabel.mas_bottom).offset(PB_Ratio(14));
                }
            }];
            [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(10 + PB_SW*1/3.0);
                make.centerY.mas_equalTo(nameLabel);
            }];
            recordLabel = nameLabel;
            nameLabel.hidden = YES;
            valueLabel.hidden = YES;
            [self.pb_t_de_nameLabels addObject:nameLabel];
            [self.pb_t_de_valueLabels addObject:valueLabel];
        }
        
        [pb_t_de_agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(pb_t_de_logoImageView);
            make.bottom.mas_offset(-PB_Ratio(20));
        }];

        self.pb_t_de_logoImageView = pb_t_de_logoImageView;
        self.pb_t_de_productNameLabel = pb_t_de_productNameLabel;
        self.pb_t_de_stateLabel = pb_t_de_stateLabel;
        self.pb_t_de_agreeButton = pb_t_de_agreeButton;
    }
    return _pb_t_de_cardView;
}

- (void)toShowAgree {
    if(self.pb_t_de_dataModel && [NSString PB_CheckStringIsEmpty:self.pb_t_de_dataModel.unifying]== NO){
        NSString *urlStr = PBStrFormat(self.pb_t_de_dataModel.nation);
        [PB_APP_Control pb_t_goToModuleWithJudgeTypeStr:urlStr fromVC:[PB_GetVC pb_to_getCurrentViewController]];
    }
}

@end
