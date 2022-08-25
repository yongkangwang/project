//
//  KKChatMacroDefinition.h
//  yunbaolive
//
//  Created by Peter on 2020/3/4.
//  Copyright © 2020 cat. All rights reserved.
//

#ifndef KKChatMacroDefinition_h
#define KKChatMacroDefinition_h

#ifdef DEBUG
//测试

//腾讯IM
//#define TXIMSdkAppid [[NSString stringWithFormat:@"%@",[KKUserDefaults valueForKey:kkTXIMSdkAppid]] intValue]
//APS推送证书id  24601
//#define kkTXAPSbusiId     @"kkTXAPSbusiId"

#else
//生产
//腾讯IM
//#define TXIMSdkAppid [[NSString stringWithFormat:@"%@",[KKUserDefaults valueForKey:kkTXIMSdkAppid]] integerValue]
//APS推送证书id
//#define kkTXAPSbusiId     @"kkTXAPSbusiId"

#endif


//#import "THeader.h"
//#import "TZImagePickerController.h"
//
//#import "YBAlertView.h"
//#import "YBBaseViewController.h"
//
//#import "KKChatConfig.h"
//#import "KKliveCommon.h"
//#import "KKcommon.h"
//#import "KKcityDefault.h"


//腾讯IM

//#define TXIMSdkAccountType    @""
//#define TXIMSdkBusiId   
//#define kkTXIMSdkAppid  @"kkTXIMSdkAppid"

//
//#define kkdeviceToken  @"kkdeviceToken"

//腾讯收费版SDK licence、key

//#define kkLicenceURL   @"kkLicenceURL"
//#define kkLicenceKey   @"kkLicenceKey"
//#define kkLicencePushURL   @"kkLicencePushURL"
//#define kkLicencePushKey   @"kkLicencePushKey"

//录制短视频
//#define LicenceURL [NSString stringWithFormat:@"%@",[KKUserDefaults valueForKey:kkLicenceURL]]
//#define LicenceKey [NSString stringWithFormat:@"%@",[KKUserDefaults valueForKey:kkLicenceKey]]
////视频通话
//#define LicencePushURL [NSString stringWithFormat:@"%@",[KKUserDefaults valueForKey:kkLicencePushURL]]
//#define LicencePushKey [NSString stringWithFormat:@"%@",[KKUserDefaults valueForKey:kkLicencePushKey]]


//#define EmojiHeight 200

 
//获取手机系统版本
//#define SysVersion [[UIDevice currentDevice] systemVersion].floatValue


//各种字体颜色
//#define color32 RGB_COLOR(@"#323232",1)
//#define color66 RGB_COLOR(@"#666666",1)
//#define colorCC RGB_COLOR(@"#cccccc",1)
//#define color96 RGB_COLOR(@"#969696",1)
//#define color99 RGB_COLOR(@"#999999",1)
//#define colorf5 RGB_COLOR(@"#f5f5f5",1)

//#define RGBA(r, g, b, a)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]


//动态通知用
//#define PAUSEVIODEINDETAIL @"PAUSEVIODEINDETAIL"
//#define RESUMEVIODEINDETAIL @"RESUMEVIODEINDETAIL"
//#define REMOVEALLVIODEORVOICE @"REMOVEALLVIODEORVOICE"


////短视频录制时长控制
//#define MAX_RECORD_TIME             15
//#define MIN_RECORD_TIME             3
//
//#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH > 736.0)
//
//#define RECOEDTIME @"60s"


//抖音 架构====================

//#define SafeAreaBottomHeight ((KKScreenHeight >= 812.0) && [[UIDevice currentDevice].model isEqualToString:@"iPhone"]  ? 30 : 0)
//
//#define ADAPTATIONRATIO     (KKScreenWidth / 750.0f)
//
//#define ColorWhiteAlpha80 RGBA(255.0, 255.0, 255.0, 0.8)
////
//#define ColorBlackAlpha1 RGBA(0.0, 0.0, 0.0, 0.01)
//#define ColorBlackAlpha20 RGBA(0.0, 0.0, 0.0, 0.2)
//#define ColorBlackAlpha40 RGBA(0.0, 0.0, 0.0, 0.4)
//
//#define ColorThemeRed RGBA(241.0, 47.0, 84.0, 1.0)
//

// 颜色
//#define GKColorRGBA(r, g, b, a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]
//#define GKColorRGB(r, g, b)     GKColorRGBA(r, g, b, 1.0)
//#define GKColorGray(v)          GKColorRGB(v, v, v)


// 来自YYKit
//#ifndef weakify
//    #if DEBUG
//        #if __has_feature(objc_arc)
//        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
//        #else
//        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
//        #endif
//    #else
//        #if __has_feature(objc_arc)
//        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
//        #else
//        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
//        #endif
//    #endif
//#endif
//
//#ifndef strongify
//    #if DEBUG
//        #if __has_feature(objc_arc)
//        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
//        #else
//        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
//        #endif
//    #else
//        #if __has_feature(objc_arc)
//        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
//        #else
//        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
//        #endif
//    #endif
//#endif


#endif /* KKChatMacroDefinition_h */
