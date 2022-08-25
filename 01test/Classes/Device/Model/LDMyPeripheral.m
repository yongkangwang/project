//
//  LDMyPeripheral.m
//  Thermometer
//
//  Created by Peter on 2022/3/9.
//

#import "LDMyPeripheral.h"

#import "ISHTDataParser.h"
#import "HealthThermometerData.h"

#import "AppDelegate.h"
#import "PeripheralInfo.h"


#import "JX_GCDTimerManager.h"

#import "CharacteristicReader.h"

//
#define channelOnPeropheralView @"peripheralView"

@interface LDMyPeripheral ()

//蓝牙对象
@property (nonatomic,strong) BabyBluetooth *baby;
//搜索到的蓝牙设备
@property (nonatomic,strong) NSMutableArray *peripheralDataArray;
///当前连接中的设备
@property (nonatomic,strong) NSDictionary *currentPeripheralDic;//包含了currentPeripheral
@property (nonatomic,strong) CBPeripheral *currentPeripheral;

///搜索到的蓝牙服务
@property (nonatomic,strong) NSMutableArray *peripheralServicesArray;

/////温度服务
//@property (nonatomic,strong)CBService *temperatureCBService;
///温度特性
@property (nonatomic,strong)CBCharacteristic *temperatureCharacteristic;
@property (nonatomic,strong) NSMutableArray *descriptors;
//2AFF信息设置
@property (nonatomic,strong)CBCharacteristic *InfoSettingCharacteristic;

//设备信息
@property (nonatomic,strong)PeripheralInfo *deviceInfo;

//电池服务
//@property (nonatomic,strong)CBService *batteriesCBService;
//电池服务下的电池特性
@property (nonatomic,strong)CBCharacteristic *batteriesCharacteristic;

//是否进入了记录模式，默认NO
@property (nonatomic,assign)BOOL isRecordMode;
//设备序列号
@property (nonatomic,copy)NSString *cimc_device_number;

//是否第一次进入记录模式
@property (nonatomic,assign)BOOL isFirstLoad;
//蓝牙连接状态，用于蓝牙的断开、连接、
//0默认，1连接成功，2手动取消连接，
@property (nonatomic,assign)int BluetoothConnectStatus;
//是否是重启重连，默认不是
@property (nonatomic,assign)BOOL isRebootReconnect;



//外设模式
//是否开始广播数据，默认NO
@property (nonatomic,assign) BOOL isStartAdvertising;
@property (nonatomic,strong) CBCharacteristic *timePeripheralCharacteristic;
@property (nonatomic,assign) int advertisingInterval;


@end
    
@implementation LDMyPeripheral
//static LDMyPeripheral* _instance = nil;
static LDMyPeripheral *share = nil;
static dispatch_once_t oneToken;

- (PeripheralInfo *)deviceInfo
{
    if (!_deviceInfo) {
        _deviceInfo = [[PeripheralInfo alloc]init];
    }
    return _deviceInfo;
}

//测量时长
- (void)GCDTimer {
    int timeInterval = 1.0;
    __weak typeof(self) weakSelf = self;
    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:Global_TIMER_Notfi
                                                           timeInterval:timeInterval
                                                                  queue:dispatch_get_main_queue()
                                                                repeats:YES
                                                          fireInstantly:NO
                                                                 action:^{
                                                                     [weakSelf GCDTimerChange];
                                                                 }];
}


- (void)GCDTimerChange
{
    
    if (self.isRebootReconnect) {
        if (self.currentPeripheral && self.InfoSettingCharacteristic) {
            self.isRebootReconnect = NO;
            [self setBluetoothRecordMode];
        }
    }
    
    self.deviceInfo.durationTime +=1;
    if (self.setBlockOnDeviceInfo) {
        self.setBlockOnDeviceInfo(self.deviceInfo);
    }
    
    self.advertisingInterval +=1;
    if (self.isStartAdvertising) {
        if (self.advertisingInterval>=60) {
            self.advertisingInterval = 0;
            [self sendTimeAdvertisingData];
        }
    }
}

+(void)attemptDealloc
{
    share = nil;
    oneToken = 0;
    
}

//单例模式
+ (instancetype)kkshareBabyBluetooth {
    dispatch_once(&oneToken, ^{
        share = [[LDMyPeripheral alloc]init];
    });
   return share;
}

- (instancetype)init {
    self = [super init];
    if (self) {

        //初始化对象
        _baby = [[BabyBluetooth alloc]init];
        _peripheralDataArray = [NSMutableArray array];
        _peripheralServicesArray = [NSMutableArray array];
        _descriptors = [NSMutableArray array];
        _deviceInfo = [[PeripheralInfo alloc]init];
//        _currentPeripheral = [CBPeripheral init] ;
        _currentPeripheralDic = [NSDictionary dictionary];
        _isRecordMode = NO;
        _isFirstLoad = YES;
        _BluetoothConnectStatus = 0;
        _isRebootReconnect = NO;
        [self GCDTimer];
        //设置蓝牙搜索委托
        [self babyDelegate];
        //以下是蓝牙设备连接babyDelegate
        [self connectBabyDelegate];
//        //监听其他方法
//        [self peripheralDelegate];
        
        //不需要开启外设，苹果不允许广播时间服务，苹果内部已经做了相关处理，做好数据解析即可
        //外设模式
        _isStartAdvertising = NO;
//        _timePeripheralCharacteristic = nil
        _advertisingInterval = 0;
        //    //开启外设
        //    [self bePeripheral];

        
    }
    return self;
    
}

