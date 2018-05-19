//
//  FollowConversationVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/19.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "FollowConversationVC.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "FollowConversationCell.h"

static NSString *const kFollowConversationTableViewCell = @"com.copticomm.jjh.followConversation.tableview.cell";
static NSString *const kFollowConversationTableViewFooter = @"com.copticomm.jjh.followConversation.tableview.footer";

@interface FollowConversationVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FollowConversationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(0xE7EBEF, 1);
    [self.view addSubview:self.tableView];
    [self setupConstraints];
}

- (void)setupConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(40);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 9;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   FollowConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:kFollowConversationTableViewCell
                                                                  forIndexPath:indexPath];
    [cell setData];
    cell.count = indexPath.section;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:kFollowConversationTableViewCell
                                    cacheByIndexPath:indexPath
                                       configuration:^(FollowConversationCell *cell) {
                                           [cell setData];
                                           cell.count = indexPath.section;
                                       }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kFollowConversationTableViewFooter];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kFollowConversationTableViewFooter];
        view.backgroundView = [UIView new];
    }
    return view;
}

#pragma mark - getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[FollowConversationCell class]
           forCellReuseIdentifier:kFollowConversationTableViewCell];
    }
    return _tableView;
}

@end
