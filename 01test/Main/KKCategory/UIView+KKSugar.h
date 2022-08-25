//
//  UIView+KKSugar.h
//  yunbaolive
//
//  Created by Peter on 2021/1/28.
//  Copyright © 2021 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (KKSugar)


/**
 *  给视图添加虚线边框
 *
 *  @param lineWidth  线宽
 *  @param lineMargin 每条虚线之间的间距
 *  @param lineLength 每条虚线的长度
 *  @param lineColor 每条虚线的颜色
 */
- (void)xl_addDottedLineBorderWithLineWidth:(CGFloat)lineWidth lineMargin:(CGFloat)lineMargin lineLength:(CGFloat)lineLength lineColor:(UIColor *)lineColor;

//简单lable
+ (UILabel *)kkLabelWithText:(NSString *)text textColor:(UIColor *)color textFont:(UIFont *)font andTextAlignment:(NSTextAlignment )alignment;

//磨砂效果，毛玻璃
+ (UIVisualEffectView *)kkaddBlurEffectToView:(UIView *)toView effectWithStyle:(UIBlurEffectStyle)style;


//获取view截图,将view截成图片，传入一个view获得一张图片
+ (UIImage *)kk_getImageViewWithView:(UIView *)view;
//保存图片至相册
+ (void)kk_writeImageToAlbum:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
