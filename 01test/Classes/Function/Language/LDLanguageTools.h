//
//  LDLanguageTools.h
//  Thermometer
//
//  Created by Peter on 2022/2/24.
//

#import <Foundation/Foundation.h>

//中文
#define ZH_CN @"zh-Hans"
//当前设置的本地化语言
#define CurrentLanguage @"CurrentLanguage"
//获取相应的语言
#define LDMsg(key) [[LDLanguageTools shareInstance] getStringForKey:key withTable:@"LanguageLocalizable"]


NS_ASSUME_NONNULL_BEGIN

@interface LDLanguageTools : NSObject

+(id)shareInstance;
/**
 *  返回table中指定的key的值
 *
 *  @param key   key
 *  @param table table
 *
 *  @return 返回table中指定的key的值
 */
-(NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table;
/**
 *  重置语言
 *
 *  @param language 新语言
 */
-(void)resetLanguage:(NSString*)language withFrom:(NSString *)appdelegate;

@end

NS_ASSUME_NONNULL_END
