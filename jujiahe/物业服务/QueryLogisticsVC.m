//
//  QueryLogisticsVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/18.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "QueryLogisticsVC.h"

@interface QueryLogisticsVC ()

@property (nonatomic, strong) UITextField *numberTextField;
@property (nonatomic, strong) UIButton *queryButton;

@end

@implementation QueryLogisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma mark - getter

- (UITextField *)numberTextField
{
    if (!_numberTextField) {
        _numberTextField = [[UITextField alloc] init];
    }
    return _numberTextField;
}

- (UIView *)textFiledLeftView
{
    UIView *view = [[UIView alloc] init];
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.text = @"快递单号";
    return lbl;
}

@end
