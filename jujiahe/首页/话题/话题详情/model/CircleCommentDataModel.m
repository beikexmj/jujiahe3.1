//
//  CircleCommentDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2017/11/20.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "CircleCommentDataModel.h"

@implementation CircleCommentDataModel
+ (NSDictionary *)objectClassInArray{
    return @{@"form" : [CircleCommentDataList class]};
}
@end
@implementation CircleCommentDataList
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}

@end

