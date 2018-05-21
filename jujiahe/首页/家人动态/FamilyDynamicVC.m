//
//  FamilyDynamicVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/20.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "FamilyDynamicVC.h"
#import "FamilyWarningVC.h"
#import <JMButton.h>

@interface FamilyDynamicVC ()

@property (nonatomic, strong) JMBaseButton *titleView;
@property (nonatomic, strong) UIButton     *refreshButton;
@property (nonatomic, strong) UIButton     *chatButton;
@property (nonatomic, strong) UIButton     *dynamicButton;
@property (nonatomic, strong) UIButton     *currentLocationButton;

@end

@implementation FamilyDynamicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configurationNavigation];
    
    [self.contentView addSubview:self.refreshButton];
    [self.contentView addSubview:self.chatButton];
    [self.contentView addSubview:self.dynamicButton];
    [self.contentView addSubview:self.currentLocationButton];
    [self setupConstraints];
    
    @weakify(self);
    [self setRightItemWithItemHandler:^(id  _Nonnull sender) {
        @strongify(self);
        [self.navigationController pushViewController:[FamilyWarningVC new] animated:YES];
    } titles:@"详情", nil];
}

- (void)configurationNavigation
{
    [self setPopLeftItem];
    self.navigationItem.titleView = self.titleView;
}

- (void)setupConstraints
{
    [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.bottom.equalTo(self.currentLocationButton.mas_top).with.offset(-20);
    }];
    [self.currentLocationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.bottom.equalTo(self.contentView).with.offset(-30);
    }];
    [self.dynamicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-15);
        make.bottom.equalTo(self.currentLocationButton);
    }];
    [self.chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.dynamicButton);
        make.bottom.equalTo(self.refreshButton);
    }];
}

#pragma mark - getter

- (JMBaseButton *)titleView
{
    if (!_titleView) {
        JMBaseButtonConfig *config = [[JMBaseButtonConfig alloc] init];
        config.titleFont = [UIFont systemFontOfSize:16];
        config.image = [UIImage imageNamed:@"icon_drop"];
        config.titleColor = RGBA(0x333333, 1);
        config.styleType = JMButtonStyleTypeBottom;
        config.title = @"current location";
        
        _titleView = [[JMBaseButton alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)
                                            ButtonConfig:config];
    }
    return _titleView;
}

- (UIButton *)refreshButton
{
    if (!_refreshButton) {
        _refreshButton = [[UIButton alloc] init];
        [_refreshButton setBackgroundImage:[UIImage imageNamed:@"home_family_btn_update"]
                                  forState:UIControlStateNormal];
    }
    return _refreshButton;
}

- (UIButton *)chatButton
{
    if (!_chatButton) {
        _chatButton = [[UIButton alloc] init];
        [_chatButton setBackgroundImage:[UIImage imageNamed:@"home_family_btn_talk"]
                               forState:UIControlStateNormal];
    }
    return _chatButton;
}

- (UIButton *)currentLocationButton
{
    if (!_currentLocationButton) {
        _currentLocationButton = [[UIButton alloc] init];
        [_currentLocationButton setBackgroundImage:[UIImage imageNamed:@"home_family_btn_position"]
                                          forState:UIControlStateNormal];
    }
    return _currentLocationButton;
}

- (UIButton *)dynamicButton
{
    if (!_dynamicButton) {
        _dynamicButton = [[UIButton alloc] init];
        [_dynamicButton setBackgroundImage:[UIImage imageNamed:@"home_family_btn_family"]
                                  forState:UIControlStateNormal];
    }
    return _dynamicButton;
}

@end
