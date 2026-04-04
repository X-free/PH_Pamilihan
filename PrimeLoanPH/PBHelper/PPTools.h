//
//  PPTools.h
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPTools : NSObject




///获取字符sfsadfsdf串长度
+ (CGFloat)pb_to_getStrWidth:(NSString *)string height:(CGFloat)height font:(CGFloat)fontSize;


///根据url 链接，取拼sadfasdfsadf接的参数
+ (NSString *)pb_to_getUrlParamWithOnlyKey:(NSString *)key URLString:(NSString *)url;

//将数组转sdfsdfsadf换成json格式字符串
+ (NSString *)pb_t_jsonStrFormatForNSArray:(NSArray *)array;


//加载网sdfsdfdsafas络图片
+(void)PB_loadUrl_ImageView:(UIImageView *)imageView urlStr:(NSString *)urlStr holdImg:(NSString *)holdImg;

+ (NSMutableAttributedString *)pb_t_attriStringWithHexString:(NSString *)attriStr totalStr:(NSString *)totalStr norColor:(UIColor *)norColor attriColor:(UIColor *)attriColor norFont:(UIFont *)font attriFont:(UIFont *)attriFont underline:(BOOL)showUnderLine;




@end

NS_ASSUME_NONNULL_END
