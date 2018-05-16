//
//  TopicDetailVC.h
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/16.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleDataModel.h"

@interface TopicDetailVC : BaseViewController
@property (nonatomic,strong)CircleDataList *dict;
@property (nonatomic,assign)CGFloat headerHeight;
@end
