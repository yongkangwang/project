//
//  MBProgressHUD+MJ.h
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger,MBProgressHUBPosition) {
    MBProgressHUBPositionTop,            //头部
    MBProgressHUBPositionCenter,         //中心
    MBProgressHUBPositionBottom          //底部
};


@interface MBProgressHUD (MJ)

+ (instancetype)kk_showDengHUDAddedTo:(UIView *)view animated:(BOOL)animated;

+ (BOOL)kk_hideDengHUDForView:(UIView *)view animated:(BOOL)animated;


//消息文字， 文字颜色，背景颜色，显示位置
+ (void)kkshowMessage:(NSString *)message toView:(UIView *)view textColor:(UIColor *)textColor andViewColor:(UIColor *)viewColor position:(MBProgressHUBPosition)position;


+ (void)kkshowMessage:(NSString *)message ;
+ (void)kkshowMessage:(NSString *)message toView:(UIView *)view;

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

//1.8六道修改，可能有问题，没有阴影蒙版了
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

@end
