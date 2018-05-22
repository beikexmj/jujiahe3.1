//
//  FamilyWarningCell.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/20.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "FamilyWarningCell.h"
#import "FamilyWarningInfoView.h"

@interface FamilyWarningCell ()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIView *warningContainer;

@end

@implementation FamilyWarningCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.warningContainer];
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).with.offset(15);
    }];
    [self.warningContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(40).priorityHigh();
        make.top.equalTo(self.dateLabel.mas_bottom).with.offset(10).priorityHigh();
        make.bottom.right.equalTo(self.contentView).with.offset(-15).priorityHigh();
    }];
}

- (void)setData
{
    self.dateLabel.text = @"date";
    [self.warningContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    FamilyWarningInfoView *oldView;
    for (int i = 0; i < 2; i++) {
        FamilyWarningInfoView *view = [[FamilyWarningInfoView alloc] init];
        [self.warningContainer addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.warningContainer);
            if (oldView) {
                make.top.equalTo(oldView.mas_bottom).with.offset(20);
            } else {
                make.top.equalTo(self.warningContainer);
            }
        }];
        oldView = view;
    }
    [oldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.warningContainer);
    }];
}

#pragma mark - getter

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = RGBA(0x303030, 1);
        _dateLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _dateLabel;
}

- (UIView *)warningContainer
{
    if (!_warningContainer) {
        _warningContainer = [[UIView alloc] init];
    }
    return _warningContainer;
}

@end
