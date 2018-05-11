//
//  FirstStepVerificationOfIdentityVC.h
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/7.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondStepVerificationOfIdentityVC.h"
@interface FirstStepVerificationOfIdentityVC : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHight;
@property (weak, nonatomic) IBOutlet UILabel *village;
@property (weak, nonatomic) IBOutlet UILabel *buildingName;
@property (weak, nonatomic) IBOutlet UILabel *unitName;
@property (weak, nonatomic) IBOutlet UILabel *flourName;
@property (weak, nonatomic) IBOutlet UILabel *roomNum;

@property (weak, nonatomic) IBOutlet UITextField *tips;
@property (weak, nonatomic) IBOutlet UIButton *nextStep;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic,assign)Identity identity;

@property (nonatomic,copy)NSString *unitId;
@property (nonatomic,copy)NSString *propertyId;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)nextStepBtnClick:(id)sender;
- (IBAction)choseBtnClick:(id)sender;
@end
