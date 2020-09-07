//
//  NSArray+Extension.m
//  XCamera
//
//  Created by lzw on 2020/7/11.
//  Copyright © 2020 xhey. All rights reserved.
//

#import "NSArray+Extension.h"
#import <objc/runtime.h>

@implementation NSArray (Extension)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method old = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
        Method new = class_getInstanceMethod(self, @selector(XH_objectAtIndex_NSArrayI:));
        if (old && new) {
            method_exchangeImplementations(old, new);
        }
        
        old = class_getInstanceMethod(objc_getClass("__NSSingleObjectArrayI"), @selector(objectAtIndex:));
        new = class_getInstanceMethod(objc_getClass("__NSSingleObjectArrayI"), @selector(XH_objectAtIndex_NSSingleObjectArrayI:));
        if (old && new) {
            method_exchangeImplementations(old, new);
        }
        
        old = class_getInstanceMethod(objc_getClass("__NSArray0"), @selector(objectAtIndex:));
        new = class_getInstanceMethod(objc_getClass("__NSArray0"), @selector(XH_objectAtIndex_NSArray0:));
        if (old && new) {
            method_exchangeImplementations(old, new);
        }
        
    });
}

- (id)XH_objectAtIndex_NSArrayI:(NSUInteger)index {
    if (index > self.count - 1 || !self.count) {
        @try {
            return [self XH_objectAtIndex_NSArrayI:index];
        } @catch (NSException *exception) {
            NSLog(@"不可数组多元素越界了");
            return nil;
        } @finally {
        }
    } else {
        return [self XH_objectAtIndex_NSArrayI:index];
    }
}

- (id)XH_objectAtIndex_NSSingleObjectArrayI:(NSUInteger)index {
    if (index > self.count - 1 || !self.count) {
        @try {
            return [self XH_objectAtIndex_NSSingleObjectArrayI:index];
        } @catch (NSException *exception) {
            NSLog(@"不可数组一个元素越界了");
            return nil;
        } @finally {
        }
    } else {
        return [self XH_objectAtIndex_NSSingleObjectArrayI:index];
    }
}

- (id)XH_objectAtIndex_NSArray0:(NSUInteger)index {
    if (index > self.count - 1 || !self.count) {
        @try {
            return [self XH_objectAtIndex_NSArray0:index];
        } @catch (NSException *exception) {
            NSLog(@"不可数组0个元素越界了");
            return nil;
        } @finally {
        }
    } else {
        return [self XH_objectAtIndex_NSArray0:index];
    }
}


@end
