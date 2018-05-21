//
//  happenCell2.m
//  jujiahe
//
//  Created by 夏明江 on 2018/5/21.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "happenCell2.h"
@interface happenCell2 ()
@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)UILabel *circleName;
@property (nonatomic,strong)UILabel *circleHost;
@property (nonatomic,strong)UIView *lineView;
@end
@implementation happenCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.img];
        [self.contentView addSubview:self.circleName];
        [self.contentView addSubview:self.circleHost];
        [self.contentView addSubview:self.lineView];
        [self setupConstraints];
    }
    return self;
}
- (UIImageView *)img{
    if (!_img) {
        _img = [[UIImageView alloc]init];
        _img.layer.cornerRadius = 2.5;
        _img.layer.masksToBounds = YES;
        _img.backgroundColor = RGBA(0x9c9c9c, 1);
    }
    return _img;
    
}
- (UILabel *)circleName{
    if (!_circleName) {
        _circleName = [[UILabel alloc]init];
        _circleName.textColor = RGBA(0x303030, 1);
        _circleName.font = [UIFont systemFontOfSize:14.0];
    }
    return _circleName;
}
- (UILabel *)circleHost{
    if (!_circleHost) {
        _circleHost = [[UILabel alloc]init];
        _circleHost.textColor = RGBA(0x9c9c9c, 1);
        _circleHost.font = [UIFont systemFontOfSize:13.0];
    }
    return _circleHost;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGBA(0xeaeef1, 1);
    }
    return _lineView;
}
- (void)setupConstraints{
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(self.contentView).with.offset(10);
        make.width.height.mas_equalTo(40);
    }];
    [self.circleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(10);
        make.left.equalTo(self.img.mas_right).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-15);
    }];
    [self.circleHost mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).with.offset(-10);
        make.left.equalTo(self.img.mas_right).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.contentView).with.offset(0);
        make.height.mas_equalTo(1);
    }];
}
- (void)setData{
    self.circleName.text = @"我要去旅行";
    self.circleHost.text = @"圈主：周杰伦";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
