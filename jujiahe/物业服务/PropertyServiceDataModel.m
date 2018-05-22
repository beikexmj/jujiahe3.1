//
//  PropertyServiceDataModel.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "PropertyServiceDataModel.h"

@implementation PropertyServiceDataModel

@end

@implementation PropertyServiceData
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [PropertyServiceList class]};
}
@end

@implementation PropertyServiceList

+ (NSDictionary *)objectClassInArray{
    return @{@"menuElements" : [MenuElementsData class]};
}
@end


@implementation MenuElementsData

@end
