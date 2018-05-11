//
//  ServiceMemberVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/10.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "ServiceMemberVC.h"
#import "ServiceMemberCell.h"
@interface ServiceMemberVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *myTableView;
@end

@implementation ServiceMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowNav = YES;
    self.titleLabel.text = @"服务团队";
    _backButton.hidden = NO;
    [self.view addSubview:self.myTableView];
    // Do any additional setup after loading the view.
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT) style:UITableViewStylePlain];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = RGBA(0xeaeef1, 1);
    }
    return _myTableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell = @"ServiceMemberCell";
    ServiceMemberCell *myCell  = [tableView dequeueReusableCellWithIdentifier:cell];
    if (!myCell) {
        myCell = [[[NSBundle mainBundle] loadNibNamed:cell owner:self options:nil] lastObject];
    }
    myCell.praiseBtn.tag = indexPath.row;
    myCell.unPraiseBtn.tag = indexPath.row;
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    myCell.praiseBtnBlock = ^(NSInteger index) {
        
    };
    myCell.unPraiseBtnBlock = ^(NSInteger index) {
        
    };
    return myCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
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
