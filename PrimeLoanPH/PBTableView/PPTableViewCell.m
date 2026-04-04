//
//  PPTableViewCell.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/27.
//

#import "PPTableViewCell.h"

@implementation PPTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self pb_initUI];
    }
    return self;
}

- (void)pb_initUI {
    self.contentView.backgroundColor = PB_BgColor;
}

- (void)pb_configWithCellData:(id)data {
    
}


@end
