//
//  PublishServiceCell.h
//  jujiahe
//
//  Created by 夏明江 on 2018/5/19.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishServiceCell : UITableViewCell
@property (nonatomic,strong)UIImageView *selectStateImage;
@property (nonatomic,strong)UILabel *titleName;
@property (nonatomic,strong)UIButton *selectBtn;
@property (nonatomic,strong)void (^selectBtnBlock)(void);
@end
