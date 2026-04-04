//
//  PPTools.m
//  PrimeLoanPH
//
//  Created by MacPing on 2023/10/27.
//

#import "PPTools.h"



@implementation PPTools







+ (CGFloat)pb_to_getStrWidth:(NSString *)string height:(CGFloat)height font:(CGFloat)fontSize {
    NSDictionary *pb_t_dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGRect frame = [string boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:pb_t_dic context:nil];
    return frame.size.width;
}


+ (NSString *)pb_to_getUrlParamWithOnlyKey:(NSString *)key URLString:(NSString *)url{
    NSError *error;
    NSString *regx = [[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)", key];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regx options:NSRegularExpressionCaseInsensitive error:&error];
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:url options:0 range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *resultValue_t = [url substringWithRange:[match rangeAtIndex:2]];
        return resultValue_t;
    }
    return @"";
}

//将数组转换成json格式字符串
+ (NSString *)pb_t_jsonStrFormatForNSArray:(NSArray *)array {
    if (![array isKindOfClass:[NSArray class]] || ![NSJSONSerialization isValidJSONObject:array]) {
        return nil;
    }
    NSData *pb_t_jsonData = [NSJSONSerialization dataWithJSONObject:array options:0 error:nil];
    NSString *pb_t_jsonstr = [[NSString alloc] initWithData:pb_t_jsonData encoding:NSUTF8StringEncoding];
    return pb_t_jsonstr;
}



+ (void)PB_loadUrl_ImageView:(UIImageView *)imageView urlStr:(NSString *)urlStr holdImg:(nonnull NSString *)holdImg{
    if([NSString PB_CheckStringIsEmpty:urlStr]){
        NSLog(@"图片url为空");
        return;
    }
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:UIImageMake(holdImg)];
}




+ (NSMutableAttributedString *)pb_t_attriStringWithHexString:(NSString *)attriStr totalStr:(NSString *)totalStr norColor:(UIColor *)norColor attriColor:(UIColor *)attriColor norFont:(UIFont *)font attriFont:(UIFont *)attriFont underline:(BOOL)showUnderLine{
    NSMutableParagraphStyle *pb_t_style = [[NSMutableParagraphStyle alloc] init];
    pb_t_style.alignment = NSTextAlignmentLeft;
    pb_t_style.lineSpacing = 5; //间距
    pb_t_style.hyphenationFactor = 1.0; //断字
    pb_t_style.firstLineHeadIndent = 0.0;
    pb_t_style.paragraphSpacingBefore = 0.0;
    pb_t_style.headIndent = 0;
    pb_t_style.tailIndent = 0;
    NSDictionary *dic = @{
        NSFontAttributeName:font,
        NSParagraphStyleAttributeName:pb_t_style,
        NSKernAttributeName:@0.5f,
        NSForegroundColorAttributeName:norColor,
    };

    NSMutableAttributedString *pb_t_result = [[NSMutableAttributedString alloc] initWithString:totalStr attributes:dic];
    NSRange range = NSMakeRange([[pb_t_result string] rangeOfString:attriStr].location, [[pb_t_result string] rangeOfString:attriStr].length);
    [pb_t_result addAttribute:NSForegroundColorAttributeName value:attriColor range:range];
    [pb_t_result addAttribute:NSFontAttributeName value:attriFont range:range];
    if(showUnderLine){
        [pb_t_result addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
        [pb_t_result addAttribute:NSUnderlineColorAttributeName value:PP_AppColor range:range];
    }
    return pb_t_result;
}




@end
