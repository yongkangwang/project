//
//  KKMacroDefinition.h
//  yunbaolive
//
//  Created by Peter on 2019/12/19.
//  Copyright © 2019 cat. All rights reserved.
//

#ifndef KKMacroDefinition_h
#define KKMacroDefinition_h

#ifdef DEBUG
//测试
# define KKLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#else
//生产
//#define BaseUrl @"/"
# define KKLog(...)

#endif



//缓存的域名类型，1、2、3
#define kkCacheNetworkURLType @"kkCacheNetworkURLType"

//cimc.uiqq.top

#define kkOneHDNetworkURL @"http://www.baidu.com/"
#define kkOneHLNetworkURL @"http://www.baidu.com/"

#define kkH5NetworkURL @"http://cimc.uiqq.top/"




//微信
#define WX_ACCESS_TOKEN @"access_token"
#define WX_OPEN_ID @"openid"
#define WX_REFRESH_TOKEN @"refresh_token"



///第一次安装启动
#define KIsFirstLanuch  @"KIsFirstLanuch"



//设备唯一标识，app删掉后会重置
#define kkIDFAstring @"kkIDFstring"

///app版本缓存
#define KAppVersion  @"KAppVersion"

//字号
#define KKTitleFont24 [UIFont systemFontOfSize:24]

#define KKTitleFont18 [UIFont systemFontOfSize:18]
#define KKTitleFont15 [UIFont systemFontOfSize:15]

#define KKTitleFont [UIFont systemFontOfSize:16]
#define KKTitleFont14 [UIFont systemFontOfSize:14]
#define KKPhoenFont13  [UIFont systemFontOfSize:13]

#define KKPhoenFont  [UIFont systemFontOfSize:13.3]
#define KKLabelFont  [UIFont systemFontOfSize:12]
#define KKLab11Font  [UIFont systemFontOfSize:11]

#define KKSmallFont  [UIFont systemFontOfSize:8]
//字体
#define kkFontWithName(Name,sizeThin)   [UIFont fontWithName:(Name) size:(sizeThin)]

//苹方-简 中粗体 PingFangSC-Semibold   加粗Helvetica-Bold这个字重不存在
#define kkFontBoldMT(sizeThin)   [UIFont fontWithName:@"PingFangSC-Semibold" size:(sizeThin)]
//常规字体，苹果默认的就是这个
#define kkFontRegularMT(sizeThin)   [UIFont fontWithName:@"PingFangSC-Regular" size:(sizeThin)]

///语言国际化
#define LDMsg(key) [[LDLanguageTools shareInstance] getStringForKey:key withTable:@"LanguageLocalizable"]
#define ZH_CN @"zh-Hans"
#define CurrentLanguage @"CurrentLanguage"
#define EN_language @"en"


//颜色
//主题色
#define KKNormalColorStr @"#24A1FE"

#define KKNormalColor [UIColor colorWithHexString:KKNormalColorStr]
//文字白色
#define KKWhiteColor [UIColor colorWithHexString:@"#ffffff"]
#define KKBgGrayColor [UIColor colorWithHexString:@"#f5f5f5"]


#define KKPinkColor [UIColor colorWithHexString:@"f49a2f"]
#define KKBgViewColor [UIColor colorWithHexString:@"#fd6c9c"]
#define KKBlackLabColor [UIColor colorWithHexString:@"#333333"]
#define KKBlackTitleLabColor [UIColor colorWithHexString:@"#000000"]
#define KKBtnColor [UIColor colorWithHexString:@"#e13a71"]
#define KKDividingLineColor [UIColor colorWithHexString:@"#e5e5e5"]
#define KKDivideLineColor2 [UIColor colorWithHexString:@"#EDEDED"]

// 屏幕适配
#define KKScreen_bounds [[UIScreen mainScreen] bounds]
#define KKScreenHeight [UIScreen mainScreen].bounds.size.height
#define KKScreenWidth [UIScreen mainScreen].bounds.size.width
#define  _window_width  [UIScreen mainScreen].bounds.size.width
#define _window_height [UIScreen mainScreen].bounds.size.height

//pageviewcontroller宽度
#define _pageBarWidth  (KKScreenWidth *0.9)

// 以6、6s、7、7s、8的宽度为基准进行比例缩放
///针对iphone7适配     iphonex  375   812( 734 )   分辨率1125x2436
#define  KKScale_Width_i7(obj)  ([UIScreen mainScreen].bounds.size.width/375.0f)*obj
#define  KKScale_Height_i7(obj) ([UIScreen mainScreen].bounds.size.height/812.0f)*obj

//这个在接入抖音视频后就获取不准了，导致导航高度不够，具体原因未查。
#define statusbarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height-20)

