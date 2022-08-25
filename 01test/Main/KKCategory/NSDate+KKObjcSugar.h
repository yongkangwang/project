//
//  NSDate+KKObjcSugar.h
//  yunbaolive
//
//  Created by Peter on 2021/3/11.
//  Copyright © 2021 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (KKObjcSugar)

+ (NSString *)formatTime:(NSTimeInterval)timeInterval;


+ (NSDate *)dateFromString:(NSString *)dateString;

+ (NSString *)stringFromDate:(NSDate *)date;


- (NSString *)tk_messageString;

//时间对比，两者是否相同
- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

//对比时间，得到时间差，以秒为单位
+(NSInteger)daysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate;

@end

NS_ASSUME_NONNULL_END
