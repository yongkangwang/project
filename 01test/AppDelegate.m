//
//  AppDelegate.m
//  Thermometer
//
//  Created by Peter on 2022/2/18.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

//#import "FirstLaunchManager.h"
#import "WXApi.h"


@interface AppDelegate ()

@property (nonatomic,assign) BOOL finishLaunch;


@end

@implementation AppDelegate


/***
 
 在这里调用初始化接口,完成接口初始化记得要 调用[FirstLaunchManager finishLaunch]
 因为是监听网络变化,当网络可用的时候会进行一次调用.多次初始化对APP不好.
 如果有特殊需求可以调用[FirstLaunchManager restLaunch]重置初始化,app每次进入会重置一次.
 
 */
//- (void)initNet{
//    if (self.finishLaunch) {
//        [FirstLaunchManager finishLaunch];
//        self.finishLaunch = NO;
//
//    }
//
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.finishLaunch = YES;
//    [[FirstLaunchManager Handler] LaunchApplicationBlock:^{
//        NSLog(@"初始化");
//        [self initNet];
//    }];

    
    if (![KKUserDefaults valueForKey:CurrentLanguage]) {
        [KKUserDefaults setObject:ZH_CN forKey:CurrentLanguage];
        [[LDLanguageTools shareInstance] resetLanguage:[KKUserDefaults objectForKey:CurrentLanguage] withFrom:@"appdelegate"];
    }
//    [KKUserDefaults setObject:EN_language forKey:CurrentLanguage];
//    [[LDLanguageTools shareInstance] resetLanguage:[KKUserDefaults objectForKey:CurrentLanguage] withFrom:@"appdelegate"];

    NSString *urlType = [KKUserDefaults valueForKey:kkCacheNetworkURLType];
    if (urlType ==nil) {
        [KKUserDefaults setValue:kkOneHDNetworkURL forKey:KKLoginNetworkStr];
        [KKUserDefaults setValue:kkOneHLNetworkURL forKey:KKLoginNetwork1V1Str];
        [KKUserDefaults setValue:@"1" forKey:kkCacheNetworkURLType];
    }
    NSString *thermType = [KKUserDefaults valueForKey:THERMOMETERtype];
    if (thermType ==nil) {
        [KKUserDefaults setValue:@"1" forKey:THERMOMETERtype];
    }
    
    [KKUserDefaults setObject:[NSString kkgetLocalAppVersion] forKey:KAppVersion];

    [self kkAddNotific];
    
    return YES;
}



//添加通知
- (void)kkAddNotific
{

    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] registerForRemoteNotifications];//只能在主线程中调用
            });

        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];

    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bannerDidClick:) name:EBBannerViewDidClickNotification object:nil];

}
//
//-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
//{
//    return [WXApi handleOpenURL:url delegate:nil];
//
//}



#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
