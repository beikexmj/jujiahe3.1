//
//  FamilyEditItem.h
//  jujiahe
//
//  Created by kerwin on 2018/5/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FamilyEditItemType) {
    FamilyEditItemTypeInput = 0,
    FamilyEditItemTypePicker,
    FamilyeditItemTypeCheckmarker,
};

@interface FamilyEditItem : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy, nullable) NSString *placeholder;
@property (nonatomic, strong, nullable) id value;

@property (nonatomic) FamilyEditItemType type;

+ (FamilyEditItem *)itemWithTitle:(NSString *)title
                      placeholder:(nullable NSString *)placeholder
                            value:(nullable id)value
                             type:(FamilyEditItemType)type;

@end

NS_ASSUME_NONNULL_END
