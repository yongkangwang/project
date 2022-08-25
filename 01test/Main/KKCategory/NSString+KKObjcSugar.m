//
//  NSString+KKObjcSugar.m
//  yunbaolive
//
//  Created by Peter on 2019/12/20.
//  Copyright © 2019 cat. All rights reserved.
//

#import "NSString+KKObjcSugar.h"

//#import <AppKit/AppKit.h>
#import <CommonCrypto/CommonCrypto.h>
#import <sys/utsname.h>


@implementation NSString (KKObjcSugar)





//时间对比，是否是当前时间的最后一条数据
+ (BOOL)isLastDate:(NSString *)lastDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm"];//设定时间格式,这里可以设置成自己需要的格式
    NSDate *lastD = [dateFormatter dateFromString:lastDate];
    
    NSString *currentDateString = [NSString currentDateStrFromDate:[NSDate date]];//将时间转化成字符串
    NSDate *currentDate = [dateFormatter dateFromString:currentDateString];

    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:currentDate] integerValue];
    NSInteger lastDYear=[[formatter stringFromDate:lastD] integerValue];

    [formatter setDateFormat:@"hh"];
    NSInteger currenth=[[formatter stringFromDate:currentDate]integerValue];
    NSInteger lastDh=[[formatter stringFromDate:lastD] integerValue];

    [formatter setDateFormat:@"mm"];
    NSInteger currentM=[[formatter stringFromDate:currentDate] integerValue];
    NSInteger lastDm=[[formatter stringFromDate:lastD] integerValue];

    if (currentYear != lastDYear) {
        return NO;
    }
    if (currenth != lastDh) {
        return NO;
    }
    if (currentM-lastDm<=1) {
        return YES;
    }else{
        return NO;
    }

}


 //将十进制转化为十六进制
+(NSString *)ToHex:(long long int)tmpid
 {
     NSString * result = [NSString stringWithFormat:@"%llx",tmpid];
        return [result uppercaseString];

     
     NSString *nLetterValue;
     NSString *str =@"";
     long long int ttmpig;
     for (int i = 0; i<9; i++) {
         ttmpig=tmpid%16;
         tmpid=tmpid/16;
         switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                 nLetterValue =@"F";break;
             default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];

         }
         str = [nLetterValue stringByAppendingString:str];
         if (tmpid == 0) {
             break;
         }

     }
     str = [NSString stringWithFormat:@"0%@",str];//少个0好像不行
     return str;
 }


//时间戳--->时分日期 转化为时间格式10:00
+(NSString *)transStringToMinDate:(NSDate *)timsp
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"hh:mm"];//设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];//设置本地时区
    NSString *dateString = [dateFormatter stringFromDate:timsp];//将时间转化成字符串
    return dateString;
}


+ (NSDate *)getCurrentDate
{
    NSDate *date = [NSDate date]; // 获得时间对象
     
//    NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得系统的时区
    NSTimeZone *zone = [NSTimeZone localTimeZone];//    // 获取本地时区

    NSTimeInterval time = [zone secondsFromGMTForDate:date];// 以秒为单位返回当前时间与系统格林尼治时间的差
    NSDate *dateNow = [date dateByAddingTimeInterval:time];
    return dateNow;
}

+ (NSString *)currentDateStrFromDate:(NSDate *)currentDate{
//    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm"];//设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];//设置本地时区
    NSString *dateString = [dateFormatter stringFromDate:currentDate];//将时间转化成字符串
    return dateString;
}


+ (NSString *)getTimeStrWithString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]*1000];//字符串转成时间戳,精确到毫秒*1000
    return timeStr;
}

+(NSString *)transToMinDate:(NSString *)timsp{
    NSTimeInterval time=[timsp doubleValue];//如果不使用本地时区,因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];//设置本地时区
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
    
    // 获取系统时区
//    NSTimeZone *zone1 = [NSTimeZone systemTimeZone];
//    // 获取本地时区
//    NSTimeZone *zone2 = [NSTimeZone localTimeZone];
//    // 获取默认时区
//    NSTimeZone *zone3 = [NSTimeZone defaultTimeZone];
}


// 16进制转NSData
+ (NSData *)convertHexStrToData:(NSString *)str
{
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}




