//
//  FamilyWarningTableHeaderView.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/20.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "FamilyWarningTableHeaderView.h"

@interface FamilyWarningTableHeaderView ()

@end

@implementation FamilyWarningTableHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:17];
        self.textLabel.textColor = RGBA(0x303030, 1);
        self.backgroundColor = RGBA(0xeaeef1, 1);
    }
    return self;
}

@end
