//
//  NSArray+KKObjcSugar.h
//  yunbaolive
//
//  Created by Peter on 2022/2/12.
//  Copyright © 2022 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (KKObjcSugar)
+ (NSArray *) getMatchsWithStr : (NSString *) text;

@end

NS_ASSUME_NONNULL_END