//适配iphoneX
#define iPhoneX (KKScreenWidth== 375.f && KKScreenHeight == 812.f)||(KKScreenWidth== 414.f && KKScreenHeight == 896.f)||(KKScreenWidth== 812.f && KKScreenHeight == 375.f)||(KKScreenWidth== 896.f && KKScreenHeight == 414.f)||(KKScreenWidth== 390.f && KKScreenHeight == 844.f)
//
//底部安全高度
#define ShowDiff (iPhoneX ? 34: 0)

/** 获取状态栏高度,顶部安全区域远离高度*/
#define kkStatusbarH (iPhoneX ? 44.f: 20.f)
//导航栏高度
#define kkNavHeight 44.f
//导航栏+状态栏高度
#define KKNavH (kkNavHeight + kkStatusbarH)
/*TabBar高度*/
#define kkTabBarHeight (49.0 + ShowDiff)


///字符串判空
#define KKVALUE_STRING(valueString) valueString && ![valueString isKindOfClass:[NSNull class]] ?  [valueString description]:@""

//基础标识
#define KKBaseTag 200

//缓存用户手机号
#define KKUserDefaults [NSUserDefaults standardUserDefaults]

//用户手机号
#define KKUserPhoneNum @"userPhoneNum"

//kk通知
#define kkNotifCenter [NSNotificationCenter defaultCenter]

#define minstr(a)    [NSString stringWithFormat:@"%@",a]

#define WeakSelf __weak typeof(self) weakSelf = self;
#define kkImageCompress 1

//字体
#define SYS_Font(a) [UIFont systemFontOfSize:(a)]


#define RGB_COLOR(_STR_,a) ([UIColor colorWithRed:[[NSString stringWithFormat:@"%lu", strtoul([[_STR_ substringWithRange:NSMakeRange(1, 2)] UTF8String], 0, 16)] intValue] / 255.0 green:[[NSString stringWithFormat:@"%lu", strtoul([[_STR_ substringWithRange:NSMakeRange(3, 2)] UTF8String], 0, 16)] intValue] / 255.0 blue:[[NSString stringWithFormat:@"%lu", strtoul([[_STR_ substringWithRange:NSMakeRange(5, 2)] UTF8String], 0, 16)] intValue] / 255.0 alpha:a])


#define KKRGBA(r, g, b, a) ([UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a])
#define KKRGB(r, g, b) KKRGBA(r,g,b,1)


//温度类型
#define THERMOMETERtype      @"THERMOMETERtype"


//全局定时器，用于给蓝牙写入时间
#define Global_TIMER_Notfi         @"Global_TIMER_Notfi"


///蓝牙端，只有这3个服务
//温度服务
#define UUIDSTR_HEALTH_THERMOMETER_SERVICE      @"1809"
//温度特性
#define UUIDSTR_TEMPERATURE_MANUFACTURE         @"2A1C"
//信息设置特性
#define UUIDSTR_HEALTH_infoSetting_SERVICE      @"2AFF"

//电池服务
#define UUIDSTR_HEALTH_batteries_SERVICE      @"180F"
//电池特性
#define UUIDSTR_batteries_MANUFACTURE         @"2A19"


//信息服务
#define UUIDSTR_HEALTH_info_SERVICE      @"180A"
//生产厂商
#define UUIDSTR_HEALTH_firm_MANUFACTURE      @"2A29"
//设备名称
#define UUIDSTR_HEALTH_firm_name_MANUFACTURE      @"2A24"
//设备序号
#define UUIDSTR_HEALTH_firm_number_MANUFACTURE      @"2A23"

//蓝牙指令
//指令头
#define Bluetooth_header_Command        @"7e7e"
//指令尾
#define Bluetooth_footer_Command        @"7e7e"

//进入记录模式,用的是1809下的2AFF特性
#define Bluetooth_record_COMMAND__WRITE        @"22"
//手动刷新获取数据
#define Bluetooth_manualRereshing_COMMAND__WRITE        @"23"
//设置报警温度
#define Bluetooth_setThermometerAlarm_COMMAND__WRITE        @"24"


//手机端,外设模式服务
////时间服务
//#define UUIDSTR_Peripheral_time_SERVICE        @"00001805-0000-1000-8000-00805f9b34fb"
/////时间特性
//#define UUIDSTR_Peripheral_TIME_MANUFACTURE    @"00002A2B-0000-1000-8000-00805f9b34fb"
////配置描述
//#define UUIDSTR_Peripheral_describe_MANUFACTURE  @"00002902-0000-1000-8000-00805f9b34fb"


//时间服务
#define UUIDSTR_Peripheral_time_SERVICE        @"00001805-0000-1000-8000-00805f9b34fb"
///时间特性
#define UUIDSTR_Peripheral_TIME_MANUFACTURE    @"2A2B"
//配置描述
#define UUIDSTR_Peripheral_describe_MANUFACTURE  @"2902"


#endif /* KKMacroDefinition_h */

