//
//  ISWeightParser.h
//  Weight Scale
//
//  Created by Rick on 2014/10/3.
//  Copyright (c) 2014年 Rick. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef struct _WEIGHT_SCALE_FEATURE {
    uint32_t time_stamp:1;
    uint32_t multiple_user:1;
    uint32_t bmi:1;
    uint32_t weight_resolution:4;
    uint32_t height_resolution:3;
    uint32_t reserved:22;
}__attribute__((packed)) WEIGHT_SCALE_FEATURE;

typedef struct _WEIGHT_SCALE_FLAG {
    uint8_t unit:1;
    uint8_t time_stamp:1;
    uint8_t user_id:1;
    uint8_t bmi_and_height:1;
    uint8_t reserved:4;
}__attribute__((packed)) WEIGHT_SCALE_FLAG;

typedef struct _TIMESTAMP {
    uint16_t year;
    uint8_t month;
    uint8_t day;
    uint8_t hour;
    uint8_t minute;
    uint8_t second;
}__attribute__((packed)) TIMESTAMP;

@interface ISWeightParser : NSObject
- (void)decodeFeature:(NSData *)data;
- (NSDictionary *)decodeData:(NSData *)data;
@end
