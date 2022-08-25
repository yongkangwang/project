//
//  YBToolClass.m
//  yunbaolive
//
//  Created by Boom on 2018/9/19.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "YBToolClass.h"

#import "AppDelegate.h"
#import<CommonCrypto/CommonDigest.h>

//#import "LoginViewController.h"


@implementation YBToolClass
static YBToolClass* kSingleObject = nil;




/** 单例类方法 */
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kSingleObject = [[super allocWithZone:NULL] init];
    });
    
    return kSingleObject;
}

// 重写创建对象空间的方法
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    // 直接调用单例的创建方法
    return [self sharedInstance];
}


- (CAShapeLayer *)kkSetViewCornerRadius:(CGFloat)num fromView:(UIView *)view{

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(num, num)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    return maskLayer;
}



/**
 网络请求
 
 @param url 请求的接口名：例：home.gethot
 @param parameter 参数的字典
 @param successBlock 成功的回调
 @param failBlock 失败的回调
 */
+ (void)postNetworkWithUrl:(NSString *)url andParameter:(id)parameter success:(networkSuccessBlock)successBlock fail:(networkFailBlock)failBlock{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];

    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/javascript", @"application/json", @"text/plain", nil];
    session.requestSerializer.timeoutInterval = 60.0f;

    NSString * _Nonnull extractedExpr = purl;
    NSString *requestUrl = [extractedExpr stringByAppendingFormat:@"/?service=%@",url];
//    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //六道修改2.0
    requestUrl =   [requestUrl stringByAddingPercentEncodingWithAllowedCharacters:[ NSCharacterSet URLQueryAllowedCharacterSet]];

    NSMutableDictionary *pDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:minstr([KKChatConfig getOwnID]),@"uid",minstr([KKChatConfig getOwnToken]),@"token", nil];
    [pDic addEntriesFromDictionary:parameter];
    
    [session GET:requestUrl parameters:pDic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
            if (responseObject) {
                NSString *jsonstr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"sataeCode" options:0 error:nil];
                if (expression) {
                    NSTextCheckingResult *result = [expression firstMatchInString:jsonstr options:0 range:NSMakeRange(0, jsonstr.length)];
                    if (!result) {
                    }
                }
                NSData *jsondata = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *jsondic = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:nil];
                NSNumber *number = [jsondic valueForKey:@"ret"];
                if([number isEqualToNumber:[NSNumber numberWithInt:200]])
                {
                    NSArray *data = [jsondic valueForKey:@"data"];
                    int code = [minstr([data valueForKey:@"code"]) intValue];
                    id info = [data valueForKey:@"info"];
                    successBlock(code, info,minstr([data valueForKey:@"msg"]));
                    if (code == 700) {
                        [[YBToolClass sharedInstance] quitLogin];
                        [MBProgressHUD showError:minstr([data valueForKey:@"msg"])];
                    }
                }else{
                    NSArray *data = [jsondic valueForKey:@"data"];
                    [MBProgressHUD kkshowMessage:minstr([data valueForKey:@"msg"])];
//                    [MBProgressHUD showError:minstr([data valueForKey:@"msg"])];
                }
            }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock();
        [MBProgressHUD hideHUD];

    }];

}

//退出登录函数
-(void)quitLogin
{

    //注销登录
    [KKChatConfig clearProfile];

//    LoginViewController *root = [[LoginViewController alloc]init];
//
//    UIApplication *app =[UIApplication sharedApplication];
//    UIWindow *app2 = (UIWindow *)app.windows.firstObject;
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:root];
//    app2.rootViewController = nav;
    
    
}



/**
 计算字符串宽度
 
 @param str 字符串
 @param font 字体
 @param height 高度
 @return 宽度
 */
