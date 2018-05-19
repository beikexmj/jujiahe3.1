//
//  JJBaseViewController.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/18.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "JJBaseViewController.h"
#import <BlocksKit/UIBarButtonItem+BlocksKit.h>
#import "UIView+Frame.h"


@implementation JJNavigationBar

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *view in self.subviews) {
        if ([NSStringFromClass([view class]) containsString:@"ContentView"] ||
            [NSStringFromClass([view class]) containsString:@"UIBarBackground"]) {
            view.yz_y = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
    }
}

- (void)setJj_barTintColor:(UIColor *)jj_barTintColor
{
    self.backgroundColor = jj_barTintColor;
    self.barTintColor = jj_barTintColor;
}

@end

@implementation JJBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(0xffffff, 1);
    [self.navigationController setNavigationBarHidden:YES];
    [self.view addSubview:self.navigationBar];
    
}

- (void)setLeftItemWithItemHandler:(void (^)(id))action icons:(NSString *)icons, ...
{
    NSMutableArray *barItems = [@[] mutableCopy];
    va_list args;
    va_start(args, icons);
    for (NSString *objectKey = icons; objectKey != nil; objectKey = va_arg(args, NSString *)) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:objectKey]
                                                                    style:UIBarButtonItemStylePlain
                                                                  handler:action];
        [barItems addObject:item];
        item.tag = [barItems indexOfObject:objectKey];
    }
    va_end(args);
    self.navigationItem.leftBarButtonItems = barItems;
}

- (void)setRightItemWithItemHandler:(void (^)(id))action icons:(NSString *)icons, ...
{
    NSMutableArray *barItems = [@[] mutableCopy];
    va_list args;
    va_start(args, icons);
    for (NSString *objectKey = icons; objectKey != nil; objectKey = va_arg(args, NSString *)) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:objectKey]
                                                                    style:UIBarButtonItemStylePlain
                                                                  handler:action];
        [barItems addObject:item];
        item.tag = [barItems indexOfObject:objectKey];
    }
    va_end(args);
    self.navigationItem.rightBarButtonItems = barItems;
}

- (void)setLeftItemWithItemHandler:(void (^)(id))action titles:(NSString *)titles, ...
{
    NSMutableArray *barItems = [@[] mutableCopy];
    va_list args;
    va_start(args, titles);
    for (NSString *objectKey = titles; objectKey != nil; objectKey = va_arg(args, NSString *)) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] bk_initWithTitle:objectKey
                                                                    style:UIBarButtonItemStylePlain
                                                                  handler:action];
        [barItems addObject:item];
        item.tag = [barItems indexOfObject:objectKey];
    }
    va_end(args);
    self.navigationItem.leftBarButtonItems = barItems;
}

- (void)setRightItemWithItemHandler:(void (^)(id))action titles:(NSString *)titles, ...
{
    NSMutableArray *barItems = [@[] mutableCopy];
    va_list args;
    va_start(args, titles);
    for (NSString *objectKey = titles; objectKey != nil; objectKey = va_arg(args, NSString *)) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] bk_initWithTitle:objectKey
                                                                    style:UIBarButtonItemStylePlain
                                                                  handler:action];
        [barItems addObject:item];
        item.tag = [barItems indexOfObject:objectKey];
    }
    va_end(args);
    self.navigationItem.rightBarButtonItems = barItems;
}

- (void)setPopLeftItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back_gray"]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(popAction)];
    item.tag = 0;
    self.navigationItem.leftBarButtonItem = item;
}

- (void)setDismissLeftItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back_gray"]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(dismissAction)];
    item.tag = 0;
    self.navigationItem.leftBarButtonItem = item;
}

- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismissAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter

- (JJNavigationBar *)navigationBar
{
    if (!_navigationBar) {
        _navigationBar = [[JJNavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT)];
        _navigationBar.barStyle = UIBarStyleDefault;
        _navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _navigationBar.jj_barTintColor = [UIColor whiteColor];
        _navigationBar.tintColor = RGBA(0x9c9c9c, 1);
        _navigationBar.translucent = NO;
        [_navigationBar pushNavigationItem:self.navigationItem animated:NO];
    }
    return _navigationBar;
}

- (UINavigationItem *)navigationItem
{
    if (!_navigationItem) {
        _navigationItem = [[UINavigationItem alloc] initWithTitle:self.title];
        
    }
    return _navigationItem;
}

@end