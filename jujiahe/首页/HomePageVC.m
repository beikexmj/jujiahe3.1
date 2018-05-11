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
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <MOBFoundation/MOBFoundation.h>
#import "YYText.h"
#import "NSString+URL.h"
@interface HomePageVC ()<UITableViewDelegate,UITableViewDataSource,NewPagedFlowViewDelegate, NewPagedFlowViewDataSource,SDCycleScrollViewDelegate,UITextViewDelegate>
{
    CGFloat ox;
    CGFloat oy;
    CGFloat width;
    CGFloat height;
    CGFloat picHight;
    JSBadgeView *_badgeView;
    BOOL refreshflag;
}
@property (nonatomic,strong)UIButton *locationBtn;
@property (nonatomic,strong)UIButton *meassgeBtn;
@property (nonatomic,strong)UIButton *signBtn;
@property (nonatomic,strong)UILabel *buildingNameLab;
@property (nonatomic,strong)UIScrollView *myScollView;
@property (nonatomic,strong)UITableView *myTableView;
@property (weak, nonatomic) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) HomePageForm *homePageData;
@property (nonatomic,strong) Activity_form *activity_from_roll;
@property (nonatomic,strong) Activity_form *activity_from_list;
@property (nonatomic,strong) NeighborhoodForm *neighborhoodFormArr;
@property (nonatomic,strong) NSMutableDictionary *activity_Dict;
@property (nonatomic, strong) NSMutableArray<Template_dataArr *> *template_data;

/**
*  图片数组
*/
@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation HomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setScrollView];
    [self setNav];
