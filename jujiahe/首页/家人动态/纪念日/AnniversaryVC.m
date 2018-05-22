//
//  AnniversaryVC.m
//  jujiahe
//
//  Created by kerwin on 2018/5/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "AnniversaryVC.h"
#import "AnniversaryCell.h"

static NSString *const kAnniversaryTableViewCell = @"com.copticomm.jjh.anniversary.tableview.cell";

@interface AnniversaryVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AnniversaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(0xE7EBEF, 1);
    [self setupNavigation];
    
    [self.contentView addSubview:self.tableView];
    [self setupConstraints];
}

- (void)setupNavigation
{
    [self setPopLeftItem];
    self.navigationBar.jj_barTintColor = RGBA(0xf6f6f6, 1);
    self.navigationBar.shadowImage = [UIImage new];
    
    UIImage *dateImage = [UIImage imageNamed:@"home_family_icon_date"];
    UIButton *dateButton = [[UIButton alloc] initWithFrame:(CGRect){CGPointZero, dateImage.size}];
    [dateButton setBackgroundImage:dateImage forState:UIControlStateNormal];
    [[dateButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
    }];
    UIBarButtonItem *dateItem = [[UIBarButtonItem alloc] initWithCustomView:dateButton];
    self.navigationItem.rightBarButtonItems = @[dateItem];
}

- (void)setupConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.bottom.right.equalTo(self.contentView);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnniversaryCell *cell = [tableView dequeueReusableCellWithIdentifier:kAnniversaryTableViewCell];
    if (!cell) {
        cell = [[AnniversaryCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:kAnniversaryTableViewCell];
    }
    [cell setData];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - getter

- (NSString *)title
{
    return @"纪念日";
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

@end
