//
//  FamilyEditCellFactory.m
//  jujiahe
//
//  Created by kerwin on 2018/5/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "FamilyEditCellFactory.h"
#import "FamilyEditTextFieldCell.h"
#import "FamilyEditPickerCell.h"
#import "FamilyEditCheckmarkerCell.h"

static NSString *const kFamilyEditTableViewInputCell = @"com.copticomm.jjh.family.edit.tableview.cell.input";
static NSString *const kFamilyEditTableViewPickerCell = @"com.copticomm.jjh.family.edit.tableview.cell.picker";
static NSString *const kFamilyEditTableViewCheckmarker = @"com.copticomm.jjh.family.edit.tableview.cell.checkmarker";

@implementation FamilyEditCellFactory

+ (UITableViewCell *)factoryCellWithTableView:(UITableView *)tableView item:(FamilyEditItem *)item
{
    if (item.type == FamilyEditItemTypeInput) {
        FamilyEditTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:kFamilyEditTableViewInputCell];
        if (!cell) {
            cell = [[FamilyEditTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:kFamilyEditTableViewInputCell];
        }
        cell.item = item;
        return cell;
    } else if (item.type == FamilyEditItemTypePicker) {
        FamilyEditPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:kFamilyEditTableViewPickerCell];
        if (!cell) {
            cell = [[FamilyEditPickerCell alloc] initWithStyle:UITableViewCellStyleValue1
                                               reuseIdentifier:kFamilyEditTableViewPickerCell];
        }
        cell.item = item;
        return cell;
    } else {
        FamilyEditCheckmarkerCell *cell = [tableView dequeueReusableCellWithIdentifier:kFamilyEditTableViewCheckmarker];
        if (!cell) {
            cell = [[FamilyEditCheckmarkerCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:kFamilyEditTableViewCheckmarker];
        }
        cell.item = item;
        return cell;
    }
}

@end
