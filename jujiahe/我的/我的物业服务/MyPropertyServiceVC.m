//
//  MyPropertyServiceVC.m
//  jujiahe
//
//  Created by 夏明江 on 2018/5/19.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "MyPropertyServiceVC.h"
#import "UITableView+WFEmpty.h"
#import "HMSegmentedControl.h"
#import "ColorUtility.h"
#import "BaseTableViewController.h"
#import "MyProperyServiceClassTableViewController.h"
@interface MyPropertyServiceVC ()<TableViewScrollingProtocol>
{
    BOOL _stausBarColorIsBlack;
    
}
@property (strong, nonatomic) HMSegmentedControl *segCtrl;
@property (nonatomic, strong) NSArray  *titleList;
@property (nonatomic, weak) UIViewController *showingVC;
@property (nonatomic, strong) NSMutableDictionary *offsetYDict; // 存储每个tableview在Y轴上的偏移量
@end

@implementation MyPropertyServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    _titleList = @[@"全部",@"待查看", @"已查看", @"已完成"];
    
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
    self.titleLabel.text = @"我的物业服务";
    self.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
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
    _segCtrl.selectedSegmentIndex = _index;
    _segCtrl.borderType = HMSegmentedControlBorderTypeNone;
    
    [_segCtrl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
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
    for (int i = 0; i<4; i++) {
        MyProperyServiceClassTableViewController *vc = [[MyProperyServiceClassTableViewController alloc]init];
        vc.propertyHouseId = [StorageUserInfromation storageUserInformation].choseUnitPropertyId;
        vc.tag = i;
        vc.menuId = @"1";
        [self addChildViewController:vc];
    }
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

