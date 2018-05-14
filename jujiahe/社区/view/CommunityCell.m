//
//  CommunityCell.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/14.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "CommunityCell.h"

@implementation CommunityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.img.layer.cornerRadius = 5;
    self.img.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
