//
//  LDLanguageTools.m
//  Thermometer
//
//  Created by Peter on 2022/2/24.
//

#import "LDLanguageTools.h"

//#import "LDTabBarController.h"
#import <UIKit/UIKit.h>

static LDLanguageTools *shareTool = nil;

@interface LDLanguageTools()

@property(nonatomic,strong)NSBundle *bundle;
@property(nonatomic,copy)NSString *language;

@end

@implementation LDLanguageTools

+(id)shareInstance {
    @synchronized (self) {
        if (shareTool == nil) {
            shareTool = [[LDLanguageTools alloc]init];
        }
    }
    return shareTool;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone {
    if (shareTool == nil) {
        shareTool = [super allocWithZone:zone];
    }
    return shareTool;
}

-(NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table {
    if (self.bundle) {
        return NSLocalizedStringFromTableInBundle(key, table, self.bundle, @"");
    }
    return NSLocalizedStringFromTable(key, table, @"");
}

-(void)resetLanguage:(NSString *)language withFrom:(NSString *)appdelegate{
    if ([language isEqualToString:self.language]) {
        return;
    }
    if ([language isEqualToString:@"kor"]) {
        language = @"ko";
    }
    if ([language isEqualToString:@"en"] || [language isEqualToString:@"zh-Hans"] || [language isEqualToString:@"ko"]) {
        NSString *path = [[NSBundle mainBundle]pathForResource:language ofType:@"lproj"];
        self.bundle = [NSBundle bundleWithPath:path];
    }
    self.language = language;

    
    [[NSUserDefaults standardUserDefaults]synchronize];
    if (![appdelegate isEqualToString:@"appdelegate"]) {
        [self resetRootViewController];
    }
    
}
-(void)resetRootViewController {
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        LDTabBarController *root = [[LDTabBarController alloc]init];
//        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:root];
//      UIWindow *window =  [UIApplication sharedApplication].windows.lastObject;
//        window.rootViewController = navi;
//    });

}

@end
