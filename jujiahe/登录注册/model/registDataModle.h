//
//  registDataModle.h
//  copooo
//
//  Created by 夏明江 on 16/9/2.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Data,UserResultModel;
@interface registDataModle : RootDataModel

@property (nonatomic, strong) Data *data;

@end
@interface Data : NSObject

@property (nonatomic, copy) NSString *uToken;
@property (nonatomic, strong) UserResultModel *userResultModel;

@end
@interface UserResultModel : NSObject

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *area;

@property (nonatomic, copy) NSString *birthday;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *ids;

@property (nonatomic, copy) NSString *lastTime;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *portrait;

@property (nonatomic, copy) NSString *realname;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *zipCode;


@end

