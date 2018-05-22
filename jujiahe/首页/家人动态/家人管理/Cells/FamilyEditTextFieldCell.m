//
//  FamilyEditTextFieldCell.m
//  jujiahe
//
//  Created by kerwin on 2018/5/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "FamilyEditTextFieldCell.h"

@interface FamilyEditTextFieldCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView      *divider;

@end

@implementation FamilyEditTextFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.divider];
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(15);
    }];
    [self.divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(6);
        make.bottom.equalTo(self.contentView).with.offset(-6);
        make.left.equalTo(self.titleLabel.mas_right).with.offset(10);
        make.width.mas_equalTo(0.5);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.left.equalTo(self.divider.mas_right).with.offset(22.5);
    }];
}

- (void)setItem:(FamilyEditItem *)item
{
    _item = item;
    self.titleLabel.text = item.title;
    self.textField.placeholder = item.placeholder;
    self.textField.text = item.value;
}

#pragma mark - getter

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.item.value = textField.text;
}

#pragma mark - getter

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGBA(0x606060, 1);
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
    }
    return _titleLabel;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textColor = RGBA(0x303030, 1);
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.delegate = self;
    }
    return _textField;
}

- (UIView *)divider
{
    if (!_divider) {
        _divider = [[UIView alloc] init];
        _divider.backgroundColor = RGBA(0xdddddd, 1);
    }
    return _divider;
}

@end
