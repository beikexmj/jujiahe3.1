//
//  TopicVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/15.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "TopicVC.h"
#import "LeftTableViewController.h"
#import "RightTableViewController.h"
#import "PublishViewController.h"
@interface TopicVC ()<TableViewScrollingProtocol>
{
    CGFloat headerViewHeight;
    CGFloat contentViewHeight;
    BOOL Flexflag;
    BOOL _stausBarColorIsBlack;
    UIButton *chossBtn;
}
@property (nonatomic,strong)UIButton *followBtn;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)UIView *headContentView;
@property (nonatomic,strong)UIButton *mostNewBtn;
@property (nonatomic,strong)UIButton *mostHotBtn;
@property (nonatomic,strong)UIView *lineViewFlag;
@property (nonatomic, strong) NSMutableDictionary *offsetYDict; // 存储每个tableview在Y轴上的偏移量
@property (nonatomic, weak) UITableViewController *showingVC;


@end

@implementation TopicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    Flexflag = YES;
    [self setNav];
    [self addHeaderView];
    [self contentViewConfig];
    [self addController];
    [self btnChoseClick:_mostNewBtn];
    [self addBottomBtn];
    
    // Do any additional setup after loading the view.
}
- (void)addBottomBtn{
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(40,SCREENHEIGHT - TABBARHEIGHT - 40, SCREENWIDTH - 80, 40)];
    btn.backgroundColor = RGBA(0x00a7ff, 1);
    btn.layer.cornerRadius = 20;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"发帖" forState:UIControlStateNormal];
    [btn setTitleColor:RGBA(0xffffff, 1) forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(publishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setNav{
    self.isShowNav = YES;
    self.navView.backgroundColor = RGBA(0xf6f6f6, 1);
    self.lineView.hidden = YES;
    _backButton.hidden = NO;
    width = 40;
    ox = SCREENWIDTH - width - 15;
    if (is_iPhone_X) {
        oy = 60.5;
    }else {
        oy = 36.5;
    }
    height = 15;
    _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _followBtn.backgroundColor = [UIColor clearColor];
    _followBtn.frame = CGRectMake(ox, oy, width, height);
    _followBtn.layer.cornerRadius = 5;
    _followBtn.layer.borderColor = RGBA(0x9c9c9c, 1).CGColor;
    _followBtn.layer.borderWidth = 1;
    [_followBtn setTitle:@"关注" forState:UIControlStateNormal];
    [_followBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [_followBtn setTitleColor:RGBA(0x9c9c9c, 1) forState:UIControlStateNormal];
    _followBtn.userInteractionEnabled = YES;
    [self.navView addSubview:_followBtn];
    [_followBtn addTarget:self action:@selector(followBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)addHeaderView{
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, 65)];
    _headerView.backgroundColor = RGBA(0xf6f6f6, 1);
    CGFloat Y = 0;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,  Y + 10, SCREENWIDTH - 30, 15.0)];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.textColor = RGBA(0x303030, 1);
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"暑假将至，十条优质暑期旅游线路，赶紧带孩子上来一次温馨的家庭旅行！";
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 6; //设置行间距
    paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:titleLabel.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:RGBA(0x303030, 1),NSParagraphStyleAttributeName:paraStyle}];
    titleLabel.attributedText = attrStr;
    
    CGFloat contentHeight = [StorageUserInfromation getStringSizeWith2:[NSString stringWithFormat:@"%@",@"暑假将至，十条优质暑期旅游线路，赶紧带孩子上来一次温馨的家庭旅行！"] withStringFont:16.0 withWidthOrHeight:SCREENWIDTH-30 lineSpacing:8.0].height + 8;
    
    CGRect frame = titleLabel.frame;
    frame.size.height = contentHeight;
    titleLabel.frame = frame;
    [_headerView addSubview:titleLabel];
    Y += 10 + contentHeight + 10;
    
    UILabel *markLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, Y, 40, 15)];
    markLabel.backgroundColor = RGBA(0x00a7ff, 1);
    markLabel.layer.cornerRadius = 5;
    markLabel.layer.masksToBounds  = YES;
    markLabel.textColor = RGBA(0xffffff, 1);
    markLabel.font = [UIFont systemFontOfSize:12.0];
    markLabel.text = @"亲子";
    markLabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:markLabel];
    
    UILabel *readNum = [[UILabel alloc]initWithFrame:CGRectMake(100, Y, SCREENWIDTH - 115, 15.0)];
    readNum.textColor = RGBA(0x9c9c9c, 1);
    readNum.font = [UIFont systemFontOfSize:12.0];
    readNum.text = @"阅读量 1000";
    [_headerView addSubview:readNum];
    
    Y += 15 +15;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, Y, SCREENWIDTH, 1)];
    lineView.backgroundColor = RGBA(0xeaeef1, 1);
    [_headerView addSubview:lineView];
    Y += 1;
    CGRect rect = _headerView.frame;
    rect.size.height = Y;
    _headerView.frame = rect;
    headerViewHeight = Y;
    [self.view addSubview:_headerView];
}

