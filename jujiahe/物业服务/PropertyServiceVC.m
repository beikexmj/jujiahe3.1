//
//  AllServiceVC.m
//  copooo
//
//  Created by XiaMingjiang on 2018/3/7.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "PropertyServiceVC.h"
#import "AllServiceDataModel.h"
#import "JSBadgeView.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "ServiceVC.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "SDCycleScrollView.h"
#import "CCPScrollView.h"
#import "QueryLogisticsVC.h"
#import "PropertyPaymentVC.h"
@interface PropertyServiceVC ()<SDCycleScrollViewDelegate>
{
    CCPScrollView *ccpScrollView;
}
@property (nonatomic,strong)UIScrollView *myScrollView;
@property (nonatomic,strong) NSArray <AllServiceArr*> *myArr;
@end

@implementation PropertyServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowNav = YES;
    self.titleLabel.text = @"物业服务";
    self.navView.backgroundColor = RGBA(0xeeeeee, 1);
    [self.view addSubview:self.myScrollView];
//    [self rebuildView];
    [self fetchData];
    // Do any additional setup after loading the view.
}
- (UIScrollView *)myScrollView{
    if (!_myScrollView) {
        _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT)];
        _myScrollView.showsVerticalScrollIndicator = NO;
    }
    return _myScrollView;
}
- (void)fetchData{
    NSDictionary *dict = @{@"apiv":@"1.0",@"propertyAreaId":@"1c265c5b5a3741cca88ace5dac48a6ef"};
    [ZTHttpTool postWithUrl:@"jujiahe/v1/serviceMenu/infos" param:dict success:^(id responseObj) {
        NSString * str = [JGEncrypt encryptWithContent:[responseObj mj_JSONObject][@"data"] type:kCCDecrypt key:KEY];
        NSDictionary * onceDict = [DictToJson dictionaryWithJsonString:str];
        NSLog(@"%@",onceDict);
        AllServiceDataModel *data = [AllServiceDataModel mj_objectWithKeyValues:str];
        if (data.rcode == 0) {
            _myArr = data.form;
            if (_myArr.count>0) {
                [self rebuildView];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)rebuildView{
    CGFloat sectionY = 0;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, sectionY + 10, 5, 15)];
    lineView.backgroundColor  = RGBA(0x00a7ff, 1);
    [self.myScrollView addSubview:lineView];
    UILabel *markTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, sectionY + 10, 100, 15)];
    markTitle.textColor = RGBA(0x303030, 1);
    markTitle.font = [UIFont systemFontOfSize:16.0];
    markTitle.text = @"生活话题";
    [self.myScrollView  addSubview:markTitle];
    
    UILabel *moreClassification = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH - 130, sectionY + 10, 100, 15)];
    moreClassification.textColor = RGBA(0x606060, 1);
    moreClassification.font = [UIFont systemFontOfSize:14.0];
    moreClassification.text = @"查看更多";
    moreClassification.textAlignment = NSTextAlignmentRight;
    [self.myScrollView  addSubview:moreClassification];
    
    UIImageView *rightMarkImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH - 20, sectionY + 10  + 2.5, 6, 10)];
    rightMarkImg.image = [UIImage imageNamed:@"icon_more_gray"];
    [self.myScrollView addSubview:rightMarkImg];
    
    UIButton *moreClassificationBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, sectionY + 10, SCREENWIDTH, 15.0)];
    [moreClassificationBtn addTarget:self action:@selector(moreClassificationbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.myScrollView addSubview:moreClassificationBtn];
    
    sectionY += 20 + 15;
    
    CGFloat picHight = (SCREENWIDTH- 30)*(8/15.0);
    NSArray * myArr = @[@"home_btn_menjin",@"home_btn_menjin",@"home_btn_menjin"];
   
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(15, sectionY, SCREENWIDTH-30, picHight) imagesGroup:myArr advertisement_data:nil];
    cycleScrollView.delegate = self;
    [self.myScrollView addSubview:cycleScrollView];
    sectionY += picHight + 20;
    UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake(15, sectionY, SCREENWIDTH - 30, 35)];
    alertView.backgroundColor = RGBA(0xf6f6f6, 1);
    alertView.layer.cornerRadius = 5;
    alertView.layer.borderColor = RGBA(0xdddddd, 1).CGColor;
    alertView.layer.borderWidth = 1;
    alertView.layer.masksToBounds = YES;
    
    UIImageView *alertImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 5, 20, 25)];
    alertImage.image = [UIImage imageNamed:@"home_icon_announcement"];
    [alertView addSubview:alertImage];
    
    UIView *alertLineView1 = [[UIView alloc]initWithFrame:CGRectMake(42, 3, 1, 29)];
    alertLineView1.backgroundColor = RGBA(0xdddddd, 1);
    [alertView addSubview:alertLineView1];
    
    UIView *alertLineView2 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH - 30 - 42, 3, 1, 29)];
    alertLineView2.backgroundColor = RGBA(0xdddddd, 1);
    [alertView addSubview:alertLineView2];
    
    UIButton *seeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH - 30 - 42, 0, 42, 35)];
    [seeBtn setTitleColor:RGBA(0x303030, 1) forState:UIControlStateNormal];
    [seeBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [seeBtn setTitle:@"查看" forState:UIControlStateNormal];
    [seeBtn addTarget:self action:@selector(seeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:seeBtn];
    
    ccpScrollView = [[CCPScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH - 115, 35)];
    ccpScrollView.titleFont = 13;
    ccpScrollView.titleColor = RGBA(0x303030, 1);
    ccpScrollView.BGColor = [UIColor clearColor];
    [alertView addSubview:ccpScrollView];
    
    NSArray * arr = @[@"sfesdfds",@"sdfs34535tewtwe",@"34534634645"];
   
    ccpScrollView.titleArray = arr;
    ccpScrollView.titleFont = 13;
    ccpScrollView.titleColor = RGBA(0x303030, 1);
    [ccpScrollView clickTitleLabel:^(NSInteger index,NSString *titleString) {
        NSLog(@"%ld-----%@",index,titleString);
    }];
    [self.myScrollView addSubview:alertView];
    sectionY += 35 + 20;
    
    for (int i = 0; i<_myArr.count; i++) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, sectionY + 30, 5, 15)];
        lineView.backgroundColor = RGBA(0x00a7ff, 1);
        [self.myScrollView addSubview:lineView];
        
        UILabel *typeName = [[UILabel alloc]initWithFrame:CGRectMake(15, sectionY + 25, 150, 25)];
        typeName.font = [UIFont systemFontOfSize:15.0];
        typeName.textColor = RGBA(0x303030, 1);
        typeName.text = _myArr[i].name;
        [self.myScrollView addSubview:typeName];
        CGFloat yy = sectionY + 40;
        for (int j = 0; j<_myArr[i].data.count/4 +(_myArr[i].data.count%4 ==0?0:1); j++) {
            for (int k = 0; k<4; k++) {
                if (j*4 + (k+1)>_myArr[i].data.count) {
                    continue;
                }
                
                UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(k*(SCREENWIDTH/4.0), yy, SCREENWIDTH/4.0, 110)];
                
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, SCREENWIDTH/4.0, 20)];
                nameLabel.text = _myArr[i].data[j*4 +k].name;
                nameLabel.font = [UIFont systemFontOfSize:13.0];
                nameLabel.textColor = RGBA(0x606060, 1);
                nameLabel.textAlignment =NSTextAlignmentCenter;
                [myView addSubview:nameLabel];
                
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH/4.0 - 55)/2.0, 20, 55, 55)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:_myArr[i].data[j*4 + k].icon] placeholderImage:[UIImage imageNamed:@"icon_默认"] options:SDWebImageAllowInvalidSSLCertificates];
                [myView addSubview:imageView];
                
                UIButton  *btn = [[UIButton alloc]initWithFrame:CGRectMake( 0 , 0 , SCREENWIDTH/4.0, 100)];
