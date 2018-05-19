//
//  PublishServiceCell.m
//  jujiahe
//
//  Created by 夏明江 on 2018/5/19.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "PublishServiceCell.h"

@implementation PublishServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleName];
        [self.contentView addSubview:self.selectStateImage];
        [self.contentView addSubview:self.selectBtn];
        [self setupConstraints];
        [self setEvents];
    }
    return self;
}
- (UILabel *)titleName{
    if (!_titleName) {
        _titleName = [[UILabel alloc]init];
        _titleName.font = [UIFont systemFontOfSize:14.0];
        _titleName.textColor = RGBA(0x9c9c9c, 1);
        _titleName.text = @"将该投诉私信发布到小区事";
    }
    return _titleName;
}
- (UIImageView *)selectStateImage{
    if (!_selectStateImage) {
        _selectStateImage = [[UIImageView alloc]init];
        _selectStateImage.image = [UIImage imageNamed:@"hap_btn_unchoice"];
    }
    return _selectStateImage;
}
- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc]init];
    }
    return _selectBtn;
}
- (void)setupConstraints
{
    [self.titleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).with.offset(12);
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(60);
        make.bottom.equalTo(self.contentView);
    }];
    [self.selectStateImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(12.5);
        make.right.equalTo(self.contentView).with.offset(-12);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(15);
    }];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
    }];
}
- (void)setEvents
{
    [[self.selectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (_selectBtnBlock) {
            _selectBtnBlock();
        }
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