-(void)contentViewConfig{
    CGFloat YY = 0;
    if (self.headContentView) {
        [self.headContentView removeFromSuperview];
    }
    self.headContentView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT + headerViewHeight, SCREENWIDTH, 0)];
    
    UILabel *contentLabel  = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, SCREENWIDTH - 30, 0)];
    contentLabel.font = [UIFont systemFontOfSize:15.0];
    contentLabel.textColor = RGBA(0x303030, 1);
    contentLabel.numberOfLines = 0;
    contentLabel.text = @"为了记录准确的偏移量，跟微博一样，采取了在滚动过程中第一次单击切换栏使tableView停止滚动，第二次单击切换栏才切换tableView的做法。因为tableView自带了单击停止滚动的效果，所以如果切换栏没有贴住导航栏时，它的父控件headerView作为tableView的一部分，单击切换栏就可以让tableView停止。如果切换栏贴住导航栏时，它的父控件headerView就是控制器view的一部分了，我的做法是此时屏蔽掉headerView对触摸事件的响应，这样子切换栏后面的tableView部分就可以响应该单击事件了。详情请看源码，分析过程请看";
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 6; //设置行间距
    paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:contentLabel.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:RGBA(0x303030, 1),NSParagraphStyleAttributeName:paraStyle}];
    contentLabel.attributedText = attrStr;
    
    CGFloat contentHeight = [StorageUserInfromation getStringSizeWith2:[NSString stringWithFormat:@"%@",@"为了记录准确的偏移量，跟微博一样，采取了在滚动过程中第一次单击切换栏使tableView停止滚动，第二次单击切换栏才切换tableView的做法。因为tableView自带了单击停止滚动的效果，所以如果切换栏没有贴住导航栏时，它的父控件headerView作为tableView的一部分，单击切换栏就可以让tableView停止。如果切换栏贴住导航栏时，它的父控件headerView就是控制器view的一部分了，我的做法是此时屏蔽掉headerView对触摸事件的响应，这样子切换栏后面的tableView部分就可以响应该单击事件了。详情请看源码，分析过程请看"] withStringFont:16.0 withWidthOrHeight:SCREENWIDTH-30 lineSpacing:8.0].height + 8;
    
    if (contentHeight>78 && Flexflag) {
        contentHeight = 78;
    }
    CGRect frame = contentLabel.frame;
    frame.size.height = contentHeight;
    contentLabel.frame = frame;
    [_headContentView addSubview:contentLabel];
    
    YY += 15 + contentHeight;
    
    UIButton *flexBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH - 115, YY + 15, 100, 20)];
    [flexBtn setTitle:@"收起文章" forState:UIControlStateNormal];
    [flexBtn setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
    [flexBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    flexBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_headContentView addSubview:flexBtn];
    [flexBtn addTarget:self action:@selector(flexBtnClick) forControlEvents:UIControlEventTouchUpInside];
    YY += 15 + 20 + 15;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, YY, SCREENWIDTH, 1)];
    lineView.backgroundColor = RGBA(0xeeeaf1, 1);
    [_headContentView addSubview:flexBtn];
    [self headerSwitchView:YY];
    YY += 40;
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, YY, SCREENWIDTH, 10)];
    lineView2.backgroundColor = RGBA(0xeaeef1, 1);
    [_headContentView addSubview:lineView2];
    YY += 10;
    CGRect rect = _headContentView.frame;
    rect.size.height = YY;
    _headContentView.frame = rect;
    contentViewHeight = YY;
