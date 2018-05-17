//
//  TopicClassificationChildVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/17.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "TopicClassificationChildVC.h"

#import "YZDisplayViewHeader.h"
#import "RequesCover.h"
#import "ProtalHomePageDataModel.h"
#import "ProtalHomePageTableViewCell.h"
#import "UITableView+WFEmpty.h"
#import "PortalHomePageDetailViewController.h"
#import "TopicClassificationCell.h"
#import "HomePageCell.h"
#import "TopicVC.h"
#import "CircleVC.h"
@interface TopicClassificationChildVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger pageIndex;
}

@property (nonatomic, weak) RequesCover *cover;
@property (nonatomic,strong)NSMutableArray <ProtalHomePageDataList *>*dataArr;
@property (nonatomic,strong)UITableView *myTableView;
@end

@implementation TopicClassificationChildVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1];
    
    
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVHEIGHT - 44) style:UITableViewStylePlain];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
    [_myTableView registerNib:[UINib nibWithNibName:@"HomePageCell" bundle:nil] forCellReuseIdentifier:@"HomePageCell"];

    pageIndex = 0;
    _dataArr = [NSMutableArray array];
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageIndex = 0;
        [self fetchData:pageIndex tabelView:_myTableView newsType:_titleIndex];
    }];
    _myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self fetchData:++pageIndex tabelView:_myTableView newsType:_titleIndex];
    }];
    /****滚动完成请求数据*******/
    
    // 如果想要滚动完成或者标题点击的时候，加载数据，需要监听通知
    
    // 监听滚动完成或者点击标题，只要滚动完成，当前控制器就会发出通知
    
    // 只需要监听自己发出的，不需要监听所有对象发出的通知，否则会导致一个控制器发出，所有控制器都能监听,造成所有控制器请求数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:YZDisplayViewClickOrScrollDidFinshNote object:self];
    
    
    // 开发中可以搞个蒙版，一开始遮住当前界面，等请求成功，在把蒙版隐藏.
    RequesCover *cover = [RequesCover requestCover];
    
    [self.view addSubview:cover];
    
    _cover = cover;
    
    if (_titleIndex == 0) {
        UIView *headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 105)];
        headerView.backgroundColor = RGBA(0xeaeef1, 1);
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        UICollectionView *myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 95)collectionViewLayout:layout];
        [myCollectionView registerNib:[UINib nibWithNibName:@"TopicClassificationCell" bundle:nil] forCellWithReuseIdentifier:@"TopicClassificationCell"];
        myCollectionView.backgroundColor = [UIColor whiteColor];
        myCollectionView.delegate = self;
        myCollectionView.dataSource = self;
        [headerView addSubview:myCollectionView];
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 104, SCREENWIDTH, 1)];
        lineView.backgroundColor = RGBA(0xeaeef1,1);
        [headerView addSubview:lineView];
        self.myTableView.tableHeaderView = headerView;
    }else{
        UIView *headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
        headerView.backgroundColor = RGBA(0xeaeef1, 1);
        self.myTableView.tableHeaderView = headerView;
    }
    
}

- (void)fetchData:(NSInteger)integer tabelView:(UITableView *)tableView newsType:(NSInteger)newsType{
    NSString * str = @"news/getnews";
    [ZTHttpTool postWithUrl:str param:@{@"newsType":[NSString stringWithFormat:@"%ld",newsType],@"page":[NSString stringWithFormat:@"%ld",integer],@"pagesize":@"10"} success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        ProtalHomePageDataModel *protalData = [ProtalHomePageDataModel mj_objectWithKeyValues:str];
        if (protalData.rcode == 0) {
            if (integer == 0) {
                if (protalData.form.list.count == 0) {
                    [tableView addEmptyViewWithImageName:@"暂无积分" title:@"暂无信息"];
                    tableView.emptyView.hidden = NO;
                }else{
                    tableView.emptyView.hidden = YES;
                }
                [_dataArr removeAllObjects];
                [_dataArr addObjectsFromArray:protalData.form.list];
                
                [tableView reloadData];
            }else{
                [_dataArr addObjectsFromArray:protalData.form.list];
                
                
                
                if (_dataArr.count == 0) {
                    [tableView addEmptyViewWithImageName:@"暂无积分" title:@"暂无信息"];
                    [tableView.emptyView setHidden:NO];
                }else{
                    [tableView.emptyView setHidden:YES];
                }
                if(protalData.form.list.count == 0){
                    [MBProgressHUD showError:@"没有更多数据"];
                    pageIndex--;
                }else{
                    NSMutableArray *insertIndexPaths = [NSMutableArray array];
                    for (int ind = 0; ind < protalData.form.list.count; ind++) {
                        NSIndexPath    *newPath =  [NSIndexPath indexPathForRow: _dataArr.count - protalData.form.list.count + ind inSection:0];
                        [insertIndexPaths addObject:newPath];
                    }
                    //重新调用UITableView的方法, 来生成行.
                    [UIView performWithoutAnimation:^{
                        [self.myTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                        [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArr.count - protalData.form.list.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
                    }];
                }
            }
        }else{
            [tableView addEmptyViewWithImageName:@"该时段暂无历史记录" title:@"该时段暂无历史记录"];
            [tableView.emptyView setHidden:NO];
            if(integer>0){
                pageIndex--;
            }
        }
        if (integer != 0) {
            [tableView.mj_footer endRefreshing];
        }else{
            [tableView.mj_header endRefreshing];
        }
    } failure:^(NSError *error) {
//        [tableView addEmptyViewWithImageName:@"暂无网络连接" title:@"网络不给力，请检测您的网络设置"];
//        tableView.emptyView.hidden = NO;
        if (integer != 0) {
            [tableView.mj_footer endRefreshing];
        }else{
            [tableView.mj_header endRefreshing];
        }
        if(integer>0){
            pageIndex--;
        }
    }];
}




- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.cover.frame = self.view.bounds;
    
}

