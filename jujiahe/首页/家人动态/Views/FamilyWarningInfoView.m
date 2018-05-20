//
//  FamilyWarningInfoView.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/20.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "FamilyWarningInfoView.h"

@interface FamilyWarningInfoView ()

@property (nonatomic, strong) UIView *pointView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation FamilyWarningInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.pointView];
        [self addSubview:self.timeLabel];
        [self addSubview:self.messageLabel];
        [self setupConstraints];
        [self setData];
    }
    return self;
}

- (void)setupConstraints
{
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self.timeLabel);
        make.width.height.mas_equalTo(3);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.pointView.mas_right).with.offset(10);
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel);
        make.right.bottom.equalTo(self);
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(10);
    }];
}

- (void)setData
{
    self.timeLabel.text = @"time";
    self.messageLabel.text = @"warning warning warning warning warning warning warning warning warning warning warning";
}

#pragma mark - getter

- (UIView *)pointView
{
    if (!_pointView) {
        _pointView = [[UIView alloc] init];
        _pointView.backgroundColor = RGBA(0x606060, 1);
        _pointView.layer.cornerRadius = 1.5;
    }
    return _pointView;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = RGBA(0x9c9c9c, 1);
        _timeLabel.font = [UIFont systemFontOfSize:15];
    }
    return _timeLabel;
}

- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = RGBA(0x606060, 1);
        _messageLabel.font = [UIFont systemFontOfSize:16];
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

@end
