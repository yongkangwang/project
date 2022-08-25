//
//  UIButton+KKObjcSugar.m
//  yunbaolive
//
//  Created by Peter on 2020/9/26.
//  Copyright © 2020 cat. All rights reserved.
//

#import "UIButton+KKObjcSugar.h"
#import <objc/runtime.h>


static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

@implementation UIButton (KKObjcSugar)




-(void)setEnLargeEdge:(CGFloat)size
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);

}

// 设置可点击范围到按钮上、右、下、左的距离
-(void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);

}

-(CGRect)enlargedRect
{
    NSNumber *topEdge=objc_getAssociatedObject(self, &topNameKey);
    NSNumber *rightEdge=objc_getAssociatedObject(self, &rightNameKey);
    NSNumber *bottomEdge=objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber *leftEdge=objc_getAssociatedObject(self, &leftNameKey);
    
    if(topEdge && rightEdge && bottomEdge && leftEdge){
        return CGRectMake(self.bounds.origin.x-leftEdge.floatValue,
                          self.bounds.origin.y-topEdge.floatValue,
                          self.bounds.size.width+leftEdge.floatValue+rightEdge.floatValue,
                          self.bounds.size.height+topEdge.floatValue+bottomEdge.floatValue);
    
    }else{
        return self.bounds;
    }

}
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect=[self enlargedRect];
    if(CGRectEqualToRect(rect, self.bounds))
    {
        return [super pointInside:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point)?YES:NO;

}


//=================================================



+ (void)kkChangeButtonEdgeInsets:(UIButton *)button

{
    CGRect rect = [button.titleLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:button.titleLabel.font} context:nil];
        
        CGFloat titleStringH = rect.size.height;
        CGFloat titleStringW = rect.size.width;

        //根据图片来计算图片的宽度
        UIImage *titleImage = button.imageView.image;
        CGFloat titleImageH = titleImage.size.height;
                    
        CGFloat totalHeight = (titleStringH + titleImageH + 5);
        button.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - titleImageH), 0.0, 0.0, - titleStringW);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, - titleImageH, - (totalHeight - titleStringH), 0);
}

/** 图片在右,文字在左,指定字体 */
+ (instancetype)kkButtonImageRightWithTitle:(NSString *)title image:(NSString *)image font:(NSInteger)font color:(UIColor *)color
{
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
       
       //根据字符串计算字符串的宽高
       
       CGRect rect = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
       
       CGFloat titleStringWidth = rect.size.width;
       
       //根据图片来计算图片的宽度
       UIImage *titleImage = [UIImage imageNamed:image];
       
       CGFloat titleImageWidth = titleImage.size.width;
       
       //根据字符串宽度以及图片的宽度来设置顶部按钮的宽度
       
       titleButton.width = titleStringWidth + 3*titleImageWidth;
       titleButton.height = rect.size.height;
       
       titleButton.frame = (CGRect){{0,0},CGSizeMake(titleButton.width, titleButton.height)};
       
       titleButton.titleLabel.font = [UIFont systemFontOfSize:font];
       [titleButton setTitleColor:color forState:UIControlStateNormal];
       
       //设置文字和图片的内边距
       titleButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//       titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, titleStringWidth + 2*titleImageWidth, 0, 0);
//       titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 3*titleImageWidth);
    //设置图片文字
    [titleButton setTitle:title forState:UIControlStateNormal];
    [titleButton setImage:titleImage forState:UIControlStateNormal];

    CGFloat kkImgW = titleButton.imageView.image.size.width +3;
    CGFloat kkLabW = titleButton.titleLabel.bounds.size.width +3;

    [titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, - kkImgW, 0, kkImgW)];
       [titleButton setImageEdgeInsets:UIEdgeInsetsMake(0, kkLabW, 0, -kkLabW)];
       
       return titleButton;
}

//图片在左，文字在右
+ (instancetype)kk_buttonImageLeftWithTitle:(NSString *)title image:(NSString *)image font:(NSInteger)font color:(UIColor *)color
{
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
       
       //根据字符串计算字符串的宽高
       
       CGRect rect = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
       
       CGFloat titleStringWidth = rect.size.width;
       
       //根据图片来计算图片的宽度
       UIImage *titleImage = [UIImage imageNamed:image];
       
       CGFloat titleImageWidth = titleImage.size.width;
       
       //根据字符串宽度以及图片的宽度来设置顶部按钮的宽度
       
       titleButton.width = titleStringWidth + 3*titleImageWidth;
       titleButton.height = rect.size.height;
       
       titleButton.frame = (CGRect){{0,0},CGSizeMake(titleButton.width, titleButton.height)};
       
       titleButton.titleLabel.font = [UIFont systemFontOfSize:font];
       [titleButton setTitleColor:color forState:UIControlStateNormal];
       
       //设置文字和图片的内边距
       titleButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//kk六道只需设置左右间距即可
    titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);

       //设置图片文字
       [titleButton setTitle:title forState:UIControlStateNormal];
       [titleButton setImage:titleImage forState:UIControlStateNormal];
       
       return titleButton;
}


