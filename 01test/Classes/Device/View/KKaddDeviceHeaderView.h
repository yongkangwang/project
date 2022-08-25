//
//  KKMyPurseContentView.h
//  yunbaolive
//
//  Created by Peter on 2022/2/26.
//  Copyright © 2022 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKaddDeviceHeaderView : UIView
@property (nonatomic,strong) NSDictionary *kkInfoDic;

- (void)starAnimation;
- (void)stopAnimation;

@end

NS_ASSUME_NONNULL_END
