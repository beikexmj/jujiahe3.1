//
//  DynamicCell.m
//  jujiahe
//
//  Created by kerwin on 2018/5/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "DynamicCell.h"
#import <JMButton/JMButton.h>

@implementation DynamicCellData

+ (DynamicCellData *)dataWithTitle:(NSString *)title imageName:(NSString *)imageName
{
    DynamicCellData *data = [[DynamicCellData alloc] init];
    data.title = title;
    data.imageName = imageName;
    return data;
}

@end

@interface DynamicCell ()

@property (nonatomic, strong) JMBaseButton *button;

@end

@implementation DynamicCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setData:(DynamicCellData *)data
{
    _data = data;
    [self.button setTitle:data.title forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:data.imageName]
                 forState:UIControlStateNormal];
}

#pragma mark - getter

- (JMBaseButton *)button
{
    if (!_button) {
        JMBaseButtonConfig *config = [[JMBaseButtonConfig alloc] init];
        config.titleFont = [UIFont systemFontOfSize:14];
        config.titleColor = RGBA(0x303030, 1);
        config.padding = 7.5;
        config.styleType = JMButtonStyleTypeTop;
        _button = [[JMBaseButton alloc] initWithFrame:CGRectZero ButtonConfig:config];
        _button.userInteractionEnabled = NO;
    }
    return _button;
}

@end