// 加载数据
- (void)loadData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"%@--请求数据成功",self.title);
        
        [self.cover removeFromSuperview];
        pageIndex = 0;
        [self fetchData:pageIndex tabelView:_myTableView newsType:_titleIndex];
        
    });
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -tableView代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cell = @"HomePageCell";
    
    HomePageCell * mycell = [tableView dequeueReusableCellWithIdentifier:cell forIndexPath:indexPath];
    if (!mycell) {
        mycell = [[[NSBundle mainBundle] loadNibNamed:cell owner:self options:nil] lastObject];
    }
    mycell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    mycell.subViewOne.hidden = YES;
    mycell.subViewTwo.hidden = YES;
    mycell.subViewThree.hidden = YES;
    mycell.followBtnOneWidth.constant = 40;
    mycell.followBtnTwoWidth.constant = 40;
    mycell.followBtnThreeWidth.constant = 40;
    mycell.followBtnOne.layer.borderColor = RGBA(0x9c9c9c, 1).CGColor;
    mycell.followBtnTwo.layer.borderColor = RGBA(0x9c9c9c, 1).CGColor;
    mycell.followBtnThree.layer.borderColor = RGBA(0x9c9c9c, 1).CGColor;
    
    if (indexPath.row == 0) {
        mycell.subViewOne.hidden = NO;
        mycell.imageOne.image = [UIImage imageNamed:@"home_btn_dongtai"];
        mycell.titleOne.text =@"母亲节送什么礼物？";
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 6; //设置行间距
        paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:mycell.titleOne.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:RGBA(0x303030, 1),NSParagraphStyleAttributeName:paraStyle}];
        mycell.titleOne.attributedText = attrStr;
    }else if (indexPath.row == 1){
        mycell.subViewTwo.hidden = NO;
        mycell.imageTwo.image = [UIImage imageNamed:@"home_btn_dongtai"];
        mycell.titleTwo.text = @"错过了孩子成长的伴侣，才是人生最大的遗憾！";
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 6; //设置行间距
        paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:mycell.titleTwo.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:RGBA(0x303030, 1),NSParagraphStyleAttributeName:paraStyle}];
        mycell.titleTwo.attributedText = attrStr;
    }else if (indexPath.row == 2){
        mycell.subViewThree.hidden = NO;
        mycell.titleThree.text = @"暑假将至，十条优质暑期旅游线路，赶紧带孩子上来一次温馨的家庭旅行！";
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 6; //设置行间距
        paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:mycell.titleThree.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:RGBA(0x303030, 1),NSParagraphStyleAttributeName:paraStyle}];
        mycell.titleThree.attributedText = attrStr;
        mycell.imageOneInViewThree.image = [UIImage imageNamed:@"home_btn_dongtai"];
        mycell.imageTwoInViewThree.image = [UIImage imageNamed:@"home_btn_dongtai"];
        mycell.imageThreeInViewThree.image = [UIImage imageNamed:@"home_btn_dongtai"];
        mycell.followBtnThreeWidth.constant = 55;
        [mycell.followBtnThree setTitle:@"已关注" forState:UIControlStateNormal];
        [mycell.followBtnThree setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
        mycell.followBtnThree.layer.borderColor = RGBA(0x00a7ff, 1).CGColor;
    }
    
    return mycell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80 + (SCREENWIDTH - 30)*(220/700.0);
    }else if (indexPath.row == 1){
        return 105;
    }
    CGFloat contentHeight = [StorageUserInfromation getStringSizeWith2:[NSString stringWithFormat:@"%@",@"暑假将至，十条优质暑期旅游线路，赶紧带孩子上来一次温馨的家庭旅行！"] withStringFont:16.0 withWidthOrHeight:SCREENWIDTH-30 lineSpacing:8.0].height;
    if (contentHeight>46) {
        contentHeight = 46;
    }
    return 110 + (SCREENWIDTH - 40)/3.0 *(150/220.0) - 40 + contentHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicVC *page = [[TopicVC alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TopicClassificationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TopicClassificationCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TopicClassificationCell" owner:self options:nil] lastObject];
    }
    cell.img.image = [UIImage imageNamed:@"home_btn_menjin"];
    cell.name.text = @"小区麻友";
    return cell;
}
#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){50,95};
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 20.0;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CircleVC *page = [[CircleVC alloc]init];
    page.titleStr = @"小区麻友";
    [self.navigationController pushViewController:page animated:YES];
    
}
@end

