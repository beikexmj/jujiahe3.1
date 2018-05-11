//
//  ProtalHomePageHelpDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2017/12/1.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ProtalHomePageHelpDataForm,ProtalHomePageHelpDataList;
@interface ProtalHomePageHelpDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) ProtalHomePageHelpDataForm *form;

@end

@interface ProtalHomePageHelpDataForm : NSObject

@property (nonatomic, strong) NSArray<ProtalHomePageHelpDataList *> *list;

@end

@interface ProtalHomePageHelpDataList : NSObject

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *contactPerson;

@property (nonatomic, copy) NSString *ids;

@property (nonatomic, copy) NSString *nodeName;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *tel;

@end



