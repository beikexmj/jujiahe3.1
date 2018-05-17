//
//  MessageCenterVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/1/29.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "MessageCenterVC.h"
#import "MyMessageCell.h"
#import "SystemMessageCell.h"
#import "SystemMessageDetailVC.h"
#import "SystemMessageDataModel.h"
#import "MyMessageDataModel.h"
#import "UITableView+WFEmpty.h"
#import "HMSegmentedControl.h"
#import "ColorUtility.h"
#import "BaseTableViewController.h"
#import "TopicMessageVC.h"
#import "CircleMessageVC.h"
#import "SystemMessageVC.h"
@interface MessageCenterVC ()<TableViewScrollingProtocol>
{
    UIView *topicMessageFlagView;
    UIView *circleMessageFlagView;
    UIView *systemMeaasgeFlagView;
    BOOL _stausBarColorIsBlack;

}
@property (strong, nonatomic) HMSegmentedControl *segCtrl;
@property (nonatomic, strong) NSArray  *titleList;
@property (nonatomic, weak) UIViewController *showingVC;
@property (nonatomic, strong) NSMutableDictionary *offsetYDict; // 存储每个tableview在Y轴上的偏移量
@end

@implementation MessageCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    _titleList = @[@"话题消息", @"圈子消息", @"系统消息"];

    [self setChoseBtn];
    [self addController];
    [self segmentedControlChangedValue:_segCtrl];

    // Do any additional setup after loading the view.
}

- (void)setNav{
    self.isShowNav = YES;
    self.navView.backgroundColor = RGBA(0xf6f6f6, 1);
    self.lineView.hidden = YES;
    _backButton.hidden = NO;
    self.titleLabel.text = @"消息";
    self.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
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
            if ([storage.socialUnread isEqualToString:@"0"]) {
//                myMessageFlagView.hidden = YES;
            }else{
//                myMessageFlagView.hidden = NO;
            }
            if ([storage.systemUnread isEqualToString:@"0"]) {
                systemMeaasgeFlagView.hidden = YES;
            }else{
                systemMeaasgeFlagView.hidden = NO;
            }
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}
- (void)setChoseBtn{
    _segCtrl = [[HMSegmentedControl alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, 40)];
    _segCtrl.sectionTitles = _titleList;
    _segCtrl.backgroundColor = [ColorUtility colorWithHexString:@"f6f6f6"];
    _segCtrl.selectionIndicatorHeight = 2.0f;
    _segCtrl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segCtrl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    _segCtrl.titleTextAttributes = @{NSForegroundColorAttributeName : RGBA(0x606060, 1), NSFontAttributeName : [UIFont systemFontOfSize:15]};
    _segCtrl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [ColorUtility colorWithHexString:@"00a7ff"]};
    _segCtrl.selectionIndicatorColor = [ColorUtility colorWithHexString:@"00a7ff"];
    _segCtrl.selectedSegmentIndex = 0;
    _segCtrl.borderType = HMSegmentedControlBorderTypeNone;
    
    [_segCtrl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    CGFloat gap = 0;
    CGFloat btnWidth = (SCREENWIDTH - gap*2)/3.0;
    
    topicMessageFlagView  = [[UIView alloc]initWithFrame:CGRectMake(gap + btnWidth/2.0 + 58/2.0, 12, 3, 3)];
    topicMessageFlagView.layer.cornerRadius = 3/2.0;
    topicMessageFlagView.backgroundColor =RGBA(0xfe4b20, 1);
    [_segCtrl addSubview:topicMessageFlagView];
    
    systemMeaasgeFlagView  = [[UIView alloc]initWithFrame:CGRectMake(gap + btnWidth + btnWidth/2.0 + 58/2.0, 12, 3, 3)];
    systemMeaasgeFlagView.layer.cornerRadius = 3/2.0;
    systemMeaasgeFlagView.backgroundColor =RGBA(0xfe4b20, 1);
    [_segCtrl addSubview:systemMeaasgeFlagView];
    
    circleMessageFlagView  = [[UIView alloc]initWithFrame:CGRectMake(gap + btnWidth*2 + btnWidth/2.0 + 58/2.0, 12, 3, 3)];
    circleMessageFlagView.layer.cornerRadius = 3/2.0;
    circleMessageFlagView.backgroundColor =RGBA(0xfe4b20, 1);
    [_segCtrl addSubview:circleMessageFlagView];
    [self.view addSubview:_segCtrl];
}
- (void)segmentedControlChangedValue:(HMSegmentedControl*)sender {
    [_showingVC.view removeFromSuperview];
    
    BaseTableViewController *newVC = self.childViewControllers[sender.selectedSegmentIndex];
    if (!newVC.view.superview) {
        [self.view addSubview:newVC.view];
        newVC.view.frame = CGRectMake(0, NAVHEIGHT + 40, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT - 40);
    }
    
    NSString *nextAddressStr = [NSString stringWithFormat:@"%p", newVC];
    CGFloat offsetY = [_offsetYDict[nextAddressStr] floatValue];
    newVC.tableView.contentOffset = CGPointMake(0, offsetY);
    [self.view insertSubview:newVC.view belowSubview:self.navView];
    _showingVC = newVC;
}
- (void)addController {
    TopicMessageVC *vc1 = [[TopicMessageVC alloc] init];
    vc1.delegate = self;
    CircleMessageVC *vc2 = [[CircleMessageVC alloc] init];
    vc2.delegate = self;
    SystemMessageVC *vc3 = [[SystemMessageVC alloc] init];
    vc3.delegate = self;
    [self addChildViewController:vc1];
    [self addChildViewController:vc2];
    [self addChildViewController:vc3];
}
#pragma mark - BaseTabelView Delegate
- (void)tableViewScroll:(UITableView *)tableView offsetY:(CGFloat)offsetY{
    
}

