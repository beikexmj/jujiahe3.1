//
//  PandaReaderLib.h
//  PandaReaderSDK
//
//  Created by changle on 2017/7/10.
//  Copyright © 2017年 hongli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDConstants.h"
#import "PDError.h"
#import "PDModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PandaReaderDelegate <NSObject>

/**
 阅读器充值成功，每次充值成功都会回调该方法

 @param info 当前登录的用户信息，包括产品ID
 */
- (void)pandaReaderRechargeCompletedWithInfo:(PDUser *)info;


/**
 阅读器在未登录的情况下，触发某些必须登录才能执行的操作时，会请求接入方让用户完成登录
 */
- (void)pandaReaderRequestLogin;


@end


@interface PandaReaderLib : NSObject


/**
 向SDK注册相关信息，应该在app启动时调用

 @param commonInfo SDK所需的外界信息
 @param delegate 用来监听SDK对外界的回调
 */
+ (void)registerCommonInfo:(PDCommonInfo *)commonInfo delegate:(id<PandaReaderDelegate>)delegate;


+ (UIViewController *)homePageWithNavigationController:(UINavigationController *)navigationController;


/**
 创建新的SDK入口控制器

 @param navigationController 接入方提供的导航控制器，weak引用，sdk不做强引用
 @param forceHideBackButton 是否强制隐藏首页导航栏的返回按钮；如果非强制，会根据是否处于导航的根控制器来隐藏或显示返回按钮
 @param bottomBarHeight SDK首页会根据bottomBarHeight调整自身内容高度
 */
+ (UIViewController *)homePageWithNavigationController:(UINavigationController *)navigationController forceHideBackButton:(BOOL)forceHideBackButton bottomBarHeight:(CGFloat)bottomBarHeight;


/**
 SDK模块内登录
 
 @param user 接入方用户信息：
    user.thridUserId必传；
    user.nick可选；
    user.oauthkey初次登录不传，以后登录必传
 @param block 登录结果回调
    登录成功后拿到user.oauthkey时，接入方应该存储这个值，用于该用户再次登录
 */
+ (void)loginWithUserID:(PDUser *)user block:(PDLoginBlock)block;


/**
 SDK模块内退出登录
 
 @param user 接入方用户信息：
 user.thridUserId必传；
 user.nick可选；
 user.oauthkey有就就传，没有就不传
 @param block 登录结果回调
 */
+ (void)loginOutWithUserID:(PDUser *)user block:(PDLoginOutBlock)block;


#pragma mark - not available

+ (instancetype)alloc __attribute__((unavailable("alloc not available, call class method instead")));
- (instancetype)init __attribute__((unavailable("init not available, call class method instead")));
+ (instancetype)new __attribute__((unavailable("new not available, call class method instead")));

@end


NS_ASSUME_NONNULL_END