- (CGFloat)widthOfString:(NSString *)str andFont:(UIFont *)font andHeight:(CGFloat)height{
    return [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size.width;
}

+ (CGFloat)widthOfString:(NSString *)str andFont:(UIFont *)font andHeight:(CGFloat)height{
    return [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size.width;
}
/**
 计算字符串的高度
 
 @param str 字符串
 @param font 字体
 @param width 宽度
 @return 高度
 */
- (CGFloat)heightOfString:(NSString *)str andFont:(UIFont *)font andWidth:(CGFloat)width{
    return [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size.height;
}

/**
 画一条线

 @param frame 线frame
 @param color 线的颜色
 @param view 父View
 */
- (void)lineViewWithFrame:(CGRect)frame andColor:(UIColor *)color andView:(UIView *)view{
    UIView *lineView = [[UIView alloc]initWithFrame:frame];
    lineView.backgroundColor = color;
    [view addSubview:lineView];
}
/**
 MD5加密
 
 @param input 要加密的字符串
 @return 加密好的字符串
 */

- (NSString *) md5:(NSString *) input {
    
    const char *cStr = [input UTF8String];
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr,strlen(cStr),digest); // This is the md5 call
    
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        
    [output appendFormat:@"%02x", digest[i]];
    
    
    return output;
    
}

-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    
    int ci;

    NSDateFormatter *df = [[NSDateFormatter alloc]init];

    [df setDateFormat:@"yyyy-MM-dd HH:mm"];

    NSDate *dt1 = [[NSDate alloc]init];

    NSDate *dt2 = [[NSDate alloc]init];

    dt1 = [df dateFromString:date01];

    dt2 = [df dateFromString:date02];

    NSComparisonResult result = [dt1 compare:dt2];

    switch (result)

    {

        //date02比date01大
        case NSOrderedAscending:
            ci = 1;
            break;
        //date02比date01小
        case NSOrderedDescending:
            ci = -1;
            break;
        //date02=date01
        case NSOrderedSame:
            ci = 0;
            break;
        default:
            NSLog(@"erorr dates %@, %@", dt2, dt1);
            break;
     }

    return ci;

}

- (NSArray <NSTextCheckingResult *> *)machesWithPattern:(NSString *)pattern  andStr:(NSString *)str
{
    NSError *error = nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (error)
    {
        NSLog(@"正则表达式创建失败");
        return nil;
    }
    return [expression matchesInString:str options:0 range:NSMakeRange(0, str.length)];
}


+ (NSString *)sortString:(NSDictionary *)dic{
    
    //  2. 非数字型字符串（注意用compare比较要剔除空数据（nil））
    NSString *returnStr = @"";
    NSArray *charArray = [dic allKeys];
    
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch;
    
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        
        NSRange range = NSMakeRange(0,obj1.length);
        
        return [obj1 compare:obj2 options:comparisonOptions range:range];
        
    };
    
    NSArray *resultArray2 = [charArray sortedArrayUsingComparator:sort];
    
    for (int i = 0; i < resultArray2.count; i++) {
        NSString *str = resultArray2[i];
        if (i != resultArray2.count - 1) {
            returnStr = [NSString stringWithFormat:@"%@%@=%@&",returnStr,str,minstr([dic valueForKey:str])];
        }else{
            returnStr = [NSString stringWithFormat:@"%@%@=%@&400d069a791d51ada8af3e6c2979bcd7",returnStr,str,minstr([dic valueForKey:str])];
        }
    }
    return [[self sharedInstance] md5:returnStr];
}

/**
 设置视图左上圆角
 
 @param leftC 左上半径
 @param rightC 又上半径
 @param view 父视图
 @return layer
 */
- (CAShapeLayer *)setViewLeftTop:(CGFloat)leftC andRightTop:(CGFloat)rightC andView:(UIView *)view{

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(leftC, rightC)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    return maskLayer;
}




#pragma mark - 原图-小-恢复
+(CAAnimation*)bigToSmallRecovery {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 1;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)]];
    animation.values = values;
    return animation;
}


#pragma mark - 以当前时间合成视频名称
+(NSString *)getNameBaseCurrentTime:(NSString *)suf {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *nameStr = [[dateFormatter stringFromDate:[NSDate date]] stringByAppendingString:suf];
    return [NSString stringWithFormat:@"%@_IOS_%@",[KKChatConfig getOwnID],nameStr];
}

+(BOOL)checkNull:(NSString *)str {
    if ([str isEqual:@"<null>"]||[str isEqual:@"(null)"]||[str isKindOfClass:[NSNull class]]||str.length==0) {
        return YES;
    }
    return NO;
}


+ (NSString *)decrypt:(NSString *)code{
    NSString* str = @"-x?8S6Ppl:BW9hKiO5m.IV7FdZzuXgRwyNQ=JsvY_C2eqDEf0T143kbGaAHjnocM/rLtU";
    NSInteger strl = str.length;
    
    NSInteger len = code.length;
    
    NSString* newCode = @"";
    for(int i = 0;i < len; i++){
        NSString *codeIteam = [code substringWithRange:NSMakeRange(i, 1)];
        
        for(int j = 0; j < strl; j++){
            NSString *strIteam = [str substringWithRange:NSMakeRange(j, 1)];
            if([strIteam isEqual:codeIteam]){
                if(j == 0){
                    newCode = [NSString stringWithFormat:@"%@%@",newCode,[str substringWithRange:NSMakeRange(strl - 1, 1)]];
                }else{
                    newCode = [NSString stringWithFormat:@"%@%@",newCode,[str substringWithRange:NSMakeRange(j-1, 1)]];
                }
            }
        }
    }
    return newCode;
}


#pragma mark - 根据色值获取图片
+(UIImage*)getImgWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f,0.0f, 1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//自定义间距上图下文字
+(UIButton*)setUpImgDownText:(UIButton *)btn space:(CGFloat)space {
    
    CGFloat totalH = btn.imageView.frame.size.height + btn.titleLabel.frame.size.height;
    CGFloat spaceH = space;
    //设置按钮图片偏移
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-(totalH - btn.imageView.frame.size.height),0.0, 0.0, -btn.titleLabel.frame.size.width)];
    //设置按钮标题偏移
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(spaceH, -btn.imageView.frame.size.width, -(totalH - btn.titleLabel.frame.size.height),0.0)];
    
    return btn;
}

