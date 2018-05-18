//
//  JJBaseViewController.h
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/18.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJNavigationBar : UINavigationBar

@property (nonatomic, strong) UIColor *jj_barTintColor;

@end

@interface JJBaseViewController : UIViewController

@property (nonatomic, strong) JJNavigationBar *navigationBar;
@property (nonatomic, strong) UINavigationItem *navigationItem;

- (void)setLeftItemWithItemHandler:(void (^)(id sender))action
                             icons:(NSString *)icons, ...NS_REQUIRES_NIL_TERMINATION;

- (void)setRightItemWithItemHandler:(void (^)(id sender))action
                              icons:(NSString *)icons, ...NS_REQUIRES_NIL_TERMINATION;

- (void)setLeftItemWithItemHandler:(void (^)(id sender))action
                            titles:(NSString *)titles, ...NS_REQUIRES_NIL_TERMINATION;

- (void)setRightItemWithItemHandler:(void (^)(id sender))action
                             titles:(NSString *)titles, ...NS_REQUIRES_NIL_TERMINATION;


- (void)setPopLeftItem;
- (void)setDismissLeftItem;

@end

NS_ASSUME_NONNULL_END