//16进制的NSData转化16进制的字符串
+ (NSString *)stringdatastringdata:(NSData *)data
{
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];

    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {

    unsigned char *dataBytes = (unsigned char*)bytes;

    for (NSInteger i = 0; i < byteRange.length; i++) {

    NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];

    if ([hexStr length] == 2) {

    [string appendString:hexStr];

    } else {

    [string appendFormat:@"0%@", hexStr];

    }

    }

    }];
    return string;
    
}


///
+ (NSString *)convertToNSStringWithNSData:(NSData *)data
{
NSMutableString *strTemp = [NSMutableString stringWithCapacity:[data length]*2];

const unsigned char *szBuffer = [data bytes];

for (NSInteger i=0; i < [data length]; ++i) {

[strTemp appendFormat:@"%02lx",(unsigned long)szBuffer[i]];

}

return strTemp;
}

//传入 秒  得到 xx:xx:xx
+ (NSString *)getMMSSFromSS:(NSInteger )totalTime
{

    NSInteger seconds = totalTime;

    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
//    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_hour,str_minute];

    return format_time;

}


//字符串长度
+ (CGRect)stringWithString:(NSString *)string WithSize:(CGSize)size withFontSize:(CGFloat)fontSize {
    return [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:fontSize] } context:nil];
}


//获取当前时间
+ (NSDate *)dateCurrentTime
{
    
    //    NSTimeZone *zone2 = [NSTimeZone localTimeZone];

    NSDate *date1 = [NSDate dateWithTimeIntervalSinceNow:8 * 60 * 60];

    return date1;
    //1.获取当前时间 零时区的时间
//        NSDate *date = [NSDate date];
//        NSLog(@"当前零时区时间 %@", date);
//
//        //2.获得本地时间 东八区 晚八个小时 以秒计时
//        NSDate *date1 = [NSDate dateWithTimeIntervalSinceNow:8 * 60 * 60];
//        NSLog(@"今天此时的时间 %@",date1);
        
}

//获取当前时间戳
+ (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;//*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
+ (NSString *)getDateStringWithTimeStr:(NSString *)str{
    NSTimeInterval time=[str doubleValue]/1000;///1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss SS"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}



+ (void)kkChangeNetworkURL
{
    NSString *urlType = [KKUserDefaults valueForKey:kkCacheNetworkURLType];
    
//    if ([urlType isEqualToString:@""] || [urlType isEqualToString:@"1"]) {
//        [KKUserDefaults setValue:kkTwoHDNetworkURL forKey:KKLoginNetworkStr];
//        [KKUserDefaults setValue:kkTwoHLNetworkURL forKey:KKLoginNetwork1V1Str];
//        [KKUserDefaults setValue:@"2" forKey:kkCacheNetworkURLType];
//    }else if ([urlType isEqualToString:@"2"]){
//        [KKUserDefaults setValue:kkThreeHDNetworkURL forKey:KKLoginNetworkStr];
//        [KKUserDefaults setValue:kkThreeHLNetworkURL forKey:KKLoginNetwork1V1Str];
//        [KKUserDefaults setValue:@"3" forKey:kkCacheNetworkURLType];
//
//    }else if ([urlType isEqualToString:@"3"]){
//        [KKUserDefaults setValue:kkOneHDNetworkURL forKey:KKLoginNetworkStr];
//        [KKUserDefaults setValue:kkOneHLNetworkURL forKey:KKLoginNetwork1V1Str];
//        [KKUserDefaults setValue:@"1" forKey:kkCacheNetworkURLType];
//
//    }
    
}

//时间转字符串
+ (NSString *)kkTimeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    if (hours == 0) {
        return [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
    }else{
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    }
}

- (NSString *)gk_unitConvert {
    float value = self.floatValue;
    
    if (value < 0) value = 0;
    
    if (value >= 10000) {
        if (value >= 100000000) {
            return [NSString stringWithFormat:@"%.1f亿",value / 100000000.0f];
        }
        return [NSString stringWithFormat:@"%.1fw",value / 10000.0f];
    }
    
    return [self isEqualToString:@""] ? @"0" : self;
}


//MARK:-动态返回label文字宽度
+(CGSize)kkSizeWithText:(NSString *)text textFont:(UIFont *)font textMaxSize:(CGSize)maxSize {
    // 计算文字时要几号字体
    NSDictionary *attr = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
}



+(NSString*)kkJSONObjectWithData:(id)kkdata

{
    NSString *jsonstr = [[NSString alloc]initWithData:kkdata encoding:NSUTF8StringEncoding];
    //开屏广告能解析，登录接口无法解析
//    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"sataeCode" options:0 error:nil];
//    if (expression) {
//        NSTextCheckingResult *result = [expression firstMatchInString:jsonstr options:0 range:NSMakeRange(0, jsonstr.length)];
//        if (!result) {
//        }
//    }
//    NSData *jsondata = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *kkjsonStr = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:nil];
    return jsonstr;
}
+(NSString*)kkGetLocalAppBuild
{
    NSNumber *app_build =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *build = [NSString stringWithFormat:@"%@",app_build];
    return build;
}

+(NSString*)kkgetLocalAppVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

// 获取BundleID
+(NSString*)kkgetBundleID
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}


+ (BOOL)kk_isChinese:(NSString *)str
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:str];
}


