//
//  CommentViewController.h
//  copooo
//
//  Created by XiaMingjiang on 2017/10/25.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *myTextView;
@property (nonatomic, copy)NSString *postId;
@property (nonatomic, copy)NSString *targetUserId;
@property (nonatomic, copy)NSString *targetName;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHight;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)publishBtnClick:(id)sender;
@property (nonatomic,strong) void(^commentBlock)();
@end
