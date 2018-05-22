//
//  CommunityClassificationVC.m
//  jujiahe
//
//  Created by 夏明江 on 2018/5/21.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "CommunityClassificationVC.h"
#import "CommunityClassificationCell.h"
#import "CommunityDetailVC.h"
@interface CommunityClassificationVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *myTableView;
@end

@implementation CommunityClassificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowNav = YES;
    _backButton.hidden = NO;
    self.titleLabel.text = _titleStr;
    [self.view addSubview:self.myTableView];
    // Do any additional setup after loading the view.
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT)style:UITableViewStylePlain];
        _myTableView.backgroundColor = RGBA(0xeaeef1, 1);
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
    }
    return _myTableView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell = @"CommunityClassificationCell";
    CommunityClassificationCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell];
    if (!myCell) {
        myCell = [[CommunityClassificationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
    }
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [myCell setData];
    return myCell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommunityDetailVC *page = [[CommunityDetailVC alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