//获取蓝牙管理对象
- (BabyBluetooth *)getBabyBluetooth
{
    return self.baby;
}


#pragma mark -蓝牙配置和操作===扫描蓝牙外设
//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    
    __weak typeof(self) weakSelf = self;
    //这个方法中可以获取到管理中心的状态
    [self.baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
       //获取手机蓝牙状态
        if (central.state == CBCentralManagerStatePoweredOn) {
//            [MBProgressHUD kkshowMessage:@"手机蓝牙设置打开成功"];
        }
    }];
    
    //设置扫描到设备的委托
    [self.baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
//        NSLog(@"搜索到了设备:%@，设备RSSI==%zd",peripheral.name,[RSSI integerValue]);
        [weakSelf insertTableView:peripheral advertisementData:advertisementData RSSI:RSSI];
    }];
    
   
    //设置发现设service的Characteristics的委托
    [self.baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        for (CBCharacteristic *c in service.characteristics) {
            NSLog(@"charateristic name is :%@",c.UUID);

        }
    }];
    //设置读取characteristics的委托
    [self.baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [self.baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [self.baby setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    

    //设置查找设备的过滤器
    [self.baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        
        //最常用的场景是查找某一个前缀开头的设备
//        if ([peripheralName hasPrefix:@"Pxxxx"] ) {
//            return YES;
//        }
//        return NO;
        
        //设置查找规则是名称大于0 ， the search rule is peripheral.name length > 0
        if (peripheralName.length >0) {
            return YES;
        }
        return NO;
    }];

    
    [self.baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
    }];
       
    [self.baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelScanBlock");
    }];
    
  
    
    /*设置babyOptions
        
        参数分别使用在下面这几个地方，若不使用参数则传nil
        - [centralManager scanForPeripheralsWithServices:scanForPeripheralsWithServices options:scanForPeripheralsWithOptions];
        - [centralManager connectPeripheral:peripheral options:connectPeripheralWithOptions];
        - [peripheral discoverServices:discoverWithServices];
        - [peripheral discoverCharacteristics:discoverWithCharacteristics forService:service];
        
        该方法支持channel版本:
            [baby setBabyOptionsAtChannel:<#(NSString *)#> scanForPeripheralsWithOptions:<#(NSDictionary *)#> connectPeripheralWithOptions:<#(NSDictionary *)#> scanForPeripheralsWithServices:<#(NSArray *)#> discoverWithServices:<#(NSArray *)#> discoverWithCharacteristics:<#(NSArray *)#>]
     */
    //示例:
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    //连接设备->
    [self.baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    

}



#pragma mark -UIViewController 方法
//插入table数据
-(void)insertTableView:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    NSArray *peripherals = [self.peripheralDataArray valueForKey:@"peripheral"];
    if(![peripherals containsObject:peripheral]) {
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:peripherals.count inSection:0];
        [indexPaths addObject:indexPath];

        NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
        [item setValue:peripheral forKey:@"peripheral"];
        [item setValue:RSSI forKey:@"RSSI"];
        [item setValue:advertisementData forKey:@"advertisementData"];
        [item setValue:@"0" forKey:@"isSelect"];
        [self.peripheralDataArray addObject:item];
        KKLog(@"六道item%@",item);
//        RSSI = "-82";//反向值，值越大，说明信号越强，需要100-82=12,12是信号强度

        NSData *data = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
//        NSString *mac = [NSString convertToNSStringWithNSData:data];
//        NSString * macstr = [mac stringByReplacingOccurrencesOfString:@" " withString:@""];
//        KKLog(@"六道item====%@",macstr);
//        KKLog(@"六道item====%@",macstr);

        
        if (self.setBlockOnDiscoverToPeripherals) {
            self.setBlockOnDiscoverToPeripherals(indexPaths, self.peripheralDataArray);
        }
        
        //在这里APP重启重连
        NSString *macid = [KKUserDefaults valueForKey:@"cimc_device_bluetoothmac"];
        NSString *searchmacid = peripheral.identifier.UUIDString;
        if ([macid isEqualToString:searchmacid]) {
            self.isRebootReconnect = YES;
            [self cancelScan];

            [[LDMyPeripheral kkshareBabyBluetooth] setCurrentConnectionPeripheral:item];
            [[LDMyPeripheral kkshareBabyBluetooth] havingPeripherals];

        }else{
        }
        
        
//        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}



