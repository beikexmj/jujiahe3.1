//
//  CommunityDataModel.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/23.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "CommunityDataModel.h"

@implementation CommunityDataModel
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [CommunityData class]};
}
@end
@implementation CommunityData
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}
@end
