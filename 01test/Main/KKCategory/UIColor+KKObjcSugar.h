//
//  UIColor+KKObjcSugar.h
//  yunbaolive
//
//  Created by Peter on 2019/12/19.
//  Copyright © 2019 cat. All rights reserved.
//

//#import <AppKit/AppKit.h>//创建时自带的报错


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (KKObjcSugar)

+ (UIColor *)getColor:(NSString *)hexColor alpha:(CGFloat)alpha;
+ (NSString *)getHexStringByColor:(UIColor *)originalColor;
+ (NSDictionary *)getRGBDictionaryByColor:(UIColor *)originalColor;
+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
@end

NS_ASSUME_NONNULL_END
