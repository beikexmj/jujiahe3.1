//
//  FamilyEditCheckmarkerCell.m
//  jujiahe
//
//  Created by kerwin on 2018/5/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "FamilyEditCheckmarkerCell.h"

@interface FamilyEditCheckmarkerCell ()

@property (nonatomic, strong) UIButton *stateButton;

@end

@implementation FamilyEditCheckmarkerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.stateButton];
        [self setupConstraints];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.textLabel.yz_x != 15) {
        self.textLabel.yz_x = 15;
    }
}

- (void)setupConstraints
{
    [self.stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-15);
    }];
}

- (void)setItem:(FamilyEditItem *)item
{
    _item = item;
    self.textLabel.text = item.title;
    BOOL state = NO;
    if ([item.value isKindOfClass:[NSNumber class]]) {
        state = [item.value boolValue];
    }
    self.stateButton.selected = state;
    if (state) {
        self.textLabel.textColor = RGBA(0x303030, 1);
    } else {
        self.textLabel.textColor = RGBA(0x9c9c9c, 1);
    }
}

#pragma mark - getter

- (UIButton *)stateButton
{
    if (!_stateButton) {
        _stateButton = [[UIButton alloc] init];
        [_stateButton setBackgroundImage:[UIImage imageNamed:@"btn_unchoice"]
                                forState:UIControlStateNormal];
        [_stateButton setBackgroundImage:[UIImage imageNamed:@"btn_choice"]
                                forState:UIControlStateSelected];
    }
    return _stateButton;
}

@end
