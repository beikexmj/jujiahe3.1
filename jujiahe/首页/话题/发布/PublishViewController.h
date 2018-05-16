//
//  PublishViewController.h
//  copooo
//
//  Created by XiaMingjiang on 2017/10/27.
//  Copyright © 2017年 夏明江. All rights reserved.
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
@interface PublishViewController : UIViewController
@property (nonatomic,assign)PUBLISH_TYPE publishType;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)pulishBtnClick:(id)sender;
@property (nonatomic,strong)void (^publichBlock)();
@end
