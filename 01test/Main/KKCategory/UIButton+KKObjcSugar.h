//
//  UIButton+KKObjcSugar.h
//  yunbaolive
//
//  Created by Peter on 2020/9/26.
//  Copyright © 2020 cat. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (KKObjcSugar)

// 设置可点击范围到按钮边缘的距离
-(void)setEnLargeEdge:(CGFloat)size;

// 设置可点击范围到按钮上、右、下、左的距离
-(void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;



//更新button  EdgeInsets
+ (void)kkChangeButtonEdgeInsets:(UIButton *)button;

/** 图片在右,文字在左,指定字体 */
+ (instancetype)kkButtonImageRightWithTitle:(NSString *)title image:(NSString *)image font:(NSInteger)font color:(UIColor *)color;

//图片在左，文字在右
+ (instancetype)kk_buttonImageLeftWithTitle:(NSString *)title image:(NSString *)image font:(NSInteger)font color:(UIColor *)color;


/**
 *普通button
 */
+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color andTitleFont:(NSInteger )font ;

/** 图片在上,文字在下 */
+ (instancetype)kkButtonUpImageWithTitle:(NSString *)title image:(NSString *)image font:(NSInteger)font;

/** 图片在右,文字在左 */
+ (instancetype)buttonWithTitle:(NSString *)title image:(NSString *)image;

/** 图片在右,文字在左,指定字体 */
+ (instancetype)buttonWithTitle:(NSString *)title image:(NSString *)image font:(NSInteger)font color:(UIColor *)color;


@end

NS_ASSUME_NONNULL_END
