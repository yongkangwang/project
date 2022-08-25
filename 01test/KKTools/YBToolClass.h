//
//  YBToolClass.h
//  yunbaolive
//
//  Created by Boom on 2018/9/19.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^networkSuccessBlock)(int code,id info,NSString *msg);
typedef void (^networkFailBlock)();
@interface YBToolClass : NSObject
/**
 单例类方法
 
 @return 返回一个共享对象
 */
+ (instancetype)sharedInstance;

/**
 设置视图四周圆角
 */
- (CAShapeLayer *)kkSetViewCornerRadius:(CGFloat)num fromView:(UIView *)view;


/**
 网络请求成功的回调
 */
@property(nonatomic,copy)networkSuccessBlock successB;
/**
 网络请求失败的回调
 */
@property(nonatomic,copy)networkFailBlock failB;

/**
 网络请求

 @param url 请求的接口名：例：home.gethot
 @param parameter 参数的字典
 @param successBlock 成功的回调
 @param failBlock 失败的回调
 */
+ (void)postNetworkWithUrl:(NSString *)url andParameter:(nullable id)parameter success:(networkSuccessBlock)successBlock fail:(networkFailBlock)failBlock;

/**
 计算字符串宽度

 @param str 字符串
 @param font 字体
 @param height 高度
 @return 宽度
 */
- (CGFloat)widthOfString:(NSString *)str andFont:(UIFont *)font andHeight:(CGFloat)height;
+ (CGFloat)widthOfString:(NSString *)str andFont:(UIFont *)font andHeight:(CGFloat)height;

/**
 计算字符串的高度

 @param str 字符串
 @param font 字体
 @param width 宽度
 @return 高度
 */
- (CGFloat)heightOfString:(NSString *)str andFont:(UIFont *)font andWidth:(CGFloat)width;
/**
 画一条线
 
 @param frame 线frame
 @param color 线的颜色
 @param view 父View
 */
- (void)lineViewWithFrame:(CGRect)frame andColor:(UIColor *)color andView:(UIView *)view;

/**
 MD5加密

 @param input 要加密的字符串
 @return 加密好的字符串
 */
- (NSString *) md5:(NSString *) input;

/**
 比较两个时间的大小

 @param date01 老的时间
 @param date02 新的时间
 @return 返回 1 -1 0
 */
-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02;

/**
 创建emoji正则表达式

 @param pattern 正则规则
 @param str 字符串
 @return 数组
 */
- (NSArray <NSTextCheckingResult *> *)machesWithPattern:(NSString *)pattern  andStr:(NSString *)str;

-(void)quitLogin;


//=======================================================================
//kk六道第二版添加
/**
 字典字符串加密排序

 @param dic 参数
 @return 加密好的字符串
 */
+ (NSString *)sortString:(NSDictionary *)dic;


/**
 设置视图左上圆角

 @param leftC 左上半径
 @param rightC 又上半径
 @param view 父视图
 @return layer
 */
- (CAShapeLayer *)setViewLeftTop:(CGFloat)leftC andRightTop:(CGFloat)rightC andView:(UIView *)view;





/** 原图-小-恢复 */
+(CAAnimation*)bigToSmallRecovery;

#pragma mark - 以当前时间合成视频名称
+(NSString *)getNameBaseCurrentTime:(NSString *)suf;

+(BOOL)checkNull:(NSString *)str ;

/**
 解密字符串
 
 @param code 待解密的字符串
 @return 解密完成的字符串
 */
+ (NSString *)decrypt:(NSString *)code;


/** 根据色值获取图片 */
+(UIImage*)getImgWithColor:(UIColor *)color;

/** 自定义间距上图下文字 */
+(UIButton*)setUpImgDownText:(UIButton *)btn space:(CGFloat)space;
/** 设置上图下文字 */
+(UIButton*)setUpImgDownText:(UIButton *)btn;

+(void)getQCloudWithUrl:(NSString *)url Suc:(networkSuccessBlock)successBlock Fail:(networkFailBlock)failBlock;

/** 原图-大-小-恢复 */
+(CAAnimation*)originToBigToSmallRecovery;




/**
网络请求
kk六道第二版云豹接口
@param url 请求的接口名：例：home.gethot
@param parameter 参数的字典
@param successBlock 成功的回调
@param failBlock 失败的回调
*/

+ (void)kk_postNetworkWithUrl:(NSString *)url andParameter:(nullable id)parameter success:(networkSuccessBlock)successBlock fail:(networkFailBlock)failBlock;


//检查域名是否可以访问，2.8.1六道
+(BOOL)checkDomainIsValid:(NSString*)kkUrl;

@end

NS_ASSUME_NONNULL_END
