
#import "MBProgressHUD+MJ.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
@implementation MBProgressHUD (MJ)

// 显示
+ (instancetype)kk_showDengHUDAddedTo:(UIView *)view animated:(BOOL)animated {
    MBProgressHUD *hud = [[self alloc] initWithView: view];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeCustomView;
    
    //2.7.6六道image修改
    FLAnimatedImageView *gifImageView = [FLAnimatedImageView new];
    gifImageView.contentMode = UIViewContentModeScaleAspectFit;
    NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle]bundlePath]]pathForResource:@"kkNetworkLoading"ofType:@"gif"];
    NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
    gifImageView.animatedImage = [FLAnimatedImage  animatedImageWithGIFData:imageData];

    
    hud.customView =gifImageView;
    hud.square = YES;
    [view addSubview:hud];
    
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor clearColor];

    [hud showAnimated:animated];
    return hud;
}

// 隐藏
+ (BOOL)kk_hideDengHUDForView:(UIView *)view animated:(BOOL)animated {
    MBProgressHUD *hud = [self HUDForView:view];
    if (hud != nil) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:animated];
        });
        return YES;
    }
    return NO;
}

+ (void)kkshowMessage:(NSString *)message toView:(UIView *)view textColor:(UIColor *)textColor andViewColor:(UIColor *)viewColor position:(MBProgressHUBPosition)position
{

    if (view == nil) {
           view = [UIApplication sharedApplication].keyWindow;
       }
       MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:view animated:YES];
       hub.userInteractionEnabled = YES;
       hub.mode = MBProgressHUDModeText;
       hub.label.text = message;
       hub.label.textColor = textColor;
    hub.label.font = KKTitleFont14;
       hub.animationType = MBProgressHUDAnimationZoomIn;
       hub.margin = 5;///修改该值，可以修改加载框大小
       hub.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
       hub.bezelView.backgroundColor = viewColor;

       hub.bezelView.layer.cornerRadius = 15;
    
       CGFloat margin = 50 ;  //距离底部和顶部的距离
       CGFloat offSetY = view.bounds.size.height / 2 - margin;
       if (position == MBProgressHUBPositionTop) {
           hub.y = -offSetY;
       }
       if (position == MBProgressHUBPositionCenter) {
           hub.y = 0;
       }
       if (position == MBProgressHUBPositionBottom) {
           hub.y = offSetY;
       }

    [hub hideAnimated:YES afterDelay:2.0];
}




+ (void)kkshowMessage:(NSString *)message
{
  UIView *view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"temp"]];

    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1];
}

+ (void)kkshowMessage:(NSString *)message toView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"temp"]];

    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1];
}



#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;

    // 1秒之后再消失
//    [hud hide:YES afterDelay:1];
    [hud hideAnimated:YES afterDelay:1];//1.8六道修改
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;

    // YES代表需要蒙版效果
//    hud.dimBackground = NO;
//    [hud ]1.8六道修改
    
    return hud;
}
+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:[UIApplication sharedApplication].keyWindow];
}

+ (void)showError:(NSString *)error
{
//    [self showError:error toView:[UIApplication sharedApplication].keyWindow];
    [self showError:error withView:nil];
}
+ (void)showError:(NSString *)error withView:(UIView *)view{
    if (view == nil) view = [[UIApplication sharedApplication].delegate window];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = error;
    hud.label.font = [UIFont systemFontOfSize:13];
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.bezelView.alpha = 1;
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1];
}
+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:[UIApplication sharedApplication].keyWindow];
}
+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:[UIApplication sharedApplication].keyWindow];
}

@end
