//
//  NSObject+Empty.m
//  jujiahe
//
//  Created by kerwin on 2018/5/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "NSObject+Empty.h"

@implementation NSObject (Empty)

- (BOOL)is_empty
{
    if (self == [NSNull null]) {
        return YES;
    }
    if ([self isKindOfClass:[NSString class]]) {
        return ((NSString *) self).length == 0;
    }
    if ([self isKindOfClass:[NSArray class]]) {
        return ((NSArray *) self).count == 0;
    }
    if ([self isKindOfClass:[NSDictionary class]]) {
        return ((NSDictionary *) self).count == 0;
    }
    if ([self isKindOfClass:[NSSet class]]) {
        return ((NSSet *) self).count == 0;
    }
    return NO;
}

@end
