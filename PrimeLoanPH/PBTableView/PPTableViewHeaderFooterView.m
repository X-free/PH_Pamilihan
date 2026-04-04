//
//  PPTableViewHeaderFooterView.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/27.
//

#import "PPTableViewHeaderFooterView.h"

@interface PPTableViewHeaderFooterView ()


@end

@implementation PPTableViewHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self pb_initUI];
    }
    return self;
}

- (void)pb_initUI {
    self.contentView.backgroundColor = [UIColor whiteColor];

}

- (void)pb_confWithSectionData:(id)data {
    
}


@end
