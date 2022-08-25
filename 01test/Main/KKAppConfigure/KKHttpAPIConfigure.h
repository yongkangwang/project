//
//  KKHttpAPIConfigure.h
//  六道
//
//  Created by caomaolufei on 2019/12/16.
//  Copyright © 2019年 OnePiece. All rights reserved.
//

#ifndef KKHttpAPIConfigure_h
#define KKHttpAPIConfigure_h

#pragma mark -- 接口环境切换
#ifdef DEBUG

//hd
#define KKBaseUrl [NSString stringWithFormat:@"%@%@",[KKUserDefaults valueForKey:KKLoginNetworkStr],@""]
//自己服务器新接口 hd
#define KKBaseUrl2 [NSString stringWithFormat:@"%@%@",[KKUserDefaults valueForKey:KKLoginNetworkStr],@""]

//hd
#define purl [NSString stringWithFormat:@"%@%@",[KKUserDefaults valueForKey:KKLoginNetworkStr],@""]
//hd
#define h5url [NSString stringWithFormat:@"%@%@",[KKUserDefaults valueForKey:KKLoginNetworkStr],@""]

//socket平台通告
#define KKSocketRocket @""

//1V1 hl
#define kkpurl [NSString stringWithFormat:@"%@%@",[KKUserDefaults valueForKey:KKLoginNetwork1V1Str],@""]

#else
//生产
#define KKBaseUrl [NSString stringWithFormat:@"%@%@",[KKUserDefaults valueForKey:KKLoginNetworkStr],@""]
#define KKBaseUrl2 [NSString stringWithFormat:@"%@%@",[KKUserDefaults valueForKey:KKLoginNetworkStr],@""]

#define purl [NSString stringWithFormat:@"%@%@",[KKUserDefaults valueForKey:KKLoginNetworkStr],@""]
#define h5url [NSString stringWithFormat:@"%@%@",[KKUserDefaults valueForKey:KKLoginNetworkStr],@""]
//socket平台通告
#define KKSocketRocket @"ws://worker.bomicloud.com:7272"
//嗨聊1V1
#define kkpurl [NSString stringWithFormat:@"%@%@",[KKUserDefaults valueForKey:KKLoginNetwork1V1Str],@""]

#endif

#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>

// -- 网络接口类


#import <AFNetworking/AFHTTPSessionManager.h>


//自定义工具


#import "UIColor+KKObjcSugar.h"
#import "NSString+KKObjcSugar.h"
#import "NSURL+KKObjcSugar.h"
#import "UIView+KKSugar.h"
#import "NSNull+KKObjcSugar.h"
#import "UIView+shadowPath.h"
#import "UIButton+KKObjcSugar.h"
#import "UIView+ITTAdditions.h"

#import "NSDate+KKObjcSugar.h"
#import "NSNotification+Extension.h"
#import "NSAttributedString+Extension.h"
#import "UIView+Frame.h"
#import "MBProgressHUD+MJ.h"

#import "LDLanguageTools.h"

#import "LiveUser.h"
#import "KKChatConfig.h"




#import "YBToolClass.h"


#import "LDBluetoothModel.h"
#import "LDMyPeripheral.h"
//控件多次点击问题
//#import "UIControl+recurClick.h"


//#import "KKInfoCache.h"

//第三方库
//下拉刷新动画
#import "UIScrollView+AJWaveRefresh.h"
#import <MJRefresh/MJRefresh.h>

//#import <BabyBluetooth/BabyBluetooth.h>
#import <CoreBluetooth/CoreBluetooth.h>

///蓝牙数据解析
#import "ISHTDataParser.h"

//#import "WMZFloatManage.h"
//下载渠道统计、应用分发 
//#import "OpenInstallSDK.h"

//trtc
//#import "TCASKitTheme.h"
//#define kScreenValue(value) value * 375 / [UIScreen mainScreen].bounds.size.width

//加载GIF
//#import "FLAnimatedImageView.h"
//#import "FLAnimatedImage.h"



#endif /* KKHttpAPIConfigure_h */

