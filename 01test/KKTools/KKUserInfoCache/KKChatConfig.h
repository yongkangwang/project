//
//  KKChatConfig.h
//  yunbaolive
//
//  Created by Peter on 2020/3/2.
//  Copyright © 2020 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LiveUser;

NS_ASSUME_NONNULL_BEGIN

@interface KKChatConfig : NSObject

+ (void)saveProfile:(LiveUser *)user;
+ (void)updateProfile:(LiveUser *)user;
+ (void)clearProfile;
+ (LiveUser *)myProfile;




+(NSString *)getCurrentLanguage;

////温度单位1摄氏度2华氏度
+(int )getcimc_device_temperaturetype;

//当前连接的蓝牙设备ID
+(NSString *)getcimc_device_id;
//获取高温报警温度
+(float )getcimc_device_hight;
//获取低温报警温度
+(float )getcimc_device_low;

+(NSString *)getPassWord;

+(NSString *)getWeiXin;

+(NSString *)getPhone;

+(NSString *)getOwnID;
+(NSString *)getOwnNicename;
+(NSString *)getOwnToken;
+(NSString *)getOwnSignature;
+(NSString *)getavatar;//头像大图
+(NSString *)getavatarThumb;//头像小图
+(NSString *)getLevel;
+(NSString *)getSex;
+(NSString *)getcoin;
+(NSString *)level_anchor;//主播等级
+(NSString *)lgetUserSign;//IM签名
+(NSString *)getIsauth;//认证状态

+(void)saveVipandliang:(NSDictionary *)subdic;//保存靓号和vip
+(NSString *)getVip_type;
+(NSString *)getliang;

+(NSString *)canshu;

+(void)saveRegisterlogin:(NSString *)isreg;
+(NSString *)getIsRegisterlogin;
+(NSString *)getIsUserauth;


@end

NS_ASSUME_NONNULL_END
