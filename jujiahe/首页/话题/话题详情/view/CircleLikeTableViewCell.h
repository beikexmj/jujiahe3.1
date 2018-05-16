//
//  CircleLikeTableViewCell.h
//  copooo
//
//  Created by XiaMingjiang on 2017/10/25.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleLikeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (nonatomic ,strong) void (^headerIconTapBlock)(NSInteger index);

@end
