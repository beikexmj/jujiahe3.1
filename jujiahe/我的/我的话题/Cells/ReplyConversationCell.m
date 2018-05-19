//
//  ReplyConversationCell.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/19.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "ReplyConversationCell.h"

@interface ReplyConversationCell ()

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *addressLabel;
@property (nonatomic, strong) UILabel     *dateLabel;
@property (nonatomic, strong) UILabel     *contentLabel;
@property (nonatomic, strong) UILabel     *conversationLabel;

@end

@implementation ReplyConversationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.avatarView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.addressLabel];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.conversationLabel];
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(self.contentView).with.offset(10);
        make.width.height.mas_equalTo(40);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.avatarView.mas_centerY).with.offset(-5);
        make.left.equalTo(self.avatarView.mas_right).with.offset(10);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.avatarView.mas_centerY).with.offset(5);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).with.offset(-15);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarView.mas_bottom).with.offset(15);
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.dateLabel);
    }];
    [self.conversationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.top.equalTo(self.contentLabel.mas_bottom).with.offset(25.5);
        make.bottom.equalTo(self.contentView).with.offset(-15);
    }];
    
    @weakify(self);
    [self addDividerWithConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentLabel.mas_bottom).with.offset(10);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)addDividerWithConstraints:(void(NS_NOESCAPE ^)(MASConstraintMaker *make))block
{
    UIView *divder = [[UIView alloc] init];
    divder.backgroundColor = RGBA(0xE6E6E6, 1);
    [self.contentView addSubview:divder];
    [divder mas_makeConstraints:block];
}

- (void)setData
{
    self.nameLabel.text = @"name";
    self.addressLabel.text = @"address";
    self.dateLabel.text = @"yesterday";
    self.contentLabel.text = @"content content content content content content";
    self.conversationLabel.text = @"#conversation subject conversation subject conversation subject conversation subject conversation subject conversation subject conversation subject";
}

#pragma mark - getter

- (UIImageView *)avatarView
{
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
        _avatarView.clipsToBounds = YES;
        _avatarView.layer.cornerRadius = 20;
    }
    return _avatarView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = RGBA(0x303030, 1);
        _nameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _nameLabel;
}

- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = RGBA(0x9c9c9c, 1);
        _addressLabel.font = [UIFont systemFontOfSize:14];
    }
    return _addressLabel;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = RGBA(0x9c9c9c, 1);
        _dateLabel.font = [UIFont systemFontOfSize:14];
    }
    return _dateLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = RGBA(0x303030, 1);
        _contentLabel.font = [UIFont systemFontOfSize:15];
    }
    return _contentLabel;
}

- (UILabel *)conversationLabel
{
    if (!_conversationLabel) {
        _conversationLabel = [[UILabel alloc] init];
        _conversationLabel.textColor = RGBA(0xc0c0c0, 1);
        _conversationLabel.font = [UIFont systemFontOfSize:13];
        _conversationLabel.numberOfLines = 2;
    }
    return _conversationLabel;
}

@end
