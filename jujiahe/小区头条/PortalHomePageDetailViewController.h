//
//  PortalHomePageDetailViewController.h
//  copooo
//
//  Created by XiaMingjiang on 2017/11/27.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProtalHomePageDataModel.h"
@interface PortalHomePageDetailViewController : UIViewController
@property (nonatomic,strong) ProtalHomePageDataList * onceList;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
- (IBAction)backBtnClick:(id)sender;
@end
