//
//  ChoseUnitDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2017/11/22.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChoseUnitDataList;
@interface ChoseUnitDataModel : RootDataModel

@property (nonatomic, strong) NSArray<ChoseUnitDataList *> *data;

@end


@interface ChoseUnitDataList : NSObject

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *cityOid;

@property (nonatomic, copy) NSString *distance;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *ids;

@property (nonatomic, copy) NSString *pinyin;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *propertyId;

@property (nonatomic, copy) NSString *propertyName;

@property (nonatomic, copy) NSString *postUserId;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *latitude;

@property (nonatomic, copy) NSString *longitude;

@property (nonatomic, assign) NSInteger isInput;//0未接入本系统 ； 1已接入本系统

@end


