//
//  KKHttpAPIConfigure.h
//  六道
//
//  Created by caomaolufei on 2019/12/16.
//  Copyright © 2019年 OnePiece. All rights reserved.
//

#ifndef KKAPPInfoConfigure_h
#define KKAPPInfoConfigure_h


//直播缓存的域名
#define KKLoginNetworkStr @"KKLoginNetworkStr"
//1V1
#define KKLoginNetwork1V1Str @"KKLoginNetwork1V1Str"






//===================写死的app配置，========================
#warning 每次新封包修改一下
//协议名称 例如 现在demo中用到的有 (云豹充值协议 云豹平台协议 云豹私聊APP协议)
#define kkProtocolName @"蓝牙"
//appstore app id
#define AppID @""



//版本号 用于后台统计，6位数不可随意更改
#define KKAppVersionNum @"100003"
//app版本，每次上架都要变
#define KKAppVersionStr @"2.8.1"

//APS推送证书id
#define kkDefaultTXAPSbusiId @"30713"



//以下是写活的在KKPostUserLoginTimeInfoApi 接口中有返回
//游戏提醒、直播大群
#define KKDefaultLiveGroupMessageID @"20201028"
//聊天大群
#define KKDefaultLiveGroupChatID @"20201106"
//聊天大群名字
#define KKDefaultLiveGroupChatName @"大厅"
//腾讯IM  在登录接口有返回
#define kkDefaultTXIMSdkAppid  @""

//===================================================

#define APP_ID @"" //填入微信申请的APP的appid
#define wxappSecret @"" //填入微信申请的APP的appSecret

//一键登录KEY/废弃的
#define KKDefaultJVAuthConfigAPPKEY @""



#endif /* KKAPPInfoConfigure_h */

