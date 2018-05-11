//
//  ServiceMemberCell.h
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/10.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceMemberCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;
@property (weak, nonatomic) IBOutlet UILabel *headerName;
@property (weak, nonatomic) IBOutlet UILabel *identity;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;

@property (weak, nonatomic) IBOutlet UIButton *unPraiseBtn;
@property (weak, nonatomic) IBOutlet UILabel *praiseNum;
@property (weak, nonatomic) IBOutlet UILabel *unPraiseNum;
- (IBAction)praiseBtnClick:(id)sender;
- (IBAction)unPraiseBtnClick:(id)sender;
@property (nonatomic,strong)void (^praiseBtnBlock)(NSInteger index);
@property (nonatomic,strong)void (^unPraiseBtnBlock)(NSInteger index);


@end