/*
- (void)getMacAddress:(MPPeripheral *)mPeripheral
{
    CBUUID *macServiceUUID = [CBUUID UUIDWithString:@"180A"];
    CBUUID *macCharcteristicUUID = [CBUUID UUIDWithString:@"2A23"];
    [CBPeripheral discoverServices:@[macServiceUUID] withBlock:^(MPPeripheral *peripheral, NSError *error) {
        if(peripheral.services.count){
            MPService *service = [peripheral.services objectAtIndex:0];
            [service discoverCharacteristics:@[macCharcteristicUUID] withBlock:^(MPPeripheral *peripheral, MPService *service, NSError *error) {
                for(MPCharacteristic *characteristic in service.characteristics){
                    if([characteristic.UUID isEqual:macCharcteristicUUID]){
                        [characteristic readValueWithBlock:^(MPPeripheral *peripheral, MPCharacteristic *characteristic, NSError *error){
                            NSString *value = [NSString stringWithFormat:@"%@",characteristic.value];
                            NSMutableString *macString = [[NSMutableString alloc] init];
                            [macString appendString:[[value substringWithRange:NSMakeRange(16, 2)] uppercaseString]];
                            [macString appendString:@":"];
                            [macString appendString:[[value substringWithRange:NSMakeRange(14, 2)] uppercaseString]];
                            [macString appendString:@":"];
                            [macString appendString:[[value substringWithRange:NSMakeRange(12, 2)] uppercaseString]];
                            [macString appendString:@":"];
                            [macString appendString:[[value substringWithRange:NSMakeRange(5, 2)] uppercaseString]];
                            [macString appendString:@":"];
                            [macString appendString:[[value substringWithRange:NSMakeRange(3, 2)] uppercaseString]];
                            [macString appendString:@":"];
                            [macString appendString:[[value substringWithRange:NSMakeRange(1, 2)] uppercaseString]];
                            NSLog(@"macString:%@",macString);
                        }];
                    }
                }
                
            }];
        }
    }];
}

}
*/

- (NSMutableArray *)peripheralDataArray
{
    if (!_peripheralDataArray) {
        _peripheralDataArray = [NSMutableArray array];
    }
    return _peripheralDataArray;
}

///开始搜索蓝牙设备
- (void)scanForPeripherals
{
    [self.peripheralDataArray removeAllObjects];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    self.baby.scanForPeripherals().begin();//搜索设备
    
    
}
//取消搜索
- (void)cancelScan
{
    [self.baby cancelScan];
}

- (void)cancelAllPeripheralsConnection
{
    self.BluetoothConnectStatus = 2;
    self.currentPeripheral = nil;

    //停止之前的连接
    [self.baby cancelAllPeripheralsConnection];
    
}
- (CBPeripheral *)getCurrentCBPeripheral
{
    return self.currentPeripheral;
}
///获取当前准备连接的设备信息
- (NSDictionary *)getCurrentCBPeripheralInfo
{
//    return self.currentPeripheralDic;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.currentPeripheralDic];
    dic[@"cimc_device_number"] = self.cimc_device_number;
    return dic;
}

#pragma mark = 以上是搜索蓝牙设备功能

///设置当前连接中的设备
//- (void)setCurrentConnectionPeripheral:(CBPeripheral *)peripheral
- (void)setCurrentConnectionPeripheral:(NSDictionary *)peripheral
{
    CBPeripheral *peri = [peripheral objectForKey:@"peripheral"];
    self.currentPeripheral = peri;
    self.currentPeripheralDic = peripheral;
//    [KKUserDefaults setValue:peri forKey:@"cimc_CBPeripheral"];
//    RSSI = "-80";
//        advertisementData =     {
//            kCBAdvDataIsConnectable = 1;
//            kCBAdvDataLocalName = "ZJZL_HTS";
//            kCBAdvDataRxPrimaryPHY = 0;
//            kCBAdvDataRxSecondaryPHY = 0;
//            kCBAdvDataServiceUUIDs =         (
//                "Health Thermometer",
//                Battery,
//                "Device Information",
//                18CF,
//                "Current Time"
//            );
//            kCBAdvDataTimestamp = "669285007.1283489";
//        };
//        peripheral = "<CBPeripheral: 0x2810264e0, identifier = E3495C49-D030-6469-32E5-B021C50A3AA1, name = ZJZL_HTS, mtu = 0, state = disconnected>";

}