- (void)tableViewDidEndDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    //    _headerView.canNotResponseTapTouchEvent = NO;  这四行被屏蔽内容，每行下面一行的效果一样
    
    NSString *addressStr = [NSString stringWithFormat:@"%p", _showingVC];
    if (offsetY > 0) {
        [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:addressStr]) {
                _offsetYDict[key] = @(offsetY);
            } else if ([_offsetYDict[key] floatValue] <= 0) {
                _offsetYDict[key] = @(0);
            }
        }];
    } else {
        if (offsetY <= 0) {
            [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                _offsetYDict[key] = @(offsetY);
            }];
        }
    }
}

- (void)tableViewDidEndDecelerating:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    //    _headerView.canNotResponseTapTouchEvent = NO; 这四行被屏蔽内容，每行下面一行的效果一样
    
    NSString *addressStr = [NSString stringWithFormat:@"%p", _showingVC];
    if (offsetY > 0) {
        [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:addressStr]) {
                _offsetYDict[key] = @(offsetY);
            } else if ([_offsetYDict[key] floatValue] <= 0) {
                _offsetYDict[key] = @(0);
            }
        }];
    } else {
        if (offsetY <= 0) {
            [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                _offsetYDict[key] = @(offsetY);
            }];
        }
    }
}

- (void)tableViewWillBeginDecelerating:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    //    _headerView.canNotResponseTapTouchEvent = YES; 这四行被屏蔽内容，每行下面一行的效果一样
}

- (void)tableViewWillBeginDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    //    _headerView.canNotResponseTapTouchEvent = YES; 这四行被屏蔽内容，每行下面一行的效果一样
}



#pragma mark - Getter/Setter
- (NSMutableDictionary *)offsetYDict {
    if (!_offsetYDict) {
        _offsetYDict = [NSMutableDictionary dictionary];
        for (BaseTableViewController *vc in self.childViewControllers) {
            NSString *addressStr = [NSString stringWithFormat:@"%p", vc];
            _offsetYDict[addressStr] = @(CGFLOAT_MIN);
        }
    }
    return _offsetYDict;
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
