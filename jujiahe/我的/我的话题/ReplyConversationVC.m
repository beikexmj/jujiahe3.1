//
//  ReplyConversationVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/19.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "ReplyConversationVC.h"
#import "ReplyConversationCell.h"
#import <UITableView+FDTemplateLayoutCell.h>

static NSString *const kReplyConversationTableViewCell = @"com.copticomm.jjh.replyConversation.tableview.cell";
static NSString *const kReplyConversationTableViewFooter = @"com.copticomm.jjh.replyConversation.tableview.footer";

@interface ReplyConversationVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ReplyConversationVC

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
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReplyConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:kReplyConversationTableViewCell
                                                                  forIndexPath:indexPath];
    [cell setData];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:kReplyConversationTableViewCell
                                    cacheByIndexPath:indexPath
                                       configuration:^(ReplyConversationCell *cell) {
                                           [cell setData];
                                       }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kReplyConversationTableViewFooter];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kReplyConversationTableViewFooter];
        view.backgroundView = [UIView new];
        view.backgroundColor = [UIColor clearColor];
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
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ReplyConversationCell class]
           forCellReuseIdentifier:kReplyConversationTableViewCell];
    }
    return _tableView;
}

@end
