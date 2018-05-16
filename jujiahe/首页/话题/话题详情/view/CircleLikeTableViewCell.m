//
//  CircleLikeTableViewCell.m
//  copooo
//
//  Created by XiaMingjiang on 2017/10/25.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "CircleLikeTableViewCell.h"

@implementation CircleLikeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerIcon.layer.cornerRadius = 15;
    self.headerIcon.layer.masksToBounds = YES;
    _headerIcon.layer.masksToBounds = YES;
    _headerIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_headerIcon addGestureRecognizer:tap];
    // Initialization code
}
- (void)tapClick:(UIGestureRecognizer *)tap{
    self.headerIconTapBlock(_headerIcon.tag);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
