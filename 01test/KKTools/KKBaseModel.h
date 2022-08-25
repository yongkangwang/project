//
//  KKBaseModel.h
//  yunbaolive
//
//  Created by Peter on 2019/12/21.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKBaseModel : NSObject

+(instancetype)baseModelWithDic:(NSDictionary *)dic;

///如果有不能解析的字段，在子类中重写改方法
-(instancetype)baseModelWithDic:(NSDictionary *)dic;


@end

NS_ASSUME_NONNULL_END



