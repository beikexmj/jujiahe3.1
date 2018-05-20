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
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.navigationBar];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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
    @weakify(self);
    [self setLeftItemWithItemHandler:^(id  _Nonnull sender) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    } icons:@"icon_back_gray", nil];
}

- (void)setDismissLeftItem
{
    @weakify(self);
    [self setLeftItemWithItemHandler:^(id  _Nonnull sender) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    } icons:@"icon_back_gray", nil];
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
        _navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : RGBA(0x333333, 1),
                                               NSFontAttributeName : [UIFont systemFontOfSize:NAVHEIGHT == 88 ? 18 : 16]
                                               };
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

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

@end