#pragma mark =//以下是连接蓝牙设备babyDelegate
-(void)connectBabyDelegate{
    
    __weak typeof(self)weakSelf = self;
    BabyRhythm *rhythm = [[BabyRhythm alloc]init];
    rhythm.beatsInterval = 2;//心跳间隔
    
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [self.baby setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        [MBProgressHUD kkshowMessage:[NSString stringWithFormat:@"%@：%@--%@",LDMsg(@"设备"),peripheral.name,LDMsg(@"连接成功")]];
        weakSelf.deviceInfo.peripheralState = 1;
        weakSelf.BluetoothConnectStatus = 1;
        if (weakSelf.isFirstLoad) {
            weakSelf.isFirstLoad = NO;
        }else{
            [weakSelf setBluetoothRecordMode];
        }
        if (peripheral.state == CBPeripheralStateConnecting) {
            weakSelf.deviceInfo.peripheralState = 3;
        }


    }];
    
    //设置设备连接失败的委托
    [self.baby setBlockOnFailToConnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        KKLog(@"设备：%@--连接失败",peripheral.name);
        if (peripheral.state == CBPeripheralStateConnecting) {
            weakSelf.deviceInfo.peripheralState = 3;
        }
        if (self.BluetoothConnectStatus == 2) {
            //手动断开的连接
        }else{
            [weakSelf connectCurrentPeripheral];
        }

        [MBProgressHUD kkshowMessage:[NSString stringWithFormat:@"%@：%@--%@",LDMsg(@"设备"),peripheral.name,LDMsg(@"连接失败")]];
    }];

    //设置设备断开连接的委托
    [self.baby setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        KKLog(@"设备：%@--断开连接",peripheral.name);
        weakSelf.deviceInfo.peripheralState = 2;
        [weakSelf connectCurrentPeripheral];
        if (peripheral.state == CBPeripheralStateConnecting) {
            weakSelf.deviceInfo.peripheralState = 3;
        }

        [MBProgressHUD kkshowMessage:[NSString stringWithFormat:@"%@：%@--%@",LDMsg(@"设备"),peripheral.name,LDMsg(@"断开连接")]];
        if (self.BluetoothConnectStatus == 2) {
            return;
        }
        if (weakSelf.setBlockOnDisconnectAtChannel) {
            weakSelf.setBlockOnDisconnectAtChannel(peripheral.name);
        }
    }];
    
    //设置发现设备的Services的委托
    [self.baby setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *s in peripheral.services) {
            ///插入section到tableview
            [weakSelf insertSectionToTableView:s];
        }
        
        [rhythm beats];
    }];
    //设置发现设service的Characteristics的委托
    [self.baby setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        //插入row到tableview
        [weakSelf insertRowToTableView:service];
        
    }];
    //设置读取characteristics的委托
    // 更新特征的value的时候会调用 （凡是从蓝牙传过来的数据都要经过这个回调，简单的说这个方法就是你拿数据的唯一方法） 你可以判断是否修改密码成功, 获取电量信息等, 以及getToken(以我工程蓝牙锁为例子)
    [self.baby setBlockOnReadValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        //characteristic.value就是你要的数据
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
        [weakSelf insertReadValues:characteristics];

    }];
    //设置发现characteristics的descriptors的委托
    [self.baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);

        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
            //服务的描述描述
//            [weakSelf insertDescriptor:d];
        }

    }];
    //设置读取Descriptor的委托
    [self.baby setBlockOnReadValueForDescriptorsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
        for (int i =0 ; i<self.descriptors.count; i++) {
            if (self.descriptors[i]==descriptor) {
//                UITableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:2]];
//                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",descriptor.value];
                NSString *descriptorStr = [NSString stringWithFormat:@"%@",descriptor.value];
                KKLog(@"descriptorStr-%@",descriptorStr);
            }
        }
        NSLog(@"CharacteristicViewController Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);

    }];
    
    //读取rssi的委托
    [self.baby setBlockOnDidReadRSSI:^(NSNumber *RSSI, NSError *error) {
        NSLog(@"setBlockOnDidReadRSSI:RSSI:%@",RSSI);
    }];
    
    
    //设置beats break委托
    [rhythm setBlockOnBeatsBreak:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsBreak call");
        
        //如果完成任务，即可停止beat,返回bry可以省去使用weak rhythm的麻烦
//        if (<#condition#>) {
//            [bry beatsOver];
//        }
        
    }];
    
    //设置beats over委托
    [rhythm setBlockOnBeatsOver:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsOver call");
    }];
    
}

//六道
#pragma mark === 蓝牙其他代理
- (void)peripheralDelegate
{
 
    //写Characteristic成功后的block
    WeakSelf;
    [self.baby setBlockOnDidWriteValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBCharacteristic *characteristic, NSError *error) {

        NSLog(@"setBlockOnDidWriteValueForCharacteristicAtChannelerror==%@，characteristic==%@",error,characteristic.value);

        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_HEALTH_infoSetting_SERVICE]]) {
            //信息设置,只要是写入或读取操作，都会经过整个回调，所以无法判断哪个是进入记录模式，只能不同页面设置不同的代理回调
            if (error == nil) {
                //进入记录模式成功
                NSLog(@"进入记录模式成功%@",error);
//                [weakSelf manualBluetoothTemperatureRereshing];
                if (weakSelf.setBlockOnBluetoothRecordMode) {
                    weakSelf.setBlockOnBluetoothRecordMode(@"");
                }
                if ([weakSelf.PeripheralDelegate respondsToSelector:@selector(OnBluetoothRecordMode)]) {
                    //一定要判断，不然会导致首页重复加载
//                    if (!weakSelf.isRecordMode) {
//                        weakSelf.isRecordMode = YES;
                        [weakSelf.PeripheralDelegate OnBluetoothRecordMode];
//                    }
//                    [weakSelf.PeripheralDelegate OnBluetoothRecordMode];

                }

            }else{
                NSLog(@"进入记录模式失败%@",error);
                NSString *kerror = [NSString stringWithFormat:@"%@:code%ld===domain%@",LDMsg(@"进入失败请重试"),(long)error.code,error.domain];
                [MBProgressHUD kkshowMessage:kerror];
            }
        }
        
    }];
    
    [self.baby setBlockOnDiscoverToPeripheralsAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"六道RSSI%zd",[RSSI integerValue]);

    }];
    
    
    /*
    //外围设备的状态
    [self.baby peripheralModelBlockOnPeripheralManagerDidUpdateState:^(CBPeripheralManager *peripheral) {
        //是否正在发送广播
        KKLog(@"%d",peripheral.isAdvertising);

        //        设备的状态
                KKLog(@"%zd",peripheral.state);
//        Unknown,
//         Resetting,
//         Unsupported,
//            
//         Unauthorized,
//         Powered Off,
//         Powered  On,
//        未知，
//         重置，
//         不支持，
//         未经授权，
//         断电，
//         已打开电源，
        
    }];
    //启用广播
    [self.baby bePeripheral];
//    startAdvertising
    */
    
}



