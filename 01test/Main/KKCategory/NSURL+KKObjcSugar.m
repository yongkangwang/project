//
//  NSURL+KKObjcSugar.m
//  yunbaolive
//
//  Created by Peter on 2020/1/7.
//  Copyright © 2020 cat. All rights reserved.
//

#import "NSURL+KKObjcSugar.h"

#import <objc/runtime.h>


@implementation NSURL (KKObjcSugar)



+ (void)load {
    /*
     self:UIImage
     谁的事情,谁开头 1.发送消息(对象:objc) 2.注册方法(方法编号:sel) 3.交互方法(方法:method) 4.获取方法(类:class)
     Method:方法名

     获取方法,方法保存到类
     Class:获取哪个类方法
     SEL:获取哪个方法
     imageName
     */
    // 获取imageName:方法的地址
    Method URLWithStringMethod = class_getClassMethod(self, @selector(URLWithString:));

    // 获取sc_imageWithName:方法的地址
    Method sc_URLWithStringMethod = class_getClassMethod(self, @selector(sc_URLWithString:));

    // 交换方法地址，相当于交换实现方式2
    method_exchangeImplementations(URLWithStringMethod, sc_URLWithStringMethod);

}


+ (NSURL *)sc_URLWithString:(NSString *)URLString {

//    NSString *newURLString = [self IsChinese:URLString];
    NSString *newURLString = [self kkIsImageURL:URLString];

    return [NSURL sc_URLWithString:newURLString];
}

+ (NSString *)kkIsImageURL:(NSString *)string
{
    //是否包含某个字符，
    if ([string containsString:@"png"]||
        [string containsString:@"jpeg"]||
        [string containsString:@"gif"]||
        [string containsString:@"tiff"]||
        [string containsString:@"RIFF"]||
        [string containsString:@"WEBP"]||
        [string containsString:@"webp"]||
        [string containsString:@"jpg"]||
        [string containsString:@"mp4"]
        ) {
        //是后缀.png之类图片
        NSString *newString = string;

        for(int i=0; i< [string length];i++){
               int a = [string characterAtIndex:i];
               if( a > 0x4e00 && a < 0x9fff)
               {//有中文好像不进到这里边
                   NSString *oldString = [string substringWithRange:NSMakeRange(i, 1)];
                   NSString *string = [oldString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

                   newString = [newString stringByReplacingOccurrencesOfString:oldString withString:string];
               } else{

               }
           }
        NSCharacterSet *queryAllowCharacterSet = [NSCharacterSet URLQueryAllowedCharacterSet];
        NSMutableCharacterSet *mSet = [queryAllowCharacterSet mutableCopy];
        [mSet addCharactersInString:@"%"];//解决中文问题
        return  [newString stringByAddingPercentEncodingWithAllowedCharacters:mSet];

//        return  [newString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

        //        return newString;
    }else{
        return string;
    }
}


//判断是否有中文
+ (NSString *)IsChinese:(NSString *)str {

    if ([self kk_isImageWithString:str]) {
        //是后缀.png之类图片
        NSString *newString = str;

        for(int i=0; i< [str length];i++){
               int a = [str characterAtIndex:i];
               if( a > 0x4e00 && a < 0x9fff)
               {//有中文好像不进到这里边
                   NSString *oldString = [str substringWithRange:NSMakeRange(i, 1)];
                   NSString *string = [oldString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

                   newString = [newString stringByReplacingOccurrencesOfString:oldString withString:string];
               } else{

               }
           }
        return newString;

    }else{
        //    这个方法是用来解决腾讯云存储图片剪辑问题的,   无法解析中文
//        这个方法会导致支付宝订单信息被编码，调不起支付页面
        return  [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
}
//判断是否为图片
+ (BOOL)kk_isImageWithString:(NSString *)str
{
    //带中文的会显示为不是图片
//    NSString *imgStr =str.lowercaseString;//这个方法不行
    NSString *imgStr = [str pathExtension];//这个方法会截取出后缀

    if (  [imgStr isEqualToString:@"png"]
        ||[imgStr isEqualToString:@"jpeg"]
        ||[imgStr isEqualToString:@"gif"]
        ||[imgStr isEqualToString:@"tiff"]
        ||[imgStr isEqualToString:@"RIFF"]
        ||[imgStr isEqualToString:@"WEBP"]
        ||[imgStr isEqualToString:@"webp"]
        ||[imgStr isEqualToString:@"jpg"]
        ||[imgStr isEqualToString:@"mp4"]) {

//    解决视频播放有中文的问题    ||[imgStr isEqualToString:@"mp4"]
           //是图片
        return YES;
    }else{
        return NO;
    }
}

//通过图片Data数据第一个字节 来获取图片扩展名,暂时不用
+ (NSString *)contentTypeForImageData:(NSData *)data {
        uint8_t c;
        [data getBytes:&c length:1];
        switch (c) {
            case 0xFF:
                return @"jpeg";
            case 0x89:
                return @"png";
            case 0x47:
                return @"gif";
            case 0x49:
            case 0x4D:
                return @"tiff";
            case 0x52:
                if ([data length] < 12) {
                    return nil;
                }
                NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
                if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                    return @"webp";
                }
                return nil;
        }
        return nil;
}

@end
