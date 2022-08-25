//
//  PeripheralInfo.h
//  BabyBluetoothAppDemo
//
//  Created by 刘彦玮 on 15/8/6.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <CoreBluetooth/CoreBluetooth.h>

@interface PeripheralInfo : NSObject

@property (nonatomic,strong) CBUUID *serviceUUID;
@property (nonatomic,strong) NSMutableArray *characteristics;


//设备信息
//温度报警次数
//@property (nonatomic,assign) NSInteger alarmNum;
//测量时长
@property (nonatomic,assign) NSInteger durationTime;
//电量
@property (nonatomic,assign) int electricityNum;

//@property (nonatomic,assign) NSInteger durationTime;

//最近的一次温度上报
@property (nonatomic,copy) NSString *temperatureStr;
@property (nonatomic,copy) NSString *temperatureTime;//nsdate
@property (nonatomic,copy) NSString *temperatureType;
@property (nonatomic,copy) NSString *timeStr;//时间

@property (nonatomic,strong) NSDictionary *temperatureDic;
//外设连接状态
//@property (nonatomic,assign) CBPeripheralState peripheralState;
//1已连接 2已断开、3默认连接中
@property (nonatomic,assign) int peripheralState;


@end
