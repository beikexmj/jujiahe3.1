//
//  PublishConversationCell.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/20.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "PublishConversationCell.h"
#import "ImageFlowView.h"
#import <JMButton/JMButton.h>

#define IMAGE_LENGHT (SCREENWIDTH - 50) / 3

@interface PublishConversationCell ()

@property (nonatomic, strong) UILabel       *subjectLabel;
@property (nonatomic, strong) UILabel       *contentLabel;
@property (nonatomic, strong) ImageFlowView *flowView;
@property (nonatomic, strong) JMBaseButton  *commentButton;
@property (nonatomic, strong) JMBaseButton  *supportButton;
@property (nonatomic, strong) UILabel       *dateLabel;

@end

@implementation PublishConversationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.subjectLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.flowView];
        [self.contentView addSubview:self.commentButton];
        [self.contentView addSubview:self.supportButton];
        [self.contentView addSubview:self.dateLabel];
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    [self.subjectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-15);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.subjectLabel);
        make.top.equalTo(self.subjectLabel.mas_bottom).with.offset(10);
    }];
    [self.flowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.subjectLabel);
        make.top.equalTo(self.contentLabel.mas_bottom).with.offset(15);
    }];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subjectLabel);
        make.top.equalTo(self.flowView.mas_bottom).with.offset(10);
        make.bottom.equalTo(self.contentView).with.offset(-10);
    }];
    [self.supportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentButton.mas_right).with.offset(35);
        make.top.equalTo(self.commentButton);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.subjectLabel);
        make.centerY.equalTo(self.commentButton);
    }];
}

- (void)setCount:(NSUInteger)count
{
    self.flowView.imageCount = count;
}

- (void)setData
{
    self.subjectLabel.text = @"#subject subject subject subject subject";
    self.contentLabel.text = @"content content content content content content content content content content content content content content content content";
    self.dateLabel.text = @"yesterday";
}

#pragma mark - getter

- (UILabel *)subjectLabel
{
    if (!_subjectLabel) {
        _subjectLabel = [[UILabel alloc] init];
        _subjectLabel.textColor = RGBA(0x00a7ff, 1);
        _subjectLabel.font = [UIFont systemFontOfSize:16];
    }
    return _subjectLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = RGBA(0x303030, 1);
        _contentLabel.font = [UIFont systemFontOfSize:15];
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
        configuration.verticalSpacing = 10;
        configuration.horizontalSpacing = 10;
        configuration.preferredLayoutWidth = SCREENWIDTH - 30;
        configuration.displayImage = ^(UIImageView *imageView, NSInteger position) {
            imageView.backgroundColor = [UIColor grayColor];
        };
        _flowView = [[ImageFlowView alloc] initWithConfiguration:configuration];
    }
    return _flowView;
}

- (JMBaseButton *)commentButton
{
    if (!_commentButton) {
        JMBaseButtonConfig *config = [[JMBaseButtonConfig alloc] init];
        config.title = @"9999";
        config.titleFont = [UIFont systemFontOfSize:13];
        config.titleColor = RGBA(0x9c9c9c, 1);
        config.image = [UIImage imageNamed:@"com_icon_comment"];
        config.padding = 8;
        
        _commentButton = [[JMBaseButton alloc] initWithFrame:CGRectZero ButtonConfig:config];
    }
    return _commentButton;
}

- (JMBaseButton *)supportButton
{
    if (!_supportButton) {
        JMBaseButtonConfig *config = [[JMBaseButtonConfig alloc] init];
        config.title = @"9999";
        config.titleFont = [UIFont systemFontOfSize:13];
        config.titleColor = RGBA(0x9c9c9c, 1);
        config.image = [UIImage imageNamed:@"com_icon_praise"];
        config.padding = 8;
        
        _supportButton = [[JMBaseButton alloc] initWithFrame:CGRectZero ButtonConfig:config];
        [_supportButton setImage:[UIImage imageNamed:@"com_icon_praise2"] forState:UIControlStateSelected];
    }
    return _supportButton;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = RGBA(0x9c9c9c, 1);
        _dateLabel.font = [UIFont systemFontOfSize:13];
    }
    return _dateLabel;
}

@end
