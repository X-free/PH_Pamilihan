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

@property (nonatomic, strong) UIImageView *pp_orderTopBg;
@property (nonatomic, strong) UILabel *pp_orderTitleLabel;
@property (nonatomic, strong) UIStackView *pp_orderSegmentStack;
@property (nonatomic, copy) NSArray<UIButton *> *pp_orderSegmentButtons;
/// 布局后 segment 底边在 `self.view` 中的 Y；用于列表顶 12pt 间距与公式兜底一致
@property (nonatomic, assign) CGFloat pp_orderLaidOutSegmentMaxY;

@end

@implementation PPOrderViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [self pp_configureOrderChromeBeforeWMLayout];
    [self pp_updateOrderKVCKeyIdForInitialSegment];
    [super viewDidLoad];
    self.view.backgroundColor = PB_Color(@"#FBF6E7");
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self pp_buildOrderListHeader];
    [self setShowNavBar:self.showNavBar];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!self.pp_orderSegmentStack) {
        return;
    }
    CGRect segFrame = [self.view convertRect:self.pp_orderSegmentStack.bounds fromView:self.pp_orderSegmentStack];
    CGFloat maxY = CGRectGetMaxY(segFrame);
    if (maxY < 10) {
        return;
    }
    if (fabs(maxY - self.pp_orderLaidOutSegmentMaxY) <= 0.5) {
        return;
    }
    self.pp_orderLaidOutSegmentMaxY = maxY;
    // `childControllersCount` 未在 WMPageController.h 公开，用已创建的 scrollView 判断 WM 已完成初始化
    if (self.scrollView) {
        [self forceLayoutSubviews];
    }
}

/// 须在 `[super viewDidLoad]` 之前调用，以便 WM 首次 `wm_calculateSize` 读到正确的顶栏占位。
- (void)pp_configureOrderChromeBeforeWMLayout {
    BOOL pushed = (self.navigationController != nil && self.navigationController.viewControllers.count > 1);
    self.showNavBar = pushed;
    self.showBackBtn = pushed;
    self.useDarkNavBackIcon = pushed;
    if (pushed) {
        self.navBgColr = UIColor.clearColor;
    }
    [self setNavTitle:@""];
}

/// 子控制器创建时 KVC 注入的 keyId，与当前 segment 一致（与 statutory：7/6/5 对应）。
- (void)pp_updateOrderKVCKeyIdForInitialSegment {
    int seg = self.currentSelIndex;
    if (seg < 0 || seg > 2) {
        seg = 0;
    }
    NSInteger keyId = [self pp_orderKeyIdForSegmentIndex:seg];
    self.values = [@[@(keyId)] mutableCopy];
}

- (CGFloat)pp_orderNavInset {
    return self.showNavBar ? PB_NaviBa_H : 0;
}

/// 与全案 `ordtopbg` 一致：高/宽 = 400/375
- (CGFloat)pp_orderOrdtopbgHeightPerWidth {
    return (CGFloat)PB_OrdtopbgHeightToWidthRatio;
}

/// segment 底边在 `self.view` 中的 Y：顶部安全区高度 + 120（未布局时用状态栏高度兜底）
- (CGFloat)pp_orderSegmentBottomY {
    CGFloat safeTop = 0;
    if (@available(iOS 11.0, *)) {
        safeTop = self.view.safeAreaInsets.top;
    }
    if (safeTop < 0.5 && CGRectGetHeight(self.view.bounds) < 1) {
        safeTop = PBStatusBar_H;
    }
    return safeTop + 120.0;
}

/// `PPSubOrderViewController` 内容区顶 = segment 底边再向下 12pt（优先用布局后的真实 frame）
- (CGFloat)pp_orderSubListContentTopY {
    if (self.pp_orderLaidOutSegmentMaxY > 10) {
        return self.pp_orderLaidOutSegmentMaxY + 12.0;
    }
    return [self pp_orderSegmentBottomY] + 12.0;
}

/// 列表区域底边：Tab 根页为系统 TabBar 顶；Push 或非 Tab 为 `self.view` 底
- (CGFloat)pp_orderListAreaBottomY {
    CGFloat viewH = CGRectGetHeight(self.view.bounds);
    if (viewH < 1) {
        viewH = PB_SH;
    }
    UITabBarController *tbc = self.tabBarController;
    UITabBar *tabBar = tbc.tabBar;
    if (!tbc || !tabBar || tabBar.isHidden) {
        return viewH;
    }
    if (self.navigationController.viewControllers.count > 1) {
        return viewH;
    }
    CGRect tabRect = [self.view convertRect:tabBar.bounds fromView:tabBar];
    if (CGRectIsEmpty(tabRect) || CGRectGetHeight(tabRect) < 1) {
        return viewH;
    }
    CGFloat y = CGRectGetMinY(tabRect);
    if (y > 0 && y <= viewH + 0.5) {
        return y;
    }
    return viewH;
}

- (NSInteger)pp_orderKeyIdForSegmentIndex:(int)seg {
    static const NSInteger kIds[3] = { 7, 6, 5 };
    if (seg < 0 || seg > 2) {
        return kIds[0];
    }
    return kIds[seg];
}

