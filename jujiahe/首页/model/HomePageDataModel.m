//
//  HomePageDataModel.m
//  copooo
//
//  Created by XiaMingjiang on 2018/1/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "HomePageDataModel.h"

@implementation HomePageDataModel

@end

@implementation HomePageData
+ (NSDictionary *)objectClassInArray{
    return @{@"recommendedResultModelList" : [RecommendedResultModelList class]};
}
@end

@implementation WeatherResultModel


@end

@implementation RecommendedResultModelList

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}

@end

@implementation TopicModel

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [TopicModelData class]};
}

@end

@implementation TopicModelData
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}
@end

