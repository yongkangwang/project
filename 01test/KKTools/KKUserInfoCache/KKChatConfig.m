//
//  KKChatConfig.m
//  yunbaolive
//
//  Created by Peter on 2020/3/2.
//  Copyright © 2020 cat. All rights reserved.
//

#import "KKChatConfig.h"



//温度报警1不报2报
//微信温度报警1不报2报
//系统温度报警1不报2报
//1不报2报
//低电量报警1不报2报
NSString * const cimc_device_prompt = @"cimc_device_prompt";
NSString * const cimc_device_wxprompt = @"cimc_device_wxprompt";
NSString * const cimc_device_systemprompt = @"cimc_device_systemprompt";
NSString * const cimc_device_bluetootprompt = @"cimc_device_bluetootprompt";
NSString * const cimc_device_soclow = @"cimc_device_soclow";




NSString * const cimc_device_explain = @"cimc_device_explain";

NSString * const cimc_device_gun = @"cimc_device_gun";
NSString * const cimc_device_bluetoothmac = @"cimc_device_bluetoothmac";
NSString * const cimc_device_zone = @"cimc_device_zone";
NSString * const cimc_device_type = @"cimc_device_type";
NSString * const cimc_device_number = @"cimc_device_number";
NSString * const cimc_device_gj = @"cimc_device_gj";
NSString * const cimc_device_name = @"cimc_device_name";

NSString * const cimc_user_openid = @"cimc_user_openid";
NSString * const cimc_user_city = @"cimc_user_city";
NSString * const cimc_user_time = @"cimc_user_time";
NSString * const cimc_user_edition = @"cimc_user_edition";
NSString * const cimc_user_pasword = @"cimc_user_pasword";
NSString * const cimc_user_avatar = @"cimc_user_avatar";
NSString * const cimc_user_emal = @"cimc_user_emal";
NSString * const cimc_user_language = @"cimc_user_language";
NSString * const cimc_user_wxnicename = @"cimc_user_wxnicename";
NSString * const cimc_user_nicename = @"cimc_user_nicename";
NSString * const cimc_user_phone = @"cimc_user_phone";


NSString * const cimc_device_replace = @"cimc_device_replace";
NSString * const cimc_device_temperaturetype = @"cimc_device_temperaturetype";
NSString * const cimc_device_hight = @"cimc_device_hight";
NSString * const cimc_device_low = @"cimc_device_low";
NSString * const cimc_device_id = @"cimc_device_id";

NSString * const KKuser_nickname = @"kkuser_nickname";
NSString * const KKconsumption = @"kkconsumption";
NSString * const KKisauth = @"kkisauth";
NSString * const KKisreg = @"kkisreg";
NSString * const KKusersig = @"kkusersig";


NSString * const KKAvatar = @"kkavatar";
NSString * const KKBirthday = @"kkbirthday";
NSString * const KKCoin = @"kkcoin";
NSString * const KKID = @"kkID";
NSString * const KKSex = @"kksex";
NSString * const KKToken = @"kktoken";
NSString * const KKUser_nicename = @"kkuser_nicename";
NSString * const KKSignature = @"kksignature";
NSString * const KKcity = @"kkcity";
NSString * const KKlevel = @"kklevel";
NSString * const kKavatar_thumb = @"kkavatar_thumb";
NSString * const KKlogin_type = @"kklogin_type";
NSString * const KKlevel_anchor = @"kklevel_anchor";


NSString * const KKvip_type = @"kkvip_type";
NSString * const KKliang = @"kkliang";


NSString *const  im_tips = @"im_tips";
//_textView.placeholdLabel.text = [KKChatConfig im_tips];
NSString * const KKMianZhuan = @"kkmianzhuan";


@implementation KKChatConfig

#pragma mark - user profile

//保存靓号和vip
+(void)saveVipandliang:(NSDictionary *)subdic{
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     [userDefaults setObject:minstr([subdic valueForKey:@"vip_type"]) forKey:KKvip_type];
     [userDefaults setObject:minstr([subdic valueForKey:@"liang"]) forKey:KKliang];
     [userDefaults synchronize];
}
+(NSString *)getVip_type{
    
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *viptype = minstr([userDefults objectForKey:KKvip_type]);
    return viptype;
    
}
+(NSString *)getliang{
    
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *liangnum = minstr( [userDefults objectForKey:KKliang]);
    return liangnum;
    
}



