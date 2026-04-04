//
//  PPOrderViewController.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/31.
//

#import "PPOrderViewController.h"

@interface PPOrderViewController ()

@property (nonatomic, strong)NSMutableArray *titlesArr;
@property (nonatomic, strong)NSMutableArray *classNamesArr;

@end

@implementation PPOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];

}


- (void)setUI {
    self.view.backgroundColor = PB_BgColor;
    [self setShowBackBtn:YES];
    [self setNavTitle:@"Order records"];
}

- (instancetype)init {
    self = [super init];
    if(self){
        
        
        self.titleColorSelected = PP_AppColor;
        self.titleColorNormal = PB_morenHoldColor;
        self.titleSizeNormal = PB_Ratio(15);
        self.titleSizeSelected = PB_Ratio(17);
        
        
        [self setMenuViewLayoutMode:WMMenuViewLayoutModeScatter];
        self.titleFontName = @"PingFangSC-Semibold";
        self.automaticallyCalculatesItemWidths = YES;
        [self setMenuViewStyle:WMMenuViewStyleLine];
        
   
        
        self.keys = @[@"keyId", @"keyId", @"keyId", @"keyId"].mutableCopy;
        self.values = @[@(4),@(7),@(6),@(5)].mutableCopy;
        self.classNamesArr = @[@"PPSubOrderViewController",  @"PPSubOrderViewController",@"PPSubOrderViewController",@"PPSubOrderViewController"].mutableCopy;
        self.titlesArr = @[@"All",@"Applying", @"Repayment",@"Finished" ].mutableCopy;
        
        self.progressColor = PP_AppColor;
        self.progressViewBottomSpace = PB_Ratio(10);
        self.progressHeight = PB_Ratio(2);
        [self setProgressViewWidths:@[
            @([PPTools pb_to_getStrWidth:self.titlesArr[0] height:30 font:PB_Ratio(16)] + 20),
            @([PPTools pb_to_getStrWidth:self.titlesArr[1] height:30 font:PB_Ratio(16)] + 20),
            @([PPTools pb_to_getStrWidth:self.titlesArr[2] height:30 font:PB_Ratio(16)] + 20),
            @([PPTools pb_to_getStrWidth:self.titlesArr[3] height:30 font:PB_Ratio(16)] + 20),
        ]];
        
        self.scrollView.backgroundColor = UIColor.clearColor;

    
    }
    return self;
}

- (void)setCurrentSelIndex:(int)currentSelIndex {
    _currentSelIndex = currentSelIndex;
    [self setSelectIndex:currentSelIndex];
}



#pragma mark - WMPageController DataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titlesArr.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titlesArr[index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    UIViewController *vc = nil;
    vc = [NSClassFromString(self.classNamesArr[index]) new];
    return vc;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    
    CGFloat leftMargin =  0;
    CGFloat originY = PB_NaviBa_H;
    return CGRectMake(leftMargin, originY, PB_SW, 64);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {

    return CGRectMake(0, PB_NaviBa_H + 64, PB_SW, PB_SH - PB_NaviBa_H - 64);
}



@end

