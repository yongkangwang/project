//
//  NSString+KKObjcSugar.h
//  yunbaolive
//
//  Created by Peter on 2019/12/20.
//  Copyright © 2019 cat. All rights reserved.
//

//#import <AppKit/AppKit.h>


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (KKObjcSugar)

//时间对比，是否是当前时间的最后一条数据
+ (BOOL)isLastDate:(NSString *)lastDate;


//十进制数字转16进制
+(NSString *)ToHex:(long long int)tmpid;


//时间戳--->时分日期 转化为时间格式10:00
+(NSString *)transStringToMinDate:(NSDate *)timsp;


//获取当前准确时间，
+ (NSDate *)getCurrentDate;

///时间转字符串=YYYY/MM/dd hh:mm
+ (NSString *)currentDateStrFromDate:(NSDate *)currentDate;


//时间字符串转时间戳
+ (NSString *)getTimeStrWithString:(NSString *)str;


//时间戳--->时分日期 转化为时间格式10:00
+(NSString *)transToMinDate:(NSString *)timsp;


// 16进制string转NSData
+ (NSData *)convertHexStrToData:(NSString *)str;


//16进制的NSData转化16进制的字符串
+ (NSString *)stringdatastringdata:(NSData *)data;


//获取蓝牙地址，
+ (NSString *)convertToNSStringWithNSData:(NSData *)data;

//秒转时分
+ (NSString *)getMMSSFromSS:(NSInteger )totalTime;



///获取字符串长度
+ (CGRect)stringLenthWithString:(NSString *)string WithSize:(CGSize)size withFontSize:(CGFloat)fontSize;



//获取东八区当前时间
+ (NSDate *)dateCurrentTime;


//获取当前时间戳
+ (NSString *)currentTimeStr;

// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
+ (NSString *)getDateStringWithTimeStr:(NSString *)str;


//切换app域名
+ (void)kkChangeNetworkURL;


//时间转字符串
+ (NSString *)kkTimeFormatted:(int)totalSeconds;


//string，用于数字单位转换，10000转1w
- (NSString *)gk_unitConvert;


//MARK:-动态返回label文字宽度
+(CGSize)kkSizeWithText:(NSString *)text textFont:(UIFont *)font textMaxSize:(CGSize)maxSize;


//后台返回的data类型转string
+(NSString*)kkJSONObjectWithData:(id)kkdata;

//app build
+(NSString*)kkGetLocalAppBuild;

//版本号
+(NSString*)kkgetLocalAppVersion;

// 获取BundleID
+(NSString*)kkgetBundleID;


//判断是否为中文,传入的必须全部是中文才行，不能有逗号数字等其他字符
+ (BOOL)kk_isChinese:(NSString *)str;


//字符串加密
+ (NSString *)kkStringToMD5:(NSString *)kkstring;

//jsons字符串转字典
+ (NSDictionary *)kkDictionaryWithJsonDic:(NSString *)jsonStr;

//Double 转string
+ (NSString *)kk_StringWithDouble:(double)object;


//字符串判空
+ (NSString *)kk_isNullString:(id)object;
//如果后台返回空，就会报错，需要确定对象是string，才可以调用这个方法
- (NSString *)kk_isNullString;

//截取字符串
+ (NSString *)kkStringIntercept:(NSString *)kkStr subStringFrom:(NSString *)startString to:(NSString *)endString;

//字符串判空
+ (BOOL)isNullObject:(id)object;


//H5url拼接uid和token
+(NSString *)kk_AppendH5URL:(NSString *)url;

//数字除以一万转字符串，
+(NSString *)kk_stringWithStringNum:(NSString *)String;

//验证手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

//+ (NSURL *)sc_URLWithString:(NSString *)URLString;

/*
 String :要计算的字符串
 fontSize : 字符串的文字大小
 rectSizeRate :可在的区域宽度相对于屏幕宽的比率
 */
///返回String字符串所占用的bounds
+(CGRect)kk_stringBoundsWithTitleString:(NSString *)String andFontOfSize:(CGFloat)fontSize  rectSizeRate:(CGFloat)rectSizeRate;

//字符串判空
+ (BOOL)kk_isEmptyString:(NSString *)string;

//字典转jsonstring
+(NSString*)convertToJsonData:(NSDictionary*)dict;
/**
 *  返回当前时间
 *
 *  @return <#return value description#>
 *
 *isDate   是否只显示日期不显示时间，YES只显示日期，
 */
+ (NSString *)getTimeNowWithDate:(BOOL)isDate;


+ (NSString *)kkJsonStringWithDictionary:(NSMutableDictionary *)kkdic;

//获取机型
+ (NSString *)kkgetDeviceModel;

@end

NS_ASSUME_NONNULL_END
