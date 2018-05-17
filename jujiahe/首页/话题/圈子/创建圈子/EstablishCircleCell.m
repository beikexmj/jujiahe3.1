//
//  EstablishCircleCell.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/17.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "EstablishCircleCell.h"

@implementation EstablishCircleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)choseBtnClick:(id)sender {
    if (self.choseBtnBlock) {
        self.choseBtnBlock();
    }
}
@end
