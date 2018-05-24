//
//  familyMember.h
//  jujiahe
//
//  Created by 刘欣 on 2018/5/24.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FamilyMember;

@interface FamilyMemberAll : NSObject
@property (nonatomic, assign) NSInteger rcode;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) NSArray <FamilyMember *> *form;
@end

@interface FamilyMember : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *headImage;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@end
