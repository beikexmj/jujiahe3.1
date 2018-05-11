//
//  ServiceMemberCell.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/10.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "ServiceMemberCell.h"

@implementation ServiceMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerIcon.layer.cornerRadius = 20;
    self.headerIcon.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)praiseBtnClick:(id)sender {
    UIButton *btn = sender;
    if (self.praiseBtnBlock) {
        self.praiseBtnBlock(btn.tag);
    }
}
- (IBAction)unPraiseBtnClick:(id)sender {
    UIButton *btn = sender;
    if (self.unPraiseBtnBlock) {
        self.unPraiseBtnBlock(btn.tag);
    }
}
@end
