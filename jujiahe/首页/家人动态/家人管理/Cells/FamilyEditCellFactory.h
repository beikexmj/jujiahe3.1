//
//  FamilyEditCellFactory.h
//  jujiahe
//
//  Created by kerwin on 2018/5/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FamilyEditItem.h"

@interface FamilyEditCellFactory : NSObject

+ (UITableViewCell *)factoryCellWithTableView:(UITableView *)tableView item:(FamilyEditItem *)item;

@end