+ (void)saveProfile:(LiveUser *)user
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:user.user_nickname forKey:KKuser_nickname];
    [userDefaults setObject:user.user_nickname forKey:KKUser_nicename];

    [userDefaults setObject:user.consumption forKey:KKconsumption];
    [userDefaults setObject:user.isauth forKey:KKisauth];
    [userDefaults setObject:user.isreg forKey:KKisreg];
    [userDefaults setObject:user.usersig forKey:KKusersig];

    
    [userDefaults setObject:user.avatar forKey:KKAvatar];
    [userDefaults setObject:user.level_anchor forKey:KKlevel_anchor];
    [userDefaults setObject:user.avatar_thumb forKey:kKavatar_thumb];
    [userDefaults setObject:user.coin forKey:KKCoin];
    [userDefaults setObject:user.sex forKey:KKSex];
    [userDefaults setObject:user.ID forKey:KKID];
    [userDefaults setObject:user.token forKey:KKToken];
    [userDefaults setObject:user.signature forKey:KKSignature];
    [userDefaults setObject:user.login_type forKey:KKlogin_type];
    
    [userDefaults setObject:user.birthday forKey:KKBirthday];
    [userDefaults setObject:user.city forKey:KKcity];
    [userDefaults setObject:user.level forKey:KKlevel];
    [userDefaults synchronize];
    
}
+ (void)updateProfile:(LiveUser *)user
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    if(user.cimc_user_openid != nil) [userDefaults setObject:user.cimc_user_openid forKey:cimc_user_openid];

    if(user.cimc_device_explain != nil) [userDefaults setObject:user.cimc_device_explain forKey:cimc_device_explain];
    if(user.cimc_device_gun != nil) [userDefaults setObject:user.cimc_device_gun forKey:cimc_device_gun];
    if(user.cimc_device_bluetoothmac != nil) [userDefaults setObject:user.cimc_device_bluetoothmac forKey:cimc_device_bluetoothmac];
    if(user.cimc_device_zone != nil) [userDefaults setObject:user.cimc_device_zone forKey:cimc_device_zone];

    if(user.cimc_device_type != nil) [userDefaults setObject:user.cimc_device_type forKey:cimc_device_type];
    if(user.cimc_device_number != nil) [userDefaults setObject:user.cimc_device_number forKey:cimc_device_number];
    if(user.cimc_device_gj != nil) [userDefaults setObject:user.cimc_device_gj forKey:cimc_device_gj];
    if(user.cimc_device_name != nil) [userDefaults setObject:user.cimc_device_name forKey:cimc_device_name];
    if(user.cimc_device_prompt != nil) [userDefaults setObject:user.cimc_device_prompt forKey:cimc_device_prompt];
    if(user.cimc_device_wxprompt != nil) [userDefaults setObject:user.cimc_device_wxprompt forKey:cimc_device_wxprompt];
    if(user.cimc_device_systemprompt != nil) [userDefaults setObject:user.cimc_device_systemprompt forKey:cimc_device_systemprompt];
    if(user.cimc_device_bluetootprompt != nil) [userDefaults setObject:user.cimc_device_bluetootprompt forKey:cimc_device_bluetootprompt];
    if(user.cimc_device_soclow != nil) [userDefaults setObject:user.cimc_device_soclow forKey:cimc_device_soclow];

    
    
    
    if(user.cimc_user_phone != nil) [userDefaults setObject:user.cimc_user_phone forKey:cimc_user_phone];
    if(user.cimc_user_nicename != nil) [userDefaults setObject:user.cimc_user_nicename forKey:cimc_user_nicename];
    if(user.cimc_user_language != nil) [userDefaults setObject:user.cimc_user_language forKey:cimc_user_language];
    if(user.cimc_user_avatar != nil) [userDefaults setObject:user.cimc_user_avatar forKey:cimc_user_avatar];
    if(user.cimc_user_pasword != nil) [userDefaults setObject:user.cimc_user_pasword forKey:cimc_user_pasword];

    if(user.cimc_user_city != nil) [userDefaults setObject:user.cimc_user_city forKey:cimc_user_city];
    if(user.cimc_user_time != nil) [userDefaults setObject:user.cimc_user_time forKey:cimc_user_time];
    if(user.cimc_user_edition != nil) [userDefaults setObject:user.cimc_user_edition forKey:cimc_user_edition];
    if(user.cimc_user_emal != nil) [userDefaults setObject:user.cimc_user_emal forKey:cimc_user_emal];
    if(user.cimc_user_wxnicename != nil) [userDefaults setObject:user.cimc_user_wxnicename forKey:cimc_user_wxnicename];
    if(user.cimc_device_replace != nil) [userDefaults setObject:user.cimc_device_replace forKey:cimc_device_replace];
    if(user.cimc_device_temperaturetype != nil) [userDefaults setObject:user.cimc_device_temperaturetype forKey:cimc_device_temperaturetype];
  
    
