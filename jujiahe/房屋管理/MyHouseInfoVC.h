//
//  MyHouseInfoVC.h
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/8.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHouseInfoVC : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *myIdentity;

@property (weak, nonatomic) IBOutlet UILabel *village;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHight;
- (IBAction)backBtnClick:(id)sender;
@end
