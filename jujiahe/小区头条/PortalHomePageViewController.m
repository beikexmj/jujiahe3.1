//
//  PortalHomePageViewController.m
//  copooo
//
//  Created by XiaMingjiang on 2017/11/14.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import "PortalHomePageViewController.h"
#import "ProtalHelpTableViewCell.h"
#import "ProtalHomePageTableViewCell.h"
#import "ProtalHomePageDataModel.h"
#import "ProtalHomePageHelpDataModel.h"
#import "UITableView+WFEmpty.h"
#import "MJRefresh.h"
#import "PortalHomePageDetailViewController.h"
#import "AppDelegate.h"
@interface PortalHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSInteger guidongPage;
    NSInteger elecRluesPage;
    NSInteger publicNewsPage;
    NSInteger helpspage;
}
@property (nonatomic,strong)UITableView *guidongNewsTableView;
@property (nonatomic,strong)UITableView *elecRulesTableView;
@property (nonatomic,strong)UITableView *pubicNewsTableView;
@property (nonatomic,strong)UITableView *helpsTableView;
@property (nonatomic,strong)NSMutableArray <ProtalHomePageDataList *>*guidongNewsArr;
@property (nonatomic,strong)NSMutableArray <ProtalHomePageDataList *>*elecRulesArr;
@property (nonatomic,strong)NSMutableArray <ProtalHomePageDataList *>*publicNewsArr;
@property (nonatomic,strong)NSMutableArray <ProtalHomePageHelpDataList *>*helpsArr;
@property (nonatomic,strong)NSArray *headerTitleArr;
@end

