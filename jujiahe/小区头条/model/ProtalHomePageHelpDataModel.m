//
//  ProtalHomePageHelpDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2017/12/1.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "ProtalHomePageHelpDataModel.h"

@implementation ProtalHomePageHelpDataModel

@end
@implementation ProtalHomePageHelpDataForm

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [ProtalHomePageHelpDataList class]};
}
@end

@implementation ProtalHomePageHelpDataList
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}

@end
