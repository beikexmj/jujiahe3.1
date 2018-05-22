//
//  AnniversaryAddVC.m
//  jujiahe
//
//  Created by kerwin on 2018/5/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "AnniversaryAddVC.h"
#import "FamilyEditCellFactory.h"
#import "FamilyManageEditSectionView.h"

static NSString *const kFamilyAnniversaryAddTableViewSectionFooter = @"com.copticomm.jjh.family.anniversary.add.tableview.section.footer";

@interface AnniversaryAddVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSArray<FamilyEditItem *> *> *dataSource;

@end

@implementation AnniversaryAddVC

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
}

- (void)setupConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.bottom.right.equalTo(self.contentView);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FamilyEditCellFactory factoryCellWithTableView:tableView item:self.dataSource[indexPath.section][indexPath.row]];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kFamilyAnniversaryAddTableViewSectionFooter];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kFamilyAnniversaryAddTableViewSectionFooter];
        view.backgroundView = [UIView new];
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - getter

- (NSString *)title
{
    return @"添加";
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSArray<NSArray<FamilyEditItem *> *> *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[@[[FamilyEditItem itemWithTitle:@"名\t称"
                                            placeholder:@"给您的纪念日起个名字"
                                                  value:nil
                                                   type:FamilyEditItemTypeInput]],
                        @[[FamilyEditItem itemWithTitle:@"内\t容"
                                            placeholder:@"纪念日描述"
                                                  value:nil
                                                   type:FamilyEditItemTypeInput]],
                        @[[FamilyEditItem itemWithTitle:@"日\t期"
                                            placeholder:@"请选择纪念日日期"
                                                  value:nil
                                                   type:FamilyEditItemTypePicker]]];
    }
    return _dataSource;
}

@end
