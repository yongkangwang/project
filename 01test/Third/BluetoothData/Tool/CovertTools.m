//
//  CovertTools.m
//  Health
//
//  Created by Rick on 2014/12/8.
//  Copyright (c) 2014年 Rick. All rights reserved.
//

#import "CovertTools.h"
#define FLOAT_POSITIVE_INFINITY     0x007FFFFE
#define FLOAT_NaN                   0x007FFFFF
#define FLOAT_NRes                  0x00800000
#define FLOAT_RESERVED_VALUE        0x00800001
#define FLOAT_NEGATIVE_INFINITY     0x00800002

#define SFLOAT_POSITIVE_INFINITY     0x07FE
#define SFLOAT_NaN                   0x07FF
#define SFLOAT_NRes                  0x0800
#define SFLOAT_RESERVED_VALUE        0x0801
#define SFLOAT_NEGATIVE_INFINITY     0x0802

@implementation CovertTools
+ (float)covertFLOAT:(uint32_t)int_data {
    int32_t mantissa = int_data & 0xFFFFFF;
    int8_t expoent = int_data >> 24;
    if (mantissa >= FLOAT_POSITIVE_INFINITY && mantissa <= FLOAT_NEGATIVE_INFINITY) {
        mantissa -= FLOAT_POSITIVE_INFINITY;
        switch (mantissa) {
            case 0:
                return INFINITY;
                break;
            case 1:
            case 2:
            case 3:
                return NAN;
                break;
            case 4:
                return -INFINITY;
                break;
            default:
                break;
        }
    }
    else {
        if (mantissa >= 0x800000) {
            mantissa = -((0xFFFFFF + 1) - mantissa);
        }
        return (mantissa * pow(10.0f, expoent));
    }
    return NAN;
}

+ (float)covertSFLOAT:(uint16_t)int_data {
    int16_t mantissa = int_data & 0x0FFF;
    int8_t expoent = int_data >> 12;
    if (expoent >= 0x0008) {
        expoent = -((0x000F + 1) - expoent);
    }
    if (mantissa >= SFLOAT_POSITIVE_INFINITY && mantissa <= SFLOAT_NEGATIVE_INFINITY) {
        mantissa -= SFLOAT_POSITIVE_INFINITY;
        switch (mantissa) {
            case 0:
                return INFINITY;
                break;
            case 1:
            case 2:
            case 3:
                return NAN;
                break;
            case 4:
                return -INFINITY;
                break;
            default:
                break;
        }
    }
    else {
        if (mantissa >= 0x0800) {
            mantissa = -((0x0FFF + 1) - mantissa);
        }
        return (mantissa * pow(10.0f, expoent));
    }
    return NAN;
}

@end