-(void)insertSectionToTableView:(CBService *)service{
    
    KKLog(@"搜索到服务:%@",service.UUID.UUIDString);
    PeripheralInfo *info = [[PeripheralInfo alloc]init];
    [info setServiceUUID:service.UUID];
    [self.peripheralServicesArray addObject:info];
    
    if ([service.UUID.UUIDString isEqual:UUIDSTR_HEALTH_batteries_SERVICE]) {
//        self.batteriesCBService = service;
    }

//    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:self.services.count-1];
//    [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

//接收Characteristics通知
-(void)insertRowToTableView:(CBService *)service{
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    int sect = -1;
    for (int i=0;i<self.peripheralServicesArray.count;i++) {
        PeripheralInfo *info = [self.peripheralServicesArray objectAtIndex:i];
        if (info.serviceUUID == service.UUID) {
            sect = i;
        }
    }
    if (sect != -1) {
        PeripheralInfo *info =[self.peripheralServicesArray objectAtIndex:sect];
        for (int row=0;row<service.characteristics.count;row++) {
            CBCharacteristic *c = service.characteristics[row];
            [info.characteristics addObject:c];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:sect];
            [indexPaths addObject:indexPath];
            KKLog(@"add indexpath in row:%d, sect:%d",row,sect);
        }
        PeripheralInfo *curInfo =[self.peripheralServicesArray objectAtIndex:sect];
        KKLog(@"%@",curInfo.characteristics);

        
        if ([service.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_HEALTH_THERMOMETER_SERVICE]]) {
            for (CBCharacteristic *cbch in service.characteristics) {
                KKLog(@"service.UUID.cbch%@",cbch);
                if ([cbch.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_TEMPERATURE_MANUFACTURE]]) {
                    KKLog(@"service.UUID.UUIDString%@",service.UUID.UUIDString);
                    self.temperatureCharacteristic = cbch;

#pragma mark ====温度获取模块
                    [self.baby notify:self.currentPeripheral characteristic:cbch block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                        NSLog(@"resume notify block");
                        [self insertReadValues:characteristics];
                    }];
                    

                }else if ([cbch.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_HEALTH_infoSetting_SERVICE]]) {
                    //信息设置
                    self.InfoSettingCharacteristic =cbch;
                    
                }
            }
        }else if ([service.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_HEALTH_batteries_SERVICE]]){
           //电池
            for (CBCharacteristic *cbch in service.characteristics) {

                if ([cbch.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_batteries_MANUFACTURE]]) {
                    self.batteriesCharacteristic = cbch;
                    [self insertReadValues:cbch];

                }
            }

        }

        //        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    
}

