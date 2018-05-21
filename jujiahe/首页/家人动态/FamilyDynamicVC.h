//
//  FamilyDynamicVC.h
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/20.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "JJBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FamilyDynamicDialogView : UIView

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, copy) NSAttributedString *text;

@end

@interface FamilyDynamicVC : JJBaseViewController

@end

NS_ASSUME_NONNULL_END