//                [btn sd_setImageWithURL:[NSURL URLWithString:_myArr[i].data[j*3 + k].icon] forState:UIControlStateNormal];
                btn.tag = j*4 + (k+1) + i*100;
//                btn.imageEdgeInsets = UIEdgeInsetsMake(-15, 15, 100- ((SCREENWIDTH - 30*2)/3.0 - 30)+15 , 15);
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [myView addSubview:btn];
                
                if (_myArr[i].data[j*4 +k].hot == 1) {
                    JSBadgeView *bage = [[JSBadgeView alloc]initWithParentView:btn alignment:JSBadgeViewAlignmentTopCenter];
                    bage.layer.borderColor = RGBA(0xffffff, 1).CGColor;
                    bage.layer.borderWidth = 1;
                    bage.layer.cornerRadius = 5;
                    bage.layer.masksToBounds = YES;
                    bage.badgeText = @"HOT";
                }
                
                [self.myScrollView addSubview:myView];
            }
            yy = yy + 110;
        }
        sectionY = sectionY + (_myArr[i].data.count/4 +(_myArr[i].data.count%4 ==0?0:1))*110 + 20;
    }
    
    UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, sectionY + 20, SCREENWIDTH - 30, (SCREENWIDTH - 30)*(180/700.0))];
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"组-1"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    sectionY += (SCREENWIDTH - 30)*(180/700.0) + 20 + 60;
    [self.myScrollView addSubview:moreBtn];
    
    self.myScrollView.contentSize = CGSizeMake(SCREENWIDTH, sectionY);
}
- (void)moreBtnClick:(UIButton *)btn{
    
}
- (void)btnClick:(UIButton *)btn{
    
    
    
//    if([[StorageUserInfromation storageUserInformation].userId isEqualToString:@""]){
//        UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:@"未登录" message:@"确定跳回登录界面？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alert show];
//        return;
//    }
    
    NSInteger section = btn.tag/100;
    NSInteger row = btn.tag%100;
    AllServiceDict *dict = _myArr[section].data[row-1];
    NSString *name = dict.name;
    if ([name isEqualToString:@"呼叫物管"]) {
        
    }else if ([name isEqualToString:@"生活缴费"]) {
        
    }else if ([name isEqualToString:@"开水开电"]) {
        
    }else if ([name isEqualToString:@"社区报事"]) {
        
    }else if ([name isEqualToString:@"代收包裹"]) {
        
    }else if ([name isEqualToString:@"缴物管费"]) {
        PropertyPaymentVC *page = [[PropertyPaymentVC alloc]init];
        page.propertyHouseId = dict.ids;
        [self.navigationController pushViewController:page animated:YES];
    }else if ([name isEqualToString:@"园区保修"]) {
        
    }else if ([name isEqualToString:@"秩序维护"]) {
        
    }else if ([name isEqualToString:@"户内保修"]) {
        
    }else if ([name isEqualToString:@"关于物业"]) {
        
    }else if ([name isEqualToString:@"开门"]) {
        
    }else if ([name isEqualToString:@"缴费大厅"]) {
        
    }else if ([name isEqualToString:@"清洁"]) {
        
    }else if ([name isEqualToString:@"教育"]) {
        
    }else if ([name isEqualToString:@"维护"]) {
        
    }else if ([name isEqualToString:@"代办"]) {
        
    }
   
    if ([dict.type isEqualToString:@"7"]) {
        return;
    }else if ([dict.type isEqualToString:@"6"]){
       
        return;
    }
    if (dict.type.integerValue == 8 | dict.type.integerValue == 9 |dict.type.integerValue == 10 |dict.type.integerValue == 11 |dict.type.integerValue == 12) {
        ServiceVC *page = [[ServiceVC alloc]init];
        page.titleStr = name;
        if (!dict.ids) {
            return;
        }
        page.menuId = dict.ids;
        [self.navigationController pushViewController:page animated:YES];
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
- (void)moreClassificationbtnClick:(UIButton *)btn{
    QueryLogisticsVC *vc = [[QueryLogisticsVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    [MobClick event:@"sqlb_c" label:[NSString stringWithFormat:@"%ld",index]];
}
- (void)seeBtnClick:(UIButton *)btn{
    NSInteger i = ccpScrollView.ccpScrollView.contentOffset.y/35 -1;
    if (i<0) {
        i = ccpScrollView.titleArray.count-1;
    }
    XMJLog(@"broadCarst == %ld",i);
    [MobClick event:@"ntlb_c" label:[NSString stringWithFormat:@"%ld",i+1]];
    
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