//插入读取的值
-(void)insertReadValues:(CBCharacteristic *)characteristics{
    
    if ([characteristics.service.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_HEALTH_THERMOMETER_SERVICE]]) {
        if ([characteristics.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_TEMPERATURE_MANUFACTURE]]) {
#pragma mark ====接收温度回调，进入记录模式的时候，会再有一次回调
//            NSString *kkstring = [NSString stringWithFormat:@"%@",characteristics.value];
            if (characteristics.value == nil) {
                return;
            }
            
            NSDictionary *temperature = [[[ISHTDataParser alloc]init] decodeData:characteristics.value];
            KKLog(@"UUIDSTR_TEMPERATURE_MANUFACTUREtemperature%@",temperature);
            self.deviceInfo.temperatureDic = temperature;
            self.deviceInfo.temperatureStr = [NSString stringWithFormat:@"%@",[temperature valueForKey:@"temperature"]];
            self.deviceInfo.temperatureTime = [NSString stringWithFormat:@"%@",[temperature valueForKey:@"timestamp"]];
            self.deviceInfo.temperatureType = [NSString stringWithFormat:@"%@",[temperature valueForKey:@"uint"]];
            self.deviceInfo.timeStr = [NSString stringWithFormat:@"%@",[temperature valueForKey:@"timeStr"]];

            if (self.setBlockOnTemperatureToPeripherals) {
                self.setBlockOnTemperatureToPeripherals(temperature);
            }
//                temperature = "28.03";
//                "temperature_type" = 0;
//                timestamp = "2022-03-09 09:07:32 +0000";
//                uint = @"℃";
//            self.ConnectView.kkInfoDic = health;

        }
        
    }else    if ([characteristics.service.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_HEALTH_batteries_SERVICE]]) {        //电池服务

        if ([characteristics.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_batteries_MANUFACTURE]]) {//电池特性
//                NSDictionary *temperature = [[[ISHTDataParser alloc]init] decodeData:characteristics.value];

                KKLog(@"UUIDSTR_batteries_MANUFACTURE temperature%@",characteristics.value);
            if ([NSString isNullObject:characteristics.value] ) {
                return;
            }
            int electricityNum =  [BabyToy ConvertDataToInt:characteristics.value];
            //            Byte *testByte = (Byte *)[characteristics.value bytes];
            //            int kkkk = testByte[0];//和上边值返回的一样。
            self.deviceInfo.electricityNum = electricityNum;
            if (self.batteriesChangeBlock) {
                self.batteriesChangeBlock(electricityNum);
            }
            KKLog(@"UUIDSTR_batteries_MANUFACTURE temperature=electricityNum==%d",electricityNum);//10%报一次，
            
            NSData *data = characteristics.value;
            uint8_t *array = (uint8_t*) data.bytes;
            uint8_t batteryLevel = [CharacteristicReader readUInt8Value:&array];
            NSString* text = [[NSString alloc] initWithFormat:@"%d%%", batteryLevel];
            KKLog(@"UUIDSTR_batteries_MANUFACTURE temperature===%@",text);

        }

        
    }else if ([characteristics.service.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_HEALTH_info_SERVICE]]){
        
        if ([characteristics.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_HEALTH_firm_MANUFACTURE]]) {
            KKLog(@"UUIDSTR_batteries_MANUFACTURE temperature%@",characteristics.value);
        if ([NSString isNullObject:characteristics.value] ) {
            return;
        }
            NSData *data = characteristics.value;
            uint8_t *array = (uint8_t*) data.bytes;
            uint8_t batteryLevel = [CharacteristicReader readUInt8Value:&array];
            NSString* text = [[NSString alloc] initWithFormat:@"%d", batteryLevel];
            NSString* textgggg = [NSString stringdatastringdata:data];
            NSString* hhhhh = [[NSString alloc]initWithData:characteristics.value encoding:NSUTF8StringEncoding];//   MyCold

            
            KKLog(@"UUIDSTR_HEALTH_firm_name_MANUFACTURE temperature===%@====%@",textgggg,text);

        }else  if ([characteristics.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_HEALTH_firm_name_MANUFACTURE]]) {
            KKLog(@"UUIDSTR_HEALTH_firm_name_MANUFACTURE temperature%@",characteristics.value);
                
                NSData *data = characteristics.value;
                uint8_t *array = (uint8_t*) data.bytes;
                uint8_t batteryLevel = [CharacteristicReader readUInt8Value:&array];
                NSString* text = [[NSString alloc] initWithFormat:@"%d", batteryLevel];
                NSString* textgggg = [NSString stringdatastringdata:data];
            NSString* hhhhh = [[NSString alloc]initWithData:characteristics.value encoding:NSUTF8StringEncoding];//            MyCold NO1
            KKLog(@"UUIDSTR_HEALTH_firm_name_MANUFACTURE temperature===%@====%@",textgggg,hhhhh);
                
        }else  if ([characteristics.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_HEALTH_firm_number_MANUFACTURE]]) {
            KKLog(@"UUIDSTR_HEALTH_firm_number_MANUFACTURE temperature%@",characteristics.value);
            NSData *data = characteristics.value;
            uint8_t *array = (uint8_t*) data.bytes;
            uint8_t batteryLevel = [CharacteristicReader readUInt8Value:&array];
            NSString* text = [[NSString alloc] initWithFormat:@"%d", batteryLevel];
            NSString* textgggg = [NSString stringdatastringdata:data];//66536823ffffffff
            self.cimc_device_number = textgggg;
//            NSString* hhhhh = [[NSString alloc]initWithData:characteristics.value encoding:NSUTF8StringEncoding];//   nil

            KKLog(@"UUIDSTR_HEALTH_firm_name_MANUFACTURE temperature===%@====%@",textgggg,text);

        }
    }

//    [self.readValueArray addObject:[NSString stringWithFormat:@"%@",characteristics.value]];
//    NSMutableArray *indexPaths = [[NSMutableArray alloc]init];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.readValueArray.count-1 inSection:0];
//    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:self.readValueArray.count-1 inSection:0];
//    [indexPaths addObject:indexPath];
//    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

//开始连接蓝牙设备
- (void)havingPeripherals
{
    self.BluetoothConnectStatus =1;
    //监听其他方法
    [self peripheralDelegate];

    //开始扫描设备
    [self performSelector:@selector(connectCurrentPeripheral) withObject:nil afterDelay:1];
//    [MBProgressHUD kkshowMessage:@"准备连接设备"];

}

