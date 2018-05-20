//
//  QueryLogisticsVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/18.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "QueryLogisticsVC.h"
#import "UIView+Frame.h"
#import "JJLabel.h"
#import "QueryResultVC.h"

@interface QueryLogisticsVC ()

@property (nonatomic, strong) UITextField *numberTextField;
@property (nonatomic, strong) UIButton *queryButton;

@end

@implementation QueryLogisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(0xE7EBEF, 1);
    [self setPopLeftItem];
    [self.contentView addSubview:self.numberTextField];
    [self.contentView addSubview:self.queryButton];
    [self setupConstraints];
    [self setEvents];
}

- (void)setupConstraints
{
    [self.numberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.navigationBar.mas_bottom).with.offset(10);
        make.height.mas_equalTo(40);
    }];
    [self.queryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.bottom.equalTo(self.contentView).with.offset(-150);
        make.height.mas_equalTo(40);
    }];
}

- (void)setEvents
{
    RAC(self.queryButton, enabled) = [RACSignal combineLatest:@[self.numberTextField.rac_textSignal] reduce:^id _Nonnull(NSString *text){
        return @(text.length > 0);
    }];
    
    @weakify(self);
    [[self.queryButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        QueryResultVC *vc = [[QueryResultVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark - getter

- (NSString *)title
{
    return @"快递查询";
}

- (UITextField *)numberTextField
{
    if (!_numberTextField) {
        _numberTextField = [[UITextField alloc] init];
        _numberTextField.leftView = self.textFiledLeftView;
        _numberTextField.leftViewMode = UITextFieldViewModeAlways;
        _numberTextField.textAlignment = NSTextAlignmentCenter;
        _numberTextField.placeholder = @"请输入您的快递单号";
        _numberTextField.font = [UIFont systemFontOfSize:16];
        _numberTextField.backgroundColor = [UIColor whiteColor];
    }
    return _numberTextField;
}

- (UIView *)textFiledLeftView
{
    JJLabel *lbl = [[JJLabel alloc] init];
    lbl.font = [UIFont systemFontOfSize:16];
    lbl.textColor = RGBA(0x303030, 1);
    lbl.textEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    lbl.text = @"快递单号";
    [lbl sizeToFit];
    
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(lbl.yz_width - 0.5, 5, 0.5, 30)];
    divider.backgroundColor = RGBA(0x9c9c9c, 1);
    [lbl addSubview:divider];
    
    return lbl;
}

- (UIButton *)queryButton
{
    if (!_queryButton) {
        _queryButton = [[UIButton alloc] init];
        [_queryButton setTitle:@"查询" forState:UIControlStateNormal];
        [_queryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_queryButton setBackgroundColor:RGBA(0x009DFF, 1)];
        _queryButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _queryButton.layer.cornerRadius = 20;
    }
    return _queryButton;
}

@end
