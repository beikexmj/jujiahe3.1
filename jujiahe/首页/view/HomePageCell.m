//
//  HomePageCell.m
//  copooo
//
//  Created by XiaMingjiang on 2018/1/18.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "HomePageCell.h"
#import "UIView+Extensions.h"

@interface HomePageCell ()

@end

@implementation HomePageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageOne.layer.cornerRadius = 5;
    self.imageTwo.layer.cornerRadius = 5;
    self.imageOneInViewThree.layer.cornerRadius = 5;
    self.imageTwoInViewThree.layer.cornerRadius = 5;
    self.imageThreeInViewThree.layer.cornerRadius = 5;
    self.imageOne.layer.masksToBounds = YES;
    self.imageTwo.layer.masksToBounds = YES;
    self.imageOneInViewThree.layer.masksToBounds = YES;
    self.imageTwoInViewThree.layer.masksToBounds = YES;
    self.imageThreeInViewThree.layer.masksToBounds = YES;
    self.markOne.layer.cornerRadius = 5;
    self.markTwo.layer.cornerRadius = 5;
    self.markThree.layer.cornerRadius = 5;
    self.markOne.layer.masksToBounds  = YES;
    self.markTwo.layer.masksToBounds = YES;
    self.markThree.layer.masksToBounds = YES;
    self.followBtnOne.layer.cornerRadius = 5;
    self.followBtnOne.layer.borderWidth = 1;
    self.followBtnTwo.layer.cornerRadius = 5;
    self.followBtnTwo.layer.borderWidth = 1;
    self.followBtnThree.layer.cornerRadius = 5;
    self.followBtnThree.layer.borderWidth = 1;
    // Initialization code
}

- (IBAction)followBtnOneClick:(id)sender {
    UIButton *btn = sender;
    if (self.followBtnOneBlock) {
        self.followBtnOneBlock(btn.tag);
    }
}

- (IBAction)followBtnTwoClick:(id)sender {
    UIButton *btn = sender;
    if (self.followBtnTwoBlock) {
        self.followBtnTwoBlock(btn.tag);
    }
}
- (IBAction)followBtnThreeClick:(id)sender {
    UIButton *btn = sender;
    if (self.followBtnThreeBlock) {
        self.followBtnThreeBlock(btn.tag);
    }
}
@end
