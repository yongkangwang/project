//
//  LDDeviceConnectView.h
//  Thermometer
//
//  Created by Peter on 2022/3/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LDDeviceConnectView : UIView

@property (nonatomic,strong) NSDictionary *kkInfoDic;
//进入记录模式
@property (nonatomic,copy) void(^connectBtnClickBlock)(NSString *string);
//
//- (void)starAnimation;
//- (void)stopAnimation;

//倒计时
- (void)starCountDownWithWidget;
@property (nonatomic,copy) void(^CountDownEndBlock)(NSString *string);

@end

NS_ASSUME_NONNULL_END
