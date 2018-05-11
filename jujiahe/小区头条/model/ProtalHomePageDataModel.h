//
//  ProtalHomePageDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2017/11/24.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ProtalHomePageDataForm,ProtalHomePageDataList;
@interface ProtalHomePageDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) ProtalHomePageDataForm *form;

@end

@interface ProtalHomePageDataForm : NSObject

@property (nonatomic, strong) NSArray<ProtalHomePageDataList *> *list;

@end

@interface ProtalHomePageDataList : NSObject

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *ids;

@property (nonatomic, assign) NSInteger layout;

@property (nonatomic, copy) NSString *newsType;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *thumb;

@property (nonatomic, copy) NSString *thumbSmall;

@property (nonatomic, copy) NSString *titlePrimary;

@property (nonatomic, assign) NSInteger up;

@property (nonatomic, copy) NSString *updateTime;


@end


