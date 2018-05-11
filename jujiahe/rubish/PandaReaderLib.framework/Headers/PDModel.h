//
//  PDModel.h
//  PandaReaderSDK
//
//  Created by changle on 2017/7/18.
//  Copyright © 2017年 hongli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDCommonInfo : NSObject

/**
 sdk名字：会显示在书城首页导航栏上面，默认是“熊猫看书”
 */
@property (nonatomic, copy) NSString *globalTitle;


/**
 UI主色调: 传入十六进制色值且不支持ffffff，且默认值是@"#3CB371"
 */
@property (nonatomic, copy) NSString *globalColor;

/**
 导航栏UI主色调: 且默认值是@"#3CB371"（提供这个字段目的是防止导航栏和UI主色调不一样的情况）
 */
@property (nonatomic, copy) NSString *navigationBarColor;

/* 
 * 导航栏字体颜色黑白选择: 默认是白色#ffffff ，只提供黑白选择(提供这个字段的目的是防止导航栏和UI主色调不一样的时候，导致导航栏和字体颜色重复看不见)
 */
@property (nonatomic) BOOL  blackFont;

/**
 首页菜单栏位置: 默认是NO放在NavigationBar下面，YES即此菜单栏替代NavigationBar的位置
 */
@property (nonatomic) BOOL topHomeMenu;

@end


@interface PDUser : NSObject

@property (nonatomic, copy) NSString *thridUserId; // 第三方用户ID
@property (nonatomic, copy) NSString *nick; //  第三方昵称

@property (nonatomic, copy) NSString *oauthkey; //  验证签名信息，sdk绑定后提供给第三方的，第三方需要做存储下次接口传给sdk
@property (nonatomic, copy) NSString *purchaseId; // 购买产品ID，用于sdk购买成功后回调给第三方用，其他情况无用处可以不传活传空，暂时预留


- (instancetype)initWithUser:(PDUser *)user;

@end
