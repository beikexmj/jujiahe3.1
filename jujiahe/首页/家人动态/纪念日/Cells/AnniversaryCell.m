//
//  AnniversaryCell.m
//  jujiahe
//
//  Created by kerwin on 2018/5/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "AnniversaryCell.h"

@interface AnniversaryCell ()

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel     *nickNameLabel;
@property (nonatomic, strong) UILabel     *timeLabel;

@end

@implementation AnniversaryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.avatarView];
        [self.contentView addSubview:self.nickNameLabel];
        [self.contentView addSubview:self.timeLabel];
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(40);
    }];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView.mas_right).with.offset(15);
        make.centerY.equalTo(self.contentView);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-15);
    }];
}

- (void)setData
{
    self.nickNameLabel.text  = @"nick name";
    self.timeLabel.text = @"day";
}

#pragma mark - getter

- (UIImageView *)avatarView
{
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
        _avatarView.clipsToBounds = YES;
        _avatarView.backgroundColor = [UIColor grayColor];
        _avatarView.layer.cornerRadius = 20;
    }
    return _avatarView;
}

- (UILabel *)nickNameLabel
{
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.textColor = RGBA(0x303030, 1);
        _nickNameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _nickNameLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = RGBA(0x303030, 1);
        _timeLabel.font = [UIFont systemFontOfSize:16];
    }
    return _timeLabel;
}

@end
