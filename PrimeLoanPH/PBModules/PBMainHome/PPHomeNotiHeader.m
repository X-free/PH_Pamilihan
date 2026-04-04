//
//  PPHomeNotiHeader.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/30.
//

#import "PPHomeNotiHeader.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "PPHomeModel.h"

@interface PPHomeNotiHeader ()

@property (nonatomic, strong) UIView *pb_t_cardView;
@property (nonatomic, strong) SDCycleScrollView *pb_t_cycleScrollView;


@end

@implementation PPHomeNotiHeader

- (void)pb_initUI {
    self.contentView.backgroundColor = PB_HomeBackColor;
    [self.contentView addSubview:self.pb_t_cardView];
    [self.pb_t_cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(PB_Ratio(14), PB_Ratio(15), PB_Ratio(14), PB_Ratio(15)));
    }];
}

- (void)pb_confWithSectionData:(id)data {
    if([data isKindOfClass:[PPHomeModel class]])
    {
        PPHomeModel *model = (PPHomeModel *)data;
        if(model.theoretical.finding && model.theoretical.finding.count > 0){
            self.pb_t_cycleScrollView.titlesGroup = model.theoretical.finding;
        }
    }}

- (UIView *)pb_t_cardView {
    if(!_pb_t_cardView){
        _pb_t_cardView = [PB_UI pb_creat_ViewWithFrame:CGRectZero color:PB_WhiteColor radius:PB_Ratio(12)];
        //
        UIImageView *pLogoV = [[UIImageView alloc] initWithImage:UIImageMake(@"home_notice")];
        //
        [_pb_t_cardView addSubview:pLogoV];
        [pLogoV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(PB_Ratio(16));
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(PB_Ratio(24));
        }];
        [_pb_t_cardView addSubview:self.pb_t_cycleScrollView];
        [self.pb_t_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, PB_Ratio(40), 0, PB_Ratio(17)));
        }];
        
    }
    return _pb_t_cardView;
}

- (SDCycleScrollView *)pb_t_cycleScrollView{
    if(!_pb_t_cycleScrollView){
        _pb_t_cycleScrollView = [[SDCycleScrollView alloc] init];
        _pb_t_cycleScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
        _pb_t_cycleScrollView.onlyDisplayText = YES;
        _pb_t_cycleScrollView.autoScroll = YES;
        _pb_t_cycleScrollView.autoScrollTimeInterval = 4;
        _pb_t_cycleScrollView.showPageControl = NO;
        [_pb_t_cycleScrollView disableScrollGesture];
        NSArray *titles = @[];
        _pb_t_cycleScrollView.titleLabelHeight = PB_Ratio(40);
        _pb_t_cycleScrollView.titleLabelTextFont = UIFontMake(PB_Ratio(14));
        _pb_t_cycleScrollView.titleLabelTextColor = PB_shenBlackColor;
        _pb_t_cycleScrollView.titleLabelBackgroundColor = UIColor.clearColor;
        _pb_t_cycleScrollView.titleLabelTextAlignment = NSTextAlignmentLeft;
        _pb_t_cycleScrollView.titlesGroup = titles;
        _pb_t_cycleScrollView.backgroundColor = UIColor.clearColor;
    }
    return _pb_t_cycleScrollView;
}



@end


