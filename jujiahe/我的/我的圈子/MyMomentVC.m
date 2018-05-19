//
//  MyMomentVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/19.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "MyMomentVC.h"
#import "MyMomentCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "MyMomentHeaderView.h"

static NSString *const kMomentTableViewCellIdentifier = @"com.copticomm.jjh.moment.tableview.cell";

@interface MyMomentVC ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MyMomentHeaderView *headerView;


@end

@implementation MyMomentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configurationNavitation];
    
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.headerView];
    [self setupConstraints];
}

- (void)setupConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)configurationNavitation
{
    [self setPopLeftItem];
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationBar.translucent = YES;
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.headerView.offset = scrollView.contentOffset.y;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyMomentCell *cell = [tableView dequeueReusableCellWithIdentifier:kMomentTableViewCellIdentifier
                                                         forIndexPath:indexPath];
    [cell setData];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:kMomentTableViewCellIdentifier
                                    cacheByIndexPath:indexPath
                                       configuration:^(MyMomentCell *cell) {
        [cell setData];
    }];
}

#pragma mark - getter

- (NSString *)title
{
    return @"我的发帖";
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[MyMomentCell class]
           forCellReuseIdentifier:kMomentTableViewCellIdentifier];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    }
    return _tableView;
}

- (MyMomentHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[MyMomentHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    }
    return _headerView;
}

@end
