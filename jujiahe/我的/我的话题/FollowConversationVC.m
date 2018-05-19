//
//  FollowConversationVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/19.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "FollowConversationVC.h"
#import "HMSegmentedControl.h"

@interface FollowConversationVC ()

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@end

@implementation FollowConversationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.segmentedControl];
}

- (HMSegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"回复的", @"关注的", @"发布的"]];
        _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _segmentedControl.frame = CGRectMake(0, NAVHEIGHT, SCREENWIDTH, 40);
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

@end