#pragma mark - 设置上图下文字
+(UIButton*)setUpImgDownText:(UIButton *)btn {
    /*
     多处使用，不要随意更改，
     */
    CGFloat totalH = btn.imageView.frame.size.height + btn.titleLabel.frame.size.height;
    CGFloat spaceH = 5;
    //设置按钮图片偏移
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-(totalH - btn.imageView.frame.size.height),0.0, 0.0, -btn.titleLabel.frame.size.width)];
    //设置按钮标题偏移
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(spaceH, -btn.imageView.frame.size.width, -(totalH - btn.titleLabel.frame.size.height),0.0)];
    
    return btn;
}

+(void)getQCloudWithUrl:(NSString *)url Suc:(networkSuccessBlock)successBlock Fail:(networkFailBlock)failBlock {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        int code = [[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]] intValue];
        NSDictionary *data = [responseObject valueForKey:@"data"];
        NSString *msg = [NSString stringWithFormat:@"%@-%@",[responseObject objectForKey:@"message"],[responseObject objectForKey:@"codeDesc"]];
        //回调
        successBlock(code,data,msg);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD showError:@"网络错误"];
        failBlock();

    }];
    /*
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]] intValue];
        NSDictionary *data = [responseObject valueForKey:@"data"];
        NSString *msg = [NSString stringWithFormat:@"%@-%@",[responseObject objectForKey:@"message"],[responseObject objectForKey:@"codeDesc"]];
        //回调
        successBlock(code,data,msg);
        
    }failure:^(NSURLSessionDataTask *task, NSError *error)     {
        [MBProgressHUD showError:@"网络错误"];
        failBlock();
    }];
     */
}

#pragma mark - 原图-大-小-恢复
+(CAAnimation*)originToBigToSmallRecovery {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)]];
    animation.values = values;
    return animation;
}




/**
 网络请求
 
 @param url 请求的接口名：例：home.gethot
 @param parameter 参数的字典
 @param successBlock 成功的回调
 @param failBlock 失败的回调
 */
+ (void)kk_postNetworkWithUrl:(NSString *)url andParameter:(id)parameter success:(networkSuccessBlock)successBlock fail:(networkFailBlock)failBlock{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];

    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/javascript", @"application/json", @"text/plain", nil];
    session.requestSerializer.timeoutInterval = 60.0f;

    NSString *requestUrl = [kkpurl stringByAppendingFormat:@"%@",url];
    //1.8六道修改
//    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    requestUrl =   [requestUrl stringByAddingPercentEncodingWithAllowedCharacters:[ NSCharacterSet URLQueryAllowedCharacterSet]];
    
    WeakSelf;
    //kk六道第二版修改
    NSMutableDictionary *pDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:minstr([KKChatConfig getOwnID]),@"uid",minstr([KKChatConfig getOwnToken]),@"token", nil];

    [pDic addEntriesFromDictionary:parameter];
    
    MBProgressHUD *hud = [weakSelf hudWithmainView:[UIApplication sharedApplication].keyWindow];

    [session GET:requestUrl parameters:pDic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self kkHudHide:hud];
//        [hud hideAnimated:YE/S];

            if (responseObject) {
                NSString *jsonstr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"sataeCode" options:0 error:nil];
                if (expression) {
                    NSTextCheckingResult *result = [expression firstMatchInString:jsonstr options:0 range:NSMakeRange(0, jsonstr.length)];
                    if (!result) {
                    }
                }
                
                NSData *jsondata = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *jsondic = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:nil];
                NSNumber *number = [jsondic valueForKey:@"ret"];
                if([number isEqualToNumber:[NSNumber numberWithInt:200]])
                {
                    NSArray *data = [jsondic valueForKey:@"data"];
                    int code = [minstr([data valueForKey:@"code"]) intValue];
                    id info = [data valueForKey:@"info"];
                    successBlock(code, info,minstr([data valueForKey:@"msg"]));
                    if (code == 700) {
                        [[YBToolClass sharedInstance] quitLogin];
                        [MBProgressHUD showError:minstr([data valueForKey:@"msg"])];
                    }
                }else{
                    NSArray *data = [jsondic valueForKey:@"data"];
                    [MBProgressHUD showError:minstr([data valueForKey:@"msg"])];
                }
            }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock();
        [NSString kkChangeNetworkURL];

        [self kkHudHide:hud];
    }];
}

#pragma mark -- MBProgressHUD的使用
+ (MBProgressHUD *)hudWithmainView:(UIView *)mainView{
    
    if (mainView == nil) {
        return  nil;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:mainView animated:YES];
    return hud;
    
}
+ (void)kkHudHide:(MBProgressHUD *)hud
{
    if (hud) {
        [hud hideAnimated:YES];
    }
}


+(BOOL)checkDomainIsValid:(NSString*)kkUrl
{
    
        NSURL *url =[NSURL URLWithString:kkUrl];

        NSURLRequest *request =[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];

        NSHTTPURLResponse *response = nil;
        NSError *error =nil;

         [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

        if (response.statusCode== 200) {
            return YES;
        }else{
            return NO;
        }

}



@end