//    for (int index = 0; index < 3; index++) {
//        UIImage *image = [UIImage imageNamed:@"home_pic3"];
//        [self.imageArray addObject:image];
//    }
    _activity_Dict = [NSMutableDictionary dictionary];
    _template_data = [NSMutableArray array];
    refreshflag = YES;
    [self fetchData];

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
- (UILabel *)dailyWord{
    if (!_dailyWord) {
        CGFloat titleLabelH = 40;
        CGFloat titleLabelX = 15;
        CGFloat titleLabelW = SCREENWIDTH - titleLabelX*2;
        CGFloat titleLabelY = SCREENHEIGHT - titleLabelH - 30;
        _dailyWord = [[UILabel alloc]initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        _dailyWord.numberOfLines = 0;
        _dailyWord.font = [UIFont systemFontOfSize:14.0];
        _dailyWord.textColor = [UIColor whiteColor];
        //阴影颜色
        _dailyWord.shadowColor = RGBA(0x000000, 0.3);
        //阴影偏移  x，y为正表示向右下偏移
        _dailyWord.shadowOffset = CGSizeMake(1, 1);
    }
    return _dailyWord;
}
- (UILabel *)day{
    if (!_day) {
        CGFloat titleLabelH = 60;
        CGFloat titleLabelX = 15;
        CGFloat titleLabelW = titleLabelH+5;
        CGFloat titleLabelY = NAVHEIGHT + 20;
        _day = [[UILabel alloc]initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        _day.font = [UIFont systemFontOfSize:50.0];
        _day.textColor = [UIColor whiteColor];
        //阴影颜色
        _day.shadowColor = RGBA(0x000000, 0.2);
        //阴影偏移  x，y为正表示向右下偏移
        _day.shadowOffset = CGSizeMake(1, 1);
    }
    return _day;
}
- (UILabel *)week{
    if (!_week) {
        CGFloat titleLabelH = 30;
        CGFloat titleLabelX = 15 + 65;
        CGFloat titleLabelW = 100;
        CGFloat titleLabelY = NAVHEIGHT +20 +5;
        _week = [[UILabel alloc]initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        _week.font = [UIFont systemFontOfSize:15.0];
        _week.textColor = [UIColor whiteColor];
        //阴影颜色
        _week.shadowColor = RGBA(0x000000, 0.3);
        //阴影偏移  x，y为正表示向右下偏移
        _week.shadowOffset = CGSizeMake(1, 1);
    }
    return _week;
}
- (UILabel *)month{
    if (!_month) {
        CGFloat titleLabelH = 25;
        CGFloat titleLabelX = 15 + 65;
        CGFloat titleLabelW = 100;
        CGFloat titleLabelY = NAVHEIGHT + 20 + 25;
        _month = [[UILabel alloc]initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        _month.font = [UIFont systemFontOfSize:19.0];
        _month.textColor = [UIColor whiteColor];
        //阴影颜色
        _month.shadowColor = RGBA(0x000000, 0.3);
        //阴影偏移  x，y为正表示向右下偏移
        _month.shadowOffset = CGSizeMake(1, 1);
    }
    return _month;
}
- (UIButton *)shareBtn{
    if (!_shareBtn) {
        CGFloat titleLabelH = 44;
        CGFloat titleLabelX = SCREENWIDTH - 60;
        CGFloat titleLabelW = 60;
        CGFloat titleLabelY = NAVHEIGHT - 44;
        _shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        [_shareBtn setImage:[UIImage imageNamed:@"icon_share_white2"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}
- (UIButton *)backBtn{
    if (!_backBtn) {
        CGFloat titleLabelH = 44;
        CGFloat titleLabelX = 0;
        CGFloat titleLabelW = 60;
        CGFloat titleLabelY = NAVHEIGHT - 44;
        _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
        [_backBtn setImage:[UIImage imageNamed:@"icon_back_white2"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (void)shareBtnClick{
//    if([[StorageUserInfromation storageUserInformation].userId isEqualToString:@""]){
//        UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:@"未登录" message:@"确定跳回登陆界面？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alert show];
//    }else{
        [self showShareActionSheet:self.view];
//    }
}
/**
 *  显示分享菜单
 *
 *  @param view 容器视图
 */
- (void)showShareActionSheet:(UIView *)view
{
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    //    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"shareImg" ofType:@"png"];
    //    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"Icon" ofType:@"png"];
    //    NSArray* imageArray = @[@"http://ww4.sinaimg.cn/bmiddle/005Q8xv4gw1evlkov50xuj30go0a6mz3.jpg",[UIImage imageNamed:@"shareImg.png"]];

    NSString *url = [NSString stringWithFormat:@"%@?id=%@",BASE_SHARE,_homePageData.daily_word_data.ids];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    XMJLog(@"%@",url);
    [shareParams SSDKSetupShareParamsByText:_homePageData.daily_word_data.name
                                     images:[UIImage imageNamed:@"登录logo"]
                                        url:[NSURL URLWithString:url]
                                      title:@"居家合"
                                       type:SSDKContentTypeAuto];
    
    [ShareSDK showShareActionSheet:view
                             items:@[
                                     @(SSDKPlatformTypeQQ),
                                     @(SSDKPlatformSubTypeQQFriend),
                                     @(SSDKPlatformSubTypeWechatSession),
                                     @(SSDKPlatformSubTypeWechatTimeline),
                                     ]
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           //Facebook Messenger、WhatsApp等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
                           if (platformType == SSDKPlatformTypeFacebookMessenger)
                           {
                               break;
                           }
                           
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短信。"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用；"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }else if([error code] == 105)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"没有有效的分享平台可以显示。原因可能是：分享平台需要安装qq或者微信客户端才能分享，而这台iOS设备没有安装这些平台的客户端。"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           //                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                           //                                                                               message:nil
                           //                                                                              delegate:nil
                           //                                                                     cancelButtonTitle:@"确定"
                           //                                                                     otherButtonTitles:nil];
                           //                           [alertView show];
                           break;
                       }
                       default:
                           break;
                   }
                   
                   if (state != SSDKResponseStateBegin && state != SSDKResponseStateBeginUPLoad)
                   {
                   }
               }];
}
- (void)backBtnClick{
    [_myScollView setContentOffset:CGPointMake(0, SCREENHEIGHT-39) animated:YES];
}
- (void)fetchData{
    if (!refreshflag) {
        return;
    }
    refreshflag = NO;
    [self messageUnreadBadge];
    _buildingNameLab.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"choseUnitName"];
    NSString *choseUnitPropertyId = [StorageUserInfromation storageUserInformation].choseUnitPropertyId;
    if ((!choseUnitPropertyId)|[choseUnitPropertyId isEqualToString:@""]) {
        choseUnitPropertyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"choseUnitPropertyId"];
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];
        StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
        storage.choseUnitPropertyId = choseUnitPropertyId;
        [NSKeyedArchiver archiveRootObject:storage toFile:file];
    }
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"device":@"1",@"userId":[StorageUserInfromation storageUserInformation].userId,@"propertyAreaId":choseUnitPropertyId,@"apiv":@"1.0"};
    [ZTHttpTool postWithUrl:@"jujiahe/v1/home/index" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        HomePageDataModel *homePageData = [HomePageDataModel mj_objectWithKeyValues:str];
        if (homePageData.rcode == 0) {
            _homePageData = homePageData.form;
            [self rebuildHomeFace];
        }
//        [MBProgressHUD hideHUD];
//        [MBProgressHUD showSuccess:homePageData.msg];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
//        [MBProgressHUD hideHUD];
        refreshflag = YES;
        [MBProgressHUD showError:@"网络不给力，请检测您的网络设置"];
    }];

}
- (void)fetchData2{
    if (!refreshflag) {
        return;
    }
    refreshflag = NO;
    [self messageUnreadBadge];
     _buildingNameLab.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"choseUnitName"];
    [MBProgressHUD showMessage:@""];
    NSString * choseUnitPropertyId = [StorageUserInfromation storageUserInformation].choseUnitPropertyId;
    if ((!choseUnitPropertyId)|[choseUnitPropertyId isEqualToString:@""]) {
        choseUnitPropertyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"choseUnitPropertyId"];
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];
        StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
        storage.choseUnitPropertyId = choseUnitPropertyId;
        [NSKeyedArchiver archiveRootObject:storage toFile:file];
    }
    NSDictionary *dict = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"device":@"1",@"userId":[StorageUserInfromation storageUserInformation].userId,@"propertyAreaId":choseUnitPropertyId,@"apiv":@"1.0"};
    [ZTHttpTool postWithUrl:@"jujiahe/v1/home/index" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSLog(@"%@",[DictToJson dictionaryWithJsonString:str]);
        HomePageDataModel *homePageData = [HomePageDataModel mj_objectWithKeyValues:str];
        if (homePageData.rcode == 0) {
            _homePageData = homePageData.form;
            [self rebuildHomeFace];
        }else{
            [MBProgressHUD hideHUD];
        }
        //        [MBProgressHUD showSuccess:homePageData.msg];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUD];
        refreshflag = YES;
        [MBProgressHUD showError:@"网络不给力，请检测您的网络设置"];
    }];
    
}
- (void)rebuildHomeFace{
    picHight = 200;

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, picHight)];

