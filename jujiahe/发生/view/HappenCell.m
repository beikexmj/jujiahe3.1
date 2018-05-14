//
//  HappenCell.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/14.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "HappenCell.h"

@implementation HappenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.img.layer.cornerRadius = 5;
    self.img.layer.masksToBounds = YES;
    // Initialization code
}

@end