- (void)pp_buildOrderListHeader {
    if (self.pp_orderTopBg) {
        return;
    }
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ordtopbg"]];
    bg.contentMode = UIViewContentModeScaleAspectFill;
    bg.backgroundColor = PB_Color(@"#FBF6E7");
    // 必须为 YES：NO 时图层会画进下方列表区域，遮挡内容且打乱点击层级
//    bg.clipsToBounds = NO;
    self.pp_orderTopBg = bg;
    [self.view addSubview:bg];

    UILabel *title = [[UILabel alloc] init];
    title.text = @"Order list";
    title.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    title.textColor = UIColor.blackColor;
    title.textAlignment = NSTextAlignmentCenter;
    self.pp_orderTitleLabel = title;
    [self.view addSubview:title];

    UIStackView *stack = [[UIStackView alloc] init];
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.spacing = 8;
    stack.distribution = UIStackViewDistributionFillEqually;
    stack.alignment = UIStackViewAlignmentFill;
    self.pp_orderSegmentStack = stack;

    NSArray<NSString *> *titles = @[ @"Apply", @"Repayment", @"Finished" ];
    NSMutableArray<UIButton *> *buttons = [NSMutableArray array];
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        [b setTitle:titles[i] forState:UIControlStateNormal];
        b.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        b.titleLabel.textAlignment = NSTextAlignmentCenter;
        b.titleLabel.numberOfLines = 2;
        b.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        b.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        b.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        b.layer.cornerRadius = 22;
        b.layer.masksToBounds = YES;
        b.tag = (int)i;
        [b addTarget:self action:@selector(pp_onOrderSegmentTap:) forControlEvents:UIControlEventTouchUpInside];
        [stack addArrangedSubview:b];
        [buttons addObject:b];
    }
    self.pp_orderSegmentButtons = buttons.copy;
    [self.view addSubview:stack];

    CGFloat navInset = [self pp_orderNavInset];
    CGFloat ordRatio = [self pp_orderOrdtopbgHeightPerWidth];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.view).offset(navInset);
        make.height.equalTo(bg.mas_width).multipliedBy(ordRatio);
    }];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(8);
        make.height.mas_equalTo(33);
    }];
    [stack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(16);
        make.leading.equalTo(self.view).offset(20);
        make.trailing.equalTo(self.view).offset(-20);
        make.bottom.equalTo(bg.mas_bottom).offset(-14);
        make.height.mas_equalTo(44);
    }];

    int seg = self.currentSelIndex;
    if (seg < 0 || seg > 2) {
        seg = 0;
    }
    [self pp_setOrderSegmentSelectedIndex:seg updateChildKeyId:NO reload:NO];

    // 头图在 scrollView 之下，避免同屏叠层时盖住 WM 子列表（ScaleAspectFill 仍保持图片比例）
    if (self.scrollView && self.pp_orderTopBg.superview == self.view) {
        [self.view insertSubview:self.pp_orderTopBg belowSubview:self.scrollView];
    }
}

- (void)pp_setOrderSegmentSelectedIndex:(int)seg updateChildKeyId:(BOOL)updateChild reload:(BOOL)reload {
    NSInteger keyId = [self pp_orderKeyIdForSegmentIndex:seg];
    UIColor *activeBg = PB_Color(@"#2C2118");
    UIColor *inactiveText = PB_Color(@"#8A8A8A");
    UIColor *borderCol = PB_Color(@"#E8E4D8");
    [self.pp_orderSegmentButtons enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        BOOL on = (NSInteger)seg == idx;
        btn.backgroundColor = on ? activeBg : UIColor.whiteColor;
        [btn setTitleColor:on ? UIColor.whiteColor : inactiveText forState:UIControlStateNormal];
        btn.layer.borderWidth = on ? 0 : 1;
        btn.layer.borderColor = on ? UIColor.clearColor.CGColor : borderCol.CGColor;
    }];
    if (updateChild) {
        [self pp_applyOrderKeyIdToSubController:keyId reload:reload];
    }
}

- (void)pp_applyOrderKeyIdToSubController:(NSInteger)keyId reload:(BOOL)reload {
    UIViewController *vc = self.currentViewController;
    if (!vc) {
        return;
    }
    [vc setValue:@(keyId) forKey:@"keyId"];
    if (reload) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if ([vc respondsToSelector:@selector(pp_reloadOrderList)]) {
            [vc performSelector:@selector(pp_reloadOrderList)];
        }
#pragma clang diagnostic pop
    }
}

- (void)pp_onOrderSegmentTap:(UIButton *)sender {
    int seg = (int)sender.tag;
    _currentSelIndex = seg;
    [self pp_setOrderSegmentSelectedIndex:seg updateChildKeyId:YES reload:YES];
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
        
   
        
        self.keys = @[@"keyId"].mutableCopy;
        self.values = @[@(7)].mutableCopy;
        self.classNamesArr = @[@"PPSubOrderViewController"].mutableCopy;
        self.titlesArr = @[@" "].mutableCopy;

        self.progressColor = PP_AppColor;
        self.progressViewBottomSpace = 0;
        self.progressHeight = 0;
        [self setProgressViewWidths:@[@(PB_SW)]];
    
    }
    return self;
}

- (void)setCurrentSelIndex:(int)currentSelIndex {
    int seg = currentSelIndex;
    if (seg < 0 || seg > 2) {
        seg = 0;
    }
    _currentSelIndex = seg;
    [self setSelectIndex:0];
    if (self.isViewLoaded && self.pp_orderSegmentButtons.count > 0) {
        [self pp_setOrderSegmentSelectedIndex:seg updateChildKeyId:YES reload:YES];
    }
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
    CGFloat top = [self pp_orderSubListContentTopY];
    CGFloat w = CGRectGetWidth(self.view.bounds);
    if (w < 1) {
        w = PB_SW;
    }
    return CGRectMake(0, top, w, 0);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat top = [self pp_orderSubListContentTopY];
    CGFloat bottomY = [self pp_orderListAreaBottomY];
    CGFloat w = CGRectGetWidth(self.view.bounds);
    if (w < 1) {
        w = PB_SW;
    }
    CGFloat h = MAX(0, bottomY - top);
    return CGRectMake(0, top, w, h);
}



@end

