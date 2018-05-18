//
//  MyPageVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/1/15.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "MyPageVC.h"
#import "MyPageCell.h"
#import "JSBadgeView.h"
#import "PersonalInformationViewController.h"
#import "WallentVC.h"
#import "InvitedRegistrationViewController.h"
#import "SetVC.h"
#import "MessageCenterVC.h"
#import "AppDelegate.h"
#import "BaseTabbarVC.h"
#import "LoginViewController.h"
#import "UIView+Extensions.h"
#import "registDataModle.h"
#import "XMJButton.h"
#import "BillingInquiriesVC.h"
#import "AboutViewController.h"
#import "FeedBackVC.h"
@interface MyPageVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIAlertViewDelegate>
{
    NSArray *iconArr;
    NSArray *nameArr;
    JSBadgeView *_badgeView1;
    JSBadgeView *_badgeView2;
    JSBadgeView *_badgeView3;
    JSBadgeView *_badgeView4;
    UIView *meaasgeFlagView;
    UILabel *indentity;
    UILabel *roomAddress;
    UILabel *allStateNum;
    JSBadgeView *_badgeView;

}
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,strong)UIImageView *headerBackguandImg;
@property (nonatomic,strong)UIImageView *headerIcon;
@property (nonatomic,strong)UIImageView *sexIcon;

@property (nonatomic,strong)UILabel *nicknameLabel;
@property (nonatomic,strong)UIButton *reSee;
@property (nonatomic,strong)UIButton *areadySee;
@property (nonatomic,strong)UIButton *areadyComplateBtn;
@property (nonatomic,strong)UIButton *allStateBtn;
@property (nonatomic,strong)UIButton *QRBtn;
@property (nonatomic,strong)UIButton *meassgeBtn;
@property (nonatomic,strong)UIButton *setBtn;
@end

@implementation MyPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    
    [self.view addSubview:self.myTableView];
    StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
    _badgeView1.badgeText = [storage.countPaying isEqualToString:@"0"]?@"":storage.countPaying;
    _badgeView2.badgeText = [storage.countShipping isEqualToString:@"0"]?@"":storage.countShipping;
    _badgeView3.badgeText = [storage.countShippingSend isEqualToString:@"0"]?@"":storage.countShippingSend;
    
    
    _headerIcon.image = [UIImage imageNamed:@"默认头像60x60"];
    [self reSetHeaderIcon];
    if ([StorageUserInfromation storageUserInformation].sex.integerValue == 0) {
//        [_nicknameBtn setImage:[UIImage imageNamed:@"com_icon_man"] forState:UIControlStateNormal];
    }else if ([StorageUserInfromation storageUserInformation].sex.integerValue == 1){
//        [_nicknameBtn setImage:[UIImage imageNamed:@"com_icon_woman"] forState:UIControlStateNormal];

    }else{
//        [_nicknameBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

    }

    NSInteger num = storage.socialUnread.integerValue + storage.systemUnread.integerValue;
    if (num) {
        meaasgeFlagView.hidden = NO;
    }else{
        meaasgeFlagView.hidden = YES;
    }
