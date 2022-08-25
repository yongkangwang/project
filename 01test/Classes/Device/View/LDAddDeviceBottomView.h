//
//  LDAddDeviceBottomView.h
//  Thermometer
//
//  Created by Peter on 2022/3/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LDAddDeviceBottomView : UIView

@property (nonatomic,copy) void(^connectBtnClickBlock)(NSString *string);

@end

NS_ASSUME_NONNULL_END
