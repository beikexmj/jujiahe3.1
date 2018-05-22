//
//  AppDelegate.h
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/7.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

static NSString *appKey = @"f4c05efcf4f635adfc6b4822";//极光推送
static NSString *channel = @"jjh_push_distribution";//
static BOOL isProduction = YES;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,copy)NSString *registrationID;

+ (AppDelegate *) app;
@end

