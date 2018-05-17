//
//  EstablishCircleVC.h
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/17.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>
/*!
 @abstract 发布类型
 @constant PUBLISH_PHOTOANDTEXT  图文
 @constant PUBLISH_VIDEO  视频
 */
typedef NS_ENUM(NSUInteger, PUBLISH_TYPE) {
    PUBLISH_PHOTOANDTEXT,
    PUBLISH_VIDEO
};
@interface EstablishCircleVC : BaseViewController
@property (nonatomic,assign)PUBLISH_TYPE publishType;

@property (nonatomic,strong)void (^publichBlock)(void);

@property (strong, nonatomic)UIButton *publishBtn;

@end
