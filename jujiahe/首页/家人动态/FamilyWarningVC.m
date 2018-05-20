//
//  FamilyWarningVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/20.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "FamilyWarningVC.h"
#import "FamilyWarningCell.h"
#import "FamilyWarningTableHeaderView.h"
#import <UITableView+FDTemplateLayoutCell.h>

static NSString *const kFamilyWarningDetailTableViewCell = @"com.copticomm.jjh.familywarning.detail.tableview.cell";
static NSString *const kFamilyWarningDetailTableViewHeader = @"com.copticomm.jjh.familywarning.detail.tableview.header";

@interface FamilyWarningVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FamilyWarningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setPopLeftItem];
    
    [self.contentView addSubview:self.tableView];
    [self setupConstraints];
}

- (void)setupConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.top.equalTo(self.navigationBar.mas_bottom);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FamilyWarningCell *cell = [tableView dequeueReusableCellWithIdentifier:kFamilyWarningDetailTableViewCell
                                                              forIndexPath:indexPath];
    [cell setData];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:kFamilyWarningDetailTableViewCell
                                    cacheByIndexPath:indexPath
                                       configuration:^(FamilyWarningCell *cell) {
                                           [cell setData];
                                       }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FamilyWarningTableHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kFamilyWarningDetailTableViewHeader];
    if (!view) {
        view = [[FamilyWarningTableHeaderView alloc] initWithReuseIdentifier:kFamilyWarningDetailTableViewHeader];
    }
    view.textLabel.text = @"Year";
    return view;
}

#pragma mark - getter

- (NSString *)title
{
    return @"告警详情";
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[FamilyWarningCell class] forCellReuseIdentifier:kFamilyWarningDetailTableViewCell];
    }
    return _tableView;
}

@end
