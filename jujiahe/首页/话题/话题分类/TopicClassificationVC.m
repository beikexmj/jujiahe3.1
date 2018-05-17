//
//  TopicClassificationVC.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/16.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "TopicClassificationVC.h"

#import "TopicClassificationChildVC.h"

@interface TopicClassificationVC ()
@property (nonatomic,strong)NSArray *headerTitleArr;

@end

@implementation TopicClassificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowNav = YES;
    self.titleLabel.text = @"话题分类";
    _backButton.hidden = NO;
    _headerTitleArr =[NSArray arrayWithObjects:@"全部",@"生活",@"健康",@"运动",@"时尚",@"生活",nil];
    // 模仿网络延迟，0.2秒后，才知道有多少标题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 移除之前所有子控制器
        [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
        
        // 把对应标题保存到控制器中，并且成为子控制器，才能刷新
        // 添加所有新的子控制器
        [self setUpAllViewController];
        
        // 注意：必须先确定子控制器
        [self refreshDisplay];
        
    });
    
    /*  设置标题渐变：标题填充模式 */
    [self setUpTitleGradient:^(YZTitleColorGradientStyle *titleColorGradientStyle, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor) {
        // 标题填充模式
        *titleColorGradientStyle = YZTitleColorGradientStyleFill;
        *norColor = RGBA(0x303030, 1);
        *selColor = RGBA(0x00a7ff, 1);
    }];
    [self setUpTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIFont *__autoreleasing *titleFont, CGFloat *titleHeight, CGFloat *titleWidth) {
        *titleScrollViewColor = RGBA(0xffffff, 1);
    }];
    [self setUpUnderLineEffect:^(BOOL *isUnderLineDelayScroll, CGFloat *underLineH, UIColor *__autoreleasing *underLineColor, BOOL *isUnderLineEqualTitleWidth) {
        *underLineH = 2;
        *underLineColor = RGBA(0x00a7ff, 1);
    }];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.selectIndex = 0;
}
// 添加所有子控制器
- (void)setUpAllViewController
{
    for (int i = 0; i<_headerTitleArr.count; i++) {
        TopicClassificationChildVC *wordVc1 = [[TopicClassificationChildVC alloc] init];
        wordVc1.title = _headerTitleArr[i];
        wordVc1.titleIndex = i;
        [self addChildViewController:wordVc1];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

