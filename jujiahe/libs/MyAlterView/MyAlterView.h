//
//  MyAlterView.h
//  Weizhi
//
//  Created by hy on 17/5/5.
//  Copyright © 2017年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyAlterViewDidSelectBlock)(NSInteger index);

typedef enum {
    MyAlterViewHighTypeLeft,        ///<left-center on statusBar
    MyAlterViewHighTypeRight,       ///<right-center on statusBar
    MyAlterViewHighTypeCenter       ///<under the statusBar
} MyAlterViewHighType;

@interface MyAlterView : UIView

+(instancetype) shareInstance;

-(void)openAlterViewType:(MyAlterViewHighType )alterType
                   title:(NSString *)title
                 content:(NSString *)content
          backguandColor:(UIColor *)color
            contentColor:(UIColor *)contentColor
                    left:(NSString *)left
                   right:(NSString *)right
             selectBlock:(MyAlterViewDidSelectBlock )selectBlock;

-(void)openAlterViewType:(MyAlterViewHighType )alterType
                   title:(NSString *)title
                 content:(NSString *)content
                    left:(NSString *)left
                   right:(NSString *)right
             selectBlock:(MyAlterViewDidSelectBlock )selectBlock;
@end
