//
//  ProtalHomePageTableViewCell.m
//  copooo
//
//  Created by XiaMingjiang on 2017/11/14.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "ProtalHomePageTableViewCell.h"

@implementation ProtalHomePageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _topicsMark.layer.cornerRadius = 5;
    _topicsMark.layer.masksToBounds = YES;
    _topicsMark2.layer.cornerRadius = 5;
    _topicsMark2.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
