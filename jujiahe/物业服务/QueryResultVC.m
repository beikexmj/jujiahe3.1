//
//  QueryResultVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/18.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "QueryResultVC.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "QueryResultCell.h"

static NSString *kTableViewCellIdentifier = @"com.copticomm.jjh.query.result.cell";

@interface QueryExpressInfoView ()

@property (nonatomic, strong) UIImageView *expressImageView;
@property (nonatomic, strong) UILabel     *expressNameLbael;
@property (nonatomic, strong) UILabel     *expressNumberLabel;
@property (nonatomic, strong) UILabel     *expressStateLabel;

@end

@implementation QueryExpressInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.expressImageView];
        [self addSubview:self.expressNameLbael];
        [self addSubview:self.expressNumberLabel];
        [self addSubview:self.expressStateLabel];
        [self setupConstraints];
        [self setData];
    }
    return self;
}

- (void)setupConstraints
{
    [self.expressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(15);
        make.width.height.mas_equalTo(40);
    }];
    [self.expressNameLbael mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.expressImageView);
        make.left.equalTo(self.expressImageView.mas_right).with.offset(10);
    }];
    [self.expressNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.expressImageView).with.offset(-5);
        make.left.equalTo(self.expressNameLbael);
    }];
    [self.expressStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.expressNameLbael);
        make.right.equalTo(self).with.offset(-15);
    }];
}

- (void)setData
{
    self.expressNameLbael.text = @"express name";
    self.expressNumberLabel.text = @"express number 111111111";
    self.expressStateLabel.text = @"processing";
}

#pragma mark - getter

- (UIImageView *)expressImageView
{
    if (!_expressImageView) {
        _expressImageView = [[UIImageView alloc] init];
        _expressImageView.clipsToBounds = YES;
        _expressImageView.contentMode = UIViewContentModeScaleAspectFill;
        _expressImageView.backgroundColor = [UIColor grayColor];
        _expressImageView.layer.cornerRadius = 20;
    }
    return _expressImageView;
}

- (UILabel *)expressNameLbael
{
    if (!_expressNameLbael) {
        _expressNameLbael = [[UILabel alloc] init];
        _expressNameLbael.textColor = RGBA(0x303030, 1);
        _expressNameLbael.font = [UIFont systemFontOfSize:16];
    }
    return _expressNameLbael;
}

- (UILabel *)expressNumberLabel
{
    if (!_expressNumberLabel) {
        _expressNumberLabel = [[UILabel alloc] init];
        _expressNumberLabel.textColor = RGBA(0x303030, 1);
        _expressNumberLabel.font = [UIFont systemFontOfSize:14];
    }
    return _expressNumberLabel;
}

- (UILabel *)expressStateLabel
{
    if (!_expressStateLabel) {
        _expressStateLabel = [[UILabel alloc] init];
        _expressStateLabel.textColor = RGBA(0x00a7ff, 1);
        _expressStateLabel.font = [UIFont systemFontOfSize:16];
    }
    return _expressStateLabel;
}

@end

@interface QueryResultVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView               *blueView;
@property (nonatomic, strong) UITableView          *tableView;
@property (nonatomic, strong) QueryExpressInfoView *expressInfoView;

@end

@implementation QueryResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(0xE7EBEF, 1);
    [self configurationNavigation];
    
    [self.contentView addSubview:self.blueView];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.expressInfoView];
    [self setupConstraints];
}

- (void)configurationNavigation
{
    [self setPopLeftItem];
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationBar.translucent = YES;
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

- (void)setupConstraints
{
    [self.blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(NAVHEIGHT + 44.0);
    }];
    [self.expressInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.height.mas_equalTo(60);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.top.equalTo(self.expressInfoView.mas_bottom);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QueryResultCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier
                                                            forIndexPath:indexPath];
    [cell setData];
    if (indexPath.row == 0) {
        cell.dividerType = QueryResultCellDividerTypeOnlyBottom;
        cell.highlight = YES;
    } else if (indexPath.row == 4) {
        cell.dividerType = QueryResultCellDividerTypeOnlyTop;
        cell.highlight = NO;
    } else {
        cell.dividerType = QueryResultCellDividerTypeDefault;
        cell.highlight = NO;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:kTableViewCellIdentifier
                                    cacheByIndexPath:indexPath
                                       configuration:^(QueryResultCell *cell) {
                                           [cell setData];
                                       }];
}

#pragma mark - getter

- (NSString *)title
{
    return @"快递查询";
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        [_tableView registerClass:[QueryResultCell class]
           forCellReuseIdentifier:kTableViewCellIdentifier];
    }
    return _tableView;
}

- (UIView *)blueView
{
    if (!_blueView) {
        _blueView = [[UIView alloc] init];
        _blueView.backgroundColor = RGBA(0x00a7ff, 1);
    }
    return _blueView;
}

- (QueryExpressInfoView *)expressInfoView
{
    if (!_expressInfoView) {
        _expressInfoView = [[QueryExpressInfoView alloc] init];
        _expressInfoView.backgroundColor = [UIColor whiteColor];
        _expressInfoView.layer.cornerRadius = 5;
    }
    return _expressInfoView;
}

@end
