//
//  NSDate+KKObjcSugar.m
//  yunbaolive
//
//  Created by Peter on 2021/3/11.
//  Copyright © 2021 cat. All rights reserved.
//

#import "NSDate+KKObjcSugar.h"

@implementation NSDate (KKObjcSugar)


+ (NSString *)formatTime:(NSTimeInterval)timeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    if ([date isToday]) {
        if([date isJustNow]) {
            return @"刚刚";
        }else {
            formatter.dateFormat = @"HH:mm";
            return [formatter stringFromDate:date];
        }
    }else{
        if ([date isYesterday]) {
            formatter.dateFormat = @"昨天HH:mm";
            return [formatter stringFromDate:date];
        }else if ([date isCurrentWeek]){
            formatter.dateFormat = [NSString stringWithFormat:@"%@%@",[date dateToWeekday],@"HH:mm"];
            return [formatter stringFromDate:date];
        }else{
            if([date isCurrentYear]) {
                formatter.dateFormat = @"MM-dd  HH:mm";
            }else {
                formatter.dateFormat = @"yy-MM-dd  HH:mm";
            }
            return [formatter stringFromDate:date];
        }
    }
    return nil;
}

- (BOOL)isJustNow {
    NSTimeInterval now = [[NSDate new] timeIntervalSince1970];
    return fabs(now - self.timeIntervalSince1970) < 60 * 2 ? YES : NO;
}

- (BOOL)isCurrentWeek {
    NSDate *nowDate = [[NSDate date] dateFormatYMD];
    NSDate *selfDate = [self dateFormatYMD];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day <= 7;
}

- (BOOL)isCurrentYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents *nowComponents = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfComponents = [calendar components:unit fromDate:self];
    return selfComponents.year == nowComponents.year;
}

- (NSString *)dateToWeekday {
    NSArray *weekdays = [NSArray arrayWithObjects: @"", @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:self];
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

- (BOOL)isToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear ;
    NSDateComponents *nowComponents = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfComponents = [calendar components:unit fromDate:self];
    return (selfComponents.year == nowComponents.year) && (selfComponents.month == nowComponents.month) && (selfComponents.day == nowComponents.day);
}

- (BOOL)isYesterday {
    NSDate *nowDate = [[NSDate date] dateFormatYMD];
    NSDate *selfDate = [self dateFormatYMD];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

- (NSDate *)dateFormatYMD {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}



//======

+ (NSDate *)dateFromString:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:dateString];
    
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date {
    //用于格式化NSDate对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置显示格式
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSDate转NSString
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}



- (NSString *)tk_messageString
{

    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[ NSDate date ]];
    NSDateComponents *myCmps = [calendar components:unit fromDate:self];
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc ] init ];
    BOOL isYesterday = NO;
    if (nowCmps.year != myCmps.year) {
        dateFmt.dateFormat = @"yyyy/MM/dd";
    }
    else{
        if (nowCmps.month == myCmps.month) {
            
            if (nowCmps.day==myCmps.day) {
                dateFmt.dateFormat = @"HH:mm";
            } else if((nowCmps.day-myCmps.day)==1) {
                isYesterday = YES;
                dateFmt.AMSymbol = @"上午"; //@"上午";
                dateFmt.PMSymbol = @"下午"; //@"下午";
    //            dateFmt.dateFormat = TUILocalizableString(YesterdayDateFormat);
                dateFmt.dateFormat = @"aaa hh:mm";

            } else {
                if ((nowCmps.day-myCmps.day) <=7) {
                    dateFmt.dateFormat = @"EEEE";
                }else {
                    dateFmt.dateFormat = @"yyyy/MM/dd";
                }
            }
        }else{
            dateFmt.dateFormat = @"yyyy/MM/dd";
        }
    }
    NSString *str = [dateFmt stringFromDate:self];
    if (isYesterday) {
        str = [NSString stringWithFormat:@"%@ %@", @"昨天", str];
    }
    return str;
}

- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy-HHmmss"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    
    NSLog(@"date1 : %@, date2 : %@", oneDay,anotherDay);
    if (result == NSOrderedDescending) {
        NSLog(@"Date1  is in the future");
        return 1;
        
    }else if (result == NSOrderedAscending){
        NSLog(@"没有达到指定日期");
        return -1;
    }
    NSLog(@"两时间相同");
    return 0;
    
}


+(NSInteger)daysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {

    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    //得到相差秒数
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    
    return (NSInteger)time;
//    int days = ((int)time)/(3600*24);
//    int hours = ((int)time)%(3600*24)/3600;
//    int minute = ((int)time)%(3600*24)/3600/60;
    

//    if (days <= 0 && hours <= 0&&minute<= 0) {
//        NSLog(@"0天0小时0分钟");
//        return 0;
//    } else {
//        NSLog(@"%@",[[NSString alloc] initWithFormat:@"%i天%i小时%i分钟",days,hours,minute]);
//        // 之所以要 + 1，是因为 此处的days 计算的结果 不包含当天 和 最后一天\
//
//    //    （如星期一 和 星期四，计算机 算的结果就是2天（星期二和星期三），日常算，星期一——星期四相差3天，所以需要+1）\
//        对于时分 没有进行计算 可以忽略不计
//        return days + 1;
//    }

}


@end
