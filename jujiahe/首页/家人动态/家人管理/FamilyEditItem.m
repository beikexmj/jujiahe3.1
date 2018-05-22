//
//  FamilyEditItem.m
//  jujiahe
//
//  Created by kerwin on 2018/5/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "FamilyEditItem.h"

@implementation FamilyEditItem

+ (FamilyEditItem *)itemWithTitle:(NSString *)title placeholder:(NSString *)placeholder value:(id)value type:(FamilyEditItemType)type
{
    FamilyEditItem *item = [[FamilyEditItem alloc] init];
    item.title = title;
    item.placeholder = placeholder;
    item.value = value;
    item.type = type;
    return item;
}

@end
