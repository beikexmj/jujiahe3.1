//
//  FamilyAlbumCell.m
//  jujiahe
//
//  Created by kerwin on 2018/5/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "FamilyAlbumCell.h"

@interface FamilyAlbumCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *stateButton;

@end

@implementation FamilyAlbumCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.stateButton];
        [self setupConstraints];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.stateButton.selected = selected;
}

- (void)setAllowPick:(BOOL)allowPick
{
    _allowPick = allowPick;
    self.stateButton.hidden = !allowPick;
}

- (void)setupConstraints
{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.contentView).with.offset(-5);
    }];
}

#pragma mark - getter

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UIButton *)stateButton
{
    if (!_stateButton) {
        _stateButton = [[UIButton alloc] init];
        [_stateButton setBackgroundImage:[UIImage imageNamed:@"btn_unchoice"]
                                forState:UIControlStateNormal];
        [_stateButton setBackgroundImage:[UIImage imageNamed:@"btn_choice"]
                                forState:UIControlStateSelected];
    }
    return _stateButton;
}

@end
