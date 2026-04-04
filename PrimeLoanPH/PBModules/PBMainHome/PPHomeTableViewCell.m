//
//  PPHomeTableViewCell.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/30.
//

#import "PPHomeTableViewCell.h"

@interface PPHomeTableViewCell ()


@end

@implementation PPHomeTableViewCell

- (void)pb_initUI {
    self.contentView.backgroundColor = PB_Color(@"#F4F5F9");
    UIImageView *pb_t_v1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 1171276127"]];
    [self.contentView addSubview:pb_t_v1];
    
    UIImageView *pb_t_v2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 1171276128"]];
    [self.contentView addSubview:pb_t_v2];
    
    [pb_t_v1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(PB_Ratio(15));
        make.height.mas_equalTo(PB_Ratio(87));
        make.width.mas_equalTo((SCREEN_WIDTH - PB_Ratio(15)*3)/2);
    }];
    [pb_t_v2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_offset(-PB_Ratio(15));
        make.width.height.mas_equalTo(pb_t_v1);
        
    }];
    
    pb_t_v1.userInteractionEnabled = YES;
    [pb_t_v1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1)]];
    
    pb_t_v2.userInteractionEnabled = YES;
    [pb_t_v2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2)]];
    
    

}

- (void)tap1{
    if(self.delegate && [self.delegate respondsToSelector:@selector(PPHomeTableViewCellTapTag:)]){
        [self.delegate PPHomeTableViewCellTapTag:1];
    }
}

- (void)tap2{
    if(self.delegate && [self.delegate respondsToSelector:@selector(PPHomeTableViewCellTapTag:)]){
        [self.delegate PPHomeTableViewCellTapTag:2];
    }
}




@end
