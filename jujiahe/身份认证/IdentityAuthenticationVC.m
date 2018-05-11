//
//  IdentityAuthenticationVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/7.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "IdentityAuthenticationVC.h"
#import "JFCityViewController.h"
#import "AppDelegate.h"
#import "FirstStepVerificationOfIdentityVC.h"
#import "HouseManagerVC.h"
#import "PropertyServiceVC.h"
#import "AreaHeadlineVC.h"
#import "SatisfactionSurveyVC.h"
//#import <PandaReaderLib/PandaReaderLib.h>
@interface IdentityAuthenticationVC ()

@end

@implementation IdentityAuthenticationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navHight.constant = NAVHEIGHT;
    self.backViewHight.constant = 200 - 64 + NAVHEIGHT;
    self.modifyInfoBtn.layer.cornerRadius = 3;
    self.modifyInfoBtn.layer.masksToBounds = YES;
    
    StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
    
    _city.text = storage.currentCity;
    _village.text = storage.choseUnitName;
    
    [self backViewColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyUnitName:) name:@"modifyUnitName" object:nil];
    // Do any additional setup after loading the view from its nib.
}
- (void)backViewColor{
    //实现背景渐变
    
    //初始化我们需要改变背景色的UIView，并添加在视图上
    
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, SCREENWIDTH, 200 - 64 + NAVHEIGHT);

    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.backView.layer insertSublayer:gradientLayer atIndex:0];
    //设置渐变区域的起始和终止位置（范围为0-1）
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    //设置颜色数组
    gradientLayer.colors = @[(__bridge id)RGBA(0x00a7ff, 1).CGColor,
                                  (__bridge id)RGBA(0x1392f4, 1).CGColor];
    
    //设置颜色分割点（范围：0-1）
    gradientLayer.locations = @[@(0.0f), @(1.0f)];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    

}
- (void)modifyUnitName:(NSNotification *)notify{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
    if ([defaults objectForKey:@"currentCity"]) {
        storage.currentCity = [defaults objectForKey:@"currentCity"];
    }
    
    if ([defaults objectForKey:@"cityNumber"]) {
        storage.cityNumber = [defaults objectForKey:@"cityNumber"];
    }
    if ([defaults objectForKey:@"choseUnitPropertyId"]) {
        storage.choseUnitPropertyId = [defaults objectForKey:@"choseUnitPropertyId"];
    }
    if ([defaults objectForKey:@"choseUnitName"]) {
        storage.choseUnitName = [defaults objectForKey:@"choseUnitName"];
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:@"storageUserInformation.data"];
        [NSKeyedArchiver archiveRootObject:storage toFile:file];
    }
    _city.text = storage.currentCity;
    _village.text = storage.choseUnitName;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)modifyInfoBtnClick:(id)sender {
    JFCityViewController *cityViewController = [[JFCityViewController alloc] init];
    cityViewController.title = @"选择城市";
    cityViewController.comFromFlag = @"3";
    [self.navigationController pushViewController:cityViewController animated:YES];
}

- (IBAction)indentifyChoseBtnClick:(id)sender {
    UIButton *btn = sender;
    FirstStepVerificationOfIdentityVC *page = [[FirstStepVerificationOfIdentityVC alloc]init];
    if (btn.tag == 10) {
        page.identity = Owner;
    }else if (btn.tag == 20){
        page.identity = Tenant;
    }else if (btn.tag == 30){
        page.identity = FamilyMembers;
    }
    page.unitId = [StorageUserInfromation storageUserInformation].choseUnitPropertyId;
    [self.navigationController pushViewController:page animated:YES];
}

- (IBAction)slipAwayBtnClick:(id)sender {
//    [[WaringAlertView shareInstance] openAlterViewtitle:@"124324" content:@"2465467您好您好啊您好您好啊您好您好啊您好您好啊您好您好啊您好您好啊您好您好啊您好您好啊您好您好啊您好您好啊您好您好啊" buttonTitle:@"确定" actionBlock:^{
//
//    }];
//    [[MyAlterView shareInstance] openAlterViewType:MyAlterViewHighTypeRight title:@"41411" content:@"4554454551125" left:@"取消" right:@"确认" selectBlock:^(NSInteger index) {
//
//    }];
    
    SatisfactionSurveyVC *page = [[SatisfactionSurveyVC alloc]init];
    [self.navigationController pushViewController:page animated:YES];
//    PDUser *pdUser = [[PDUser alloc]init];
//    pdUser.thridUserId = [StorageUserInfromation storageUserInformation].userId;
//    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"oathKey"]) {
//        pdUser.oauthkey = [[NSUserDefaults standardUserDefaults] valueForKey:@"oathKey"];
//    }
//    [PandaReaderLib loginWithUserID:pdUser block:^(PDUser * _Nullable user, PDError * _Nullable error) {
//        [[NSUserDefaults standardUserDefaults] setValue:user.oauthkey forKey:@"oathKey"];
//        UIViewController *pdViewController = [PandaReaderLib homePageWithNavigationController:self.navigationController];
//        [self.navigationController pushViewController:pdViewController animated:YES];
//    }];
}
@end
