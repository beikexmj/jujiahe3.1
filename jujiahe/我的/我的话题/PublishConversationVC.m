//
//  PublishConversationVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/19.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "PublishConversationVC.h"
#import "PublishConversationCell.h"
#import <UITableView+FDTemplateLayoutCell.h>

static NSString *const kPublishConversationTableViewCell = @"com.copticomm.jjh.publishConversation.tableview.cell";

@interface PublishConversationVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PublishConversationVC

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
    PublishConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:kPublishConversationTableViewCell
                                                                    forIndexPath:indexPath];
    [cell setData];
    cell.count = indexPath.section;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:kPublishConversationTableViewCell
                                    cacheByIndexPath:indexPath
                                       configuration:^(PublishConversationCell *cell) {
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
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kPublishConversationTableViewCell];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kPublishConversationTableViewCell];
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
        [_tableView registerClass:[PublishConversationCell class]
           forCellReuseIdentifier:kPublishConversationTableViewCell];
    }
    return _tableView;
}


@end