//    .01
    if ([user.cimc_device_temperaturetype isEqualToString:@"1"]) {
        NSString *cimc_device_hightstr = [NSString stringWithFormat:@"%f",[user.cimc_device_hight floatValue]];
        if(user.cimc_device_hight != nil) [userDefaults setObject:cimc_device_hightstr forKey:cimc_device_hight];
        NSString *cimc_device_lowstr = [NSString stringWithFormat:@"%f",[user.cimc_device_low floatValue]];

        if(user.cimc_device_low != nil) [userDefaults setObject:cimc_device_lowstr forKey:cimc_device_low];

    }else{
        
        float kkcimc_device_hight = [user.cimc_device_hight floatValue];
        float kkcimc_device_low = [user.cimc_device_low floatValue];
        if (kkcimc_device_hight >50) {
            kkcimc_device_hight = (kkcimc_device_hight-32)/ 1.8;
            kkcimc_device_low = (kkcimc_device_low-32)/ 1.8;

        }else{
            
        }
        NSString *cimc_device_hightstr = [NSString stringWithFormat:@"%f",kkcimc_device_hight];
        if(user.cimc_device_hight != nil) [userDefaults setObject:cimc_device_hightstr forKey:cimc_device_hight];
        NSString *cimc_device_lowstr = [NSString stringWithFormat:@"%f",kkcimc_device_low];

        if(user.cimc_device_low != nil) [userDefaults setObject:cimc_device_lowstr forKey:cimc_device_low];

    }

    
    if(user.cimc_device_id != nil) [userDefaults setObject:user.cimc_device_id forKey:cimc_device_id];

    if(user.mianzhuan != nil) [userDefaults setObject:user.mianzhuan forKey:KKMianZhuan];

    if(user.ID != nil) [userDefaults setObject:user.ID forKey:KKID];
    if(user.token != nil) [userDefaults setObject:user.token forKey:KKToken];

    if(user.user_nicename != nil) [userDefaults setObject:user.user_nicename forKey:KKUser_nicename];
    if(user.level_anchor != nil) [userDefaults setObject:user.level_anchor forKey:KKlevel_anchor];
    if(user.signature!=nil) [userDefaults setObject:user.signature forKey:KKSignature];
    if(user.avatar!=nil) [userDefaults setObject:user.avatar forKey:KKAvatar];
    if(user.avatar_thumb!=nil) [userDefaults setObject:user.avatar_thumb forKey:kKavatar_thumb];
    if(user.coin!=nil) [userDefaults setObject:user.coin forKey:KKCoin];
    if(user.birthday!=nil) [userDefaults setObject:user.birthday forKey:KKBirthday];
    if(user.login_type!=nil) [userDefaults setObject:user.login_type forKey:KKlogin_type];
    if(user.city!=nil) [userDefaults setObject:user.city forKey:KKcity];
    if(user.sex!=nil) [userDefaults setObject:user.sex forKey:KKSex];
    if(user.level!=nil) [userDefaults setObject:user.level forKey:KKlevel];

    
    if(user.user_nickname!=nil) [userDefaults setObject:user.user_nickname forKey:KKuser_nickname];
    if(user.consumption!=nil) [userDefaults setObject:user.consumption forKey:KKconsumption];
    if(user.isauth!=nil) [userDefaults setObject:user.isauth forKey:KKisauth];
    if(user.isreg!=nil) [userDefaults setObject:user.isreg forKey:KKisreg];
    if(user.usersig!=nil) [userDefaults setObject:user.usersig forKey:KKusersig];

    
    [userDefaults synchronize];
}

