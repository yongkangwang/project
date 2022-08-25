//
//  KKMyPurseTableViewCell.h
//  yunbaolive
//
//  Created by Peter on 2022/2/26.
//  Copyright © 2022 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKaddDeviceTableViewCell : UITableViewCell
+ (instancetype)cellWithTabelView:(UITableView *)tableView;
@property (nonatomic,strong) NSDictionary *kkInfoDic;

@end

NS_ASSUME_NONNULL_END
