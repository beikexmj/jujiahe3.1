//
//  CircleCommentTableViewCell.h
//  copooo
//
//  Created by XiaMingjiang on 2017/10/25.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (nonatomic ,strong) void (^headerIconTapBlock)(NSInteger index);

@end
