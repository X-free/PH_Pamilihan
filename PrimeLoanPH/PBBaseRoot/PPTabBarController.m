//
//  PPTabBarController.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/27.
//

#import "PPTabBarController.h"
#import "HomeViewController.h"
#import "MeViewController.h"
#import "PPNavigationController.h"

@interface PPTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) HomeViewController *pb_t_page1_de;
@property (nonatomic, strong) MeViewController *pb_t_page2_de;

@end

@implementation PPTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self start];
}

- (void)start {
    self.delegate = self;
    NSArray *pb_t_normalImgs = @[
        UIImageMake(@"icon_home_default"),
        UIImageMake(@"icon_Me_default"),
    ];
    NSArray *pb_t_selectlImgs = @[
        UIImageMake(@"icon_home_actice"),
        UIImageMake(@"icon_Me_active"),
    ];
    NSArray *pb_t_titles = @[@"Home",@"Me"];
    
    self.pb_t_page1_de = [[HomeViewController alloc] initWithPBTableViewOfGroupStyle:YES];
    PPNavigationController *pb_t_navVC1 = [[PPNavigationController alloc] initWithRootViewController:self.pb_t_page1_de];
    
    self.pb_t_page2_de = [[MeViewController alloc] initWithPBTableViewOfGroupStyle:YES];
    PPNavigationController *pb_t_navVC2 = [[PPNavigationController alloc] initWithRootViewController:self.pb_t_page2_de];
    
    self.viewControllers = @[pb_t_navVC1,pb_t_navVC2];
    
    ///设置普通图片
    for (int i = 0; i < self.tabBar.items.count && i < pb_t_normalImgs.count; ++i) {
        UITabBarItem *pb_t_tabBarItem = [self.tabBar.items objectAtIndex:i];
        //pb_t_tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        pb_t_tabBarItem.image = [[pb_t_normalImgs objectAtIndex:i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        NSDictionary *pb_t_textNormalOptions = @{
            NSFontAttributeName:UIFontMake(11),
            NSForegroundColorAttributeName:PB_Color(@"#C9C9C9")
        };
        NSDictionary *pb_t_textSelectOptions = @{
            NSFontAttributeName:UIFontMake(11),
            NSForegroundColorAttributeName:PP_AppColor
        };
        pb_t_tabBarItem.title = pb_t_titles[i];
        [pb_t_tabBarItem setTitleTextAttributes:pb_t_textNormalOptions forState:UIControlStateNormal];
        [pb_t_tabBarItem setTitleTextAttributes:pb_t_textSelectOptions forState:UIControlStateSelected];
        
    }
    ///设置选中图片
    for (int i = 0; i < self.tabBar.items.count && pb_t_selectlImgs.count; ++i) {
        UITabBarItem *pb_t_tabBarItem = [self.tabBar.items objectAtIndex:i];
        pb_t_tabBarItem.selectedImage = [[pb_t_selectlImgs objectAtIndex:i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    if (@available(iOS 13.0, *)) { //去掉tabbard顶部黑色线
        self.tabBar.backgroundImage = [UIImage new];
        self.tabBar.shadowImage = [UIImage new];
    } else {
        self.tabBar.backgroundImage = [UIImage new];
        self.tabBar.shadowImage = [UIImage new];
    }
    //[[UIpb_t_tabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, 4)];
    
    [PB_NotificationOfCenter addObserver:self selector:@selector(toRootHome:) name:PB_NotiLogoutThanToHome object:nil];
}



#pragma mark - UITabBarControllerDelegate
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    _pageIndex = self.pageIndex;
    return YES;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //点击pb_t_tabBarItem动画

    if (self.selectedIndex > 0) {
        if ([PB_APP_Control instanceOnly].pb_t_hasLogin == YES) {
            _pageIndex = self.pageIndex;
        }else{ //present 登录界面
            self.selectedIndex = _pageIndex;
            [PB_APP_Control pb_t_presentLoginVCWithTargetVC:[PB_GetVC pb_to_getCurrentViewController]];
        }
    }else{
        if (self.selectedIndex != _pageIndex){
            _pageIndex = self.pageIndex;        }
    }

}

- (void)toRootHome:(NSNotification *)noti {
    [self allToRootVC];
    self.selectedIndex = 0;
}

- (void)allToRootVC {
    [self.pb_t_page1_de.navigationController popToRootViewControllerAnimated:NO];
    [self.pb_t_page2_de.navigationController popToRootViewControllerAnimated:NO];
}


@end
