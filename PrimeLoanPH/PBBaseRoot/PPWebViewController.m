//
//  PPWebViewController.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/27.
//

#import "PPWebViewController.h"
#import <WebKit/WebKit.h>
#import <StoreKit/StoreKit.h>

@interface PPWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *pb_t_de_webView;
@property (nonatomic, copy) NSString *pb_t_de_bindBankStartTime;
@property (nonatomic, copy) NSString *pb_t_de_bindBankEndTime;


@end

@implementation PPWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pb_t_de_bindBankEndTime = @"";
    self.pb_t_de_bindBankEndTime = @"";
    NSString *urlString = [self.url stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"webView_urlString:%@",urlString);
    NSMutableURLRequest *pb_t_de_request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    pb_t_de_request.timeoutInterval = 15.0f;
    [self.pb_t_de_webView loadRequest:pb_t_de_request];
    self.showBackBtn = YES;
}

- (WKWebView *)pb_t_de_webView {
    if (!_pb_t_de_webView) {
        WKUserContentController* pb_t_de_userContentController = [WKUserContentController new];
       // [pb_t_de_userContentController addUserScript:wkUScript];
        //设置userContentController 遵守代理WKScriptMessageHandler 实现方法
        [pb_t_de_userContentController addScriptMessageHandler:self name:@"sda"];
        [pb_t_de_userContentController addScriptMessageHandler:self name:@"sdb"];
        [pb_t_de_userContentController addScriptMessageHandler:self name:@"sdc"];
        [pb_t_de_userContentController addScriptMessageHandler:self name:@"sdd"];
        [pb_t_de_userContentController addScriptMessageHandler:self name:@"sde"];
        [pb_t_de_userContentController addScriptMessageHandler:self name:@"sdf"];
        [pb_t_de_userContentController addScriptMessageHandler:self name:@"sdg"];
        [pb_t_de_userContentController addScriptMessageHandler:self name:@"sdk"];
        [pb_t_de_userContentController addScriptMessageHandler:self name:@"sdl"];
        [pb_t_de_userContentController addScriptMessageHandler:self name:@"startBank"];
        [pb_t_de_userContentController addScriptMessageHandler:self name:@"endBank"];
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        //实例化对象
        config.userContentController = pb_t_de_userContentController;
        
        _pb_t_de_webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, PB_NaviBa_H, PB_SW, PB_SH - PB_NaviBa_H) configuration:config];
        _pb_t_de_webView.navigationDelegate = self;
        _pb_t_de_webView.backgroundColor = PB_BgColor;
        _pb_t_de_webView.opaque = NO;
        _pb_t_de_webView.UIDelegate = self;
        [_pb_t_de_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        [self.view addSubview:_pb_t_de_webView];
    }
    return _pb_t_de_webView;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"title"])
    {
        self.title = self.pb_t_de_webView.title;
    }
}
///WKScriptMessageHandler delegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {

//    NSLog(@"message.name ::: %@",message.name);
//    NSLog(@"message.body ::: %@",message.body);
    if([NSString PB_CheckStringIsEmpty:message.name]) return;
    
    if ([message.name isEqualToString:@"sda"]) {//页面跳转
        NSString *toUrl = PBStrFormat([(NSArray *)message.body firstObject]);
        if([toUrl hasPrefix:@"http"]){
            PPWebViewController *vc = [[PPWebViewController alloc] init];
            vc.url = [[PB_APP_Control instanceOnly] pb_t_addPublicParamsDictKeyToUrlSuff:toUrl];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [PB_OpenUrl pb_to_openUrl:[NSURL URLWithString:toUrl]];
        }
    }if ([message.name isEqualToString:@"sdc"]) {//页面带参跳转
        NSString *toUrl = PBStrFormat([(NSArray *)message.body firstObject]);
        if([toUrl hasPrefix:@"http"]){
            PPWebViewController *vc = [[PPWebViewController alloc] init];
            vc.url = [[PB_APP_Control instanceOnly] pb_t_addPublicParamsDictKeyToUrlSuff:toUrl];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [PB_OpenUrl pb_to_openUrl:[NSURL URLWithString:toUrl]];
        }
    }
    else if ([message.name isEqualToString:@"sdb"]){//关闭当前webview
        [self coloseCurrnetVC];
    }else if ([message.name isEqualToString:@"sdd"]){//回到首页，并关闭当前页面ruBHome()
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if ([message.name isEqualToString:@"sde"]){//回到个人中心，并关闭当前页面
        self.tabBarController.selectedIndex = 1;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if ([message.name isEqualToString:@"sdf"]){//跳转到登录页，并清空页面栈
        [PB_APP_Control pb_t_toLogoutAntToHomeMyAccount];
        [PB_APP_Control pb_t_presentLoginVCWithTargetVC:[PB_GetVC pb_to_getCurrentViewController]];
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if ([message.name isEqualToString:@"sdg"]){//拨打电话号码（客户端补充"tel:"）
        NSString *myUrl = PBStrFormat([(NSArray *)message.body firstObject]);
        myUrl = [myUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
        [PB_CallCell pb_to_callPhone:myUrl];
    }else if ([message.name isEqualToString:@"sdk"]){//app store评分功能 scoreKey
        [SKStoreReviewController requestReview];
    }else if ([message.name isEqualToString:@"sdl"]){//确认申请埋点调用方法
        NSDictionary *riskDict = @{
            @"speak":[PB_timeHelper pb_t_getCurrentStampTimeString],
            @"advantage":[PB_timeHelper pb_t_getCurrentStampTimeString],
            @"rejection":@"10"
        };
        [[PB_APP_Control instanceOnly] pb_t_toRePortRiskDataToServe:riskDict];
    }else if ([message.name isEqualToString:@"startBank"]){//开始绑卡
        self.pb_t_de_bindBankStartTime = [PB_timeHelper pb_t_getCurrentStampTimeString];
    }else if ([message.name isEqualToString:@"endBank"]){ //结束绑卡
        self.pb_t_de_bindBankEndTime = [PB_timeHelper pb_t_getCurrentStampTimeString];
        NSDictionary *riskDict = @{
            @"speak":self.pb_t_de_bindBankStartTime,
            @"advantage":self.pb_t_de_bindBankEndTime,
            @"rejection":@"8"
        };
        [[PB_APP_Control instanceOnly] pb_t_toRePortRiskDataToServe:riskDict];
    }
    
}



#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//    NSURL *url = navigationAction.request.URL;
    decisionHandler(WKNavigationActionPolicyAllow);
}

///加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if([NSString PB_CheckStringIsEmpty:self.pb_t_de_webView.title] == NO){
        self.navTitle = self.pb_t_de_webView.title;
    }
}

- (void)coloseCurrnetVC{
    [self.navigationController popViewControllerAnimated:YES];
}

/// 点击返回按钮
- (void)popController {
    if ([self.pb_t_de_webView canGoBack]) {
        [self goBackAction];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/// 上一页
- (void)goBackAction {
    if ([self.pb_t_de_webView canGoBack]) {
        [self.pb_t_de_webView goBack];
    }
}

///下一页
- (void)goForwardAction {
    if ([self.pb_t_de_webView canGoForward]) {
        [self.pb_t_de_webView goForward];
    }
}

/// 刷新
- (void)refreshAction {
    [self.pb_t_de_webView reload];
}

- (void)nextClick:(UIBarButtonItem *)btn {
    //NSLog(@"点击下一步");
}
//
//H5 交互函数：
//sda(String url)页面跳转
//sdb()关闭当前webview
//sdc(String url, String params)带参数页面跳转
//sdd()回到首页，并关闭当前页
//sde()回到个人中心，并关闭当前页
//sdf()跳转到登录页，并清空页面栈
//sdg(String phone)拨打电话号码（客户端补充"tel:"）
//sdk() app store评分功能
//sdl() 确认申请埋点调用方法
-(void)dealloc {
    [self.pb_t_de_webView.configuration.userContentController removeScriptMessageHandlerForName:@"sda"];
    [self.pb_t_de_webView.configuration.userContentController removeScriptMessageHandlerForName:@"sdb"];
    [self.pb_t_de_webView.configuration.userContentController removeScriptMessageHandlerForName:@"sdc"];
    [self.pb_t_de_webView.configuration.userContentController removeScriptMessageHandlerForName:@"sdd"];
    [self.pb_t_de_webView.configuration.userContentController removeScriptMessageHandlerForName:@"sde"];
    [self.pb_t_de_webView.configuration.userContentController removeScriptMessageHandlerForName:@"sdf"];
    [self.pb_t_de_webView.configuration.userContentController removeScriptMessageHandlerForName:@"sdg"];
    [self.pb_t_de_webView.configuration.userContentController removeScriptMessageHandlerForName:@"sdk"];
    [self.pb_t_de_webView.configuration.userContentController removeScriptMessageHandlerForName:@"sdl"];
    [self.pb_t_de_webView.configuration.userContentController removeScriptMessageHandlerForName:@"startBank"];
    [self.pb_t_de_webView.configuration.userContentController removeScriptMessageHandlerForName:@"endBank"];
}

@end