-(void)connectCurrentPeripheral{
    [MBProgressHUD kkshowMessage:LDMsg(@"开始连接设备")];
    if (self.currentPeripheral) {
        self.baby.having(self.currentPeripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    }

}
- (CBCharacteristic *)getTemperatureCharacteristic
{
    return self.temperatureCharacteristic;
}
#pragma mark ==============以上是蓝牙连接功能


//设置蓝牙为记录模式
- (void)setBluetoothRecordMode
{

    //    NSString*str =@"7e7e227e7e";
    NSString *str = [NSString stringWithFormat:@"%@%@%@",Bluetooth_footer_Command,Bluetooth_record_COMMAND__WRITE,Bluetooth_footer_Command];
    NSData *data = [NSString convertHexStrToData:str];
    if (self.currentPeripheral && self.InfoSettingCharacteristic) {
        [self.currentPeripheral writeValue:data forCharacteristic:self.InfoSettingCharacteristic type:CBCharacteristicWriteWithResponse];
    }else{
//        [MBProgressHUD kkshowMessage:@"尚未连接到设备"];
        
    }
    
}


//手动刷新温度数据
- (void)manualBluetoothTemperatureRereshing
{
    if (!self.InfoSettingCharacteristic) {
        return;
    }
//    NSString*str =@"7e7e237e7e";
    NSString *str = [NSString stringWithFormat:@"%@%@%@",Bluetooth_footer_Command,Bluetooth_manualRereshing_COMMAND__WRITE,Bluetooth_footer_Command];
    NSData *data = [NSString convertHexStrToData:str];
    [self.currentPeripheral writeValue:data forCharacteristic:self.InfoSettingCharacteristic type:CBCharacteristicWriteWithResponse];
//    CBCharacteristicWriteWithResponse//有回应
//    CBCharacteristicWriteWithoutResponse//无回应
}

//获取电池特性值
- (void)ReadValueForBatteriesCharacteristic
{

    [self.baby characteristicDetails];
    self.baby.channel(channelOnPeropheralView).characteristicDetails(self.currentPeripheral,self.batteriesCharacteristic);

}

///获取记录的最后一条温度信息
- (NSDictionary *)getRecordLastThermometerInfo
{
    return self.deviceInfo.temperatureDic;
}



//设置报警温度
- (void )setThermometerAlarmInfo:(NSString *)num;
{
    int kknum = [num floatValue] *100;
    NSString *hexString = [NSString ToHex:kknum];
    KKLog(@"setThermometerAlarmInfo==%@",hexString);

    NSString *str = [NSString stringWithFormat:@"%@%@%@%@",Bluetooth_header_Command,Bluetooth_setThermometerAlarm_COMMAND__WRITE,hexString,Bluetooth_footer_Command];
    NSData *data = [NSString convertHexStrToData:str];
    [self.currentPeripheral writeValue:data forCharacteristic:self.InfoSettingCharacteristic type:CBCharacteristicWriteWithResponse];
}











#pragma mark ====开启外设模式，添加服务

- (void)bePeripheral
{
    
    //配置委托
    [self bePeripheralDelegate];
    
    
    //配置第一个服务s1
    CBMutableService *s1 = makeCBService(UUIDSTR_Peripheral_time_SERVICE);
    //配置s1的3个characteristic
    makeCharacteristicToService(s1, UUIDSTR_Peripheral_TIME_MANUFACTURE, nil, UUIDSTR_Peripheral_describe_MANUFACTURE);//读

    //启动外设
    self.baby.bePeripheral().addServices(@[s1]).startAdvertising();

}
- (void)addServicesggg
{

    CBUUID *CBUUIDCharacteristicUserDescriptionStringUUID = [CBUUID UUIDWithString:CBUUIDCharacteristicUserDescriptionString];
    
    /*
     可以通知的Characteristic
     properties：CBCharacteristicPropertyNotify
     permissions CBAttributePermissionsReadable
     */
    CBMutableCharacteristic *notiyCharacteristic = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:UUIDSTR_Peripheral_TIME_MANUFACTURE] properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
    /*
     可读写的characteristics
     properties：CBCharacteristicPropertyWrite | CBCharacteristicPropertyRead
     permissions CBAttributePermissionsReadable | CBAttributePermissionsWriteable
     */
    CBMutableCharacteristic *readwriteCharacteristic = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:UUIDSTR_Peripheral_TIME_MANUFACTURE] properties:CBCharacteristicPropertyWrite | CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsReadable | CBAttributePermissionsWriteable];
    //设置description
    CBMutableDescriptor *readwriteCharacteristicDescription1 = [[CBMutableDescriptor alloc]initWithType: CBUUIDCharacteristicUserDescriptionStringUUID value:@"hhhname"];
    [readwriteCharacteristic setDescriptors:@[readwriteCharacteristicDescription1]];
    
    //service1初始化并加入两个characteristics
    CBMutableService *service1 = [[CBMutableService alloc]initWithType:[CBUUID UUIDWithString:UUIDSTR_Peripheral_time_SERVICE] primary:YES];
    NSLog(@"%@",service1.UUID);
    [service1 setCharacteristics:@[readwriteCharacteristic]];

