//
//  HappenDataModel.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "HappenDataModel.h"

@implementation HappenDataModel

@end

@implementation HappenData
+ (NSDictionary *)objectClassInArray{
    return @{@"myCircles" : [HappenDataMyCircles class],@"microdistrictCircles" : [HappenDataCirclesThings class],@"cityCircles" : [HappenDataCirclesThings class]};
}
@end

@implementation HappenDataMyCircles
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}
@end

@implementation HappenDataCirclesThings
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}
@end


