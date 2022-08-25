//
//  LDMyPeripheral.h
//  Thermometer
//
//  Created by Peter on 2022/3/9.
//蓝牙连接管理单例

//因为蓝牙只能支持16进制，而且每次传输只能20个字节，所以要把信息流转成双方可识别的16进制。


#import <Foundation/Foundation.h>

//#import <CoreBluetooth/CoreBluetooth.h>
#import <BabyBluetooth.h>

//#import "PeripheralInfo.h"
@class PeripheralInfo;
@protocol LDMyPeripheralDelegate <NSObject>


@optional;
//记录模式回调
- (void)OnBluetoothRecordMode;


@end

NS_ASSUME_NONNULL_BEGIN

@interface LDMyPeripheral : NSObject

//单例销毁
+(void)attemptDealloc;

/**
 * 单例构造方法
 * @return BabyBluetooth共享实例
 */
+ (instancetype)kkshareBabyBluetooth;

//获取蓝牙管理对象
- (BabyBluetooth *)getBabyBluetooth;
//代理，数据传输
@property (nonatomic,weak) id<LDMyPeripheralDelegate> PeripheralDelegate;
//扫描到了蓝牙设备,
@property (nonatomic,copy) void(^setBlockOnDiscoverToPeripherals)(NSMutableArray *indexPaths,NSMutableArray *Peripherals);

///开始搜索蓝牙设备
- (void)scanForPeripherals;
//取消搜索
- (void)cancelScan;
//停止之前的蓝牙连接
- (void)cancelAllPeripheralsConnection;

///设置当前连接中的设备
//- (void)setCurrentConnectionPeripheral:(CBPeripheral *)peripheral;
- (void)setCurrentConnectionPeripheral:(NSDictionary *)peripheral;

///获取当前连接中的设备
- (CBPeripheral *)getCurrentCBPeripheral;
///获取当前准备连接的设备信息
- (NSDictionary *)getCurrentCBPeripheralInfo;


#pragma mark ====== 以上是搜索蓝牙设备

//开始连接蓝牙设备
- (void)havingPeripherals;
//温度特性回调，
@property (nonatomic,copy) void(^setBlockOnTemperatureToPeripherals)(NSDictionary *TemperatureDic);
///获取当前温度特性对象
- (CBCharacteristic *)getTemperatureCharacteristic;
#pragma mark ====== 以上是蓝牙设备连接和温度获取

//设置蓝牙为记录模式
- (void)setBluetoothRecordMode;
///进入记录模式成功的回调
@property (nonatomic,copy) void(^setBlockOnBluetoothRecordMode)(NSString *string);
//手动刷新温度数据
- (void)manualBluetoothTemperatureRereshing;

//定时器获取设备信息
@property (nonatomic,copy) void(^setBlockOnDeviceInfo)(PeripheralInfo *deviceInfo);

//获取电池特性值
- (void)ReadValueForBatteriesCharacteristic;
///获取记录的最后一条温度信息
- (NSDictionary *)getRecordLastThermometerInfo;
//设置报警温度
- (void )setThermometerAlarmInfo:(NSString *)num;
//设备断开连接
@property (nonatomic,copy) void(^setBlockOnDisconnectAtChannel)(NSString *string);

//电量变化，低电量警报
@property (nonatomic,copy) void(^batteriesChangeBlock)(int batteries);




@end

NS_ASSUME_NONNULL_END
