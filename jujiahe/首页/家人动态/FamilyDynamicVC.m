//
//  FamilyDynamicVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/20.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "FamilyDynamicVC.h"
#import "FamilyWarningVC.h"

@interface FamilyDynamicVC ()

@end

@implementation FamilyDynamicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setPopLeftItem];
    
    @weakify(self);
    [self setRightItemWithItemHandler:^(id  _Nonnull sender) {
        @strongify(self);
        [self.navigationController pushViewController:[FamilyWarningVC new] animated:YES];
    } titles:@"详情", nil];
}

- (NSString *)title
{
    return @"title";
}

@end