//    [service1 setCharacteristics:@[notiyCharacteristic,readwriteCharacteristic]];
    self.baby.bePeripheral().addServices(@[service1]).startAdvertising();

}



- (void)bePeripheralDelegate
{
    WeakSelf;
    //设置添加service委托 | set didAddService block
    //外围设备的状态
      [self.baby peripheralModelBlockOnPeripheralManagerDidUpdateState:^(CBPeripheralManager *peripheral) {
          NSLog(@"PeripheralManager-trun-status code: %ld",(long)peripheral.state);
          switch (peripheral.state) {
                      //在这里判断蓝牙设备的状态  当开启了则可调用  setUp方法(自定义)
                  case CBPeripheralManagerStatePoweredOn:
                      NSLog(@"peripheralModelBlockOnPeripheralManagerDidUpdateStatepowered on");
                  //                      [info setText:[NSString stringWithFormat:@"设备名%@已经打开，可以使用center进行连接",LocalNameKey]];
//                      [self setUp];//添加服务
                      break;
                  case CBPeripheralManagerStatePoweredOff:
                      NSLog(@"peripheralModelBlockOnPeripheralManagerDidUpdateStatepowered off");
//                      [info setText:@"powered off"];
                      break;

                  default:
                      break;
              }
      }];
      
    //设置添加service委托 | set didAddService block
    [self.baby peripheralModelBlockOnDidAddService:^(CBPeripheralManager *peripheral, CBService *service, NSError *error) {
        if (error == nil) {
            NSLog(@"添加了服务 DidAddService uuid: %@ ",service.UUID);
        }else{
            NSLog(@"添加服务报错==%@ ",error);
        }

        
    }];
    //设置添加service委托 | set didAddService block
//    //peripheral开始发送advertising,
    [self.baby peripheralModelBlockOnDidStartAdvertising:^(CBPeripheralManager *peripheral, NSError *error) {
        NSLog(@"开始发送广播 didStartAdvertising !!!error==%@",error);
    }];
    
    //中心设备订阅了服务回调
    [self.baby peripheralModelBlockOnDidSubscribeToCharacteristic:^(CBPeripheralManager *peripheral, CBCentral *central, CBCharacteristic *characteristic) {
        NSLog(@"peripheralModelBlockOnDidSubscribeToCharacteristic订阅了 %@的数据",characteristic.UUID);
        weakSelf.isStartAdvertising = YES;
        weakSelf.timePeripheralCharacteristic = characteristic;
        //每秒执行一次给主设备发送一个当前时间的秒数
//        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendData:) userInfo:characteristic  repeats:YES];

    }];
    [self.baby peripheralModelBlockOnDidUnSubscribeToCharacteristic:^(CBPeripheralManager *peripheral, CBCentral *central, CBCharacteristic *characteristic) {
        NSLog(@"取消订阅 %@的数据",characteristic.UUID);
        //取消回应
//        [timer invalidate];
        weakSelf.isStartAdvertising = NO;
    }];

    
    //收到中心设备读请求时触发的方法
    [self.baby peripheralModelBlockOnDidReceiveReadRequest:^(CBPeripheralManager *peripheral, CBATTRequest *request) {
        NSLog(@"peripheralModelBlockOnDidReceiveReadRequest%@",request.value);
        if (request.characteristic.properties & CBCharacteristicPropertyRead) {
                NSData *data = request.characteristic.value;
                [request setValue:data];
                //对请求作出成功响应
                [self.baby.peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
            }else{
                [self.baby.peripheralManager respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
            }
        

    }];
  
    //收到写请求时触发的方法
    [self.baby peripheralModelBlockOnDidReceiveWriteRequests:^(CBPeripheralManager *peripheral, NSArray *requests) {
        NSLog(@"peripheralModelBlockOnDidReceiveWriteRequests%@",requests);
        //判断是否有写数据的权限
//            if (request.characteristic.properties & CBCharacteristicPropertyWrite) {
//                //需要转换成CBMutableCharacteristic对象才能进行写值
//                CBMutableCharacteristic *c =(CBMutableCharacteristic *)request.characteristic;
//                c.value = request.value;
//                [peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
//            }else{
//                [peripheralManager respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
//            }
    }];
     

}


//发送数据，发送当前时间的秒数
-(BOOL)sendTimeAdvertisingData{
        
   NSDate *date = [NSString getCurrentDate];
   NSString *timeStr = [NSString currentDateStrFromDate:date];
   NSString *time16Str = [BabyToy ConvertStringToHexString:timeStr];
    NSData *data = [NSString convertHexStrToData:time16Str];
    KKLog(@"getCurrentDate %@===%@===%@",timeStr,time16Str,data);
    //执行回应Central通知数据
    return  [self.baby.peripheralManager updateValue:data forCharacteristic:(CBMutableCharacteristic *)self.timePeripheralCharacteristic onSubscribedCentrals:nil];

//    return  [self.baby.peripheralManager updateValue:[[dft stringFromDate:[NSDate date]] dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:(CBMutableCharacteristic *)characteristic onSubscribedCentrals:nil];

}

@end
