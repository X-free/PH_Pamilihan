//
//  PB_UI.h
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PB_UI : NSObject


///创建View
+ (UIView *)pb_creat_ViewWithFrame:(CGRect)frame color:(UIColor *)color;
///创建带圆角的view
+ (UIView *)pb_creat_ViewWithFrame:(CGRect)frame color:(UIColor *)color radius:(CGFloat)radius;

///创建标签
+ (QMUILabel *)pb_create_LabelWithFrame:(CGRect)frame
                        title:(NSString *)title
                        color:(UIColor *)color
                         font:(UIFont *)font
                    alignment:(NSTextAlignment)alignment
                        lines:(NSInteger)lines;

///创建ImageView 背景图片
+ (UIImageView *)pb_create_imageViewWhihFrame:(CGRect)frame
                                 imgName:(NSString *)imgStr
                            cornerRadius:(CGFloat)cornerRadius;



///创建输入框
+ (QMUITextField *)pb_create_textFieldWithFrame:(CGRect)frame
                          bgColor:(UIColor *)bgColor
                              placeholder:(NSString *)placeholder
                                textColor:(UIColor *)textColor
                                font:(UIFont *)font
                            cornerRadius:(CGFloat)cornerRadius
                            keyboardType:(UIKeyboardType)kType;

@end

NS_ASSUME_NONNULL_END
