//
//  NSArray+KKObjcSugar.m
//  yunbaolive
//
//  Created by Peter on 2022/2/12.
//  Copyright © 2022 cat. All rights reserved.
//

#import "NSArray+KKObjcSugar.h"

#define kATRegular @"@[\\u4e00-\\u9fa5\\w\\-\\_]+ "

@implementation NSArray (KKObjcSugar)
+ (NSArray *) getMatchsWithStr : (NSString *) text{
    // 找到文本中所有的@
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kATRegular options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, [text length])];
    return matches;
}
@end