//    _badgeView4.badgeText = num == 0?@"":[NSString stringWithFormat:@"%ld",num];
    if(![[StorageUserInfromation storageUserInformation].userId isEqualToString:@""]){
        [self fetchData];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replaceHeaderImg) name:@"ReplaceHeaderImg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replaceSex) name:@"ReplaceSex" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyNickname) name:@"ModifyNickname" object:nil];
    _headerIcon.image = [UIImage imageNamed:@"per_head"];
    _sexIcon.image = [UIImage imageNamed:@"my_icon_female"];
    _nicknameLabel.text = @"我是大傻瓜";
    // Do any additional setup after loading the view.
}
- (void)freshInterface{
    StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
    _badgeView1.badgeText = [storage.countPaying isEqualToString:@"0"]?@"":storage.countPaying;
    _badgeView2.badgeText = [storage.countShipping isEqualToString:@"0"]?@"":storage.countShipping;
    _badgeView3.badgeText = [storage.countShippingSend isEqualToString:@"0"]?@"":storage.countShippingSend;
    NSInteger num = storage.socialUnread.integerValue + storage.systemUnread.integerValue;
//    _badgeView4.badgeText = num == 0?@"":[NSString stringWithFormat:@"%ld",num];
    if (num) {
        meaasgeFlagView.hidden = NO;
    }else{
        meaasgeFlagView.hidden = YES;
    }
//    [_nicknameBtn setTitle:[NSString stringWithFormat:@" %@",[StorageUserInfromation storageUserInformation].nickname] forState:UIControlStateNormal];
    if ([StorageUserInfromation storageUserInformation].sex.integerValue == 0) {
//        [_nicknameBtn setImage:[UIImage imageNamed:@"com_icon_man"] forState:UIControlStateNormal];
    }else if ([StorageUserInfromation storageUserInformation].sex.integerValue == 1){
//        [_nicknameBtn setImage:[UIImage imageNamed:@"com_icon_woman"] forState:UIControlStateNormal];
        
    }else{
//        [_nicknameBtn setImage:[UIImage imageNamed:@"com_icon_woman"] forState:UIControlStateNormal];

    }
    [self reSetHeaderIcon];
    [self fetchUnreadMessageCount];
    [self fetchUnreadGoodsMessageCount];

}
- (void)fetchUnreadMessageCount{
    NSDictionary *dict = @{@"apiv":@"1.0",@"userId":[StorageUserInfromation storageUserInformation].userId};
    [ZTHttpTool postWithUrl:@"jujiaheuser/v1/userInfo/unreadMessageCount" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        if ([onceDict[@"rcode"] integerValue] == 0) {
            NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];
            StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
            storage.socialUnread = [NSString stringWithFormat:@"%ld",[onceDict[@"form"][@"socialUnread"] integerValue]];
            storage.systemUnread = [NSString stringWithFormat:@"%ld",[onceDict[@"form"][@"systemUnread"] integerValue] ];
            [NSKeyedArchiver archiveRootObject:storage toFile:file];
            NSInteger num = storage.socialUnread.integerValue + storage.systemUnread.integerValue;
//            _badgeView4.badgeText = (num == 0?@"":[NSString stringWithFormat:@"%ld",num]);
            if (num) {
                meaasgeFlagView.hidden = NO;
            }else{
                meaasgeFlagView.hidden = YES;
            }
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}
- (void)fetchUnreadGoodsMessageCount{
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"apiv":@"1.0",@"device":@"1"};
    [ZTHttpTool postWithUrl:@"uaa/v1/user" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        registDataModle *user = [registDataModle mj_objectWithKeyValues:str];
        StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];
//        if (user.rcode == 0) {
//            storage.email = user.form.email;
//            storage.nickname = user.form.nickname;
//            storage.token = @"123456";
//            storage.username = user.form.username;
//            storage.sessionId = user.form.sessionId;
//            storage.accountBalance =  [NSString stringWithFormat:@"%.2f",user.form.accountBalance.floatValue];
//            storage.point = user.form.point;
//            storage.sex = user.form.sex;
//            storage.invitationCode = user.form.invitationCode;
//            storage.invitationLink = user.form.invitationLink;
//            storage.payPasswordSet = user.form.payPasswordSet;
//            storage.socialUnread = user.form.socialUnread;
//            storage.systemUnread = user.form.systemUnread;
//            storage.countShippingSend = user.form.countShippingSend;
//            storage.countShipping = user.form.countShipping;
//            storage.countPaying = user.form.countPaying;
//            storage.userId = user.form.userId;
//            [NSKeyedArchiver archiveRootObject:storage toFile:file];
//            
//            _badgeView1.badgeText = [storage.countPaying isEqualToString:@"0"]?@"":storage.countPaying;
//            _badgeView2.badgeText = [storage.countShipping isEqualToString:@"0"]?@"":storage.countShipping;
//            _badgeView3.badgeText = [storage.countShippingSend isEqualToString:@"0"]?@"":storage.countShippingSend;
//        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
    NSInteger num = storage.socialUnread.integerValue + storage.systemUnread.integerValue;
    //    _badgeView4.badgeText = num == 0?@"":[NSString stringWithFormat:@"%ld",num];
    if (num) {
        meaasgeFlagView.hidden = NO;
    }else{
        meaasgeFlagView.hidden = YES;
    }
 
}
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//}
- (void)reSetHeaderIcon{
    NSString * str = [NSString stringWithFormat:@"%@/%@%@",BASE_URL,@"uaa/v1/getAvatar?userId=",[StorageUserInfromation storageUserInformation].userId];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str] options:NSDataReadingUncached error:nil];
        if (data.length) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                _headerIcon.image = [UIImage imageWithData:data];
            });
        }
    });
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    if([[StorageUserInfromation storageUserInformation].userId isEqualToString:@""]){
//        UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:@"未登录" message:@"确定跳回登录界面？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alert show];
//    }
}
- (void)fetchData{
    [self freshInterface];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        self.tabBarController.selectedIndex = 0;
    }else{
        LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.window.rootViewController =  [[UINavigationController alloc] initWithRootViewController:controller];

    }
}
- (void)setNav{
    self.isShowNav = YES;
    self.navView.backgroundColor = RGBA(0xffffff, 1);
    self.lineView.hidden = YES;
    UIImage *img = [UIImage imageNamed:@"my_icon_set"];
    width = img.size.width + 30;
    ox = SCREENWIDTH - width;
    
    _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _setBtn.backgroundColor = [UIColor clearColor];
    _setBtn.frame = CGRectMake(ox, oy, width, height);
    if (img) {
        [_setBtn setImage:img forState:UIControlStateNormal];
    }
    
    _setBtn.userInteractionEnabled = YES;
    [self.navView addSubview:_setBtn];
    [_setBtn addTarget:self action:@selector(setBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:_setBtn];
    

    UIImage *meassgeBtnImg = [UIImage imageNamed:@"home_icon_massage_black"];
    width = meassgeBtnImg.size.width;
    ox -= width;

    _meassgeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _meassgeBtn.backgroundColor = [UIColor clearColor];
    _meassgeBtn.frame = CGRectMake(ox, oy, width, height);
    if (meassgeBtnImg) {
        [_meassgeBtn setImage:meassgeBtnImg forState:UIControlStateNormal];
    }

    _meassgeBtn.userInteractionEnabled = YES;
    _badgeView = [[JSBadgeView alloc] initWithParentView:_meassgeBtn alignment:JSBadgeViewAlignmentTopLeft];
    [self.navView addSubview:_meassgeBtn];
    [_meassgeBtn addTarget:self action:@selector(meassgeBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setBtnClick{
    
}
- (void)meassgeBtnClick{
    
}
- (void)rightButtonClick:(UIButton *)button{
    [MobClick event:@"pcxx_c"];
    MessageCenterVC *page = [[MessageCenterVC alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}

//获取当前时间戳有两种方法(以秒为单位)
- (NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%0.0lf", [datenow timeIntervalSince1970]];
    XMJLog(@"%@",timeSp);
    return timeSp;
    
}
- (void)QRBtnClick{
    [MobClick event:@"pcewm_c"];
   
}
- (UIButton *)QRBtn{
    if (!_QRBtn) {
        _QRBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH - 40 - 44, NAVHEIGHT - 44, 50, 44)];
        [_QRBtn setImage:[UIImage imageNamed:@"my_icon_二维码2"] forState:UIControlStateNormal];
        [_QRBtn addTarget:self action:@selector(QRBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _QRBtn;
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT - TABBARHEIGHT) style:UITableViewStylePlain];
        _myTableView.backgroundColor = RGBA(0xffffff, 1);
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        // 手动添加下拉刷新
//        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
//        refreshControl.tintColor = RGBA(0xffffff, 1);
//        [refreshControl addTarget:self action:@selector(refreshControlStateChange:) forControlEvents:UIControlEventValueChanged];
//        [_myTableView addSubview:refreshControl];
        [self addTableHeaderView];
    }
    return _myTableView;
}
- (void)refreshControlStateChange:(UIRefreshControl  *)refresh{
    [refresh endRefreshing];
}
- (void)addTableHeaderView{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0)];
    headerView.backgroundColor = RGBA(0xffffff, 1);
    CGFloat Y = 0;
    [headerView addSubview:self.headerIcon];
    [headerView addSubview:self.sexIcon];
    [headerView addSubview:self.nicknameLabel];
    UIButton *infoDetailBtn = [[UIButton alloc]initWithFrame:CGRectMake(105, 15, SCREENWIDTH - 120, 75)];
    [infoDetailBtn setImage:[UIImage imageNamed:@"icon_more2"] forState:UIControlStateNormal];
    infoDetailBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [headerView addSubview:infoDetailBtn];
    [infoDetailBtn addTarget:self action:@selector(infoDetailBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    Y += 15 + 75 + 15;
    
    UIView *midleView = [[UIView alloc]initWithFrame:CGRectMake(20, Y, SCREENWIDTH - 40, 75)];
    midleView.backgroundColor = RGBA(0x00a7ff, 1);
    midleView.layer.cornerRadius = 5;
    
    UILabel *rightNowRoom = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 120, 15)];
    rightNowRoom.textColor = RGBA(0xffffff, 1);
    rightNowRoom.font = [UIFont systemFontOfSize:14.0];
    rightNowRoom.text = @"当前房屋";
    [midleView addSubview:rightNowRoom];
    
    indentity = [[UILabel alloc]initWithFrame:CGRectMake(15, 45, 40, 15)];
    indentity.textColor = RGBA(0xffffff, 1);
    indentity.font = [UIFont systemFontOfSize:16.0];
    indentity.text = @"业主";
    [midleView addSubview:indentity];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(55, 42.5, 1, 20)];
    lineView.backgroundColor = RGBA(0xffffff, 1);
    [midleView addSubview:lineView];
    
    roomAddress = [[UILabel alloc]initWithFrame:CGRectMake(65, 45, SCREENWIDTH - 135 - 40, 15)];
    roomAddress.textColor = RGBA(0xffffff, 1);
    roomAddress.font = [UIFont systemFontOfSize:16.0];
    roomAddress.text = @"重庆复地新成就1期A栋201";
    [midleView addSubview:roomAddress];
    
    UIButton *roomSwitchBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH - 40 - 50, 5, 50, 35)];
    [roomSwitchBtn setImage:[UIImage imageNamed:@"my_icon_change"] forState:UIControlStateNormal];
    [roomSwitchBtn addTarget:self action:@selector(roomSwitchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [midleView addSubview:roomSwitchBtn];
    [headerView addSubview:midleView];
    
    Y += 75 + 15;
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, Y, 5, 15)];
    lineView2.backgroundColor  = RGBA(0x00a7ff, 1);
    [headerView addSubview:lineView2];
    UILabel *markTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, Y, 150, 15)];
    markTitle.textColor = RGBA(0x303030, 1);
    markTitle.font = [UIFont systemFontOfSize:16.0];
    markTitle.text = @"我的物业服务";
    [headerView  addSubview:markTitle];
    
    Y += 15;
    
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, Y, SCREENWIDTH, 100)];
    [headerView addSubview:myView];
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(3*(SCREENWIDTH - 15)/4.0, 28, 1, 50)];
    lineView3.backgroundColor = RGBA(0xeeeeee, 1);
    [myView addSubview:lineView3];

    [myView addSubview:self.reSee];
    [myView addSubview:self.areadySee];
    [myView addSubview:self.areadyComplateBtn];
    [myView addSubview:self.allStateBtn];
    
    allStateNum = [[UILabel alloc]initWithFrame:CGRectMake(3*(SCREENWIDTH - 15)/4.0, 25, (SCREENWIDTH - 15)/4.0 +15, 30)];
    allStateNum.textColor = RGBA(0x303030, 1);
    allStateNum.font = [UIFont systemFontOfSize:17.0];
    allStateNum.textAlignment = NSTextAlignmentCenter;
    allStateNum.text = @"30项";
    [myView addSubview:allStateNum];
    
    UILabel *allStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(3*(SCREENWIDTH - 15)/4.0, 55, (SCREENWIDTH - 15)/4.0 +15, 30)];
    allStateLabel.textColor = RGBA(0x606060, 1);
    allStateLabel.font = [UIFont systemFontOfSize:13.0];
    allStateLabel.textAlignment = NSTextAlignmentCenter;
    allStateLabel.text = @"全部";
    [myView addSubview:allStateLabel];
    
    _badgeView1 = [[JSBadgeView alloc] initWithParentView:_reSee alignment:JSBadgeViewAlignmentTopRight];
    _badgeView2 = [[JSBadgeView alloc] initWithParentView:_areadySee alignment:JSBadgeViewAlignmentTopRight];
    _badgeView3 = [[JSBadgeView alloc] initWithParentView:_areadyComplateBtn alignment:JSBadgeViewAlignmentTopRight];

    Y += 100;
    
    UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake(0, Y, SCREENWIDTH, 10)];
    lineView4.backgroundColor = RGBA(0xeaeef1, 1);
    [headerView addSubview:lineView4];
    
    Y += 10;
    
    CGRect frame = headerView.frame;
    frame.size.height = Y;
    headerView.frame = frame;
    
    _myTableView.tableHeaderView = headerView;
}
- (void)infoDetailBtnClick:(UIButton*)btn{
    PersonalInformationViewController *page = [[PersonalInformationViewController alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}
- (void)roomSwitchBtnClick:(UIButton *)btn{
    
}
- (UIImageView *)headerBackguandImg{
    if (!_headerBackguandImg) {
        _headerBackguandImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT - 64 + 150)];
        _headerBackguandImg.image = [UIImage imageNamed:@"my_bg2"];
    }
    return _headerBackguandImg;
}
- (UIImageView *)headerIcon{
    if (!_headerIcon) {
        _headerIcon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 75, 75)];
        _headerIcon.layer.cornerRadius = 37.5;
        _headerIcon.layer.masksToBounds = YES;
        _headerIcon.userInteractionEnabled = YES;
        _headerIcon.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerIconTapClick:)];
        [_headerIcon addGestureRecognizer:tap];
    }
    return _headerIcon;
}
- (UIImageView *)sexIcon{
    if (!_sexIcon) {
        _sexIcon = [[UIImageView alloc]initWithFrame:CGRectMake(90 - 20, 90 - 20, 20, 20)];
        _sexIcon.layer.cornerRadius = 10;
        _sexIcon.layer.borderColor = RGBA(0xffffff, 1).CGColor;
        _sexIcon.layer.borderWidth = 2;
        _sexIcon.layer.masksToBounds = YES;
        _sexIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _sexIcon;
}
- (UILabel *)nicknameLabel{
    if (!_nicknameLabel) {
        _nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 15 + 37.5 - 15, SCREENWIDTH - 120, 30)];
        _nicknameLabel.textColor = RGBA(0x303030, 1);
        [_nicknameLabel setFont:[UIFont systemFontOfSize:16.0]];

    }
    return _nicknameLabel;
}
- (UIButton *)reSee{
    if (!_reSee) {
        _reSee = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (SCREENWIDTH - 15)/4.0, 100)];
        [_reSee setImage:[UIImage imageNamed:@"my_icon_pro1"] forState:UIControlStateNormal];
        [_reSee setTitle:@"待查看" forState:UIControlStateNormal];
        [_reSee setTitleColor:RGBA(0x606060, 1) forState:UIControlStateNormal];
        [_reSee.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        _reSee.tag = 10;
        [_reSee verticalImageAndTitle:10.0];
        [_reSee addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reSee;
}
- (UIButton *)areadySee{
    if (!_areadySee) {
        _areadySee = [[UIButton alloc]initWithFrame:CGRectMake((SCREENWIDTH - 15)/4.0, 0, (SCREENWIDTH - 15)/4.0, 100)];
        [_areadySee setImage:[UIImage imageNamed:@"my_icon_pro2"] forState:UIControlStateNormal];
        [_areadySee setTitle:@"已查看" forState:UIControlStateNormal];
        [_areadySee setTitleColor:RGBA(0x606060, 1) forState:UIControlStateNormal];
        [_areadySee.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        _areadySee.tag = 20;
        [_areadySee verticalImageAndTitle:10.0];
        [_areadySee addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _areadySee;
}
- (UIButton *)areadyComplateBtn{
    if (!_areadyComplateBtn) {
        _areadyComplateBtn = [[UIButton alloc]initWithFrame:CGRectMake(2*(SCREENWIDTH - 15)/4.0, 0, (SCREENWIDTH - 15)/4.0, 100)];
        [_areadyComplateBtn setImage:[UIImage imageNamed:@"my_icon_pro3"] forState:UIControlStateNormal];
        [_areadyComplateBtn setTitle:@"已完成" forState:UIControlStateNormal];
        [_areadyComplateBtn setTitleColor:RGBA(0x606060, 1) forState:UIControlStateNormal];
        [_areadyComplateBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        _areadyComplateBtn.tag = 30;
        [_areadyComplateBtn verticalImageAndTitle:10.0];
        [_areadyComplateBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _areadyComplateBtn;
}
- (UIButton *)allStateBtn{
    if (!_allStateBtn) {
        _allStateBtn = [[UIButton alloc]initWithFrame:CGRectMake(3*(SCREENWIDTH - 15)/4.0, 0, (SCREENWIDTH - 15)/4.0 +15, 100)];
        _allStateBtn.tag = 40;
        [_allStateBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _allStateBtn;
}
- (void)headerIconTapClick:(UIGestureRecognizer *)tap{
    [MobClick event:@"pczl_c"];
    PersonalInformationViewController *page = [[PersonalInformationViewController alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}
- (void)btnClick:(UIButton*)btn{
    
    NSString *orderType = @"";
    
    switch (btn.tag) {
        case 10:
        {
            orderType = @"2";
        }
            break;
        case 20:
        {
            orderType = @"9";
        }
            break;
        case 30:
        {
            orderType = @"6";
        }
            break;
        case 40:
        {
            orderType = @"";
        }
            break;
            
        default:
            break;
    }
    [MobClick event:@"pczt_c" label:orderType];

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.myTableView) {
        CGFloat f = scrollView.contentOffset.y;
        if (f >= 15) {
            self.titleLabel.text = @"我的";
        }else{
            self.titleLabel.text = @"";
        }
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierCell = @"MyPageCell";
    MyPageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifierCell owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tips.hidden = YES;
    if (indexPath.section == 0) {
        cell.icon.image = [UIImage imageNamed:@[@"my_icon_topic",@"my_icon_circle",@"my_icon_activity"][indexPath.row]] ;
        cell.name.text = @[@"我的话题",@"我的圈子",@"我的活动"][indexPath.row];
    }else if (indexPath.section == 1){
        cell.icon.image =  [UIImage imageNamed:@[@"my_icon_data",@"my_icon_list"][indexPath.row]];
        cell.name.text = @[@"我的资料",@"账单查询"][indexPath.row];
    }else if (indexPath.section == 2){
        cell.icon.image =  [UIImage imageNamed:@[@"my_icon_us",@"my_icon_opinion",@"my_icon_set2"][indexPath.row]];
        cell.name.text = @[@"关于居家合",@"意见反馈",@"设置"][indexPath.row];
    }else if (indexPath.section == 3){
        cell.icon.image =  [UIImage imageNamed:@"my_icon_phone"];
        cell.name.text = @"服务热线";
        cell.tips.hidden = NO;
        cell.tips.text = @"18580465179";
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 3;
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 1) {
            
        }else if (indexPath.row == 2) {
            
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            PersonalInformationViewController *page = [[PersonalInformationViewController alloc]init];
            [self.navigationController pushViewController:page animated:YES];
        }else if (indexPath.row == 1) {
            BillingInquiriesVC *page = [[BillingInquiriesVC alloc]init];
            [self.navigationController pushViewController:page animated:YES];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            AboutViewController *page = [[AboutViewController alloc]init];
            [self.navigationController pushViewController:page animated:YES];
        }else if (indexPath.row == 1) {
            FeedBackVC *page = [[FeedBackVC alloc]init];
            [self.navigationController pushViewController:page animated:YES];
        }else if (indexPath.row == 2) {
            SetVC *page = [[SetVC alloc]init];
            [self.navigationController pushViewController:page animated:YES];
        }
    }else if (indexPath.section == 3){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *callPhone = [NSString stringWithFormat:@"tel://%@",@"18580465179"];
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
            }
        });
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    myView.backgroundColor = RGBA(0xeaeef1, 1);
    return myView;
}
- (void)replaceHeaderImg{
    [self reSetHeaderIcon];
}
- (void)modifyNickname{
//    [_nicknameBtn setTitle:[NSString stringWithFormat:@" %@",[StorageUserInfromation storageUserInformation].nickname?[StorageUserInfromation storageUserInformation].nickname:@""] forState:UIControlStateNormal];
}
- (void)replaceSex{
    if ([StorageUserInfromation storageUserInformation].sex.integerValue == 0) {
//        [_nicknameBtn setImage:[UIImage imageNamed:@"com_icon_man"] forState:UIControlStateNormal];
    }else if ([StorageUserInfromation storageUserInformation].sex.integerValue == 1){
//        [_nicknameBtn setImage:[UIImage imageNamed:@"com_icon_woman"] forState:UIControlStateNormal];
        
    }else{
//        [_nicknameBtn setImage:[UIImage imageNamed:@"com_icon_woman"] forState:UIControlStateNormal];
        
    }
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
