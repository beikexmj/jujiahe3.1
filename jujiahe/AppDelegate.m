//
//  AppDelegate.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/7.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "JFCityViewController.h"
#import "BaseTabbarVC.h"
//微信SDK头文件
#import "WXApi.h"
//以下是微信SDK的依赖库：
//libsqlite3.dylib
#import <AlipaySDK/AlipaySDK.h>
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#import <UserNotifications/UserNotifications.h>  // Push组件必须的系统库
#import "LaunchIntroductionView.h"
#import "EBForeNotification.h"
@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate>{
    BMKMapManager* _mapManager;
}

@end

@implementation AppDelegate

#pragma mark 静态
static AppDelegate *_appDelegate;
//return app;
//================================================================================
+ (AppDelegate *) app
{
    return _appDelegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _appDelegate = self;
    // Override point for customization after application launch.
    LoginViewController *cityViewController = [[LoginViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:cityViewController];
    [self.window makeKeyAndVisible];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    SDWebImageDownloader *sdmanager = [SDWebImageManager sharedManager].imageDownloader;
    [sdmanager setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [sdmanager setValue:@"zh-CN,zh;q=0.8,en;q=0.6,zh-TW;q=0.4" forHTTPHeaderField:@"Accept-Language"];
    if (![StorageUserInfromation storageUserInformation].choseUnitPropertyId || [[StorageUserInfromation storageUserInformation].choseUnitPropertyId isEqualToString:@""]) {
        JFCityViewController *cityViewController = [[JFCityViewController alloc] init];
        cityViewController.title = @"选择城市";
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:cityViewController];
    }else{
        NSLog(@"%@",[StorageUserInfromation storageUserInformation].userId);
        if (![StorageUserInfromation storageUserInformation].userId || [[StorageUserInfromation storageUserInformation].userId  isEqual:@""]) {
            StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
            storage.userId = @"";
            storage.token = @"";
            storage.access_token = @"";
            storage.uuid = @"";
        }
        BaseTabbarVC *tabBarController = [BaseTabbarVC Shareinstance];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tabBarController];
        nav.fd_fullscreenPopGestureRecognizer.enabled = true;
        nav.fd_prefersNavigationBarHidden = true;
        nav.fd_interactivePopDisabled = true;
        nav.fd_viewControllerBasedNavigationBarAppearanceEnabled = false;
        [nav setNavigationBarHidden:YES animated:YES];
        tabBarController.selectedIndex = 0;
        self.window.rootViewController = nav;
    }
    [self setJPush:launchOptions];
    [self setBaiDuMapManager];
    [WXApi registerApp:@"wx74a28fcbd5e80775"];
     [LaunchIntroductionView sharedWithImages:@[@"引导页1",@"引导页2",@"引导页3"]];
    return YES;
}
- (void)setJPush:(NSDictionary *)launchOptions{
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        if (@available(iOS 10.0, *)) {
            entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        } else {
            // Fallback on earlier versions
        }
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
#ifdef NSFoundationVersionNumber_iOS_8_x_Max
        
#else
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
#endif
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            _registrationID = registrationID;
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    [JPUSHService crashLogON];
}
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        [EBForeNotification handleRemoteNotification:userInfo soundID:1312 isIos10:YES];
    }else{
        [EBForeNotification handleRemoteNotification:userInfo soundID:1312 isIos10:NO];
    }
    
    NSLog(@"收到自定义消息:%@", [self logDic:userInfo]);
    
    //    [HomePageViewController addNotificationCount];
    
    
}
#pragma mark - 判断是不是首次登录或者版本更新
-(BOOL )isFirstLauch{
    //获取当前版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentAppVersion = infoDic[@"CFBundleShortVersionString"];
    //获取上次启动应用保存的appVersion
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"appVersion"];
    //版本升级或首次登录
    if (version == nil || ![version isEqualToString:currentAppVersion]) {
        [[NSUserDefaults standardUserDefaults] setObject:currentAppVersion forKey:@"appVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }else{
        return NO;
    }
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]|[url.host isEqualToString:@"platformapi"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [MBProgressHUD hideHUD];
            if ([resultDic[@"resultStatus"] integerValue] == 9000) {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"支付成功" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                alert.tag = 10;
                [alert show];
            }else{
                [MBProgressHUD showError:@"支付失败！"];
            }
            
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        
    }else if ([url.host isEqualToString:@"pay"]){
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]|[url.host isEqualToString:@"platformapi"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [MBProgressHUD hideHUD];
            if ([resultDic[@"resultStatus"] integerValue] == 9000) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"支付成功" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                alert.tag = 10;
                [alert show];
            }else{
                [MBProgressHUD showError:@"支付失败！"];
            }
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }else if ([url.host isEqualToString:@"pay"]){
        return  [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}
//前面的两个方法被iOS9弃用了，如果是Xcode7.2网上的话会出现无法进入进入微信的onResp回调方法，就是这个原因。本来我是不想写着两个旧方法的，但是一看官方的demo上写的这两个，我就也写了。。。。

//9.0前的方法，为了适配低版本 保留
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if ([url.host isEqualToString:@"safepay"]) {
        return YES;
    }else if ([url.host isEqualToString:@"pay"]){
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}


//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法,显示支付结果的
-(void) onResp:(BaseResp*)resp
{
    //启动微信支付的response
    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    XMJLog(@"%@",payResoult);
    
    //    if([resp isKindOfClass:[PayResp class]]){
    //支付返回结果，实际支付结果需要去微信服务器端查询
    switch (resp.errCode) {
        case 0:
            payResoult = @"支付结果：成功！";
            break;
        case -1:
            payResoult = @"支付结果：失败！";
            break;
        case -2:
            payResoult = @"用户已经退出支付！";
            break;
        default:
            payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
            break;
    }
    //    }
    XMJLog(@"%@",payResoult);
}

-(void)setBaiDuMapManager{
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"RAaLGZQsUgxzfQ4aH8It6Gpvbygz4AST"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListWithData:tempData
                                              options:NSPropertyListImmutable
                                               format:NULL
                                                error:NULL];
    return str;
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    } // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

@end
