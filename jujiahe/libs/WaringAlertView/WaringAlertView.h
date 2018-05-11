//
//  WaringAlertView.h
//  Weizhi
//
//  Created by 何月 on 2017/9/28.
//  Copyright © 2017年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionBlock)();

@interface WaringAlertView : UIView
{

}

+(instancetype) shareInstance;

-(void)openAlterViewtitle:(NSString *)title
                 content:(NSString *)content
              buttonTitle:(NSString *)buttonTitle
           backguandColor:(UIColor *)color
             contentColor:(UIColor *)contentColor
               okBtnColor:(UIColor *)okBtnColor
              actionBlock:(ActionBlock )actionBlock;

-(void)openAlterViewtitle:(NSString *)title
                  content:(NSString *)content
              buttonTitle:(NSString *)buttonTitle
              actionBlock:(ActionBlock )actionBlock;
@end

/*
 [[WaringAlertView shareInstance] openAlterViewtitle:@"温馨提示" content:@"您的孩子不在可控范围内，\ning打发斯蒂芬" buttonTitle:@"我知道了"];

 */