+ (NSString *)kkStringToMD5:(NSString *)str
{
    
    //1.首先将字符串转换成UTF-8编码, 因为MD5加密是基于C语言的,所以要先把字符串转化成C语言的字符串
    const char *fooData = [str UTF8String];
    
    //2.然后创建一个字符串数组,接收MD5的值
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    //3.计算MD5的值, 这是官方封装好的加密方法:把我们输入的字符串转换成16进制的32位数,然后存储到result中
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);
    /**
     第一个参数:要加密的字符串
     第二个参数: 获取要加密字符串的长度
     第三个参数: 接收结果的数组
     */
    
    //4.创建一个字符串保存加密结果
    NSMutableString *saveResult = [NSMutableString string];
    
    //5.从result 数组中获取加密结果并放到 saveResult中
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02x", result[i]];
    }
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
    return saveResult;
}



+ (NSDictionary *)kkDictionaryWithJsonDic:(id)jsonStr
{
    NSString *jsonstr = [[NSString alloc]initWithData:jsonStr encoding:NSUTF8StringEncoding];
    //开屏广告能解析，登录接口无法解析
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"sataeCode" options:0 error:nil];
    if (expression) {
        NSTextCheckingResult *result = [expression firstMatchInString:jsonstr options:0 range:NSMakeRange(0, jsonstr.length)];
        if (!result) {
        }
    }
    
    NSData *jsondata = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsondic = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:nil];
    return jsondic;
}


//Double 转string
+ (NSString *)kk_StringWithDouble:(double)object
{
    
    NSString *dStr      = [NSString stringWithFormat:@"%f", object];
    return dStr;
//    NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:dStr];
//    return  [dn stringValue];
}


//字符串判空
+ (NSString *)kk_isNullString:(id)object
{
    if (object == nil
        ||[object isEqual:[NSNull null]]
        || [object isKindOfClass:[NSNull class]]
        || [object isEqual:@"<null>"]
        || [object isEqual:@"null"]
        || [object isEqual:@"nil"]
        || [object isEqual:@"(nil)"]
        || [object isEqual:@"(null)"]

        )
    {
        return @"";
    }else if ([object isKindOfClass:[NSNumber class]]){
        return [NSString stringWithFormat:@"%@",object];
    }else{
        return object;
    }
}
- (NSString *)kk_isNullString
{
    if (self == nil
        ||[self isEqual:[NSNull null]]
        || [self isKindOfClass:[NSNull class]]
        || [self isEqual:@"<null>"]
        || [self isEqual:@"null"]
        || [self isEqual:@"nil"]
        || [self isEqual:@"(nil)"]
        || [self isEqual:@"(null)"]

        )
    {
        return @"";
    }else if ([self isKindOfClass:[NSNumber class]]){
        return [NSString stringWithFormat:@"%@",self];
    }else{
        return self;
    }
}


+ (NSString *)kkStringIntercept:(NSString *)kkStr subStringFrom:(NSString *)startString to:(NSString *)endString{
NSRange startRange = [kkStr rangeOfString:startString];
NSRange endRange = [kkStr rangeOfString:endString];
NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
return [kkStr substringWithRange:range];
}


+ (BOOL) isNullObject:(id)object
{
    if (object == nil
        ||[object isEqual:[NSNull null]] ) {
        
        return YES;
    }else if ([object isKindOfClass:[NSNull class]])
    {
        if ([object isEqualToString:@""]) {
            return YES;
            
        }else
        {
            return NO;
            
        }
        
    }else if ([object isKindOfClass:[NSNumber class]])
    {
        if ([object isEqualToNumber:@0]) {
            return YES;
            
        }else
        {
            return NO;
            
        }
        
    }
    return NO;
}


