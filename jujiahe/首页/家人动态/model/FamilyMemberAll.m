//
//  familyMember.m
//  jujiahe
//
//  Created by 刘欣 on 2018/5/24.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "FamilyMemberAll.h"

@implementation FamilyMemberAll
+ (NSDictionary *)objectClassInArray{
    return @{@"form" : [FamilyMember class]};
}
@end

@implementation FamilyMember

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}

@end
