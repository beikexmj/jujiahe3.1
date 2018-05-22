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
#import "BMKConfiguration.h"

@interface AppDelegate ()

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
    
    [BMKConfiguration sharedInstance];
    
    SDWebImageDownloader *sdmanager = [SDWebImageManager sharedManager].imageDownloader;
    [sdmanager setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [sdmanager setValue:@"zh-CN,zh;q=0.8,en;q=0.6,zh-TW;q=0.4" forHTTPHeaderField:@"Accept-Language"];
#if 0
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
#else
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
#endif
    return YES;
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

@end