+(NSString *)kk_AppendH5URL:(NSString *)url{
//    return [url stringByAppendingFormat:@"&uid=%@&cimc_user_token=%@",[KKChatConfig getOwnID],[KKChatConfig getOwnToken]];
//    return [url stringByAppendingFormat:@"&uid=%@&cimc_user_token=%@&cimc_notice_deviceid=%@",[KKChatConfig getOwnID],[KKChatConfig getOwnToken],[KKChatConfig getcimc_device_id]];
    return [url stringByAppendingFormat:@"&uid=%@&cimc_user_token=%@&cimc_notice_deviceid=%@&systemtype=%@&temperaturetype=%d",[KKChatConfig getOwnID],[KKChatConfig getOwnToken],[KKChatConfig getcimc_device_id],@"ios",[KKChatConfig getcimc_device_temperaturetype]];

    
    
    return url;
}


+(NSString *)kk_stringWithStringNum:(NSString *)String
{
   CGFloat  kkstrNum = [String integerValue]/10000;
    if (kkstrNum >= 1) {
        return  [NSString stringWithFormat:@"%.1f",kkstrNum];
    }else{
        return  String;
    }
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
        NSString * MOBILE = @"^1(3[0-9])\\d{8}$";
    //移动
//    NSString * CM = @"^1(5[0-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|3[5-9]|47|5[0127-9]|8[23478]|98)\\d{8}$";

    //联通
//    NSString * CU = @"^1(8[0-9])\\d{8}$";
    NSString * CU = @"^1((3[0-2]|45|5[56]|166|7[56]|8[56]))\\d{8}$";

    //电信
//    NSString * CT = @"^1(4[0-9])\\d{8}$";
    NSString * CT = @"^1((33|49|53|7[37]|8[019]|9[19]))\\d{8}$";
    
    NSString * CL = @"^1(7[03678])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestcl = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CL];
    BOOL res1 = [regextestmobile evaluateWithObject:mobileNum];
    BOOL res2 = [regextestcm evaluateWithObject:mobileNum];
    BOOL res3 = [regextestcu evaluateWithObject:mobileNum];
    BOOL res4 = [regextestct evaluateWithObject:mobileNum];
    BOOL res5 = [regextestcl evaluateWithObject:mobileNum];
    
    if (res1 || res2 || res3 || res4 || res5)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    

     //    NSString *regexStr = @"^1[3,8]\\d{9}|14[5,7,9]\\d{8}|15[^4]\\d{8}|17[^2,4,9]\\d{8}$";
//    NSError *error;
//    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
//    if (error) return NO;
//    NSInteger count = [regular numberOfMatchesInString:mobileNum options:NSMatchingReportCompletion range:NSMakeRange(0, mobileNum.length)];
//    if (count > 0) {
//        return YES;
//    } else {
//        return NO;
//    }

}
+(CGRect)kk_stringBoundsWithTitleString:(NSString *)String andFontOfSize:(CGFloat)fontSize  rectSizeRate:(CGFloat)rectSizeRate{
    
    if (rectSizeRate == 0) {
        rectSizeRate = 0.5;
    }
    
    //获取文字字符串
    NSString *titleString = String;
    //设置文字的属性
    NSDictionary *stringAttribute = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]};
    //获取文字的bounds
    CGRect bound =  [titleString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width * rectSizeRate, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:stringAttribute context:nil];
   
//    CGSize kklabSize  = [kkuserNameStr
//    boundingRectWithSize:CGSizeMake(MAXFLOAT, 15)
//    options:NSStringDrawingUsesLineFragmentOrigin
//    attributes:@{NSFontAttributeName:KKPhoenFont}
//    context:nil].size;

    //返回文字的bounds
    return  bound;
}


+ (BOOL)kk_isEmptyString:(NSString *)string {
    if (!string) {    //等价于if(string == ni||string == NULL)
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {//后台的数据可能是NSNull
        return YES;
    }
    if ([string isEqualToString:@"<null>"]) {
         return YES;
    }
    if (!string.length) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:set];
    if (!trimmedString.length) {
//    存在一些空格或者换行
        return YES;
    }
    
    return NO;
}

