//
//  LiveUser.h
//  yunbaolive
//
//  Created by cat on 16/3/9.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveUser : NSObject

@property (nonatomic, strong)NSString *ID;
@property (nonatomic, strong)NSString *token;




//产品说明
@property (nonatomic, strong)NSString *cimc_device_explain;

//设备信号强度
@property (nonatomic, strong)NSString *cimc_device_gun;

//蓝牙MAC地址
@property (nonatomic, strong)NSString *cimc_device_bluetoothmac;

//设备时区
@property (nonatomic, strong)NSString *cimc_device_zone;

//设备型号,ZJZL_HTS
@property (nonatomic, strong)NSString *cimc_device_type;

//设备序列号
@property (nonatomic, strong)NSString *cimc_device_number;

//设备固件
@property (nonatomic, strong)NSString *cimc_device_gj;

//设备名称
@property (nonatomic, strong)NSString *cimc_device_name;

//当前连接的蓝牙设备ID，后台返回的。
@property (nonatomic, strong)NSString *cimc_device_id;
//高温报警温度
@property (nonatomic, strong)NSString *cimc_device_hight;
//低温报警温度
@property (nonatomic, strong)NSString *cimc_device_low;
//自动更新间隔
@property (nonatomic, strong)NSString *cimc_device_replace;
//温度单位1摄氏度2华氏度
@property (nonatomic, strong)NSString *cimc_device_temperaturetype;

@property (nonatomic, strong)NSString *cimc_device_prompt;//温度报警1不报2报
@property (nonatomic, strong)NSString *cimc_device_wxprompt;//微信温度报警1不报2报
@property (nonatomic, strong)NSString *cimc_device_systemprompt;//系统温度报警1不报2报
@property (nonatomic, strong)NSString *cimc_device_bluetootprompt;//蓝牙报警1不报2报
@property (nonatomic, strong)NSString *cimc_device_soclow;//低电量报警1不报2报

    


@property (nonatomic, strong)NSString *cimc_user_city;
@property (nonatomic, strong)NSString *cimc_user_time;
@property (nonatomic, strong)NSString *cimc_user_edition;
@property (nonatomic, strong)NSString *cimc_user_pasword;
@property (nonatomic, strong)NSString *cimc_user_avatar;
@property (nonatomic, strong)NSString *cimc_user_emal;
@property (nonatomic, strong)NSString *cimc_user_language;
@property (nonatomic, strong)NSString *cimc_user_wxnicename;//微信昵称

@property (nonatomic, strong)NSString *cimc_user_nicename;
@property (nonatomic, strong)NSString *cimc_user_banbentime;
@property (nonatomic, strong)NSString *cimc_user_phone;
@property (nonatomic, strong)NSString *cimc_user_openid;//微信绑定字段


@property (nonatomic, strong)NSString *avatar;//用户大头像
@property (nonatomic, strong)NSString *birthday;
@property (nonatomic, strong)NSString *coin;
@property (nonatomic, strong)NSString *sex;
@property (nonatomic, strong)NSString *user_nicename;
@property (nonatomic, strong)NSString *signature;
@property (nonatomic, strong)NSString *city;
@property (nonatomic, strong)NSString *level;
@property (nonatomic, strong)NSString *level_anchor;
@property (nonatomic, strong)NSString *avatar_thumb;//用户小头像
@property (nonatomic, strong)NSString *login_type;
//免转,1没开启，2开启
@property (nonatomic,copy) NSString * mianzhuan;



@property (nonatomic,copy) NSString * user_nickname;
@property (nonatomic,copy) NSString * consumption;
@property (nonatomic,copy) NSString * isauth;
@property (nonatomic,copy) NSString * isreg;
@property (nonatomic,copy) NSString * usersig;//腾讯聊天签名

@property (nonatomic, strong)NSString *isUserauth;





-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
-(instancetype)initWithDic:(NSDictionary *) dic;
+(instancetype)modelWithDic:(NSDictionary *) dic;

@end
