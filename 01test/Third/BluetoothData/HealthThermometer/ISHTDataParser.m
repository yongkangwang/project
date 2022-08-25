//
//  ISHTDataParser.m
//  Health
//
//  Created by Rick on 2014/12/1.
//  Copyright (c) 2014年 Rick. All rights reserved.
//

#import "ISHTDataParser.h"
#import "ISWeightParser.h"
#import "CovertTools.h"

#import "CharacteristicReader.h"

@interface ISHTDataParser() {
    NSDateFormatter *formater;
}
@end

@implementation ISHTDataParser
- (id)init {
    self = [super init];
    if (self) {
        formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formater setTimeZone:[NSTimeZone localTimeZone]];//设置本地时区


    }
    return self;
}

- (NSDictionary *)decodeData:(NSData *)data {
    uint8_t buffer[1];
    [data getBytes:&buffer length:1];
    HEALTH_THERMOMETER_FLAG *flag = (HEALTH_THERMOMETER_FLAG *)buffer;
    int pointer = 1;
    NSString *uint;
    if (flag->temperature_units == 0) {
        uint = @"℃";
    }
    else {
        uint = @"℉";
    }
    uint32_t int_data;
    [data getBytes:&int_data range:NSMakeRange(pointer, 4)];
    float_t temperature = [CovertTools covertFLOAT:int_data];
    pointer+=4;
//    NSDate *time = [NSDate date];
//    NSDate* time = [NSString dateCurrentTime];//获取当前时间0秒后的时间
    NSDate* time = [NSString getCurrentDate];//获取当前时间0秒后的时间

    if (flag->timestamp ==1) {
        uint8_t time_buffer[7];
        [data getBytes:&time_buffer range:NSMakeRange(pointer, 7)];
        pointer+=7;
        TIMESTAMP *t = (TIMESTAMP *)time_buffer;
        NSString *t_s = [NSString stringWithFormat:@"%d-%d-%d %d:%d:%d",t->year,t->month,t->day,t->hour,t->minute,t->second];
        time = [formater dateFromString:t_s];//这里的formatter导致了差八个小时时差
    }
    uint8_t temperature_type = 0;
    if (flag->temperature_type == 1) {
        [data getBytes:&temperature_type range:NSMakeRange(pointer, 1)];
    }
    
    //测试
//    uint8_t *array = (uint8_t*) data.bytes;
//    NSDate* date = [CharacteristicReader readDateTime:&array];
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString* dateFormattedString = [dateFormat stringFromDate:date];
//    KKLog(@"dateFormattedString ==%@",dateFormattedString);
    
    //time的时区是零时区，和中国地区差了8小时时差
    if (time == nil) {
        time = [NSString getCurrentDate];
    }

    NSTimeInterval timeInterval=[time timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", timeInterval];//时间戳
//    
    NSString *timeStr = [NSString currentDateStrFromDate:time];
    if (timeStr == nil) {
        timeStr =  [NSString currentDateStrFromDate:time];
    }
//    NSString *timeString = [NSString getTimeStrWithString:timeStr];//时间戳
//        NSString *kkkkk = [NSString getDateStringWithTimeStr:timeString];
    return @{@"uint":uint,
             @"temperature":@(temperature),
             @"timestamp":time,
             @"temperature_type":@(temperature_type),
             @"timestampStr":timeString,
             @"timeStr":timeStr

    };
//    return @{@"uint":uint,
//             @"temperature":@(temperature),
//             @"timestamp":time,
//             @"temperature_type":@(temperature_type)};
}



- (NSDictionary *)decodeElectricityData:(NSData *)data
{
    return [NSDictionary dictionary];
}

@end
