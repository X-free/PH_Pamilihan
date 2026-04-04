//
//  PB_UI.m
//  PrimeLoanPH
//
//  Created by MacPing on 2024/8/7.
//

#import "PB_UI.h"

@implementation PB_UI

+ (UIView *)pb_creat_ViewWithFrame:(CGRect)frame color:(UIColor *)color {
    UIView *pb_t_view = [[UIView alloc] initWithFrame:frame];
    pb_t_view.backgroundColor = color;
    return pb_t_view;
}
+ (UIView *)pb_creat_ViewWithFrame:(CGRect)frame color:(UIColor *)color radius:(CGFloat)radius{
    UIView *pb_t_view = [self pb_creat_ViewWithFrame:frame color:color];
    pb_t_view.layer.cornerRadius = radius;
    pb_t_view.layer.masksToBounds = YES;
    return pb_t_view;
}

+ (QMUILabel *)pb_create_LabelWithFrame:(CGRect)frame title:(NSString *)title color:(UIColor *)color font:(UIFont *)font alignment:(NSTextAlignment)alignment lines:(NSInteger)lines {
    QMUILabel *pb_t_label = [[QMUILabel alloc] qmui_initWithFont:font textColor:color];
    pb_t_label.text = title;
    pb_t_label.numberOfLines = lines;
    pb_t_label.frame = frame;
    pb_t_label.textAlignment = alignment;
    return pb_t_label;
}

+ (UIImageView *)pb_create_imageViewWhihFrame:(CGRect)frame
                                 imgName:(NSString *)imgStr
                          cornerRadius:(CGFloat)cornerRadius {
    UIImageView *pv_t_imgView = [[UIImageView alloc] initWithImage:UIImageMake(imgStr)];
    pv_t_imgView.frame = frame;
    if(cornerRadius > 0){
        pv_t_imgView.layer.cornerRadius = cornerRadius;
    }
    pv_t_imgView.layer.masksToBounds = YES;
    pv_t_imgView.image = [UIImage imageNamed:imgStr];
    return pv_t_imgView;
}





+ (QMUITextField *)pb_create_textFieldWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor placeholder:(NSString *)placeholder textColor:(UIColor *)textColor font:(UIFont *)font cornerRadius:(CGFloat)cornerRadius keyboardType:(UIKeyboardType)kType {
    QMUITextField *pb_t_textField = [[QMUITextField alloc] initWithFrame:frame];
    pb_t_textField.placeholder          = placeholder;
    pb_t_textField.borderStyle          = UITextBorderStyleNone;
    pb_t_textField.backgroundColor      = bgColor;
    pb_t_textField.clearButtonMode      = UITextFieldViewModeWhileEditing;
    pb_t_textField.clearsOnBeginEditing = NO;
    pb_t_textField.textColor            = textColor;
    pb_t_textField.keyboardType         = kType;
    //关闭首字母大写
    [pb_t_textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    pb_t_textField.font = font;
    if(cornerRadius > 0){
        pb_t_textField.layer.cornerRadius = cornerRadius;
        pb_t_textField.layer.masksToBounds = YES;
    }
    return pb_t_textField;
}




@end
