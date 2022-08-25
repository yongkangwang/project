//
//  NSNull+KKObjcSugar.m
//  yunbaolive
//
//  Created by Peter on 2020/4/17.
//  Copyright © 2020 cat. All rights reserved.
//

#import "NSNull+KKObjcSugar.h"
#import <objc/runtime.h>

@implementation NSNull (KKObjcSugar)


//kk六道为了解决这个问题
//-[NSNull rangeOfCharacterFromSet:]: unrecognized selector sent to instance 0x1e08dfc30

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    anInvocation.target = nil;
    [anInvocation invoke];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
     @synchronized([self class])
     {
         //look up method signature
         NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
         if (!signature)
         {
             //not supported by NSNull, search other classes
             static NSMutableSet *classList = nil;
             static NSMutableDictionary *signatureCache = nil;
             static NSMutableArray *kkClassExcludedList = nil;

             if (signatureCache == nil)
             {
                 classList = [[NSMutableSet alloc] init];
                 signatureCache = [[NSMutableDictionary alloc] init];
                 kkClassExcludedList = [NSMutableArray array];
                 //get class list
                 int numClasses = objc_getClassList(NULL, 0);
                 Class *classes = (Class *)malloc(sizeof(Class) * (unsigned long)numClasses);
                 numClasses = objc_getClassList(classes, numClasses);

                 //add to list for checking
                 for (int i = 0; i < numClasses; i++)
                 {
                     //determine if class has a superclass
                     Class someClass = classes[i];
                     Class superclass = class_getSuperclass(someClass);
                     while (superclass)
                     {
                         if (superclass == [NSObject class])
                         {
                             [classList addObject:someClass];
                             break;
                         }
                         [kkClassExcludedList addObject:NSStringFromClass(superclass)];
                         superclass = class_getSuperclass(superclass);
                     }
                 }

                 //remove all classes that have subclasses
                 for (Class someClass in kkClassExcludedList)
                 {
                     [classList removeObject:someClass];
                 }

                 //free class list
                 free(classes);
             }

             //check implementation cache first
             NSString *selectorString = NSStringFromSelector(aSelector);
             signature = signatureCache[selectorString];
             if (!signature)
             {
                 //find implementation
                 for (Class someClass in classList)
                 {
                     if ([someClass instancesRespondToSelector:aSelector])
                     {
                         signature = [someClass instanceMethodSignatureForSelector:aSelector];
                         break;
                     }
                 }

                 //cache for next time
                 signatureCache[selectorString] = signature ?: [NSNull null];
             }
             else if ([signature isKindOfClass:[NSNull class]])
             {
                 signature = nil;
             }
         }
         return signature;
     }
 }
@end