//    UIImage *image = [UIImage imageNamed:@"banner_pic"];
    NSMutableArray * myArr = [NSMutableArray array];
    [myArr addObject:_homePageData.daily_word_data.icon];

    for (Advertisement_dataArr *dict in  _homePageData.advertisement_data.data) {
        [myArr addObject:dict.icon];
    }
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, picHight) imagesGroup:myArr advertisement_data:_homePageData.daily_word_data];
    _cycleScrollView.delegate = self;
    //         --- 模拟加载延迟
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        _cycleScrollView.imageURLStringsGroup = myArr;
//    });
    [headerView addSubview:_cycleScrollView];
    [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headerView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _myTableView.tableHeaderView = headerView;
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    UIImageView *topImageView = [[UIImageView alloc]init];
    topView.contentMode = UIViewContentModeScaleAspectFill;
//    topImageView.image = [UIImage imageNamed:@"banner_pic"];
    [topImageView sd_setImageWithURL:[NSURL URLWithString:_homePageData.daily_word_data.background_image] placeholderImage:[UIImage imageNamed:@"icon_默认"] options:SDWebImageAllowInvalidSSLCertificates];
    [topView addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(topView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.myScollView addSubview:topView];
    
    [topView addSubview:self.dailyWord];
    [topView addSubview:self.day];
    [topView addSubview:self.week];
    [topView addSubview:self.month];
    [topView addSubview:self.shareBtn];
    [topView addSubview:self.backBtn];
    self.dailyWord.text = _homePageData.daily_word_data.name;
    CGFloat titleLabelX = 15;
    CGFloat titleLabelW = SCREENWIDTH - titleLabelX*2;
    CGSize size = [self.dailyWord sizeThatFits:CGSizeMake(titleLabelW, MAXFLOAT)];
    CGFloat titleLabelY = SCREENHEIGHT - size.height - 30;
    self.dailyWord.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, size.height);
    self.day.text = [StorageUserInfromation dayFromDateString:_homePageData.daily_word_data.time];
    self.month.text = [StorageUserInfromation monthFromDateString:_homePageData.daily_word_data.time];
    self.week.text = [StorageUserInfromation weekFromDateString:_homePageData.daily_word_data.time];
    [self.myTableView reloadData];
    [_template_data removeAllObjects];
    [_template_data addObjectsFromArray:_homePageData.template_data];
    [ZTHttpTool sendGroupPostRequest:^{
        [self fetchTableListData:_homePageData.template_data];
    } success:^{
        [MBProgressHUD hideHUD];
        refreshflag = YES;
        _homePageData.template_data = _template_data;
        [self.myTableView reloadData];
        if ([self.myTableView numberOfRowsInSection:0]) {
            [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
        }
    } failure:^(NSArray *errorArray) {
        [MBProgressHUD hideHUD];
        refreshflag = YES;
        _homePageData.template_data = _template_data;
        [self.myTableView reloadData];
        if ([self.myTableView numberOfRowsInSection:0]) {
            [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
        }

    }];
//    [self fetchTableListData];
}
- (void)fetchTableListData:(NSMutableArray<Template_dataArr *> *)template_data{
    [_activity_Dict removeAllObjects];
    for (Template_dataArr *dict in template_data) {
        NSString *url = @"jujiahe/v1/activity/queryIndexActivityList";
        if ([dict.type isEqualToString:@"chat"]) {
            url = @"social/v1/public/linli";
        }
          NSDictionary *dicts = @{@"timestamp":[StorageUserInfromation dateTimeInterval],@"device":@"1",@"userId":[StorageUserInfromation storageUserInformation].userId,@"appTemplateId":dict.ids,@"apiv":@"1.0"};
        [ZTHttpTool postWithUrl:url param:dicts success:^(id responseObj) {
            NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
            NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
            NSLog(@"%@",onceDict);

            if ([onceDict[@"rcode"] integerValue] == 0) {
                if ([dict.type isEqualToString:@"roll"]) {
                    Activity_form *form = [Activity_form mj_objectWithKeyValues:str];
                    if (form.form.count) {
                        _activity_from_roll = form;
                    }else{
                        [_template_data removeObject:dict];
                    }
                }else if ([dict.type isEqualToString:@"list"]){
                    Activity_form *form = [Activity_form mj_objectWithKeyValues:str];
                    _activity_from_list = form;
                    if(form.form.count){
                        NSDictionary *dict2 = @{dict.goodsTypeId:form};
                        [_activity_Dict addEntriesFromDictionary:dict2];
                    }else{
                        [_template_data removeObject:dict];
                        
                    }
                  
                }else if ([dict.type isEqualToString:@"chat"]){
                    
                    NeighborhoodForm *form = [NeighborhoodForm mj_objectWithKeyValues:str];
                    if (form.form.count) {
                        _neighborhoodFormArr = form;
                    }else{
                        [_template_data removeObject:dict];

                    }
                }
                for (int i = 0; i< _homePageData.template_data.count;i++) {
                    if ([_homePageData.template_data[i] isEqual:dict]) {
                        NSIndexPath *index = [NSIndexPath indexPathForRow:i+1 inSection:0];
                        if (index.row < [self.myTableView numberOfRowsInSection:0]) {
                            [self.myTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
                        }
                    }
                }
            }

        } failure:^(NSError *error) {
            XMJLog(@"%@",error)
        }];
    }
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
//    self.navView.backgroundColor = RGBA(0xffffff, 1);
    UIImage *locationBtnImg = [UIImage imageNamed:@"home_icon_house"];
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
    _buildingNameLab.textColor = RGBA(0x303030, 1);
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
    [self.navView addSubview:_signBtn];
    [_signBtn addTarget:self action:@selector(signBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
//    UIImage *meassgeBtnImg = [UIImage imageNamed:@"home_icon_massage"];
//    width = meassgeBtnImg.size.width;
//    ox -= width;
//
//    _meassgeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _meassgeBtn.backgroundColor = [UIColor clearColor];
//    _meassgeBtn.frame = CGRectMake(ox, oy, width, height);
//    if (meassgeBtnImg) {
//        [_meassgeBtn setImage:meassgeBtnImg forState:UIControlStateNormal];
//    }
//
//    _meassgeBtn.userInteractionEnabled = YES;
//    _badgeView = [[JSBadgeView alloc] initWithParentView:_meassgeBtn alignment:JSBadgeViewAlignmentTopLeft];
//    [self messageUnreadBadge];
//    [self.navView addSubview:_meassgeBtn];
//    [_meassgeBtn addTarget:self action:@selector(meassgeBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)messageUnreadBadge{
    StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
    NSInteger num = storage.socialUnread.integerValue + storage.systemUnread.integerValue;
    _badgeView.badgeText = num == 0?@"":[NSString stringWithFormat:@"%ld",num];
//    [self fetchUnreadMessageCount];
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
            _badgeView.badgeText = num == 0?@"":[NSString stringWithFormat:@"%ld",num];
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
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
        
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];
        
        
        StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
        storage.choseUnitPropertyId = choseUnitPropertyId;
        storage.choseUnitName = choseUnitName;
        storage.cityNumber = cityNumber;
        storage.currentCity = currentCity;
        
        [NSKeyedArchiver archiveRootObject:storage toFile:file];
        [self fetchData];
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
    if([[StorageUserInfromation storageUserInformation].userId isEqualToString:@""]){
        UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:@"未登录" message:@"确定跳回登陆界面？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 10;
        [alert show];
    }else{
        MessageCenterVC * mcVC = [[MessageCenterVC alloc]init];
        [self.navigationController pushViewController:mcVC animated:YES];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {

    }else{
        LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.window.rootViewController =  [[UINavigationController alloc] initWithRootViewController:controller];
        
    }
}
- (void)setScrollView{
    _myScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-TABBARHEIGHT)];
    _myScollView.contentSize = CGSizeMake(SCREENWIDTH, (SCREENHEIGHT*2 - TABBARHEIGHT));
    _myScollView.pagingEnabled = YES;
    _myScollView.delegate = self;
    _myScollView.contentOffset = CGPointMake(0, SCREENHEIGHT-39);
    [self.view addSubview:_myScollView];
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT-TABBARHEIGHT)style:UITableViewStyleGrouped];

    _myTableView.backgroundView = nil;
    _myTableView.backgroundColor = [UIColor clearColor];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [_myScollView addSubview:_myTableView];
    [_myTableView registerNib:[UINib nibWithNibName:@"HomePageCell" bundle:nil] forCellReuseIdentifier:@"HomePageCell"];
//    UIImageView *img = [[UIImageView alloc]init];
//    img.image = [UIImage imageNamed:@"banner_pic"];
//    [headerView addSubview:img];
//    [img mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(headerView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.myScollView) {
        CGFloat f = scrollView.contentOffset.y;
        XMJLog(@"%0.2f",f);
        if (f<=TABBARHEIGHT) {
            self.tabBarController.tabBar.hidden = YES;
            self.navView.hidden = YES;
            self.myScollView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        }else{
            self.tabBarController.tabBar.hidden = NO;
            self.navView.hidden = NO;
            self.myScollView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-TABBARHEIGHT);
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
    mycell.propertyView.hidden = YES;
    mycell.dailySurpriseView.hidden = YES;
    mycell.flowView.hidden = YES;
    mycell.neighborhoodInteractionView.hidden = YES;
    mycell.alertView.hidden = YES;
    mycell.alertViewHeight.constant = 0;

    return mycell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger i = 0;
    if (_homePageData) {
        i++;
        i = i +_homePageData.template_data.count;
    }
//    if (_activity_from_list) {
//        i++;
//    }
//    if (_activity_from_roll) {
//        i++;
//    }
    return i;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        CGFloat f = 0;
        if (_homePageData) {
            if (_homePageData.menu_data) {
                f = 115;
            }
            if (_homePageData.broadcast_data) {
                f += 35;
            }
        }
        return f;
    }else{
        if (_homePageData) {
            if (_homePageData.template_data) {
                NSString * str = _homePageData.template_data[indexPath.row-1].type;
                if ([str isEqualToString:@"list"]) {
                    return 210;
                }else if ([str isEqualToString:@"roll"]){
                    return 190;
                }else if ([str isEqualToString:@"chat"]){
                    return 255;
                }else{
                    return 0;
                }
            }else{
                return 0;
            }
        }else{
            return 0;
        }
    }
    
    return 50;
    
}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    [MobClick event:@"sylb_c" label:[NSString stringWithFormat:@"%ld",index]];

    if (index == 0) {
      
        return;
    }
    Advertisement_dataArr *onceDict = _homePageData.advertisement_data.data[index-1];
    if ([onceDict.url isEqualToString:@""]|(!onceDict.url)|[onceDict.url isEqualToString:@"<null>"]) {
        return;
    }
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return _activity_from_roll.form.count;
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH-40, 170)];
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    
    if (_activity_from_roll.form.count>0) {
        //在这里下载网络图片
        [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:_activity_from_roll.form[index].icon] placeholderImage:[UIImage imageNamed:@""]options:SDWebImageAllowInvalidSSLCertificates];
    }
   
//    bannerView.mainImageView.image = self.imageArray[index];
    
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    NSLog(@"TestViewController 滚动到了第%ld页",pageNumber);
}
#pragma mark NewPagedFlowView Delegate
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    [MobClick event:@"adsy_c" label:[NSString stringWithFormat:@"%@",_activity_from_roll.form[subIndex].goodsId]];
    
    if ([_activity_from_roll.form[subIndex].file_type isEqualToString:@"interface"]) {
        if ([_activity_from_roll.form[subIndex].type isEqualToString:@"88888"]) {
            self.tabBarController.selectedIndex = 2;
           
            return;
        }
    }
    if ([JGIsBlankString isBlankString:_activity_from_roll.form[subIndex].url]) {
        return;
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
