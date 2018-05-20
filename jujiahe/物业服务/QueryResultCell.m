//
//  QueryResultCell.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/18.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "QueryResultCell.h"
#import "UIView+Frame.h"

@interface QueryResultCell ()

@property (nonatomic, strong) UILabel     *dateLabel;
@property (nonatomic, strong) UILabel     *timeLabel;
@property (nonatomic, strong) UIImageView *affixImageView;

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *subTitleLabel;

@property (nonatomic, strong) UIView      *topDivider;
@property (nonatomic, strong) UIView      *bottomDivider;
@property (nonatomic, strong) UIView      *container;

@end

@implementation QueryResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.container];
        [self.container addSubview:self.dateLabel];
        [self.container addSubview:self.timeLabel];
        [self.container addSubview:self.topDivider];
        [self.container addSubview:self.bottomDivider];
        [self.container addSubview:self.affixImageView];
        [self.container addSubview:self.titleLabel];
        [self.container addSubview:self.subTitleLabel];
        [self setupConstraints];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = (CGRect){CGPointZero, CGSizeMake(self.contentView.yz_width - 30, self.contentView.yz_height)};
    CGSize cornerRadii;
    UIRectCorner corners;
    switch (self.dividerType) {
        case QueryResultCellDividerTypeOnlyTop:
            cornerRadii = CGSizeMake(5, 5);
            corners = UIRectCornerBottomLeft | UIRectCornerTopRight;
            break;
        case QueryResultCellDividerTypeOnlyBottom:
            cornerRadii = CGSizeMake(5, 5);
            corners = UIRectCornerTopRight | UIRectCornerTopLeft;
            break;
        default:
            cornerRadii = CGSizeZero;
            corners = UIRectCornerAllCorners;
            break;
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:corners
                                                         cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    self.container.layer.mask = maskLayer;
}

- (void)setHighlight:(BOOL)highlight
{
    _highlight = highlight;
    if (highlight) {
        self.dateLabel.textColor = RGBA(0x00a7ff, 1);
        self.timeLabel.textColor = RGBA(0x00a7ff, 1);
        self.titleLabel.textColor = RGBA(0x00a7ff, 1);
        self.subTitleLabel.textColor = RGBA(0x00a7ff, 1);
        self.affixImageView.image = [UIImage imageNamed:@"pro_package_icon1"];
    } else {
        self.dateLabel.textColor = RGBA(0x9c9c9c, 1);
        self.timeLabel.textColor = RGBA(0x9c9c9c, 1);
        self.titleLabel.textColor = RGBA(0x9c9c9c, 1);
        self.subTitleLabel.textColor = RGBA(0x9c9c9c, 1);
        self.affixImageView.image = [UIImage imageNamed:@"pro_package_icon2"];
    }
}

- (void)setupConstraints
{
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.top.bottom.equalTo(self.contentView);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.container).with.offset(15);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.dateLabel);
        make.top.equalTo(self.dateLabel.mas_bottom).with.offset(10);
    }];
    [self.affixImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateLabel.mas_right).with.offset(10);
        make.centerY.equalTo(self.dateLabel);
        make.width.height.mas_equalTo(10);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.affixImageView.mas_right).with.offset(10);
        make.centerY.equalTo(self.affixImageView);
        make.right.equalTo(self.container).with.offset(-15);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.timeLabel);
        make.bottom.equalTo(self.container).with.offset(-15);
        make.height.greaterThanOrEqualTo(@14);
    }];
    [self.topDivider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.affixImageView);
        make.bottom.equalTo(self.affixImageView.mas_centerY);
        make.top.equalTo(self.container);
        make.width.mas_equalTo(0.5);
    }];
    [self.bottomDivider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.affixImageView);
        make.top.equalTo(self.affixImageView.mas_centerY);
        make.bottom.equalTo(self.container);
        make.width.mas_equalTo(0.5);
    }];
}

- (void)setData
{
    self.dateLabel.text = @"05-07";
    self.timeLabel.text = @"10:00";
    self.titleLabel.text = @"title";
    self.subTitleLabel.text = @"subTitle";
}

- (void)setDividerType:(QueryResultCellDividerType)dividerType
{
    _dividerType = dividerType;
    switch (dividerType) {
        case QueryResultCellDividerTypeDefault:
            self.topDivider.hidden = NO;
            self.bottomDivider.hidden = NO;
            break;
        case QueryResultCellDividerTypeOnlyTop:
            self.topDivider.hidden = NO;
            self.bottomDivider.hidden = YES;
            break;
        case QueryResultCellDividerTypeOnlyBottom:
            self.topDivider.hidden = YES;
            self.bottomDivider.hidden = NO;
            break;
        default:
            break;
    }
}

#pragma mark - getter

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:14];
        [_dateLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _dateLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:11];
    }
    return _timeLabel;
}

- (UIImageView *)affixImageView
{
    if (!_affixImageView) {
        _affixImageView = [[UIImageView alloc] init];
    }
    return _affixImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont systemFontOfSize:11];
    }
    return _subTitleLabel;
}

- (UIView *)topDivider
{
    if (!_topDivider) {
        _topDivider = [[UIView alloc] init];
        _topDivider.backgroundColor = RGBA(0x9c9c9c, 1);
    }
    return _topDivider;
}

- (UIView *)bottomDivider
{
    if (!_bottomDivider) {
        _bottomDivider = [[UIView alloc] init];
        _bottomDivider.backgroundColor = RGBA(0x9c9c9c, 1);
    }
    return _bottomDivider;
}

- (UIView *)container
{
    if (!_container) {
        _container = [[UIView alloc] init];
        _container.backgroundColor = [UIColor whiteColor];
    }
    return _container;
}

@end
