//
//  CircleLikeDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2017/11/20.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "CircleLikeDataModel.h"

@implementation CircleLikeDataModel
+ (NSDictionary *)objectClassInArray{
    return @{@"form" : [CircleLikeDataList class]};
}
@end
@implementation CircleLikeDataList
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}
@end
