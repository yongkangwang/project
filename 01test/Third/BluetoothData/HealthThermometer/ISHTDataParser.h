//
//  ISHTDataParser.h
//  Health
//
//  Created by Rick on 2014/12/1.
//  Copyright (c) 2014年 Rick. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef struct _HEALTH_THERMOMETER_FLAG {
    uint8_t temperature_units:1;
    uint8_t timestamp:1;
    uint8_t temperature_type:1;
    uint8_t reserved:5;
}__attribute__((packed)) HEALTH_THERMOMETER_FLAG;

@interface ISHTDataParser : NSObject
- (NSDictionary *)decodeData:(NSData *)data;

- (NSDictionary *)decodeElectricityData:(NSData *)data;

@end
