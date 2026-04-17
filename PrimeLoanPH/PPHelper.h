//
//  PPHelper.h
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/27.
//

#ifndef PPHelper_h
#define PPHelper_h


//颜色
#define PB_Color(V)       [UIColor PBColorBackHexStr:V]
#define PB_AlphaColor(V,A)    [UIColor PBColorBackHexStr:V alpha:A]

#define PB_BgColor          PB_Color(@"#F5F5F5") //背景色qweqw
#define PB_WhiteColor       PB_Color(@"#FFFFFF") //白色fsdf
#define PP_AppColor        PB_Color(@"#FFDB3F")  //主色调sdfdsf
#define PB_TitleColor       PB_Color(@"#294A72") //标题色sdf
#define PB_xiaoTitleColor    PB_AlphaColor(@"#4A4A4C",0.5) //小标题色sdff
#define PB_shenBlackColor   PB_Color(@"#202020") //深黑色dfsdd
#define PB_yiBanBlackColor       PB_Color(@"#373940") //黑色ddd
#define PB_morenHoldColor    PB_Color(@"#70747D") //占位文字fsdf

#define PB_ChengSeOrangeColor  PB_Color(@"#D25A00") //橘色文字sdfs
#define PB_Gray_1_Color        PB_Color(@"#8F8F8F") //灰色sdfs
#define PB_Line_1_Color        PB_Color(@"#EEEEEE") //线条色sdf

#define PB_HomeBackColor      PB_Color(@"#F4F5F9") //首页背景色sdf
#define PB_ShouYeTitleColor   PB_Color(@"#26252A") //首页标题文字sdf
#define PB_DetailTextColor PB_Color(@"#8C8C8C") //小标题文字sfdvxc


#define PMMyWeekSelf __weak typeof(self) weakSelf = self;



//格式化字符串
#define PBStrFormat(s) [NSString stringWithFormat:@"%@",s]


#define PB_CameraTipMsg @"Please enable the camera function so that the Pamilihan PesoAPP application can obtain image information for a better experience and better service"
#define PB_PhotoTipContent  @"Please enable the photo album function so that the Pamilihan PesoAPP can obtain image information for a better experience and better service"
#define PBPositionSettingTipContent @"Pamilihan PesoAPP needs to assess whether your account has a security risk or determine whether it is a real location based on your account login location. Do you need to go to setup now ?"

#define PBContactTipContent @"Please enable the contacts function, so that the Pamilihan PesoAPP can obtain contact information, get better experience and better service"


#ifdef DEBUG

#define NSLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] );

#else

#define NSLog(format, ...)

#endif


//设备宽高
#define PB_SW  [[UIScreen mainScreen] bounds].size.width
#define PB_SH [[UIScreen mainScreen] bounds].size.height

/**当前设备对应375的比例 UI设计师i提供 750尺寸*/
#define PB_Scale_iphone7 (PB_SW/375.0)
/**转换成当前比例的数*/
#define PB_Ratio(x) ((double)((x) * PB_Scale_iphone7))


//获取底部导航条的asdada高度(如果是iPhoneX的是比sdfsfsdsdf普通的多出34)
//#define PHBsdsadaottomBarHeight (PB_SH>=812?83:49)
//底部iPhoneX上虚sdfsfaf拟按键的高度
#define PB_BottomBarXH (PB_SH>=812?34:0)
//状态栏高度scsdvdfgfd
#define PBStatusBar_H (PB_SH>=812?44:20)
//获取导航栏顶部加上状asdasd态栏的高度(如果是iPhoneX 状态栏高度由之前的20 变成44)
#define PB_NaviBa_H (PBStatusBar_H + 64)




//通知
#define PB_NotificationOfCenter   [NSNotificationCenter defaultCenter]
#define PB_NotiLogoutThanToHome  @"PB_NotiLogoutThanToHome" //退出saasd登录通知
#define PB_NotiLoginThanSuccess     @"PB_NotiLoginThanSuccess" //sadasdadwqd登录成功
#define PBLoading_TipMsg             @"Loading..."

#endif /* PPHelper_h */
