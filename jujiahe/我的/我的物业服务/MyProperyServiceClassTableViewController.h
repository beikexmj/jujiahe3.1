//
//  MyProperyServiceClassTableViewController.h
//  jujiahe
//
//  Created by 夏明江 on 2018/5/19.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
@interface MyProperyServiceClassTableViewController : BaseTableViewController
@property (nonatomic,copy)NSString *menuId;

@property (nonatomic,copy)NSString *propertyHouseId;//房号id

@property (nonatomic,copy)NSString *propertyHouseName;//小区名称

@property (nonatomic,assign) NSInteger tag;
@end
