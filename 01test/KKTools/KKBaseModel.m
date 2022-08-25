//
//  KKBaseModel.m
//  yunbaolive
//
//  Created by Peter on 2019/12/21.
//  Copyright © 2019 cat. All rights reserved.
//

#import "KKBaseModel.h"

@implementation KKBaseModel

-(instancetype)baseModelWithDic:(NSDictionary *)dic
{
    
    [self setValuesForKeysWithDictionary:dic];
    
    return self;
}

+(instancetype)baseModelWithDic:(NSDictionary *)dic
{

    return [[[self alloc]init] baseModelWithDic:dic];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{}
@end
