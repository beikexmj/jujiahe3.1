//
//  CommunityVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/11.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "CommunityVC.h"
#import "CommunityCell.h"
#import "CommunityClassificationVC.h"
#import "CommunityDataModel.h"
#import "UITableView+WFEmpty.h"
@interface CommunityVC ()<UITableViewDelegate,UITableViewDataSource>
{
  NSInteger pageIndex;
}
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,strong)NSMutableArray <CommunityData *> *dataArr;

@end

@implementation CommunityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowNav = YES;
    self.titleLabel.text = @"社区";
    [self.view addSubview:self.myTableView];
    pageIndex = 1;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageIndex = 1;
        [self fetchData:1];
    }];
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        pageIndex++;
        [self fetchData:pageIndex];
    }];
    [self fetchData:1];    // Do any additional setup after loading the view.
}
- (void)fetchData:(NSInteger)pageNum{
    StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
    NSDictionary *dict = @{@"communityId":storage.choseUnitPropertyId,@"propertyId":@"",@"pageNum":[NSString stringWithFormat:@"%ld",pageNum],@"pageSize":@"12"};
    [XMJHttpTool postWithUrl:@"community/communityTheme/list" param:dict success:^(id responseObj) {
        NSString * str = [responseObj mj_JSONObject];
        CommunityDataModel *data = [CommunityDataModel mj_objectWithKeyValues:str];
        
        if (data.success) {
            if (pageNum == 1) {
                if (data.data.count == 0) {
                    [self.myTableView addEmptyViewWithImageName:@"暂无积分" title:@"暂无信息"];
                    self.myTableView.emptyView.hidden = NO;
                }else{
                    self.myTableView.emptyView.hidden = YES;
                }
                [_dataArr removeAllObjects];
                [_dataArr addObjectsFromArray:data.data];

                [self.myTableView reloadData];
            }else{
                [_dataArr addObjectsFromArray:data.data];
                if (_dataArr.count == 0) {
                    [self.myTableView addEmptyViewWithImageName:@"暂无积分" title:@"暂无信息"];
                    [self.myTableView.emptyView setHidden:NO];
                }else{
                    [self.myTableView.emptyView setHidden:YES];
                }
                if(data.data.count == 0){
                    [MBProgressHUD showError:@"没有更多数据"];
                    pageIndex--;
                }else{
                    NSMutableArray *insertIndexPaths = [NSMutableArray array];
                    for (int ind = 0; ind < data.data.count; ind++) {
                        NSIndexPath    *newPath =  [NSIndexPath indexPathForRow: _dataArr.count - data.data.count + ind inSection:0];
                        [insertIndexPaths addObject:newPath];
                    }
                    //重新调用UITableView的方法, 来生成行.
                    [UIView performWithoutAnimation:^{
                        [self.myTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                        [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArr.count - data.data.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
                    }];
                }
            }
        }else{
            [self.myTableView addEmptyViewWithImageName:@"该时段暂无历史记录" title:@"该时段暂无历史记录"];
            [self.myTableView.emptyView setHidden:NO];
            if(pageNum>1){
                pageIndex--;
            }
        }
        if (pageNum != 1) {
            [self.myTableView.mj_footer endRefreshing];
        }else{
            [self.myTableView.mj_header endRefreshing];
        }
    } failure:^(NSError *error) {
        [self.myTableView addEmptyViewWithImageName:@"暂无网络连接" title:@"网络不给力，请检测您的网络设置"];
        self.myTableView.emptyView.hidden = NO;
        if (pageNum != 1) {
            [self.myTableView.mj_footer endRefreshing];
        }else{
            [self.myTableView.mj_header endRefreshing];
        }
        if(pageNum>1){
            pageIndex--;
        }
    }];
}

- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-TABBARHEIGHT-NAVHEIGHT)style:UITableViewStylePlain];
        _myTableView.backgroundView = nil;
        _myTableView.backgroundColor = [UIColor clearColor];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
    }
    return _myTableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell = @"CommunityCell";
    CommunityCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell];
    if (!myCell) {
        myCell = [[[NSBundle mainBundle] loadNibNamed:cell owner:self options:nil] lastObject];
    }
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    CommunityData *data = _dataArr[indexPath.row];
    [myCell.img sd_setImageWithURL:[NSURL URLWithString:data.pictureUrl] placeholderImage:[UIImage imageNamed:@"icon_默认"]];
    myCell.title.text = data.themeName;
    return myCell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommunityData *data = _dataArr[indexPath.row];

    CommunityClassificationVC *page = [[CommunityClassificationVC alloc]init];
    page.titleStr = data.themeName;
    page.communityId = data.communityId;
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
