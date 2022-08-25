//
//  HealthThermometerData.h
//  Health
//
//  Created by Rick on 2014/12/3.
//  Copyright (c) 2014年 Rick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HealthThermometerData : NSManagedObject

@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * unit;

@end
