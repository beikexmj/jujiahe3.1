//
//  MyHouseInfoVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/8.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "MyHouseInfoVC.h"
#import "NSString+ZF.h"

@interface MyHouseInfoVC ()

@end

@implementation MyHouseInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navHight.constant = NAVHEIGHT;
    self.backViewHight.constant = 200 - 64 + NAVHEIGHT;
    StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
    _city.text = storage.currentCity;
    _village.text = storage.choseUnitName;
    
    [self backViewColor];
    [self viewconfig];
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
-(void)viewconfig{
    UIScrollView *myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 200 - 64 + NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT - (200 - 64 + NAVHEIGHT))];
    [self.view addSubview:myScrollView];
    CGFloat height = 0;
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, SCREENWIDTH - 30, 30)];
    nameLabel.textColor = RGBA(0x606060, 1);
    nameLabel.font = [UIFont systemFontOfSize:14.0];
    nameLabel.text = @"其他已认证成员";
    [myScrollView addSubview:nameLabel];
    height = 30 + 15 + 15;
    
    for (int i = 0; i<3; i++) {
        UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, height, SCREENWIDTH, 40)];
        myView.backgroundColor = RGBA(0xffffff, 1);
        UILabel *identityName = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 60, 40)];
        identityName.textColor = RGBA(0x303030, 1);
        identityName.font = [UIFont systemFontOfSize:16.0];
        identityName.text = @"家属";
        [myView addSubview:identityName];
        
        UILabel *memberName = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, 90, 40)];
        memberName.textColor = RGBA(0x303030, 1);
        memberName.font = [UIFont systemFontOfSize:16.0];
        memberName.text = @"张雪梅";
        
        NSString * str = memberName.text;
        if (str.length == 2) {
            str = [memberName.text replaceStringWithAsterisk:1 length: memberName.text.length-1];
        }else if (memberName.text.length > 2){
            str = [memberName.text replaceStringWithAsterisk:1 length: memberName.text.length-2];
        }
        memberName.text = str;
        
        [myView addSubview:memberName];
        
        
        UILabel *telphone = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH - 150, 0, 130, 40)];
        telphone.textColor = RGBA(0x303030, 1);
        telphone.textAlignment = NSTextAlignmentRight;
        telphone.font = [UIFont systemFontOfSize:16.0];
        telphone.text = @"18580465179";
        [myView addSubview:telphone];
        
        height += 50;
        [myScrollView addSubview:myView];
        
    }
    
    myScrollView.contentSize = CGSizeMake(SCREENWIDTH, height);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
