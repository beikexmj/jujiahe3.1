//
//  peopleIMView.h
//  jujiahe
//
//  Created by 刘欣 on 2018/5/21.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface peopleIMView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *peopleImage;
@property (weak, nonatomic) IBOutlet UILabel *peopleName;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIView *grayView;
@property (weak, nonatomic) IBOutlet UIButton *contactBtn;
@property (weak, nonatomic) IBOutlet UIButton *navBtn;

@property(nonatomic,strong)NSString *phonenumber;
@property(nonatomic,strong)NSString *addressStr;
@property (nonatomic,assign)CLLocationCoordinate2D coordinate;  //!< 要导航的坐标


@end
