//
//  PropertyServiceDataModel.h
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PropertyServiceList,MenuElementsData,PropertyServiceData;

@interface PropertyServiceDataModel : RootDataModel

@property (nonatomic, strong) PropertyServiceData *data;


@end

@interface PropertyServiceData : NSObject

@property (nonatomic, strong) NSArray <PropertyServiceList *> *list;

@property (nonatomic, copy) NSString *houseId;

@end

@interface PropertyServiceList : NSObject

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray <MenuElementsData *> *menuElements;

@end

@interface MenuElementsData : NSObject

@property (nonatomic, copy) NSString *link;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, assign) NSInteger isHot;

@end
