//
//  PPServe.h
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/27.
//

#ifndef PPServe_h
#define PPServe_h
#import "PB_AskRootUrlHelper.h"

#define PBServe_Url [PB_AskRootUrlHelper instanceOnly].pb_root_url

#define PB_Url(apiName) [NSString stringWithFormat:@"%@%@",PBServe_Url,apiName]



#define PBURL_LanguageUrl                PB_Url(@"off/inplo")    //APP登录初始化语言

#define PBURL_loginMessageUrl             PB_Url(@"off/questions")    //短信验证码
#define PBURL_loginVoiceMessageUrl        PB_Url(@"off/defines")       //语音验证码
#define PBURL_loginUrl                    PB_Url(@"off/concepts")    //登陆/注册
#define PBURL_logoutUrl                   PB_Url(@"service/login/logout")   //登录退出
#define PBURL_cancelationUrl              PB_Url(@"off/opposition")      //注销账号

#define PBURL_appHomeUrl                  PB_Url(@"off/reviews")  //APP首页
#define PBURL_appMineMenuUrl              PB_Url(@"off/networks")        //个人中心菜单
#define PBURL_selAdressUrl                PB_Url(@"off/voice")          //城市列表

#define PBURL_productCanApplyUrl          PB_Url(@"off/next")           //准入接口
#define PBURL_productDetailInfoUrl        PB_Url(@"off/differentiation")       //产品详情

//(第一项)
#define PBURL_V1CardInfoUrl          PB_Url(@"off/politics")  //获取用户身份信息
#define PBURL_V1UploadCardInfo    PB_Url(@"off/shapes")       //接口上传(face,身份证正面,反面)
#define PBURL_V1CardInfoSaveUrl      PB_Url(@"off/experiences")         //保存用户身份证信息

//（第二项）
#define PBURL_V2UserInfoUrl          PB_Url(@"off/chapters")      //获取用户信息
#define PBURL_V2UserInfoSubUrl       PB_Url(@"off/finding")        //保存用户信息

//第三项）
#define PBURL_V3JobInfoUrl           PB_Url(@"off/stage")            //获取工作信息
#define PBURL_V3JobInfoSubUrl        PB_Url(@"off/foundation") //保存工作信息

//获取联系人信息（第四项）
#define PBURL_V4ContactInfoUrl       PB_Url(@"off/draw")       //获取联系人
#define PBURL_V4ContactInfoSubUrl    PB_Url(@"off/reviewed")            //保存联系人

//获取绑卡信息（第五项）
#define PBURL_V5BankInfoUrl          PB_Url(@"off/conclusion")   //获取绑卡信息
#define PBURL_V5BankSubUrl           PB_Url(@"off/translated")             //提交绑卡

///提交借款
//#define PBURL_toTakeOrder                PB_Url(@"/off/next")            //下单接口
#define PBURL_myOrderListUrl             PB_Url(@"off/pivotal")        //订单列表
#define PBURL_myOrderListItemLinkUrl     PB_Url(@"off/examine")        //跟进订单号获取跳转地址

///上报
#define PBURL_reportLocationInfoUrl      PB_Url(@"off/powerful")       //上报位置信息
#define PBURL_reportGoogleMarkInfoUrl    PB_Url(@"off/questioning")    //google_market上报
#define PBURL_reportDeviceInfoUrl        PB_Url(@"off/naldic")         //上报设备信息
#define PBURL_reportRiskInfoUrl          PB_Url(@"off/lobbying")       //上报风控
#define PBURL_reportConnectInfoUrl       PB_Url(@"credit-info/upload-contacts-ios")       //上报通讯录

/// h5 privaty
#define url_h5Agree                 @"https://mjj-atthi-lending.com/PB-PrivacyPolicy.html"

///证件类型标签
static NSString *const PB_VeIdCard_only_tag = @"PB_VeIdCard_only_tag";
static NSString *const PBFaceCard_only_tag = @"PBFaceCard_only_tag";

/// C 宏在 Swift 中不可见，供 Swift / 桥接调用（与上方 PBURL_* 宏一致）
NS_INLINE NSString *PB_API_LoginMessageURL(void) { return PBURL_loginMessageUrl; }
NS_INLINE NSString *PB_API_H5PrivacyPolicyURL(void) { return url_h5Agree; }
NS_INLINE NSString *PB_API_MyOrderListURL(void) { return PBURL_myOrderListUrl; }
NS_INLINE NSString *PB_API_MineMenuURL(void) { return PBURL_appMineMenuUrl; }
NS_INLINE NSString *PB_API_LogoutURL(void) { return PBURL_logoutUrl; }
NS_INLINE NSString *PB_API_ProductDetailInfoURL(void) { return PBURL_productDetailInfoUrl; }
NS_INLINE NSString *PB_API_MyOrderListItemLinkURL(void) { return PBURL_myOrderListItemLinkUrl; }

NS_INLINE NSString *PB_API_V2UserInfoFetchURL(void) { return PBURL_V2UserInfoUrl; }
NS_INLINE NSString *PB_API_V2UserInfoSubmitURL(void) { return PBURL_V2UserInfoSubUrl; }
NS_INLINE NSString *PB_API_V3JobInfoFetchURL(void) { return PBURL_V3JobInfoUrl; }
NS_INLINE NSString *PB_API_V3JobInfoSubmitURL(void) { return PBURL_V3JobInfoSubUrl; }
NS_INLINE NSString *PB_API_V5BankInfoFetchURL(void) { return PBURL_V5BankInfoUrl; }
NS_INLINE NSString *PB_API_V5BankSubmitURL(void) { return PBURL_V5BankSubUrl; }

#endif /* PPServe_h */
