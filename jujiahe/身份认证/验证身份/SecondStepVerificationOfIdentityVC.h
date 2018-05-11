//
//  SecondStepVerificationOfIdentityVC.h
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/7.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, Identity)
{
    Owner = 0,
    Tenant,
    FamilyMembers,
};

@interface SecondStepVerificationOfIdentityVC : UIViewController

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHight;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *village;
@property (nonatomic,assign)Identity identity;
- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;
- (IBAction)nextSetpBtnClick:(id)sender;
@end
