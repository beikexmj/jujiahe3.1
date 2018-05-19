//
//  MyMomentHeaderView.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/19.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "MyMomentHeaderView.h"
#import "UIView+Frame.h"

#define MAX_OFFSET (self.yz_height - NAVHEIGHT)

@interface MyMomentHeaderView ()

@property (nonatomic, strong) UIView      *headerContainer;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UIImageView *genderView;
@property (nonatomic, strong) UILabel *nickNameLabel;

@end

@implementation MyMomentHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.headerContainer];
        [self.headerContainer addSubview:self.avatarView];
        [self.headerContainer addSubview:self.genderView];
        [self.headerContainer addSubview:self.nickNameLabel];
        [self setupConstraints];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *bgImg = [UIImage imageNamed:@"my_topic_bac1"];
    UIGraphicsPushContext(context);
    [bgImg drawInRect:self.bounds];
    UIGraphicsPopContext();
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)setupConstraints
{
    [self.headerContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(100);
    }];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerContainer).with.offset(15);
        make.centerY.equalTo(self.headerContainer);
        make.width.height.mas_equalTo(70);
    }];
    [self.genderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.avatarView);
    }];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView.mas_right).with.offset(15);
        make.centerY.equalTo(self.avatarView);
    }];
}

- (void)setOffset:(CGFloat)offset
{
    _offset = offset;
    if (offset < 0) {
        self.yz_height = HEADER_HEIGHT + fabs(offset);
    } else {
        if (offset <= MAX_OFFSET) {
            self.yz_y = -(offset);
        } else {
            self.yz_y = -MAX_OFFSET;
        }
    }
    self.headerContainer.alpha = 1 - (fabs(self.yz_y) / MAX_OFFSET);
}

#pragma mark - getter

- (UIView *)headerContainer
{
    if (!_headerContainer) {
        _headerContainer = [[UIView alloc] init];
    }
    return _headerContainer;
}

- (UIImageView *)avatarView
{
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
        _avatarView.clipsToBounds = YES;
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarView.layer.cornerRadius = 35;
        _avatarView.layer.borderColor = RGBA(0xFFFFFF, 0.6).CGColor;
        _avatarView.layer.borderWidth = 5;
    }
    return _avatarView;
}

- (UIImageView *)genderView
{
    if (!_genderView) {
        _genderView = [[UIImageView alloc] init];
    }
    return _genderView;
}

- (UILabel *)nickNameLabel
{
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.textColor = [UIColor whiteColor];
        _nickNameLabel.font = [UIFont systemFontOfSize:16];
        _nickNameLabel.text = @"this is nickName";
    }
    return _nickNameLabel;
}

@end
