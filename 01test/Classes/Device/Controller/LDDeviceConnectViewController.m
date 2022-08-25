//
//  LDDeviceConnectViewController.m
//  Thermometer
//
//  Created by Peter on 2022/3/8.
//

#import "LDDeviceConnectViewController.h"

#import "PeripheralInfo.h"
#import "LDDeviceConnectView.h"




#define channelOnPeropheralView @"peripheralView"

@interface LDDeviceConnectViewController ()<LDMyPeripheralDelegate>

@property (nonatomic,strong) NSMutableArray *services;
@property (nonatomic,weak) LDDeviceConnectView *ConnectView;

@property (nonatomic,assign) BOOL isConnection;

@property (nonatomic,weak) UIActivityIndicatorView *ActivityIndicatorV;//菊花


@end

@implementation LDDeviceConnectViewController

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [LDMyPeripheral kkshareBabyBluetooth].PeripheralDelegate = nil;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleL.text = LDMsg(@"测温贴");

    self.isConnection = NO;
    LDMyPeripheral *baby = [LDMyPeripheral kkshareBabyBluetooth];
    [baby havingPeripherals];
    WeakSelf;
    baby.setBlockOnTemperatureToPeripherals = ^(NSDictionary * _Nonnull TemperatureDic) {
        weakSelf.isConnection = YES;
        weakSelf.ConnectView.kkInfoDic = TemperatureDic;
    };
//    baby.setBlockOnBluetoothRecordMode = ^(NSString * _Nonnull string) {
//        [weakSelf resetRootViewController];
//    };
    baby.PeripheralDelegate = self;
    

    LDDeviceConnectView *ConnectView = [[LDDeviceConnectView alloc] init];
    self.ConnectView = ConnectView;
    [self.view addSubview:ConnectView];
    [ConnectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(KKNavH);
        make.bottom.mas_equalTo(-ShowDiff);
    }];
    ConnectView.connectBtnClickBlock = ^(NSString * _Nonnull string) {
        if (weakSelf.isConnection) {
            [[LDMyPeripheral kkshareBabyBluetooth] setBluetoothRecordMode];
        }else{
            [MBProgressHUD kkshowMessage:LDMsg(@"设备获取温度中...")];
        }
//        [weakSelf resetRootViewController];
    };
    ConnectView.CountDownEndBlock = ^(NSString * _Nonnull string) {
        [[LDMyPeripheral kkshareBabyBluetooth] cancelAllPeripheralsConnection];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
//    [kkNotifCenter addObserver:self selector:@selector(writeTimeValueToBluetooth:) name:Global_TIMER_Notfi object:nil];

}

//记录模式回调
- (void)OnBluetoothRecordMode
{
  
    

    
    [self loadData];
    
}

- (void)loadData
{
    
}

- (NSMutableArray *)services
{
    if (!_services) {
        _services = [NSMutableArray array];
    }
    return _services;
}

- (void)dealloc
{

    [LDMyPeripheral kkshareBabyBluetooth].PeripheralDelegate = nil;
}



@end