@implementation PortalHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    
    _headerTitleArr = [NSArray array];
    _headerTitleArr =[NSArray arrayWithObjects:@"小区公告",@"物业新闻",@"科普宣传",@"温馨提示",nil];
    [self buildHeaderScrollView];
    self.myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH *4, SCREEN_HEIGHT - 64 - 43 - 49);
    self.myScrollView.pagingEnabled = YES;
    self.myScrollView.delegate = self;
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    _guidongNewsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 43 - 49) style:UITableViewStylePlain];
    _elecRulesTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 43 - 49) style:UITableViewStylePlain];
    _pubicNewsTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 43 - 49) style:UITableViewStylePlain];
    _helpsTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*3, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 43 - 49) style:UITableViewStylePlain];
    [self.myScrollView addSubview:_guidongNewsTableView];
    [self.myScrollView addSubview:_elecRulesTableView];
    [self.myScrollView addSubview:_pubicNewsTableView];
    [self.myScrollView addSubview:_helpsTableView];
    _guidongNewsTableView.delegate = self;
    _guidongNewsTableView.dataSource = self;
    _elecRulesTableView.delegate = self;
    _elecRulesTableView.dataSource = self;
    _helpsTableView.delegate = self;
    _helpsTableView.dataSource = self;
    _pubicNewsTableView.delegate = self;
    _pubicNewsTableView.dataSource =self;
    _guidongNewsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _elecRulesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _pubicNewsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _helpsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [MBProgressHUD showMessage:@""];
    guidongPage = 0;
    elecRluesPage = 0;
    publicNewsPage = 0;
    helpspage = 0;
    _guidongNewsArr = [NSMutableArray array];
    _elecRulesArr = [NSMutableArray array];
    _publicNewsArr = [NSMutableArray array];
    _helpsArr = [NSMutableArray array];
    _guidongNewsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        guidongPage = 0;
        [self fetchData:guidongPage tabelView:_guidongNewsTableView newsType:0];
    }];
    _guidongNewsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self fetchData:++guidongPage tabelView:_guidongNewsTableView newsType:0];
    }];
    _elecRulesTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        elecRluesPage = 0;
        [self fetchData:elecRluesPage tabelView:_elecRulesTableView newsType:1];
    }];
    _elecRulesTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self fetchData:++elecRluesPage tabelView:_elecRulesTableView newsType:1];
    }];
    _pubicNewsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        publicNewsPage = 0;
        [self fetchData:publicNewsPage tabelView:_pubicNewsTableView newsType:2];
    }];
    _pubicNewsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchData:++publicNewsPage tabelView:_pubicNewsTableView newsType:2];
    }];
    _helpsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        helpspage = 0;
        [self fetchData:helpspage tabelView:_helpsTableView newsType:3];
    }];
    _helpsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self fetchData:++helpspage tabelView:_helpsTableView newsType:3];
    }];
    [ZTHttpTool sendGroupPostRequest:^{
        [self fetchData:guidongPage tabelView:_guidongNewsTableView newsType:0];
        [self fetchData:elecRluesPage tabelView:_elecRulesTableView newsType:1];
        [self fetchData:publicNewsPage tabelView:_pubicNewsTableView newsType:2];
        [self fetchData:helpspage tabelView:_helpsTableView newsType:3];

    } success:^{
        [MBProgressHUD hideHUD];
    } failure:^(NSArray *errorArray) {
        [MBProgressHUD hideHUD];
    }];
    
    [self btnClick:_guidongNews];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)setNav{
    self.isShowNav = YES;
    self.titleLabel.text = @"小区头条";
}
- (void)buildHeaderScrollView{
    _headerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, 44)];
    [self.view addSubview:_headerScrollView];
    for (int i = 0; i<_headerTitleArr.count; i++) {
        
    }
}
- (void)fetchData:(NSInteger)integer tabelView:(UITableView *)tableView newsType:(NSInteger)newsType{
    NSString * str = @"news/getnews";
    if (tableView == _helpsTableView) {
        str = @"news/getContact";
    }
    [ZTHttpTool postWithUrl:str param:@{@"newsType":[NSString stringWithFormat:@"%ld",newsType],@"page":[NSString stringWithFormat:@"%ld",integer],@"pagesize":@"10"} success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        ProtalHomePageDataModel *protalData = [ProtalHomePageDataModel mj_objectWithKeyValues:str];
        if (protalData.rcode == 0) {
            if (integer == 0) {
                if (protalData.form.list.count == 0) {
                    if (tableView == _helpsTableView) {
                        [tableView addEmptyViewWithImageName:@"暂无积分" title:@"暂无信息"];
                    }else{
                        [tableView addEmptyViewWithImageName:@"暂无积分" title:@"暂无新闻"];
                    }
                    tableView.emptyView.hidden = NO;
                }else{
                    tableView.emptyView.hidden = YES;
                }
                if (tableView == _guidongNewsTableView) {
                    [_guidongNewsArr removeAllObjects];
                    [_guidongNewsArr addObjectsFromArray:protalData.form.list];
                }else if (tableView == _elecRulesTableView){
                    [_elecRulesArr removeAllObjects];
                    [_elecRulesArr addObjectsFromArray:protalData.form.list];
                }else if (tableView == _pubicNewsTableView){
                    [_publicNewsArr removeAllObjects];
                    [_publicNewsArr addObjectsFromArray:protalData.form.list];
                }else{
                    [_helpsArr removeAllObjects];
                    ProtalHomePageHelpDataModel *protalData = [ProtalHomePageHelpDataModel mj_objectWithKeyValues:str];
                    [_helpsArr addObjectsFromArray:protalData.form.list];
                }
                [tableView reloadData];
            }else{
                if (tableView == _guidongNewsTableView) {
                    [_guidongNewsArr addObjectsFromArray:protalData.form.list];
                    if (_guidongNewsArr.count == 0) {
                        
                        [tableView addEmptyViewWithImageName:@"暂无积分" title:@"暂无新闻"];
                        [tableView.emptyView setHidden:NO];
                        
                    }else{
                        [tableView.emptyView setHidden:YES];
                    }
                    if(protalData.form.list.count == 0){
                        [MBProgressHUD showError:@"没有更多数据"];
                        guidongPage--;
                    }else{
                        [tableView reloadData];
                    }
                }else if (tableView == _elecRulesTableView){
                    [_elecRulesArr addObjectsFromArray:protalData.form.list];
                    if (_elecRulesArr.count == 0) {
                        
                        [tableView addEmptyViewWithImageName:@"暂无积分" title:@"暂无新闻"];
                        [tableView.emptyView setHidden:NO];
                        
                    }else{
                        [tableView.emptyView setHidden:YES];
                    }
                    if(protalData.form.list.count == 0){
                        [MBProgressHUD showError:@"没有更多数据"];
                        elecRluesPage--;
                    }else{
                        [tableView reloadData];
                    }
                }else if (tableView == _pubicNewsTableView){
                    [_publicNewsArr addObjectsFromArray:protalData.form.list];
                    if (_publicNewsArr.count == 0) {
                        
                        [tableView addEmptyViewWithImageName:@"暂无积分" title:@"暂无新闻"];
                        [tableView.emptyView setHidden:NO];
                        
                    }else{
                        [tableView.emptyView setHidden:YES];
                    }
                    if(protalData.form.list.count == 0){
                        [MBProgressHUD showError:@"没有更多数据"];
                        publicNewsPage--;
                    }else{
                        [tableView reloadData];
                    }
                }else{
                    ProtalHomePageHelpDataModel *protalData = [ProtalHomePageHelpDataModel mj_objectWithKeyValues:str];
                    [_helpsArr addObjectsFromArray:protalData.form.list];
                    if (_helpsArr.count == 0) {
                        
                        [tableView addEmptyViewWithImageName:@"暂无积分" title:@"暂无信息"];
                        [tableView.emptyView setHidden:NO];
                        
                    }else{
                        [tableView.emptyView setHidden:YES];
                    }
                    if(protalData.form.list.count == 0){
                        [MBProgressHUD showError:@"没有更多数据"];
                        helpspage--;
                    }else{
                        [tableView reloadData];
                    }
                }
            }
           
        }else{
            [tableView addEmptyViewWithImageName:@"该时段暂无历史记录" title:@"该时段暂无历史记录"];
            [tableView.emptyView setHidden:NO];
            if(integer>0){
                if(tableView == _guidongNewsTableView){
                    guidongPage--;
                }else if (tableView == _elecRulesTableView){
                    elecRluesPage--;
                }else if (tableView == _pubicNewsTableView){
                    publicNewsPage--;
                }else{
                    helpspage--;
                }
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
            if(tableView == _guidongNewsTableView){
                guidongPage--;
            }else if (tableView == _elecRulesTableView){
                elecRluesPage--;
            }else if (tableView == _pubicNewsTableView){
                publicNewsPage--;
            }else{
                helpspage--;
            }
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _helpsTableView) {
        static NSString *cell1 = @"ProtalHelpTableViewCell";
        ProtalHelpTableViewCell *mycell = [tableView dequeueReusableCellWithIdentifier:cell1];
        if (!mycell) {
            mycell = [[[NSBundle mainBundle] loadNibNamed:cell1 owner:self options:nil] lastObject];
        }
        if (_helpsArr.count>0) {
            ProtalHomePageHelpDataList * onceList = _helpsArr[indexPath.row];
            mycell.name.text = onceList.nodeName;
            mycell.phone.text = [NSString stringWithFormat:@"联系电话：%@",onceList.tel];
            mycell.contactName.text = [NSString stringWithFormat:@"联系人：%@",onceList.contactPerson];
            mycell.adressName.text = [NSString stringWithFormat:@"地址：%@",onceList.address];

        }
        mycell.selectionStyle = UITableViewCellSelectionStyleNone;
        return mycell;
    }
    static NSString *cell4 = @"ProtalHomePageTableViewCell";
    ProtalHomePageTableViewCell *mycell = [tableView dequeueReusableCellWithIdentifier:cell4];
    if (!mycell) {
        mycell = [[[NSBundle mainBundle] loadNibNamed:@"ProtalHomePageTableViewCell" owner:self options:nil] lastObject];
    }
    ProtalHomePageDataList * onceList;
    if (tableView == _guidongNewsTableView) {
        if (_guidongNewsArr.count>0) {
            onceList = _guidongNewsArr[indexPath.row];
        }
    }else if (tableView == _elecRulesTableView){
        if (_elecRulesArr.count>0) {
            onceList = _elecRulesArr[indexPath.row];
        }
    }else if(tableView == _pubicNewsTableView){
        if (_publicNewsArr.count>0) {
            onceList = _publicNewsArr[indexPath.row];
        }
    }
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
    if (tableView == _helpsTableView) {
        return _helpsArr.count;
    }else if (tableView == _guidongNewsTableView){
        return _guidongNewsArr.count;
    }else if (tableView == _elecRulesTableView){
        return _elecRulesArr.count;
    }else if (tableView == _pubicNewsTableView){
        return _publicNewsArr.count;
    }else{
        return _helpsArr.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _helpsTableView) {
        return 128;
    }else{
        ProtalHomePageDataList * onceList;
        if (tableView == _guidongNewsTableView) {
            if (_guidongNewsArr.count>0) {
                onceList = _guidongNewsArr[indexPath.row];
            }
        }else if (tableView == _elecRulesTableView){
            if (_elecRulesArr.count>0) {
                onceList = _elecRulesArr[indexPath.row];
            }
        }else{
            if (_publicNewsArr.count>0) {
                onceList = _publicNewsArr[indexPath.row];
            }
        }
        if(onceList){
            switch (onceList.layout) {
                case 0:
                {
                    ;
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
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _helpsTableView) {
        return;
    }
    ProtalHomePageDataList * onceList;
    if (tableView == _guidongNewsTableView) {
        if (_guidongNewsArr.count>0) {
            onceList = _guidongNewsArr[indexPath.row];
        }
    }else if (tableView == _elecRulesTableView){
        if (_elecRulesArr.count>0) {
            onceList = _elecRulesArr[indexPath.row];
        }
    }else{
        if (_publicNewsArr.count>0) {
            onceList = _publicNewsArr[indexPath.row];
        }
    }
    PortalHomePageDetailViewController * page = [[PortalHomePageDetailViewController alloc]init];
    page.onceList = onceList;
    [self.navigationController pushViewController:page animated:YES];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.myScrollView) {
       NSInteger f = scrollView.contentOffset.x/SCREEN_WIDTH;
        if (f == 0) {
            [self btnClick:_guidongNews];
        }else if (f== 1){
            [self btnClick:_elecRules];
        }else if (f == 2){
            [self btnClick:_pubicNews];
        }else if (f == 3){
            [self btnClick:_helps];
        }
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

- (IBAction)btnClick:(id)sender {
    [_guidongNews.titleLabel setAlpha:0.7];
    [_elecRules.titleLabel setAlpha:0.7];
    [_pubicNews.titleLabel setAlpha:0.7];
    [_helps.titleLabel setAlpha:0.7];
    [_guidongNews.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_elecRules.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_pubicNews.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_helps.titleLabel setFont:[UIFont systemFontOfSize:15]];

    
    
    UIButton *btn = sender;
    [btn.titleLabel setAlpha:1];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];

    
    switch (btn.tag) {
        case 10://桂东新闻
            {
                self.myScrollView.contentOffset = CGPointMake(0, 0);
            }
            break;
        case 20://电价法规
        {
            self.myScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);

        }
            break;
        case 30://公共新闻
        {
            self.myScrollView.contentOffset = CGPointMake(SCREEN_WIDTH *2, 0);
        }
            break;
        case 40://帮助
        {
            self.myScrollView.contentOffset = CGPointMake(SCREEN_WIDTH*3, 0);
        }
            break;
        default:
            break;
    }
}
@end
