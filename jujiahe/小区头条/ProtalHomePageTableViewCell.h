//
//  ProtalHomePageTableViewCell.h
//  copooo
//
//  Created by XiaMingjiang on 2017/11/14.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProtalHomePageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *topicsView;
@property (weak, nonatomic) IBOutlet UIView *nomalView;
@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UILabel *time1;
@property (weak, nonatomic) IBOutlet UILabel *topicsMark;
@property (weak, nonatomic) IBOutlet UIImageView *topicsImg;
@property (weak, nonatomic) IBOutlet UILabel *topicsMark2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topicsImgHeight;
@property (weak, nonatomic) IBOutlet UIImageView *nomalImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nomalImgToLeft;
@property (weak, nonatomic) IBOutlet UILabel *title2;
@property (weak, nonatomic) IBOutlet UILabel *time2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nomalImgWidth;

@end
