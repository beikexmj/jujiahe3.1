//
//  HomePageCell.h
//  copooo
//
//  Created by XiaMingjiang on 2018/1/18.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageDataModel.h"
@interface HomePageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *subViewOne;
@property (weak, nonatomic) IBOutlet UIView *subViewTwo;
@property (weak, nonatomic) IBOutlet UIView *subViewThree;
@property (weak, nonatomic) IBOutlet UILabel *titleOne;
@property (weak, nonatomic) IBOutlet UIImageView *imageOne;
@property (weak, nonatomic) IBOutlet UILabel *markOne;
@property (weak, nonatomic) IBOutlet UILabel *readNumOne;
@property (weak, nonatomic) IBOutlet UIButton *followBtnOne;
@property (weak, nonatomic) IBOutlet UIImageView *imageTwo;
@property (weak, nonatomic) IBOutlet UILabel *titleTwo;
@property (weak, nonatomic) IBOutlet UILabel *markTwo;
@property (weak, nonatomic) IBOutlet UILabel *readNumTwo;
@property (weak, nonatomic) IBOutlet UIButton *followBtnTwo;
@property (weak, nonatomic) IBOutlet UILabel *markThree;
@property (weak, nonatomic) IBOutlet UILabel *readNumThree;
@property (weak, nonatomic) IBOutlet UIButton *followBtnThree;
@property (weak, nonatomic) IBOutlet UILabel *titleThree;
@property (weak, nonatomic) IBOutlet UIImageView *imageOneInViewThree;
@property (weak, nonatomic) IBOutlet UIImageView *imageTwoInViewThree;
@property (weak, nonatomic) IBOutlet UIImageView *imageThreeInViewThree;
- (IBAction)followBtnOneClick:(id)sender;
- (IBAction)followBtnTwoClick:(id)sender;
- (IBAction)followBtnThreeClick:(id)sender;
@property (nonatomic,strong)void (^followBtnOneBlock)(NSInteger index);
@property (nonatomic,strong)void (^followBtnTwoBlock)(NSInteger index);
@property (nonatomic,strong)void (^followBtnThreeBlock)(NSInteger index);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *followBtnThreeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *followBtnTwoWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *followBtnOneWidth;

@end
