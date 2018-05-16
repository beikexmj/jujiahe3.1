//
//  CircleCommentTableViewCell.m
//  copooo
//
//  Created by XiaMingjiang on 2017/10/25.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "CircleCommentTableViewCell.h"

@implementation CircleCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.icon.layer.cornerRadius = 15;
    self.icon.layer.masksToBounds = YES;
    _icon.layer.masksToBounds = YES;
    _icon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_icon addGestureRecognizer:tap];
    // Initialization code
}
- (void)tapClick:(UIGestureRecognizer *)tap{
    self.headerIconTapBlock(_icon.tag);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
