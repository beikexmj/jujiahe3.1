//
//  CommunityClassificationCell.m
//  jujiahe
//
//  Created by 夏明江 on 2018/5/21.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "CommunityClassificationCell.h"
@interface CommunityClassificationCell ()
@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong)UILabel *content;
@property (nonatomic,strong)UIView *lineView;
@end
@implementation CommunityClassificationCell

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
        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.content];
        [self.contentView addSubview:self.lineView];
        [self setupConstraints];
    }
    return self;
}
- (UIImageView *)img{
    if (!_img) {
        _img = [[UIImageView alloc]init];
        _img.backgroundColor = RGBA(0x9c9c9c, 1);
    }
    return _img;
    
}
- (UILabel *)name{
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.textColor = RGBA(0x303030, 1);
        _name.font = [UIFont systemFontOfSize:16.0];
    }
    return _name;
}
- (UILabel *)content{
    if (!_content) {
        _content = [[UILabel alloc]init];
        _content.textColor = RGBA(0x606060, 1);
        _content.font = [UIFont systemFontOfSize:14.0];
        _content.numberOfLines = 2;
    }
    return _content;
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
        make.top.equalTo(self.contentView).with.offset(15);
        make.width.height.mas_equalTo(70);
    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(15);
        make.left.equalTo(self.img.mas_right).with.offset(20);
        make.right.equalTo(self.contentView).with.offset(-15);
    }];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).with.offset(-25);
        make.left.equalTo(self.img.mas_right).with.offset(20);
        make.right.equalTo(self.contentView).with.offset(-15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.contentView).with.offset(0);
        make.height.mas_equalTo(10);
    }];
}
- (void)setData{
    self.name.text = @"新鲜龙虾试吃活动";
    self.content.text = @"海南进口新鲜龙虾，个大肉肥，现在有100个吃名额，欢迎大家报名参加。";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

