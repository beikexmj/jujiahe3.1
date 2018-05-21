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
#import "YYText.h"
#import "YYLabel.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface FamilyDynamicVC ()<BMKMapViewDelegate, BMKLocationServiceDelegate>

@property (nonatomic, strong) JMBaseButton            *titleView;
@property (nonatomic, strong) UIButton                *refreshButton;
@property (nonatomic, strong) UIButton                *chatButton;
@property (nonatomic, strong) UIButton                *dynamicButton;
@property (nonatomic, strong) UIButton                *currentLocationButton;
@property (nonatomic, strong) FamilyDynamicDialogView *dialogView;
@property (nonatomic, strong) BMKMapView              *mapView;

@property (nonatomic, strong) BMKLocationService      *locationService;

@end

@implementation FamilyDynamicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configurationNavigation];
    
    [self.contentView addSubview:self.mapView];
    [self.contentView addSubview:self.refreshButton];
    [self.contentView addSubview:self.chatButton];
    [self.contentView addSubview:self.dynamicButton];
    [self.contentView addSubview:self.currentLocationButton];
    [self.contentView addSubview:self.dialogView];
    [self setupConstraints];
    [self setData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
}

- (void)configurationNavigation
{
    [self setPopLeftItem];
    self.navigationItem.titleView = self.titleView;
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
}

- (void)setupConstraints
{
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
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

- (void)setData
{
    NSString *dialogText = @"text text text";
    NSString *actionText = @"查看详情";
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", dialogText, actionText]];
    
    NSRange range = NSMakeRange(dialogText.length, actionText.length);
    [text yy_setFont:[UIFont systemFontOfSize:14] range:range];
    @weakify(self);
    [text yy_setTextHighlightRange:range
                             color:RGBA(0x07d7f6, 1)
                   backgroundColor:nil
                         tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                             @strongify(self);
                             [self.navigationController pushViewController:[FamilyWarningVC new] animated:YES];
                         }];
    [text setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                          NSFontAttributeName : [UIFont systemFontOfSize:14]
                          }
                  range:NSMakeRange(0, dialogText.length)];
    _dialogView.text = text;
}

#pragma mark - BMKMapViewDelegate

#pragma mark - BMKLocationServiceDelegate

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    
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

- (FamilyDynamicDialogView *)dialogView
{
    if (!_dialogView) {
        _dialogView = [[FamilyDynamicDialogView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT + 70, 0, 0)];
    }
    return _dialogView;
}

- (BMKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] init];
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = BMKUserTrackingModeNone;
    }
    return _mapView;
}

- (BMKLocationService *)locationService
{
    if (!_locationService) {
        _locationService = [[BMKLocationService alloc] init];
        _locationService.delegate = self;
    }
    return _locationService;
}

@end

@interface FamilyDynamicDialogView ()

@property (nonatomic, strong) YYLabel *titleLabel;

@end

@implementation FamilyDynamicDialogView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.closeButton];
        self.backgroundColor = RGBA(0x000000, 0.3);
    }
    return self;
}

- (void)setText:(NSAttributedString *)text
{
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(SCREENWIDTH / 2, MAXFLOAT)
                                                            text:text];
    self.titleLabel.attributedText = text;
    self.titleLabel.textLayout = layout;
    self.titleLabel.yz_width = layout.textBoundingSize.width;
    self.titleLabel.yz_height = layout.textBoundingSize.height;
    
    self.yz_height = self.titleLabel.yz_height + 6;
    self.yz_width = self.titleLabel.yz_width + 29 + self.closeButton.yz_width;
    self.closeButton.yz_x = self.yz_width - self.closeButton.yz_width - 7;
    self.closeButton.yz_centerY = self.yz_height / 2;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(self.yz_height / 2, self.yz_height / 2)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

#pragma mark - getter

- (YYLabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] initWithFrame:CGRectMake(15, 3, SCREENWIDTH / 2, 0)];
        _titleLabel.numberOfLines = 0;
        _titleLabel.userInteractionEnabled = YES;
    }
    return _titleLabel;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        UIImage *img = [UIImage imageNamed:@"home_family_icon_delete"];
        _closeButton = [[UIButton alloc] initWithFrame:(CGRect){CGPointZero, img.size}];
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"home_family_icon_delete"]
                                forState:UIControlStateNormal];
    }
    return _closeButton;
}

@end
