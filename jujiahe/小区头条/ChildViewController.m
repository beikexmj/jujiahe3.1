//
//  ChildViewController.m
//  YZDisplayViewControllerDemo
//
//  Created by yz on 15/12/5.
//  Copyright © 2015年 yz. All rights reserved.
//

#import "ChildViewController.h"
#import "YZDisplayViewHeader.h"
#import "RequesCover.h"
#import "ProtalHomePageDataModel.h"
#import "ProtalHomePageTableViewCell.h"
#import "UITableView+WFEmpty.h"
#import "PortalHomePageDetailViewController.h"
@interface ChildViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger pageIndex;
}

@property (nonatomic, weak) RequesCover *cover;
@property (nonatomic,strong)NSMutableArray <ProtalHomePageDataList *>*dataArr;
@property (nonatomic,strong)UITableView *myTableView;
@end

@implementation ChildViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1];
    

    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVHEIGHT - 44) style:UITableViewStylePlain];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
    
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
        [tableView addEmptyViewWithImageName:@"暂无网络连接" title:@"网络不给力，请检测您的网络设置"];
        tableView.emptyView.hidden = NO;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cell4 = @"ProtalHomePageTableViewCell";
    ProtalHomePageTableViewCell *mycell = [tableView dequeueReusableCellWithIdentifier:cell4];
    if (!mycell) {
        mycell = [[[NSBundle mainBundle] loadNibNamed:@"ProtalHomePageTableViewCell" owner:self options:nil] lastObject];
    }
    ProtalHomePageDataList * onceList = _dataArr[indexPath.row];
    
    if(onceList){
        mycell.contentHeight.constant = 0;
        mycell.content.hidden = YES;
        if (onceList.up) {
            mycell.topicsMark.hidden = NO;
            mycell.topicsMark2.hidden = NO;
            
        }else{
            mycell.topicsMark.hidden = YES;
            mycell.topicsMark2.hidden = YES;
        }
        if (onceList.layout == 0) {
            mycell.nomalView.hidden = YES;
            mycell.topicsView.hidden = NO;
            mycell.topicsImg.hidden  = NO;
            mycell.topicsImgHeight.constant = (SCREEN_WIDTH - 30)*172/345;
            [mycell.topicsImg sd_setImageWithURL:[NSURL URLWithString:onceList.thumb] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates];
            mycell.time1.text = [StorageUserInfromation timeStrFromDateString:onceList.updateTime];
            mycell.title1.text = onceList.titlePrimary;
        }else if (onceList.layout == 1){
            mycell.nomalView.hidden = NO;
            mycell.topicsView.hidden = YES;
            mycell.nomalImg.hidden = NO;
            mycell.nomalImgWidth.constant = 110;
            mycell.nomalImgToLeft.constant = 15;
            [mycell.nomalImg sd_setImageWithURL:[NSURL URLWithString:onceList.thumb] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates];
            mycell.time2.text = [StorageUserInfromation timeStrFromDateString:onceList.updateTime];
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.lineSpacing = 3; //设置行间距
            paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
            NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0], NSParagraphStyleAttributeName:paraStyle, NSForegroundColorAttributeName:RGBCOLOR(48, 48, 48)};
            NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:onceList.titlePrimary attributes:dic];
            mycell.title2.attributedText = attributeStr;
            
        }else if (onceList.layout == 2){
            mycell.nomalView.hidden = NO;
            mycell.topicsView.hidden = YES;
            mycell.nomalImg.hidden = YES;
            mycell.nomalImgWidth.constant = 0;
            mycell.nomalImgToLeft.constant = 7;
            mycell.time2.text = [StorageUserInfromation timeStrFromDateString:onceList.updateTime];
            
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.lineSpacing = 3; //设置行间距
            paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
            NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0], NSParagraphStyleAttributeName:paraStyle, NSForegroundColorAttributeName:RGBCOLOR(48, 48, 48)};
            NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:onceList.titlePrimary attributes:dic];
            mycell.title2.attributedText = attributeStr;
        }
    }
    
    mycell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return mycell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProtalHomePageDataList * onceList =_dataArr[indexPath.row];
    if(onceList){
        switch (onceList.layout) {
            case 0:
            {
                return 307-42 - 172 + (SCREEN_WIDTH - 30)*172/345;
            }
                break;
            case 1:
            {
                return 105;
            }
                break;
            case 2:
            {
                if ([StorageUserInfromation getStringSizeWith:onceList.titlePrimary withStringFont:17.0 withWidthOrHeight:SCREEN_WIDTH-30].height<30) {
                    return 105 -21;
                }
                
                return 105;
            }
                break;
                
            default:
                return 105;
                break;
        }
    }else{
        return 105;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProtalHomePageDataList * onceList = _dataArr[indexPath.row];
    
    PortalHomePageDetailViewController * page = [[PortalHomePageDetailViewController alloc]init];
    page.onceList = onceList;
    [self.navigationController pushViewController:page animated:YES];
}


@end
