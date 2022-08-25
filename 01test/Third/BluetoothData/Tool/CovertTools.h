//
//  CovertTools.h
//  Health
//
//  Created by Rick on 2014/12/8.
//  Copyright (c) 2014年 Rick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CovertTools : NSObject
+ (float)covertFLOAT:(uint32_t)int_data;
+ (float)covertSFLOAT:(uint16_t)int_data;
@end
