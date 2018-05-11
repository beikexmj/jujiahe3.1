//
//  PortalHomePageViewController.h
//  copooo
//
//  Created by XiaMingjiang on 2017/11/14.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PortalHomePageViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *guidongNews;
@property (weak, nonatomic) IBOutlet UIButton *elecRules;
@property (weak, nonatomic) IBOutlet UIButton *pubicNews;
@property (weak, nonatomic) IBOutlet UIButton *helps;
@property (strong, nonatomic) UIScrollView *myScrollView;
@property (strong, nonatomic) UIScrollView *headerScrollView;

@end
