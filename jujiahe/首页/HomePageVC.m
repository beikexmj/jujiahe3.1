//
//  HomePageVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/1/15.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "HomePageVC.h"
#import "SDCycleScrollView.h"
#import "HomePageCell.h"
#import "PGIndexBannerSubiew.h"
#import "HomePageDataModel.h"
#import "MyWebVC.h"
#import "MessageCenterVC.h"
#import "JSBadgeView.h"
#import "ChoseUnitViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "PropertyServiceVC.h"
#import "ServiceVC.h"
#import "CallPropertyVC.h"
#import <MOBFoundation/MOBFoundation.h>
#import "YYText.h"
#import "NSString+URL.h"
#import "TopicVC.h"
#import "TopicClassificationVC.h"
#import "MessageCenterVC.h"
#import "FamilyDynamicVC.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "UITableView+WFEmpty.h"

@interface HomePageVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    CGFloat ox;
    CGFloat oy;
    CGFloat width;
    CGFloat height;
    CGFloat picHight;
    JSBadgeView *_badgeView;
    BOOL refreshflag;
    NSInteger pageIndex;
    HomePageCell *followCell;
    UIView *meaasgeFlagView;

}
@property (nonatomic,strong)UIButton *locationBtn;
@property (nonatomic,strong)UIButton *meassgeBtn;
@property (nonatomic,strong)UIButton *signBtn;
@property (nonatomic,strong)UILabel *buildingNameLab;
@property (nonatomic,strong)UITableView *myTableView;
@property (weak, nonatomic) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) NSMutableDictionary *activity_Dict;
/**
*  图片数组
*/
@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic,strong)HomePageData *homePageData;
@property (nonatomic,strong)NSMutableArray <TopicModelData *> *dataArr;
@property (nonatomic,strong)NSMutableDictionary * hightDict;

@end