//    [self.view addSubview:_headContentView];
    
}
- (void)headerSwitchView:(CGFloat)y{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, y, SCREENWIDTH, 40)];
    myView.backgroundColor = RGBA(0xffffff, 1);
    [_headContentView addSubview:myView];
    CGFloat gap = (SCREENWIDTH - 55*2)/3.0;
    CGFloat btnWidth = (SCREENWIDTH - gap*2)/2.0;
    _mostNewBtn = [[UIButton alloc]initWithFrame:CGRectMake(gap, 0, btnWidth, 40)];
    [_mostNewBtn setTitle:@"最新" forState:UIControlStateNormal];
    [_mostNewBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_mostNewBtn setTitleColor:RGBA(0x606060, 1) forState:UIControlStateNormal];
    [_mostNewBtn addTarget:self action:@selector(btnChoseClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _mostHotBtn = [[UIButton alloc]initWithFrame:CGRectMake(gap + btnWidth, 0, btnWidth, 40)];
    [_mostHotBtn setTitle:@"最热" forState:UIControlStateNormal];
    [_mostHotBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_mostHotBtn setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
    [_mostHotBtn addTarget:self action:@selector(btnChoseClick:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:_mostNewBtn];
    [myView addSubview:_mostHotBtn];
    
    _lineViewFlag = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 2)];
    _lineViewFlag.backgroundColor = RGBA(0x00a7ff, 1);
    _lineViewFlag.center = CGPointMake(gap + btnWidth/2.0 + btnWidth, 40-2);
    [myView addSubview:_lineViewFlag];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, SCREENWIDTH, 1)];
    lineView.backgroundColor = RGBA(0xdbdbdb, 1);
    [myView addSubview:lineView];
}