+ (void)clearProfile
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setValue:nil forKey:THERMOMETERtype];

    [userDefaults setObject:nil forKey:cimc_device_explain];

    [userDefaults setObject:nil forKey:cimc_device_gun];
    [userDefaults setObject:nil forKey:cimc_device_bluetoothmac];
    [userDefaults setObject:nil forKey:cimc_device_zone];
    [userDefaults setObject:nil forKey:cimc_device_type];
    [userDefaults setObject:nil forKey:cimc_device_number];
    [userDefaults setObject:nil forKey:cimc_device_name];
    [userDefaults setObject:nil forKey:cimc_device_name];
    [userDefaults setObject:nil forKey:cimc_user_time];
    [userDefaults setObject:nil forKey:cimc_user_city];
    [userDefaults setObject:nil forKey:cimc_user_openid];
    
    
    [userDefaults setObject:nil forKey:cimc_device_id];
    [userDefaults setObject:nil forKey:cimc_device_low];
    [userDefaults setObject:nil forKey:cimc_device_hight];
    [userDefaults setObject:nil forKey:cimc_device_temperaturetype];
    [userDefaults setObject:nil forKey:cimc_device_replace];
    [userDefaults setObject:nil forKey:cimc_user_phone];
    [userDefaults setObject:nil forKey:cimc_user_nicename];
    [userDefaults setObject:nil forKey:cimc_user_wxnicename];
    [userDefaults setObject:nil forKey:cimc_user_language];
    [userDefaults setObject:nil forKey:cimc_user_emal];
    [userDefaults setObject:nil forKey:cimc_user_avatar];
    [userDefaults setObject:nil forKey:cimc_user_pasword];
    [userDefaults setObject:nil forKey:cimc_user_edition];

    
    
    [userDefaults setObject:nil forKey:KKuser_nickname];
    [userDefaults setObject:nil forKey:KKconsumption];
    [userDefaults setObject:nil forKey:KKisauth];
    [userDefaults setObject:nil forKey:KKisreg];
    [userDefaults setObject:nil forKey:KKusersig];
    
    [userDefaults setObject:nil forKey:KKlevel_anchor];
    [userDefaults setObject:nil forKey:KKAvatar];
    [userDefaults setObject:nil forKey:KKBirthday];
    [userDefaults setObject:nil forKey:KKCoin];
    [userDefaults setObject:nil forKey:KKID];
    [userDefaults setObject:nil forKey:KKSex];
    [userDefaults setObject:nil forKey:KKToken];
    [userDefaults setObject:nil forKey:KKUser_nicename];
    [userDefaults setObject:nil forKey:KKlogin_type];
    [userDefaults setObject:nil forKey:KKSignature];
    [userDefaults setObject:nil forKey:KKcity];
    [userDefaults setObject:nil forKey:KKlevel];
    [userDefaults setObject:nil forKey:kKavatar_thumb];
    [userDefaults setObject:nil forKey:KKvip_type];
    [userDefaults setObject:nil forKey:KKliang];
    [userDefaults setObject:nil forKey:@"notifacationOldTime"];
    [userDefaults synchronize];
}