@implementation HomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self.view addSubview:self.myTableView];
    _hightDict = [NSMutableDictionary dictionary];
    _activity_Dict = [NSMutableDictionary dictionary];
    _dataArr = [NSMutableArray array];
    refreshflag = YES;
    pageIndex = 1;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageIndex = 1;
        [self fetchData:1];
    }];
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        pageIndex++;
        [self fetchData:pageIndex];
    }];
    [self fetchData:1];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)fetchData:(NSInteger)pageNum{
    StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
    NSDictionary *dict = @{@"cityOid":storage.areaNumber,@"userId":storage.ids?storage.ids:@"",@"pageNum":[NSString stringWithFormat:@"%ld",pageNum],@"pageSize":@"20"};
    [XMJHttpTool postWithUrl:@"homepage/getHomepage" param:dict success:^(id responseObj) {
        NSString * str = [responseObj mj_JSONObject];
        HomePageDataModel *data = [HomePageDataModel mj_objectWithKeyValues:str];
        
        if (data.success) {
            _homePageData = data.data;
            if (pageNum == 1) {
                [_hightDict removeAllObjects];
                [self messageUnreadBadge];
                [self rebuildHomeFace];
//                if (_homePageData.topicModel.data.count == 0) {
//                    [self.myTableView addEmptyViewWithImageName:@"暂无积分" title:@"暂无信息"];
//                    self.myTableView.emptyView.hidden = NO;
//                }else{
//                    self.myTableView.emptyView.hidden = YES;
//                }
                [_dataArr removeAllObjects];
                [_dataArr addObjectsFromArray:_homePageData.topicModel.data];
                
                [self.myTableView reloadData];
            }else{
                [_dataArr addObjectsFromArray:_homePageData.topicModel.data];
//                if (_dataArr.count == 0) {
//                    [self.myTableView addEmptyViewWithImageName:@"暂无积分" title:@"暂无信息"];
//                    [self.myTableView.emptyView setHidden:NO];
//                }else{
//                    [self.myTableView.emptyView setHidden:YES];
//                }
                if(_homePageData.topicModel.data == 0){
                    [MBProgressHUD showError:@"没有更多数据"];
                    pageIndex--;
                }else{
                    NSMutableArray *insertIndexPaths = [NSMutableArray array];
                    for (int ind = 0; ind < _homePageData.topicModel.data.count; ind++) {
                        NSIndexPath    *newPath =  [NSIndexPath indexPathForRow: _dataArr.count - _homePageData.topicModel.data.count + ind inSection:0];
                        [insertIndexPaths addObject:newPath];
                    }
                    //重新调用UITableView的方法, 来生成行.
                    [UIView performWithoutAnimation:^{
                        [self.myTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                        [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArr.count - _homePageData.topicModel.data.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
                    }];
                }
            }
        }else{
//            [self.myTableView addEmptyViewWithImageName:@"该时段暂无历史记录" title:@"该时段暂无历史记录"];
//            [self.myTableView.emptyView setHidden:NO];
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
- (void)fetchData2{
    
}
- (void)rebuildHomeFace{
    NSArray<RecommendedResultModelList *> *imageArr = _homePageData.recommendedResultModelList;
    NSInteger num = imageArr.count;
    CGFloat btnWidth = (SCREENWIDTH - 40)/2.0;
    CGFloat btnHeight =  btnWidth * (85.0/170);
    if (num == 2) {
        picHight = 30 + 15 + 30 + btnHeight;
    }else if (num == 4){
        picHight = 30 + 15 + 30 + btnHeight*2 + 10;
    }else{
        picHight = 30 + 30;
    }

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, picHight)];

    UIView *weatherView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH,30)];
    weatherView.backgroundColor = RGBA(0x00a7ff, 1);
    UILabel *temperature = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 30)];
    temperature.textColor = RGBA(0xffffff, 1);
    temperature.font = [UIFont systemFontOfSize:19.0];
    temperature.text  = [NSString stringWithFormat:@"%@°C",_homePageData.weatherResultModel.temp];
    CGRect frame  = temperature.frame;
    frame.size.width = [temperature sizeThatFits:CGSizeMake(MAXFLOAT, 30)].width;
    temperature.frame = frame;
    [weatherView addSubview:temperature];
    
    UILabel *subTemperature = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width + frame.origin.x + 10, 0, 150, 30)];
    subTemperature.textColor = RGBA(0xffffff, 1);
    subTemperature.font = [UIFont systemFontOfSize:14.0];
    subTemperature.text  = [NSString stringWithFormat:@"%@    %@/%@°C",_homePageData.weatherResultModel.condition,_homePageData.weatherResultModel.tempNight,_homePageData.weatherResultModel.tempDay];
    [weatherView addSubview:subTemperature];
   
    UILabel *airQuality = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH - 135, 0, 120, 30)];
    airQuality.textColor = RGBA(0xffffff, 1);
    airQuality.font = [UIFont systemFontOfSize:14.0];
    airQuality.text  = [NSString stringWithFormat:@"空气质量：%@",_homePageData.weatherResultModel.value_level];
    airQuality.textAlignment = NSTextAlignmentRight;
    [weatherView addSubview:airQuality];
    
    [headerView addSubview:weatherView];
    NSInteger k = 0;
    for (int i = 0; i<num/2; i++) {
        for (int j=0; j<2; j++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15 + (btnWidth+10)*j,  30 + 15 + i*(btnHeight + 10), btnWidth, btnHeight)];
            k++;
            btn.tag = k;
            if ([imageArr is_empty]) {
                [btn sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
            } else {
                [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:imageArr[k-1].pictureUrl] forState:UIControlStateNormal];
            }
            [btn addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:btn];
        }
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, picHight  - 15, 5, 15)];
    lineView.backgroundColor  = RGBA(0x00a7ff, 1);
    [headerView addSubview:lineView];
    UILabel *markTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, picHight - 15, 100, 15)];
    markTitle.textColor = RGBA(0x00a7ff, 1);
    markTitle.font = [UIFont systemFontOfSize:16.0];
    markTitle.text = @"生活话题";
    [headerView  addSubview:markTitle];

    UILabel *moreClassification = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH - 130, picHight - 15, 100, 15)];
    moreClassification.textColor = RGBA(0x606060, 1);
    moreClassification.font = [UIFont systemFontOfSize:14.0];
    moreClassification.text = @"更多分类";
    moreClassification.textAlignment = NSTextAlignmentRight;
    [headerView  addSubview:moreClassification];
    
    UIImageView *rightMarkImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH - 20, picHight - 15  + 2.5, 6, 10)];
    rightMarkImg.image = [UIImage imageNamed:@"icon_more_gray"];
    [headerView addSubview:rightMarkImg];
    
    UIButton *moreClassificationBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, picHight - 15, SCREENWIDTH, 15.0)];
    [moreClassificationBtn addTarget:self action:@selector(moreClassificationbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:moreClassificationBtn];
    
    _myTableView.tableHeaderView = headerView;
    
    
}
- (void)headerBtnClick:(UIButton *)btn{
    FamilyDynamicVC *vc = [[FamilyDynamicVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)moreClassificationbtnClick:(UIButton *)btn{
    TopicClassificationVC *page = [[TopicClassificationVC alloc]init];
    [self.navigationController pushViewController:page animated:YES];
}
#pragma mark --懒加载
- (NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
- (void)setNav{
    self.isShowNav = YES;
    self.navView.backgroundColor = RGBA(0x00a7ff, 1);
    self.lineView.hidden = YES;
    UIImage *locationBtnImg = [UIImage imageNamed:@"home_icon_house2"];
    width = locationBtnImg.size.width + 30;
    ox = 0;
    if (is_iPhone_X) {
        oy = 44;
    }else {
        oy = 20;
    }
    height = NAVHEIGHT - oy;

    _locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationBtn.backgroundColor = [UIColor clearColor];
    _locationBtn.frame = CGRectMake(ox, oy, width, height);
    [_locationBtn setImage:locationBtnImg forState:UIControlStateNormal];
    _locationBtn.userInteractionEnabled = YES;
    [self.navView addSubview:_locationBtn];
    [_locationBtn addTarget:self action:@selector(locationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _buildingNameLab = [[UILabel alloc]initWithFrame:CGRectMake(ox+width-5, oy, 150, height)];
    _buildingNameLab.text = [StorageUserInfromation storageUserInformation].choseUnitName;
    _buildingNameLab.textAlignment = NSTextAlignmentLeft;
    _buildingNameLab.font = [UIFont systemFontOfSize:15.0];
    _buildingNameLab.textColor = RGBA(0xffffff, 1);
    [self.navView addSubview:_buildingNameLab];
    
    UIImage *img = [UIImage imageNamed:@"home_icon_calendar"];
    width = img.size.width + 30;
    ox = SCREENWIDTH - width;

    _signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _signBtn.backgroundColor = [UIColor clearColor];
    _signBtn.frame = CGRectMake(ox, oy, width, height);
    if (img) {
        [_signBtn setImage:img forState:UIControlStateNormal];
    }
    
    _signBtn.userInteractionEnabled = YES;
//    [self.navView addSubview:_signBtn];
    [_signBtn addTarget:self action:@selector(signBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIImage *meassgeBtnImg = [UIImage imageNamed:@"home_icon_massage"];
    width = meassgeBtnImg.size.width + 30;
    ox = SCREENWIDTH - width;

    _meassgeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _meassgeBtn.backgroundColor = [UIColor clearColor];
    _meassgeBtn.frame = CGRectMake(ox, oy, width, height);
    if (meassgeBtnImg) {
        [_meassgeBtn setImage:meassgeBtnImg forState:UIControlStateNormal];
    }

    _meassgeBtn.userInteractionEnabled = YES;
    _badgeView = [[JSBadgeView alloc] initWithParentView:_meassgeBtn alignment:JSBadgeViewAlignmentTopLeft];
    [self messageUnreadBadge];
    [self.navView addSubview:_meassgeBtn];
    
    meaasgeFlagView  = [[UIView alloc]initWithFrame:CGRectMake(15, 12, 7, 7)];
    meaasgeFlagView.layer.cornerRadius = 7/2.0;
    meaasgeFlagView.backgroundColor =RGBA(0xfe4b20, 1);
    meaasgeFlagView.hidden  = YES;
    [self.meassgeBtn addSubview:meaasgeFlagView];
    
    [_meassgeBtn addTarget:self action:@selector(meassgeBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)messageUnreadBadge{
    NSInteger num = _homePageData.messageFlag;
    if (num) {
        meaasgeFlagView.hidden = NO;
    }else{
        meaasgeFlagView.hidden = YES;
    }
}

- (void)locationBtnClick{
    [MobClick event:@"csq_c"];
    ChoseUnitViewController *page = [[ChoseUnitViewController alloc]init];
    page.comFromFlag = 2;
    page.unitChoseBlock = ^(NSString *unitName, NSString *ids, NSString *propertyId,NSString *proertyName,NSInteger isInput) {
        _buildingNameLab.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"choseUnitName"];
        NSString  *choseUnitPropertyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"choseUnitPropertyId"];
        NSString  *choseUnitName = [[NSUserDefaults standardUserDefaults] objectForKey:@"choseUnitName"];
        NSString  *cityNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityNumber"];
        NSString  *currentCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentCity"];
        NSString  *areaNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"areaNumber"];
        NSString  *currentArea = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentArea"];
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];
        
        
        StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
        storage.choseUnitPropertyId = choseUnitPropertyId;
        storage.choseUnitName = choseUnitName;
        storage.cityNumber = cityNumber;
        storage.currentCity = currentCity;
        storage.currentArea = currentArea;
        storage.areaNumber = areaNumber;
        [NSKeyedArchiver archiveRootObject:storage toFile:file];
        [self fetchData:1];
    };
    [self.navigationController pushViewController:page animated:YES];
}
- (void)signBtnClick{
    if([[StorageUserInfromation storageUserInformation].userId isEqualToString:@""]){
        UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:@"未登录" message:@"确定跳回登陆界面？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 5;
        [alert show];
    }else{
        [MobClick event:@"itrk_c"];
//        MyIntegralVC *page = [[MyIntegralVC alloc]init];
//        [self.navigationController pushViewController:page animated:YES];
    }
}
- (void)meassgeBtnClick{
//    if([[StorageUserInfromation storageUserInformation].userId isEqualToString:@""]){
//        UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:@"未登录" message:@"确定跳回登陆界面？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        alert.tag = 10;
//        [alert show];
//    }else{
        MessageCenterVC * mcVC = [[MessageCenterVC alloc]init];
        [self.navigationController pushViewController:mcVC animated:YES];
//    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {

    }else{
        LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.window.rootViewController =  [[UINavigationController alloc] initWithRootViewController:controller];
        
    }
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-TABBARHEIGHT-NAVHEIGHT)style:UITableViewStylePlain];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        [_myTableView registerNib:[UINib nibWithNibName:@"HomePageCell" bundle:nil] forCellReuseIdentifier:@"HomePageCell"];
    }
    return _myTableView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.myTableView) {
        CGFloat f = scrollView.contentOffset.y;
//        XMJLog(@"%0.2f",f);
        if (f>= 40) {
            self.navView.backgroundColor = RGBA(0xffffff, 1);
            [self.locationBtn setImage:[UIImage imageNamed:@"home_icon_house"] forState:UIControlStateNormal];
            self.buildingNameLab.textColor = RGBA(0x303030, 1);
            
            [self.meassgeBtn setImage:[UIImage imageNamed:@"home_icon_massage_black"] forState:UIControlStateNormal];

        }else{
            self.navView.backgroundColor = RGBA(0x00a7ff, 1);
            [self.locationBtn setImage:[UIImage imageNamed:@"home_icon_house2"] forState:UIControlStateNormal];
            self.buildingNameLab.textColor = RGBA(0xffffff, 1);
            [self.meassgeBtn setImage:[UIImage imageNamed:@"home_icon_massage"] forState:UIControlStateNormal];

        }
    }
    
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
    mycell.followBtnOne.tag = indexPath.row;
    mycell.followBtnTwo.tag = indexPath.row;
    mycell.followBtnThree.tag = indexPath.row;

    if (_dataArr.count>0) {
        TopicModelData *onceDict = _dataArr[indexPath.row];
        NSMutableArray *coverArr = [NSMutableArray array];
        if (![JGIsBlankString isBlankString:onceDict.covers ]) {
           [coverArr addObjectsFromArray:[DictToJson arrWithJsonString:onceDict.covers]];
        }
        if (onceDict.layerType == 1) {
            mycell.subViewOne.hidden = NO;
            [mycell.imageOne sd_setImageWithURL:[NSURL URLWithString:coverArr.lastObject] placeholderImage:[UIImage imageNamed:@"icon_默认"]];
            mycell.titleOne.text = onceDict.title;
            mycell.markOne.text = onceDict.typeName;
            mycell.markOneWidth.constant = [mycell.markOne sizeThatFits:CGSizeMake(MAXFLOAT, 15)].width + 10;
            mycell.readNumOne.text = [NSString stringWithFormat:@"阅读：%@",onceDict.viewNum];
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.lineSpacing = 6; //设置行间距
            paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:mycell.titleOne.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:RGBA(0x303030, 1),NSParagraphStyleAttributeName:paraStyle}];
            mycell.titleOne.attributedText = attrStr;
            if (onceDict.attentionFlag == 1) {
                mycell.followBtnOneWidth.constant = 55;
                [mycell.followBtnOne setTitle:@"已关注" forState:UIControlStateNormal];
                [mycell.followBtnOne setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
                mycell.followBtnOne.layer.borderColor = RGBA(0x00a7ff, 1).CGColor;
            }
            mycell.followBtnOneBlock = ^(NSInteger index,HomePageCell *cell) {
                followCell = cell;
            };
        }else if (onceDict.layerType == 2){
            mycell.subViewTwo.hidden = NO;
            [mycell.imageTwo sd_setImageWithURL:[NSURL URLWithString:coverArr.lastObject] placeholderImage:[UIImage imageNamed:@"icon_默认"]];
            mycell.titleTwo.text = onceDict.title;
            mycell.markTwo.text = onceDict.typeName;
            mycell.markTwoWidth.constant = [mycell.markTwo sizeThatFits:CGSizeMake(MAXFLOAT, 15)].width + 10;
            mycell.readNumTwo.text = [NSString stringWithFormat:@"阅读：%@",onceDict.viewNum];
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.lineSpacing = 6; //设置行间距
            paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:mycell.titleTwo.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:RGBA(0x303030, 1),NSParagraphStyleAttributeName:paraStyle}];
            mycell.titleTwo.attributedText = attrStr;
            if (onceDict.attentionFlag == 1) {
                mycell.followBtnTwoWidth.constant = 55;
                [mycell.followBtnTwo setTitle:@"已关注" forState:UIControlStateNormal];
                [mycell.followBtnTwo setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
                mycell.followBtnTwo.layer.borderColor = RGBA(0x00a7ff, 1).CGColor;
            }
            mycell.followBtnTwoBlock = ^(NSInteger index,HomePageCell *cell) {
                followCell = cell;
            };
        }else if (onceDict.layerType == 3){
            mycell.subViewThree.hidden = NO;
            mycell.titleThree.text = onceDict.title;
            mycell.markThree.text = onceDict.typeName;
            mycell.markThreeWidth.constant = [mycell.markThree sizeThatFits:CGSizeMake(MAXFLOAT, 15)].width + 10;
            mycell.readNumThree.text = [NSString stringWithFormat:@"阅读：%@",onceDict.viewNum];
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.lineSpacing = 6; //设置行间距
            paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:mycell.titleThree.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f],NSForegroundColorAttributeName:RGBA(0x303030, 1),NSParagraphStyleAttributeName:paraStyle}];
            mycell.titleThree.attributedText = attrStr;
            if (coverArr.count>0) {
                [mycell.imageOneInViewThree sd_setImageWithURL:[NSURL URLWithString:coverArr[0]] placeholderImage:[UIImage imageNamed:@"icon_默认"]];
            }
            if (coverArr.count>1) {
                [mycell.imageTwoInViewThree sd_setImageWithURL:[NSURL URLWithString:coverArr[1]] placeholderImage:[UIImage imageNamed:@"icon_默认"]];
            }
            if (coverArr.count>2) {
                [mycell.imageThreeInViewThree sd_setImageWithURL:[NSURL URLWithString:coverArr[2]] placeholderImage:[UIImage imageNamed:@"icon_默认"]];
            }
            if (onceDict.attentionFlag == 1) {
                mycell.followBtnThreeWidth.constant = 55;
                [mycell.followBtnThree setTitle:@"已关注" forState:UIControlStateNormal];
                [mycell.followBtnThree setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
                mycell.followBtnThree.layer.borderColor = RGBA(0x00a7ff, 1).CGColor;
            }
            mycell.followBtnThreeBlock = ^(NSInteger index,HomePageCell *cell) {
                followCell = cell;
            };
        }
    }
    return mycell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber* cellHeightNumber = [_hightDict objectForKey:@(indexPath.row)];
    CGFloat cellHeight;
    if (cellHeightNumber) {//判断是否缓存了该cell的高度
        cellHeight = [cellHeightNumber floatValue];
        return cellHeight;
    }
    TopicModelData *onceDict = _dataArr[indexPath.row];

    if (onceDict.layerType == 1) {
        CGFloat contentHeight = [StorageUserInfromation getStringSizeWith2:[NSString stringWithFormat:@"%@",onceDict.title] withStringFont:16.0 withWidthOrHeight:SCREENWIDTH-30 lineSpacing:8.0].height;
        if (contentHeight>46) {
            contentHeight = 46;
        }
        [_hightDict setObject:[NSNumber numberWithFloat:80 + (SCREENWIDTH - 30)*(220/700.0) - 15 + contentHeight] forKey:@(indexPath.row)];

        return 80 + (SCREENWIDTH - 30)*(220/700.0) - 15 + contentHeight;
    }else if (onceDict.layerType == 2){
        [_hightDict setObject:[NSNumber numberWithFloat:105] forKey:@(indexPath.row)];

        return 105;
    }
    CGFloat contentHeight = [StorageUserInfromation getStringSizeWith2:[NSString stringWithFormat:@"%@",onceDict.title] withStringFont:16.0 withWidthOrHeight:SCREENWIDTH-30 lineSpacing:8.0].height;
    if (contentHeight>46) {
        contentHeight = 46;
    }
    [_hightDict setObject:[NSNumber numberWithFloat:110 + (SCREENWIDTH - 40)/3.0 *(150/220.0) - 40 + contentHeight] forKey:@(indexPath.row)];
    return 110 + (SCREENWIDTH - 40)/3.0 *(150/220.0) - 40 + contentHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicVC *page = [[TopicVC alloc]init];
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