- (void)addController {
    LeftTableViewController *vc1 = [[LeftTableViewController alloc] init];
    vc1.delegate = self;
    RightTableViewController *vc2 = [[RightTableViewController alloc] init];
    vc2.delegate = self;
    [self addChildViewController:vc1];
    [self addChildViewController:vc2];
}
- (void)flexBtnClick{
    Flexflag = !Flexflag;
    [self contentViewConfig];

    if (chossBtn) {
        [self btnChoseClick:chossBtn];
    }else{
        [self btnChoseClick:_mostNewBtn];
    }
   
    
}
-(void)followBtnClick{
    
}
- (void)btnChoseClick:(UIButton *)btn{
    CGFloat gap = (SCREENWIDTH - 55*2)/3.0;
    CGFloat btnWidth = (SCREENWIDTH - gap*2)/2.0;
    if (btn == _mostHotBtn) {
        _lineViewFlag.center = CGPointMake(gap + btnWidth/2.0 + btnWidth, 40-2);
        [_mostHotBtn setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
        [_mostNewBtn setTitleColor:RGBA(0x606060, 1) forState:UIControlStateNormal];
        [self segmentedControlChangedValue:1];
    }else{
        _lineViewFlag.center = CGPointMake(gap + btnWidth/2.0, 40-2);
        [_mostHotBtn setTitleColor:RGBA(0x606060, 1) forState:UIControlStateNormal];
        [_mostNewBtn setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
        [self segmentedControlChangedValue:0];

    }
    chossBtn = btn;
}
- (void)segmentedControlChangedValue:(NSInteger)tag {
    [_showingVC.view removeFromSuperview];
    
    BaseTableViewController *newVC = self.childViewControllers[tag];
    if (!newVC.view.superview) {
//        [self.view addSubview:newVC.view];
        newVC.view.frame = CGRectMake(0, NAVHEIGHT + headerViewHeight, SCREENWIDTH, SCREENHEIGHT - (NAVHEIGHT + headerViewHeight));
    }
    
    NSString *nextAddressStr = [NSString stringWithFormat:@"%p", newVC];
    CGFloat offsetY = [_offsetYDict[nextAddressStr] floatValue];
    XMJLog(@"offsetY11111 ==== %.0f",offsetY);
    newVC.tableView.contentOffset = CGPointMake(0, offsetY);
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, contentViewHeight)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    newVC.tableView.tableHeaderView = headerView;
    newVC.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

    
    [self.view insertSubview:newVC.view belowSubview:self.navView];
    if (offsetY <= contentViewHeight - 50) {
        [newVC.view addSubview:_headContentView];
        
        CGRect rect = _headContentView.frame;
        rect.origin.y = 0;
        _headContentView.frame = rect;
    }  else {
        [self.view insertSubview:_headContentView belowSubview:self.navView];
        CGRect rect = _headContentView.frame;
        rect.origin.y = headerViewHeight + NAVHEIGHT -contentViewHeight +50;
        _headContentView.frame = rect;
    }
    XMJLog(@"offsetY22222 ==== %.0f",_headContentView.frame.origin.y);

    _showingVC = newVC;
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

#pragma mark - BaseTabelView Delegate
- (void)tableViewScroll:(UITableView *)tableView offsetY:(CGFloat)offsetY{
    if (offsetY > contentViewHeight - 50) {
        if (![_headContentView.superview isEqual:self.view]) {
            [self.view insertSubview:_headContentView belowSubview:self.navView];
        }
        CGRect rect = self.headContentView.frame;
        rect.origin.y = headerViewHeight + NAVHEIGHT -contentViewHeight +50;
        self.headContentView.frame = rect;
    } else {
        if (![_headContentView.superview isEqual:tableView]) {
            for (UIView *view in tableView.subviews) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    [tableView insertSubview:_headContentView aboveSubview:view];
                    break;
                }
            }
        }
        CGRect rect = self.headContentView.frame;
        rect.origin.y = 0;
        self.headContentView.frame = rect;
    }
    
}

- (void)tableViewDidEndDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    //    _headerView.canNotResponseTapTouchEvent = NO;  这四行被屏蔽内容，每行下面一行的效果一样
    _headContentView.userInteractionEnabled = YES;
    
    NSString *addressStr = [NSString stringWithFormat:@"%p", _showingVC];
    if (offsetY > contentViewHeight - 50) {
        [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:addressStr]) {
                _offsetYDict[key] = @(offsetY);
            } else if ([_offsetYDict[key] floatValue] <= contentViewHeight - 50) {
                _offsetYDict[key] = @(contentViewHeight - 50);
            }
        }];
    } else {
        if (offsetY <= contentViewHeight - 50) {
            [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                _offsetYDict[key] = @(offsetY);
            }];
        }
    }
}

- (void)tableViewDidEndDecelerating:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    //    _headerView.canNotResponseTapTouchEvent = NO; 这四行被屏蔽内容，每行下面一行的效果一样
    NSString *addressStr = [NSString stringWithFormat:@"%p", _showingVC];
    if (offsetY > contentViewHeight - 50) {
        [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:addressStr]) {
                _offsetYDict[key] = @(offsetY);
            }
//            else if ([_offsetYDict[key] floatValue] <= contentViewHeight - 50) {
//                _offsetYDict[key] = @(contentViewHeight - 50);
//            }
        }];
    } else {
        if (offsetY <= contentViewHeight - 50) {
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
- (void)publishBtnClick:(UIButton *)btn{
    PublishViewController *page = [[PublishViewController alloc]init];
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