//字典转jsonstring
+(NSString*)convertToJsonData:(NSDictionary*)dict
{
    NSError*error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString*jsonString;
    if(!jsonData) {
//        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}


/**
 *  返回当前时间
 *
 *  @return <#return value description#>
 *
 *isDate   是否只显示日期不显示时间，YES只显示日期，
 */
+ (NSString *)getTimeNowWithDate:(BOOL)isDate
{
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    if (isDate) {
        [formatter setDateFormat:@"YYYY-MM-dd"];
    }else{
        [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    }
    date = [formatter stringFromDate:[NSDate date]];
    //取出个随机数
    int last = arc4random() % 10000;
    NSString *timeNow;
    if (isDate) {
        timeNow  = [[NSString alloc] initWithFormat:@"%@", date];
    }else{
        timeNow  = [[NSString alloc] initWithFormat:@"%@%i", date,last];
    }
    return timeNow;
}


+ (NSString *)kkJsonStringWithDictionary:(NSMutableDictionary *)kkdic
{
    NSError *error = nil;
    NSData *jsonData = nil;
    if (!self) {
        return nil;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [kkdic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *keyString = nil;
        NSString *valueString = nil;
        if ([key isKindOfClass:[NSString class]]) {
            keyString = key;
        }else{
            keyString = [NSString stringWithFormat:@"%@",key];
        }

        if ([obj isKindOfClass:[NSString class]]) {
            valueString = obj;
        }else{
            valueString = [NSString stringWithFormat:@"%@",obj];
        }

        [dict setObject:valueString forKey:keyString];
    }];
    jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] == 0 || error != nil) {
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;

}

+ (NSString *)kkgetDeviceModel
{
    struct utsname

       systemInfo;



       uname(&systemInfo);



       NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];

    
       if ([platform isEqualToString:@"i386"]) return @"iPhone Simulator";


       if ([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";



       //TODO:iPhone//2020年10月14日，新款iPhone 12 mini、12、12 Pro、12 Pro Max发布



       if ([platform isEqualToString:@"iPhone13,1"]) return @"iPhone 12 mini";



       if ([platform isEqualToString:@"iPhone13,2"]) return @"iPhone 12";



       if ([platform isEqualToString:@"iPhone13,3"]) return @"iPhone 12 Pro";



       if ([platform isEqualToString:@"iPhone13,4"]) return @"iPhone 12 Pro Max";



       //2020年4月15日，新款iPhone SE发布

       if ([platform isEqualToString:@"iPhone12,8"]) return @"iPhone SE 2020";



       //2019年9月11日，第十四代iPhone 11，iPhone 11 Pro，iPhone 11 Pro Max发布

       if ([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";



       if ([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";



       if ([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";



       //2018年9月13日，第十三代iPhone XS，iPhone XS Max，iPhone XR发布

       if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";



       if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";



       if ([platform isEqualToString:@"iPhone11,4"]) return @"iPhone XS Max";

       if ([platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";



       //2017年9月13日，第十二代iPhone 8，iPhone 8 Plus，iPhone X发布



       if ([platform isEqualToString:@"iPhone10,1"])return @"iPhone 8";



       if ([platform isEqualToString:@"iPhone10,4"])return @"iPhone 8";



       if ([platform isEqualToString:@"iPhone10,2"])return @"iPhone 8 Plus";



       if ([platform isEqualToString:@"iPhone10,5"])return @"iPhone 8 Plus";



       if ([platform isEqualToString:@"iPhone10,3"])return @"iPhone X";



       if ([platform isEqualToString:@"iPhone10,6"])return @"iPhone X";



       /*2007年1月9日，第一代iPhone 2G发布；

        2008年6月10日，第二代iPhone 3G发布 [1]；

        2009年6月9日，第三代iPhone 3GS发布 [2]；

        2010年6月8日，第四代iPhone 4发布；

        2011年10月4日，第五代iPhone 4S发布；

        2012年9月13日，第六代iPhone 5发布；

        2013年9月10日，第七代iPhone 5C及iPhone 5S发布；

        2014年9月10日，第八代iPhone 6及iPhone 6 Plus发布；

        2015年9月10日，第九代iPhone 6S及iPhone 6S Plus发布；

        2016年3月21日，第十代iPhone SE发布；

        2016年9月8日，第十一代iPhone 7及iPhone 7 Plus发布；

        */

       if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";

       if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";

       if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";

       if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";

       if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";

       if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";

       if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";

       if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";

       if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";

       if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";

       if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";

       if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";

       if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";

       if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";

       if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";

       if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s (A1633/A1688/A1691/A1700)";

       if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus (A1634/A1687/A1690/A1699)";

       if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE (A1662/A1723/A1724)";

       if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7 (A1660/A1779/A1780)";

       if ([platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7 (A1778)";

       if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus (A1661/A1785/A1786)";

       if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus (A1784)";



       //TODO:iPod

       if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";

       if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";

       if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";

       if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";

       if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch (5 Gen)";

       if ([platform isEqualToString:@"iPod7,1"]) return @"iPod touch (6th generation)";



       //2019年5月发布，更新一种机型：iPod touch (7th generation)

       if ([platform isEqualToString:@"iPod9,1"]) return @"iPod touch (7th generation)";





       //TODO:iPad

       if([platform isEqualToString:@"iPad1,1"])return@"iPad 1G";

       if([platform isEqualToString:@"iPad2,1"])return@"iPad 2";

       if([platform isEqualToString:@"iPad2,2"])return@"iPad 2";

       if([platform isEqualToString:@"iPad2,3"])return@"iPad 2";

       if([platform isEqualToString:@"iPad2,4"])return@"iPad 2";

       if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";

       if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";

       if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";

       if([platform isEqualToString:@"iPad3,1"])return@"iPad 3";

       if([platform isEqualToString:@"iPad3,2"])return@"iPad 3";

       if([platform isEqualToString:@"iPad3,3"])return@"iPad 3";

       if([platform isEqualToString:@"iPad3,4"])return@"iPad 4";

       if([platform isEqualToString:@"iPad3,5"])return@"iPad 4";

       if([platform isEqualToString:@"iPad3,6"])return@"iPad 4";

       if([platform isEqualToString:@"iPad4,1"])return@"iPad Air";

       if([platform isEqualToString:@"iPad4,2"])return@"iPad Air";

       if([platform isEqualToString:@"iPad4,3"])return@"iPad Air";

       if ([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";

       if ([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";

       if ([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";

       if ([platform isEqualToString:@"iPad4,7"]) return @"iPad Mini 3";

       if ([platform isEqualToString:@"iPad4,8"]) return @"iPad Mini 3";

       if ([platform isEqualToString:@"iPad4,9"]) return @"iPad Mini 3";

       if ([platform isEqualToString:@"iPad5,1"]) return @"iPad Mini 4";

       if ([platform isEqualToString:@"iPad5,2"]) return @"iPad Mini 4";

       if ([platform isEqualToString:@"iPad5,3"]) return @"iPad Air 2";

       if ([platform isEqualToString:@"iPad5,4"]) return @"iPad Air 2";

       if ([platform isEqualToString:@"iPad6,3"]) return @"iPad Pro 9.7";

       if ([platform isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7";

       if ([platform isEqualToString:@"iPad6,7"]) return @"iPad Pro 12.9";

       if ([platform isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9";

       if ([platform isEqualToString:@"iPad6,11"]) return @"iPad 5 (WiFi)";

       if ([platform isEqualToString:@"iPad6,12"]) return @"iPad 5 (Cellular)";

       if ([platform isEqualToString:@"iPad7,1"]) return @"iPad Pro 12.9 inch 2nd gen (WiFi)";

       if ([platform isEqualToString:@"iPad7,2"]) return @"iPad Pro 12.9 inch 2nd gen (Cellular)";

       if ([platform isEqualToString:@"iPad7,3"]) return @"iPad Pro 10.5 inch (WiFi)";

       if ([platform isEqualToString:@"iPad7,4"]) return @"iPad Pro 10.5 inch (Cellular)";


       //2019年3月发布，更新二种机型：iPad mini、iPad Air

       if ([platform isEqualToString:@"iPad11,1"]) return @"iPad mini (5th generation)";

       if ([platform isEqualToString:@"iPad11,2"]) return @"iPad mini (5th generation)";

       if ([platform isEqualToString:@"iPad11,3"]) return @"iPad Air (3rd generation)";

       if ([platform isEqualToString:@"iPad11,4"]) return @"iPad Air (3rd generation)";

       return platform;

}
@end