+ (LiveUser *)myProfile
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    LiveUser *user = [[LiveUser alloc] init];
    
    
    
    user.cimc_device_explain =[NSString kk_isNullString: [userDefaults objectForKey: cimc_device_explain]];

    user.cimc_device_gun =[NSString kk_isNullString: [userDefaults objectForKey: cimc_device_gun]];

    user.cimc_device_bluetoothmac =[NSString kk_isNullString: [userDefaults objectForKey: cimc_device_bluetoothmac]];
    user.cimc_device_zone =[NSString kk_isNullString: [userDefaults objectForKey: cimc_device_zone]];
    user.cimc_device_type =[NSString kk_isNullString: [userDefaults objectForKey: cimc_device_type]];
    user.cimc_device_number =[NSString kk_isNullString: [userDefaults objectForKey: cimc_device_number]];
    user.cimc_device_gj =[NSString kk_isNullString: [userDefaults objectForKey: cimc_device_gj]];
    user.cimc_device_name =[NSString kk_isNullString: [userDefaults objectForKey: cimc_device_name]];

    user.ID =[NSString kk_isNullString: [userDefaults objectForKey: KKID]];
    user.token = [NSString kk_isNullString: [userDefaults objectForKey: KKID]];
    user.cimc_device_id = [NSString kk_isNullString: [userDefaults objectForKey: KKID]];
    user.cimc_device_hight = [NSString kk_isNullString: [userDefaults objectForKey: cimc_device_hight]];
    user.cimc_device_low = [NSString kk_isNullString: [userDefaults objectForKey: cimc_device_low]];
    user.cimc_device_replace = [NSString kk_isNullString: [userDefaults objectForKey: cimc_device_replace]];
    user.cimc_device_temperaturetype = [NSString kk_isNullString: [userDefaults objectForKey: cimc_device_temperaturetype]];
    user.cimc_device_prompt = [NSString kk_isNullString: [userDefaults objectForKey: cimc_device_prompt]];
    user.cimc_device_wxprompt = [NSString kk_isNullString: [userDefaults objectForKey: cimc_device_wxprompt]];
    user.cimc_device_systemprompt = [NSString kk_isNullString: [userDefaults objectForKey: cimc_device_systemprompt]];
    user.cimc_device_bluetootprompt = [NSString kk_isNullString: [userDefaults objectForKey: cimc_device_bluetootprompt]];
    user.cimc_device_soclow = [NSString kk_isNullString: [userDefaults objectForKey: cimc_device_soclow]];
    user.cimc_user_city = [NSString kk_isNullString: [userDefaults objectForKey: cimc_user_city]];
    user.cimc_user_time = [NSString kk_isNullString: [userDefaults objectForKey: cimc_user_time]];
    user.cimc_user_edition = [NSString kk_isNullString: [userDefaults objectForKey: cimc_user_edition]];
    user.cimc_user_pasword = [NSString kk_isNullString: [userDefaults objectForKey: cimc_user_pasword]];
    user.cimc_user_avatar = [NSString kk_isNullString: [userDefaults objectForKey: cimc_user_avatar]];
    user.cimc_user_emal = [NSString kk_isNullString: [userDefaults objectForKey: cimc_user_emal]];

    
    user.cimc_user_language = [NSString kk_isNullString: [userDefaults objectForKey: cimc_user_language]];
    user.cimc_user_wxnicename = [NSString kk_isNullString: [userDefaults objectForKey: cimc_user_wxnicename]];
    user.cimc_user_nicename = [NSString kk_isNullString: [userDefaults objectForKey: cimc_user_nicename]];
//    user.cimc_user_banbentime = [userDefaults objectForKey: cimc_user_banbentime];
    user.cimc_user_phone = [NSString kk_isNullString: [userDefaults objectForKey: cimc_user_phone]];
    user.cimc_user_openid = [NSString kk_isNullString: [userDefaults objectForKey: cimc_user_openid]];

    
    return user;
    
    
    user.mianzhuan = [userDefaults objectForKey: KKMianZhuan];
    user.user_nickname = [userDefaults objectForKey: KKuser_nickname];
    user.consumption = [userDefaults objectForKey: KKconsumption];
    user.isauth = [userDefaults objectForKey: KKisauth];
    user.isreg = [userDefaults objectForKey: KKisreg];
    user.usersig = [userDefaults objectForKey: KKusersig];

    
    user.avatar = [userDefaults objectForKey: KKAvatar];
    user.birthday = [userDefaults objectForKey: KKBirthday];
    user.coin = [userDefaults objectForKey: KKCoin];
    user.level_anchor = [userDefaults objectForKey: KKlevel_anchor];
    user.ID = [userDefaults objectForKey: KKID];
    user.sex = [userDefaults objectForKey: KKSex];
    user.token = [userDefaults objectForKey: KKToken];
    user.user_nicename = [userDefaults objectForKey: KKUser_nicename];
    user.signature = [userDefaults objectForKey:KKSignature];
    user.level = [userDefaults objectForKey:KKlevel];
    user.city = [userDefaults objectForKey:KKcity];
    user.avatar_thumb = [userDefaults objectForKey:kKavatar_thumb];
    user.login_type = [userDefaults objectForKey:KKlogin_type];

    
    return user;
}







