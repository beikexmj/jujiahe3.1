//
//  QueryResultCell.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/18.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "QueryResultCell.h"

@interface QueryResultCell ()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *affixImageView;
@property (nonatomic, strong) UILabel *titleLabel;


@end

@implementation QueryResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

#pragma mark - getter

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        
    }
    return _dateLabel;
}

@end
