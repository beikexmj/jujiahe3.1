//
//  FollowConversationCell.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/19.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "FollowConversationCell.h"
#import "JJLabel.h"
#import "ImageFlowView.h"

#define IMAGE_LENGHT (SCREENWIDTH - 60) / 3

@interface FollowConversationCell ()

@property (nonatomic, strong) UILabel       *contentLabel;
@property (nonatomic, strong) ImageFlowView *flowView;
@property (nonatomic, strong) JJLabel       *typeLabel;
@property (nonatomic, strong) UILabel       *readCountLabel;
@property (nonatomic, strong) UIButton      *followButton;

@end

@implementation FollowConversationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.flowView];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.readCountLabel];
        [self.contentView addSubview:self.followButton];
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-15);
    }];
    [self.flowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentLabel);
        make.top.equalTo(self.contentLabel.mas_bottom).with.offset(10);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel);
        make.top.equalTo(self.flowView.mas_bottom).with.offset(10);
        make.bottom.equalTo(self.contentView).with.offset(-25);
    }];
    [self.readCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.typeLabel);
        make.left.equalTo(self.typeLabel.mas_right).with.offset(20);
    }];
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.typeLabel);
        make.right.equalTo(self.flowView);
        make.size.mas_equalTo(CGSizeMake(50, 18));
    }];
}

- (void)setCount:(NSUInteger)count
{
    self.flowView.imageCount = count;
}

- (void)setData
{
    self.contentLabel.text = @"content content content content content content content content content content content content";
    self.typeLabel.text = @"生活";
    self.readCountLabel.text = @"阅读 1000";
    [self.followButton setTitle:@"已关注" forState:UIControlStateNormal];
}

#pragma mark - getter

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textColor = RGBA(0x303030, 1);
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (ImageFlowView *)flowView
{
    if (!_flowView) {
        ImageFlowConfiguration *configuration = [[ImageFlowConfiguration alloc] init];
        configuration.singleImageSize = CGSizeMake(SCREENWIDTH - 30, IMAGE_LENGHT);
        configuration.multiImageSize = CGSizeMake(IMAGE_LENGHT, IMAGE_LENGHT);
        configuration.verticalSpacing = 15;
        configuration.horizontalSpacing = 15;
        configuration.preferredLayoutWidth = SCREENWIDTH - 30;
        configuration.displayImage = ^(UIImageView *imageView, NSInteger position) {
            imageView.backgroundColor = [UIColor grayColor];
        };
        _flowView = [[ImageFlowView alloc] initWithConfiguration:configuration];
    }
    return _flowView;
}

- (JJLabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [[JJLabel alloc] init];
        _typeLabel.font = [UIFont systemFontOfSize:10];
        _typeLabel.textColor = [UIColor whiteColor];
        _typeLabel.backgroundColor = RGBA(0x00a7ff, 1);
        _typeLabel.textEdgeInsets = UIEdgeInsetsMake(3, 8, 3, 8);
        _typeLabel.layer.cornerRadius = 1;
    }
    return _typeLabel;
}

- (UILabel *)readCountLabel
{
    if (!_readCountLabel) {
        _readCountLabel = [[UILabel alloc] init];
        _readCountLabel.textColor = RGBA(0x9c9c9c, 1);
        _readCountLabel.font = [UIFont systemFontOfSize:10];
    }
    return _readCountLabel;
}

- (UIButton *)followButton
{
    if (!_followButton) {
        _followButton = [[UIButton alloc] init];
        [_followButton setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
        _followButton.titleLabel.font = [UIFont systemFontOfSize:10];
        _followButton.layer.borderColor = RGBA(0x00a7ff, 1).CGColor;
        _followButton.layer.borderWidth = 0.5;
        _followButton.layer.cornerRadius = 2;
    }
    return _followButton;
}

@end