#pragma mark ===== 温度计相关

+(NSString *)getPassWord
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* ID = [userDefaults objectForKey: cimc_user_pasword];
    return [NSString kk_isNullString:ID];

    return ID;
}

+(NSString *)getWeiXin
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* ID = [userDefaults objectForKey: cimc_user_openid];
    return [NSString kk_isNullString:ID];

    return ID;
}

+(NSString *)getPhone
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* ID = [userDefaults objectForKey: cimc_user_phone];
    return [NSString kk_isNullString:ID];
//    return ID;
}


+(NSString *)getCurrentLanguage
{
    return  [KKUserDefaults valueForKey:CurrentLanguage];
}



+(int )getcimc_device_temperaturetype
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   int ID = [[userDefaults objectForKey: cimc_device_temperaturetype] intValue];
//    int ID = [[userDefaults objectForKey: THERMOMETERtype] intValue];
    
    return ID;

}

+(NSString *)getcimc_device_id
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* ID = [userDefaults objectForKey: cimc_device_id];
    return ID;

}

//获取高温报警温度
+(float )getcimc_device_hight
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    float value = [[userDefaults objectForKey: cimc_device_hight] floatValue];
    return value;

}
//获取低温报警温度
+(float )getcimc_device_low
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    float value = [[userDefaults objectForKey: cimc_device_low] floatValue];
    return value;
}



+(NSString *)getOwnID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* ID = [userDefaults objectForKey: KKID];
    return ID;
}

+(NSString *)getOwnNicename
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString* nicename = [userDefaults objectForKey: KKUser_nicename];
    NSString* nicename = [userDefaults objectForKey: cimc_user_nicename];

    return nicename;
}

+(NSString *)getOwnToken
{

    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefults objectForKey:KKToken];
    return token;
}

+(NSString *)getOwnSignature
{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *signature = [userDefults objectForKey:KKSignature];
    return signature;
}
+(NSString *)getavatar
{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *avatar = [NSString stringWithFormat:@"%@",[userDefults objectForKey:KKAvatar]];
    return avatar;
}
+(NSString *)getavatarThumb
{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
//    NSString *signature = [userDefults objectForKey:kKavatar_thumb];
    NSString *signature = [userDefults objectForKey:cimc_user_avatar];

    return signature;
}
+(NSString *)getLevel
{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *level = [userDefults objectForKey:KKlevel];
    return level;
}
+(NSString *)getSex
{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *sex = [userDefults objectForKey:KKSex];
    return sex;
}
+(NSString *)getcoin
{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *coin = [userDefults objectForKey:KKCoin];
    return coin;
}
+(NSString *)level_anchor
{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *level_anchors = [userDefults objectForKey:KKlevel_anchor];
    return level_anchors;
}

+(NSString *)canshu{
    return @"zh_cn";

//    if ([lagType isEqual:ZH_CN]) {
//
//    }
}

+(NSString *)getIsRegisterlogin{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *isauth = [userDefults objectForKey:KKisreg];
    return isauth;
}

+(void)saveRegisterlogin:(NSString *)isreg{
    [[NSUserDefaults standardUserDefaults] setObject:isreg forKey:KKisreg];
}

+(NSString *)getIsauth{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *isauth = [userDefults objectForKey:KKisauth];
    return isauth;
}

+(NSString *)lgetUserSign{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *sign = [userDefults objectForKey:KKusersig];
    return sign;

}
@end
