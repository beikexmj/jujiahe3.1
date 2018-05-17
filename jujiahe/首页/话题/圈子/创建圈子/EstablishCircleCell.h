//
//  EstablishCircleCell.h
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/17.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EstablishCircleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *choseBtn;
- (IBAction)choseBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *tips;
@property (weak, nonatomic) IBOutlet UILabel *tipsDetail;
@property (nonatomic,strong)void (^choseBtnBlock)(void);
@end
