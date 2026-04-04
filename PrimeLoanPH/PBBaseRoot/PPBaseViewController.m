//
//  PPBaseViewController.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/27.
//

#import "PPBaseViewController.h"

@interface PPBaseViewController ()

@property (nonatomic, strong) UIView *nav;
@property (nonatomic, strong) QMUIButton *backBtn;
@property (nonatomic, strong) QMUILabel *titleLB;

@end

@implementation PPBaseViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = PB_BgColor;
    [self.view addSubview:self.nav];
}

- (void)popController {
    if(_isDismiss){
        if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
             [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)setShowNavBar:(BOOL)showNavBar {
    _showNavBar = showNavBar;
    self.nav.hidden = !showNavBar;
    [self.view bringSubviewToFront:self.nav];
}

- (void)setShowBackBtn:(BOOL)showBackBtn {
    _showBackBtn = showBackBtn;
    self.backBtn.hidden = !showBackBtn;
    [self.view bringSubviewToFront:self.nav];

}

- (void)setNavTitle:(NSString *)navTitle {
    _navTitle = navTitle;
    self.titleLB.hidden = NO;
    self.titleLB.text = navTitle;
    [self.view bringSubviewToFront:self.nav];
}


- (void)setNameFont:(UIFont *)nameFont {
    _nameFont = nameFont;
    self.titleLB.font = nameFont;
    [self.view bringSubviewToFront:self.nav];

}

- (void)setNavBgColr:(UIColor *)navBgColr {
    _navBgColr = navBgColr;
    self.nav.backgroundColor = navBgColr;
    [self.view bringSubviewToFront:self.nav];

}

- (UIView *)nav {
    if(!_nav){
        _nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PB_SW, PB_NaviBa_H)];
        _nav.backgroundColor = PP_AppColor;
        //
        _backBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.backgroundColor = UIColor.clearColor;

        [_backBtn setImage:[UIImage imageNamed:@"icon_return_white"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"icon_return_white"] forState:UIControlStateHighlighted];
        [_backBtn addTarget:self action:@selector(popController) forControlEvents:UIControlEventTouchUpInside];

        //为了让图片铺满
        [_nav addSubview:self.backBtn];
        _titleLB = [PB_UI pb_create_LabelWithFrame:CGRectZero title:@"" color:PB_WhiteColor font:UIFontMediumMake(PB_Ratio(20)) alignment:NSTextAlignmentCenter lines:1];
        [_nav addSubview:self.titleLB];
        
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.bottom.mas_offset(-9);
            make.width.height.mas_equalTo(34);
        }];
        
        
        self.backBtn.hidden = YES;
        self.titleLB.hidden = YES;
        [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(self.backBtn);
        }];
    }
    return _nav;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setIsPopGestureRecognizerEnable:YES];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setIsPopGestureRecognizerEnable:YES];

    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)dealloc {
    NSLog(@"dealloc:%@",[self class]);
}


@end
