//
//  ISWeightParser.m
//  Weight Scale
//
//  Created by Rick on 2014/10/3.
//  Copyright (c) 2014年 Rick. All rights reserved.
//

#import "ISWeightParser.h"
@interface ISWeightParser() {
    WEIGHT_SCALE_FEATURE *feature;
    NSDateFormatter *formater;
}
@end

@implementation ISWeightParser
- (id)init {
    self = [super init];
    if (self) {
        feature = nil;
        formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return self;
}

- (void)dealloc {
    free(feature);
}

- (void)decodeFeature:(NSData *)data {
    uint32_t *buffer = malloc(sizeof(uint32_t));
    [data getBytes:buffer length:[data length]];
    feature = (WEIGHT_SCALE_FEATURE *)buffer;
    NSLog(@"weight_resolution 0 %d",feature->weight_resolution);
}

- (NSDictionary *)decodeData:(NSData *)data {
    uint16_t weight_t;
    float_t weight;
    NSString *unit_weight;
//    NSDate *time = [NSDate date];
    NSDate *time = [NSString dateCurrentTime];

    uint8_t userID = 0;
    uint16_t height_t = 0;
    float_t height = 0;
    NSString *unit_height;
    uint16_t bmi_t = 0;
    float_t bmi = 0;
    uint8_t buffer[1];
    NSLog(@"weight_resolution %d",feature->weight_resolution);
    [data getBytes:&buffer length:1];
    WEIGHT_SCALE_FLAG *flag = (WEIGHT_SCALE_FLAG *)buffer;
    [data getBytes:&weight_t range:NSMakeRange(1, 2)];
    if (flag->unit == 0) {
        unit_weight = @"kg";
        unit_height = @"cm";
    }
    else {
        unit_weight = @"lb";
        unit_height = @"inch";
    }
    int pointer = 3;
    if (flag->time_stamp ==1) {
        uint8_t time_buffer[7];
        [data getBytes:&time_buffer range:NSMakeRange(pointer, 7)];
        pointer+=7;
        TIMESTAMP *t = (TIMESTAMP *)time_buffer;
        NSString *t_s = [NSString stringWithFormat:@"%d-%d-%d %d:%d:%d",t->year,t->month,t->day,t->hour,t->minute,t->second];
        time = [formater dateFromString:t_s];
    }
    if (flag->user_id == 1) {
        [data getBytes:&userID range:NSMakeRange(pointer, 1)];
        pointer+=1;
    }
    if (flag->bmi_and_height == 1) {
        [data getBytes:&bmi_t range:NSMakeRange(pointer, 2)];
        [data getBytes:&height_t range:NSMakeRange(pointer+2, 2)];
    }
    if (/*feature == nil*/1) {
        if (flag->unit == 0) {
            weight = weight_t * 0.005;
            height = height_t * 0.01;
        }
        else {
            weight = weight_t * 0.01;
            height = height_t * 0.1;
        }
    }
    else {
        if (flag->unit == 0) {
            switch (feature->weight_resolution) {
                case 1:
                    weight = weight_t * 0.5;
                    break;
                case 2:
                    weight = weight_t * 0.2;
                    break;
                case 3:
                    weight = weight_t * 0.1;
                    break;
                case 4:
                    weight = weight_t * 0.05;
                    break;
                case 5:
                    weight = weight_t * 0.02;
                    break;
                case 6:
                    weight = weight_t * 0.01;
                    break;
                case 7:
                    weight = weight_t * 0.005;
                    break;
                default:
                    weight = weight_t * 0.005;
                    break;
            }
            switch (feature->height_resolution) {
                case 1:
                    height = height_t * 0.01;
                    break;
                case 2:
                    height = height_t * 0.005;
                    break;
                case 3:
                    height = height_t * 0.001;
                    break;
                default:
                    height = height_t * 0.001;
                    break;
            }
        }
        else {
            switch (feature->weight_resolution) {
                case 1:
                    weight = weight_t * 1.0;
                    break;
                case 2:
                    weight = weight_t * 0.5;
                    break;
                case 3:
                    weight = weight_t * 0.2;
                    break;
                case 4:
                    weight = weight_t * 0.1;
                    break;
                case 5:
                    weight = weight_t * 0.05;
                    break;
                case 6:
                    weight = weight_t * 0.02;
                    break;
                case 7:
                    weight = weight_t * 0.01;
                    break;
                default:
                    weight = weight_t * 0.01;
                    break;
            }
            switch (feature->height_resolution) {
                case 1:
                    height = height_t * 1.0;
                    break;
                case 2:
                    height = height_t * 0.5;
                    break;
                case 3:
                    height = height_t * 0.1;
                    break;
                default:
                    height = height_t * 0.1;
                    break;
            }
        }
    }
    bmi = bmi_t * 0.1;
    if (flag->bmi_and_height == 0) {
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        if ([def objectForKey:@"Height"]) {
            height = [[def objectForKey:@"Height"] floatValue];
            if (flag->unit == 0) {
                if ([def integerForKey:@"Unit"]==1) {
                    height = height * 2.54;
                }
                bmi = weight/pow((height*0.01), 2);
            }
            else {
                if ([def integerForKey:@"Unit"]==0) {
                    height = height * 0.3937;
                }
                bmi = (weight/pow(height, 2))*703;
            }
        }
    }

    return @{@"weight":@(weight),
             @"height":@(height),
             @"bmi":@(bmi),
             @"unit_weight":unit_weight,
             @"unit_height":unit_height,
             @"time":time,
             @"user_id":@(userID)
             };
}

@end
