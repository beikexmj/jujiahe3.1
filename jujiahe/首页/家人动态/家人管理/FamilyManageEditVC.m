//
//  FamilyManageEditVC.m
//  jujiahe
//
//  Created by kerwin on 2018/5/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "FamilyManageEditVC.h"
#import "FamilyEditCellFactory.h"
#import "FamilyManageEditSectionView.h"

static NSString *const kFamilyManageEditTableViewSectionHeader = @"com.copticomm.jjh.family.manage.edit.tableview.section.header";
static NSString *const kFamilyManageEditTableViewSectionFooter = @"com.copticomm.jjh.family.manage.edit.tableview.section.footer";

@interface FamilyManageEditVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel     *dialogLabel;
@property (nonatomic, strong) UIView      *tableFooterView;
@property (nonatomic, strong) UIButton    *inviteButton;
@property (nonatomic, strong) UIButton    *saveButton;
@property (nonatomic, strong) UIView      *bottomView;

@property (nonatomic, strong) NSArray<NSArray<FamilyEditItem *> *> *dataSource;

@end

@implementation FamilyManageEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(0xE7EBEF, 1);
    [self setupNavigation];
    
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.bottomView];
    [self.bottomView addSubview:self.inviteButton];
    [self.bottomView addSubview:self.saveButton];
    [self setupConstraints];
    [self setupEvents];
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
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(87);
    }];
    [self.inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.right.equalTo(self.bottomView.mas_centerX).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(95, 30));
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.left.equalTo(self.bottomView.mas_centerX).with.offset(15);
        make.size.equalTo(self.inviteButton);
    }];
}

- (void)setupEvents
{
    [[self.inviteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
    }];
    [[self.saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 4 || section == 5) {
        return 40;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 4 || section == 5) {
        FamilyManageEditSectionView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kFamilyManageEditTableViewSectionHeader];
        if (!view) {
            view = [[FamilyManageEditSectionView alloc] initWithReuseIdentifier:kFamilyManageEditTableViewSectionHeader];
        }
        if (section == 4) {
            view.textLabel.text = @"小区安全告警提示设定（多选）";
        } else {
            view.textLabel.text = @"小区安全告警提示设定（单选）";
        }
        return view;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kFamilyManageEditTableViewSectionFooter];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kFamilyManageEditTableViewSectionFooter];
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
    return @"编辑";
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = self.tableFooterView;
    }
    return _tableView;
}

- (UILabel *)dialogLabel
{
    if (!_dialogLabel) {
        _dialogLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, SCREENWIDTH - 30, 0)];
        _dialogLabel.font = [UIFont systemFontOfSize:14];
        _dialogLabel.textColor = RGBA(0x9c9c9c, 1);
        _dialogLabel.text = @"提示：邀请家人绑定后，即可管理实时位置";
        [_dialogLabel sizeToFit];
    }
    return _dialogLabel;
}

- (UIView *)tableFooterView
{
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.dialogLabel.yz_height + 116)];
        _tableFooterView.backgroundColor = [UIColor whiteColor];
        [_tableFooterView addSubview:self.dialogLabel];
    }
    return _tableFooterView;
}

- (UIButton *)inviteButton
{
    if (!_inviteButton) {
        _inviteButton = [[UIButton alloc] init];
        [_inviteButton setTitle:@"邀请家人" forState:UIControlStateNormal];
        [_inviteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _inviteButton.backgroundColor = RGBA(0x00a7ff, 1);
        _inviteButton.layer.cornerRadius = 15;
    }
    return _inviteButton;
}

- (UIButton *)saveButton
{
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] init];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
        _saveButton.layer.cornerRadius  = 15;
        _saveButton.layer.borderWidth = 0.5;
        _saveButton.layer.borderColor = RGBA(0x00a7ff, 1).CGColor;
    }
    return _saveButton;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (NSArray<NSArray<FamilyEditItem *> *> *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[@[[FamilyEditItem itemWithTitle:@"姓\t名"
                                            placeholder:@"请输入您对家人的姓名或称呼"
                                                  value:nil
                                                   type:FamilyEditItemTypeInput]],
                        @[[FamilyEditItem itemWithTitle:@"手机号"
                                            placeholder:@"请输入您家人的手机号"
                                                  value:nil
                                                   type:FamilyEditItemTypeInput]],
                        @[[FamilyEditItem itemWithTitle:@"关\t系"
                                            placeholder:@"请输入您与Ta的关系"
                                                  value:nil
                                                   type:FamilyEditItemTypeInput]],
                        @[[FamilyEditItem itemWithTitle:@"生\t日"
                                            placeholder:@"请选择"
                                                  value:nil
                                                   type:FamilyEditItemTypePicker]],
                        @[[FamilyEditItem itemWithTitle:@"走出小区围栏进行提示"
                                            placeholder:nil
                                                  value:@(YES)
                                                   type:FamilyeditItemTypeCheckmarker],
                          [FamilyEditItem itemWithTitle:@"走出小区围栏进行提示"
                                            placeholder:nil
                                                  value:@(NO)
                                                   type:FamilyeditItemTypeCheckmarker]],
                        @[[FamilyEditItem itemWithTitle:@"消息只发送给我"
                                            placeholder:nil
                                                  value:@(YES)
                                                   type:FamilyeditItemTypeCheckmarker],
                          [FamilyEditItem itemWithTitle:@"消息发送给所有家人"
                                            placeholder:nil
                                                  value:@(NO)
                                                   type:FamilyeditItemTypeCheckmarker]]];
    }
    return _dataSource;
}

@end
