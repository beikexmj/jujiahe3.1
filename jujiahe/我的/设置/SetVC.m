//
//  SetVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/2/2.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "SetVC.h"
#import "SetCell.h"
#import "PersonalInformationViewController.h"
#import "ModifyLoginPasswordFirstStepViewController.h"
#import "ResetPasswordViewController.h"
#import "MyWebVC.h"
#import "AboutViewController.h"
#import "MessagePushSetUpVC.h"
#import "FeedBackVC.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "JPUSHService.h"
@interface SetVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic,strong) UITableView *myTableView;
@end

@implementation SetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self addBottomBtn];
    [self.view addSubview:self.myTableView];
    // Do any additional setup after loading the view.
}
- (void)setNav{
    self.isShowNav = YES;
    _backButton.hidden = NO;
    self.titleLabel.text = @"设置";
    
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT - 200 - NAVHEIGHT) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _myTableView;
}
- (void)addBottomBtn{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(12, SCREENHEIGHT - 100 + 20, SCREENWIDTH - 12*2, 40)];
    [btn setTitle:@"退出当前帐号" forState:UIControlStateNormal];
    [btn setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    btn.layer.cornerRadius = 20.0;
    btn.layer.borderColor = RGBA(0x00a7ff, 1).CGColor;
    btn.layer.borderWidth = 1;
    [btn addTarget:self action:@selector(loadingOffBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
-(void)loadingOffBtn{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定退出登录？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        } seq:0];
        LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//        [self.navigationController pushViewController:controller animated:YES];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.window.rootViewController =  [[UINavigationController alloc] initWithRootViewController:controller];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifierCell = @"SetCell";
    SetCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifierCell];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:indentifierCell owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.typeName.text = @[@"登录密码设置",@"消息推送设置",@"协议与隐私"][indexPath.row];
    

    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ResetPasswordViewController *page = [[ResetPasswordViewController alloc]init];
        [self.navigationController pushViewController:page animated:YES];
    }else if (indexPath.row == 1){
        
        MessagePushSetUpVC *page = [[MessagePushSetUpVC alloc]init];
        [self.navigationController pushViewController:page animated:YES];
    }else if (indexPath.row == 2){
        MyWebVC *page = [[MyWebVC alloc]init];
        page.titleStr = @"协议及隐私";
        page.url = [NSString stringWithFormat:@"%@%@", BASE_URL2,@"/jujiaheDocument/jujiaheuser/privacy.html"];
        [self.navigationController pushViewController:page animated:YES];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
