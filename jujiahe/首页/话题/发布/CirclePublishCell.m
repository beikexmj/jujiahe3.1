//
//  CirclePublishCell.m
//  jujiahe
//
//  Created by 夏明江 on 2018/5/19.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "CirclePublishCell.h"
@interface CirclePublishCell ()
@property (nonatomic,strong)UILabel *rightNowCircle;
@property (nonatomic,strong)UILabel *tips;

@end
@implementation CirclePublishCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.circleName];
//        [self.contentView addSubview:self.rightNowCircle];
        [self.contentView addSubview:self.tips];
        [self setupConstraints];
    }
    return self;
}
- (UILabel *)circleName{
    if (!_circleName) {
        _circleName = [[UILabel alloc]init];
        _circleName.font = [UIFont systemFontOfSize:14.0];
        _circleName.textColor = RGBA(0x303030, 1);
    }
    [_circleName sizeToFit];
    return _circleName;
}
- (UILabel *)rightNowCircle{
    if (!_rightNowCircle) {
        _rightNowCircle = [[UILabel alloc]init];
        _rightNowCircle.font = [UIFont systemFontOfSize:13.0];
        _rightNowCircle.textColor = RGBA(0x9c9c9c, 1);
        _rightNowCircle.text = @"(当前圈子)";
    }
    return _rightNowCircle;
}
- (UILabel *)tips{
    if (!_tips) {
        _tips = [[UILabel alloc]init];
        _tips.font = [UIFont systemFontOfSize:12.0];
        _tips.textColor = RGBA(0x9c9c9c, 1);
        _tips.text = @"内容发布后周边（小区）业主可见";
    }
    return _tips;
}
- (void)setupConstraints{
    [self.circleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12);
        make.top.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-12);
        make.height.mas_equalTo(20);
    }];
//    [self.rightNowCircle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.circleName).with.offset(12);
//        make.top.equalTo(self.contentView).with.offset(15);
//        make.height.mas_equalTo(20);
//        make.width.mas_equalTo(80);
//    }];
    [self.tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12);
        make.top.equalTo(self.contentView).with.offset(50);
        make.height.mas_equalTo(20);
        make.right.equalTo(self.contentView).with.offset(-12);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
