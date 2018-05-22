//
//  FamilyManageEditSectionView.m
//  jujiahe
//
//  Created by kerwin on 2018/5/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "FamilyManageEditSectionView.h"

@implementation FamilyManageEditSectionView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.textLabel.textColor = RGBA(0x00a7ff, 1);
    self.textLabel.yz_x = 15;
}

@end
