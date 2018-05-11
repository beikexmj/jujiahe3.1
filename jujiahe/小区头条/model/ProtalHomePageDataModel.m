//
//  ProtalHomePageDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2017/11/24.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "ProtalHomePageDataModel.h"

@implementation ProtalHomePageDataModel

@end
@implementation ProtalHomePageDataForm

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [ProtalHomePageDataList class]};
}
@end

@implementation ProtalHomePageDataList
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}

@end
