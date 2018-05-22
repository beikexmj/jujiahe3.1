//
//  FamilyEditPickerCell.m
//  jujiahe
//
//  Created by kerwin on 2018/5/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "FamilyEditPickerCell.h"

@implementation FamilyEditPickerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textLabel.textColor = RGBA(0x606060, 1);
        self.textLabel.font = [UIFont systemFontOfSize:15];
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:15];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.textLabel.yz_x != 15) {
        self.textLabel.yz_x = 15;
    }
}

- (void)setItem:(FamilyEditItem *)item
{
    _item = item;
    self.textLabel.text = item.title;
    if (item.value && ![item.value is_empty]) {
        self.detailTextLabel.textColor = RGBA(0x9c9c9c, 1);
        self.detailTextLabel.text = item.placeholder;
    } else {
        self.detailTextLabel.textColor = RGBA(0x303030, 1);
        self.detailTextLabel.text = item.value;
    }
}

@end
