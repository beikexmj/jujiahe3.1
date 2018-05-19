//
//  SubjectConversationVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/19.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "SubjectConversationVC.h"
#import <TYPagerController/TYPagerController.h>
#import "HMSegmentedControl.h"

@interface SubjectConversationVC ()<TYPagerControllerDelegate, TYPagerControllerDataSource>

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) TYPagerController  *pagerController;
@property (nonatomic, strong) NSArray<NSString *> *viewControllers;

@end

@implementation SubjectConversationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(0xE7EBEF, 1);
    [self configurationNavigation];
    
    [self.contentView addSubview:self.pagerController.view];
    [self addChildViewController:self.pagerController];
    [self.pagerController.view addSubview:self.segmentedControl];
    [self setupConstraints];
    [self setEvents];
    [self.segmentedControl setSelectedSegmentIndex:0 animated:YES];
}

- (void)configurationNavigation
{
    [self setPopLeftItem];
    self.navigationBar.jj_barTintColor = RGBA(0xf6f6f6, 1);
    self.navigationBar.shadowImage = [UIImage new];
}

- (void)setupConstraints
{
    [self.pagerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.top.equalTo(self.navigationBar.mas_bottom);
    }];
}

- (void)setEvents
{
    @weakify(self);
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        @strongify(self);
        [self.pagerController scrollToControllerAtIndex:index animate:YES];
    }];
}

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController {
    return self.viewControllers.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    NSString *clzzName = self.viewControllers[index];
    return [[NSClassFromString(clzzName) alloc] init];
}

#pragma mark - TYPagerControllerDelegate

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [self.segmentedControl setSelectedSegmentIndex:toIndex animated:animated];
}

#pragma mark - getter

- (NSString *)title
{
    return @"我参与的话题";
}

- (HMSegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"回复的", @"关注的", @"发布的"]];
        _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _segmentedControl.frame = CGRectMake(0, 0, SCREENWIDTH, 40);
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : RGBA(0x606060, 1),
                                                  NSFontAttributeName : [UIFont systemFontOfSize:15]};
        _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : RGBA(0x00a7ff, 1),
                                                          NSFontAttributeName : [UIFont systemFontOfSize:15]};
        _segmentedControl.verticalDividerEnabled = NO;
        _segmentedControl.selectionIndicatorHeight = 1.5;
        _segmentedControl.selectionIndicatorColor = RGBA(0x00a7ff, 1);
        _segmentedControl.backgroundColor = RGBA(0xf6f6f6, 1);
    }
    return _segmentedControl;
}

- (TYPagerController *)pagerController
{
    if (!_pagerController) {
        _pagerController = [[TYPagerController alloc] init];
        _pagerController.layout.prefetchItemCount = 1;
        _pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
        _pagerController.dataSource = self;
        _pagerController.delegate = self;
        _pagerController.scrollView.bounces = NO;
        [_pagerController.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    }
    return _pagerController;
}

- (NSArray<NSString *> *)viewControllers
{
    if (!_viewControllers) {
        _viewControllers = @[@"ReplyConversationVC", @"FollowConversationVC", @"PublishConversationVC"];
    }
    return _viewControllers;
}

@end
