//
//  peopleIMView.m
//  jujiahe
//
//  Created by 刘欣 on 2018/5/21.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "peopleIMView.h"
//系统版本号是否大于8.0
#define IS_SystemVersionGreaterThanEight  ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0)

@implementation peopleIMView

- (void)awakeFromNib{
    [super awakeFromNib];
    //添加手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
    //将手势添加到需要相应的view中去
    [_grayView addGestureRecognizer:tapGesture];
    
    _peopleImage.layer.masksToBounds=YES;
    _peopleImage.layer.cornerRadius=25;
    
    _contactBtn.layer.cornerRadius=19;
    [_contactBtn.layer setBorderWidth:1.0];
    _contactBtn.layer.borderColor=ColorWithHexString(@"#00A7FF").CGColor;
    _navBtn.layer.cornerRadius=19;
    
    
}

- (void)event:(UITapGestureRecognizer *)gesture{
    [self removeFromSuperview];
}

- (IBAction)contactClick:(UIButton *)sender {
    NSLog(@"%@",_phonenumber);
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_phonenumber];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self addSubview:callWebview];
    
}

/**
 *  获取父视图的控制器
 *
 *  @return 父视图的控制器
 */
- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (IBAction)navClick:(UIButton *)sender {
    NSLog(@"%f-----%f",self.coordinate.latitude,self.coordinate.longitude);
    //系统版本高于8.0，使用UIAlertController
    if (IS_SystemVersionGreaterThanEight) {
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"导航到设备" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        //自带地图
        [alertController addAction:[UIAlertAction actionWithTitle:@"自带地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 自带地图");
            
            //使用自带地图导航
            MKMapItem *currentLocation =[MKMapItem mapItemForCurrentLocation];
            
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:nil]];
            
            [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
            
        }]];
        
        //判断是否安装了高德地图，如果安装了高德地图，则使用高德地图导航
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSLog(@"alertController -- 高德地图");
                NSString *urlsting =[[NSString stringWithFormat:@"iosamap://navi?sourceApplication= &backScheme= &lat=%f&lon=%f&dev=0&style=2",self.coordinate.latitude,self.coordinate.longitude]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:urlsting]];
                
            }]];
        }
        
        //判断是否安装了百度地图，如果安装了百度地图，则使用百度地图导航
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
            [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSLog(@"alertController -- 百度地图");
                NSString *urlsting =[[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",self.coordinate.latitude,self.coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
                
            }]];
        }
        
        //添加取消选项
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [alertController dismissViewControllerAnimated:YES completion:nil];
            
        }]];
        
        //显示alertController
        [[self viewController] presentViewController:alertController animated:YES completion:nil];
        
    }
    else {  //系统版本低于8.0，则使用UIActionSheet
        
        UIActionSheet * actionsheet = [[UIActionSheet alloc] initWithTitle:@"导航到设备" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"自带地图", nil];
        
        //如果安装高德地图，则添加高德地图选项
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
            
            [actionsheet addButtonWithTitle:@"高德地图"];
            
        }
        
        //如果安装百度地图，则添加百度地图选项
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
            
            [actionsheet addButtonWithTitle:@"百度地图"];
        }
        
        [actionsheet showInView:self];
        
        
    }
    

}

@end