+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color andTitleFont:(NSInteger )font
{
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];

    titleButton.titleLabel.font = [UIFont systemFontOfSize:font];
    [titleButton setTitleColor:color forState:UIControlStateNormal];
    //设置文字
    [titleButton setTitle:title forState:UIControlStateNormal];
    
    return titleButton;
}
/** 图片在上,文字在下 */
+ (instancetype)kkButtonUpImageWithTitle:(NSString *)title image:(NSString *)image font:(NSInteger)font
{
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //根据字符串计算字符串的宽高
    
    CGRect rect = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    CGFloat titleStringH = rect.size.height;
    CGFloat titleStringW = rect.size.width;

    //根据图片来计算图片的宽度
    UIImage *titleImage = [UIImage imageNamed:image];
    
    CGFloat titleImageH = titleImage.size.height;
    
    //根据字符串宽度以及图片的宽度来设置顶部按钮的宽度
    
    titleButton.height = titleStringH + titleImageH;
    titleButton.width = 45;
    
    titleButton.titleLabel.font = [UIFont systemFontOfSize:font];
    [titleButton setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateNormal];
    
    //设置文字和图片的内边距
//    titleButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    CGFloat totalHeight = (titleStringH + titleImageH + 5);
    titleButton.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - titleImageH), 0.0, 0.0, - titleStringW);
    titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, - titleImageH, - (totalHeight - titleStringH), 0);
    
    //设置图片文字
    [titleButton setTitle:title forState:UIControlStateNormal];
    [titleButton setImage:titleImage forState:UIControlStateNormal];
    

    return titleButton;
}

/** 图片在右,文字在左 */
+ (instancetype)buttonWithTitle:(NSString *)title image:(NSString *)image{

    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    //根据字符串计算字符串的宽高
    
    CGRect rect = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    
    CGFloat titleStringWidth = rect.size.width;
    
    //根据图片来计算图片的宽度
    UIImage *titleImage = [UIImage imageNamed:image];
    
    CGFloat titleImageWidth = titleImage.size.width;
    
    //根据字符串宽度以及图片的宽度来设置顶部按钮的宽度
    
    titleButton.width = titleStringWidth + 3*titleImageWidth;
    titleButton.height = 30;
    
    titleButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //设置文字和图片的内边距
    titleButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, titleStringWidth + 2*titleImageWidth, 0, 0);
    titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2*titleImageWidth);
    
    //设置图片文字
    [titleButton setTitle:title forState:UIControlStateNormal];
    [titleButton setImage:titleImage forState:UIControlStateNormal];
    
    
    return titleButton;
    
}

/** 图片在右,文字在左 */

+ (instancetype)buttonWithTitle:(NSString *)title image:(NSString *)image font:(NSInteger)font color:(UIColor *)color{
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    //根据字符串计算字符串的宽高
    
    CGRect rect = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    CGFloat titleStringWidth = rect.size.width;
    
    //根据图片来计算图片的宽度
    UIImage *titleImage = [UIImage imageNamed:image];
    
    CGFloat titleImageWidth = titleImage.size.width;
    
    //根据字符串宽度以及图片的宽度来设置顶部按钮的宽度
    
    titleButton.width = titleStringWidth + 3*titleImageWidth;
    titleButton.height = rect.size.height;
    
    titleButton.frame = (CGRect){{0,0},CGSizeMake(titleButton.width, titleButton.height)};
    
    titleButton.titleLabel.font = [UIFont systemFontOfSize:font];
    [titleButton setTitleColor:color forState:UIControlStateNormal];
    
    //设置文字和图片的内边距
    titleButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, titleStringWidth + 3*titleImageWidth, 0, 0);
    titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 3*titleImageWidth);
    
    //设置图片文字
    [titleButton setTitle:title forState:UIControlStateNormal];
    [titleButton setImage:titleImage forState:UIControlStateNormal];
    
    
    return titleButton;
    
}

@end
