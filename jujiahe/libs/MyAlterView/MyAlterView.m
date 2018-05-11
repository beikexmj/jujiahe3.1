//
//  MyAlterView.m
//  Weizhi
//
//  Created by hy on 17/5/5.
//  Copyright © 2017年 hy. All rights reserved.
//

#import "MyAlterView.h"
#import "AppDelegate.h"
#import "UIView+Additions.h"
@interface MyAlterView()
{
    UIView *_backgourdView;
    UIView *_contentView;

    UILabel *_titleLabel;
    UILabel *_contentLabel;
    
    UIButton *_leftButton;
    UIButton *_rightButton;
    
    BOOL _isShow;
    
    MyAlterViewDidSelectBlock _selectBlock;
}

@end

@implementation MyAlterView


+(instancetype) shareInstance
{
    static dispatch_once_t pred;
    __strong static MyAlterView *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[MyAlterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    });
    
    return sharedInstance;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _isShow = false;
        
        [self initContentView];
    }
    return self;
}

-(void)initContentView
{
    CGFloat ox = 0;
    CGFloat oy = 0;
    CGFloat width = 0;
    CGFloat height = 0;
    
    _backgourdView =[[UIView alloc] initWithFrame:self.bounds];
    _backgourdView.backgroundColor = RGBA(0x000000, 0.3);
    _backgourdView.alpha = 0;
    [self addSubview:_backgourdView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionSelf)];
    [_backgourdView addGestureRecognizer:tap];
    
    ox = 30;
    width = SCREENWIDTH  - ox * 2;
    if (SCREENWIDTH != 320) {
        width = 320;
        ox = SCREENWIDTH/2 - width/2;
    }
    height = 180;
    oy = -height;
    
    _contentView = [[UIView alloc] init];
    _contentView.frame = CGRectMake(ox, oy, width, height);
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.clipsToBounds = true;
    _contentView.layer.cornerRadius = 4;
    [self addSubview:_contentView];
    
    ox = 10;
    oy = 30;
    width = _contentView.width - ox * 2;
    height = 20;
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(ox, oy, width, height);
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textColor = RGBA(0x333333, 1);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:_titleLabel];
    
    ox = 0;
    width = _contentView.width/2;
    height = 54;
    oy = _contentView.height - height;
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(ox, oy, width, height);
    _leftButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [_leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [_contentView addSubview:_leftButton];
    [_leftButton setBackgroundColor:RGBA(0xffffff, 1)];
    [_leftButton addTarget:self action:@selector(actionLeft) forControlEvents:UIControlEventTouchUpInside];
    
    ox = _contentView.width/2;
    width = _contentView.width/2;
    height = 54;
    oy = _contentView.height - height;
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(ox, oy, width, height);
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [_rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [_rightButton setBackgroundColor:RGBA(0xffffff, 1)];
    [_contentView addSubview:_rightButton];
    [_rightButton addTarget:self action:@selector(actionRight) forControlEvents:UIControlEventTouchUpInside];


    
    ox = 15;
    width = SCREENWIDTH - ox * 2;
    height = 0.5;
    oy = _leftButton.y;
    UILabel *downLibel = [[UILabel alloc] initWithFrame:CGRectMake(ox, oy, width, height)];
    downLibel.backgroundColor = RGBA(0xd8d8d8, 1);
    downLibel.highlighted = false;
    [_contentView addSubview:downLibel];
    
    ox = _contentView.width/2;
    oy = downLibel.bottom + 15;
    width = 0.5;
    height = _leftButton.height - 15 * 2;
    UILabel *verticalLibel = [[UILabel alloc] initWithFrame:CGRectMake(ox, oy, width, height)];
    verticalLibel.backgroundColor = RGBA(0xd8d8d8, 1);
    verticalLibel.highlighted = false;
    [_contentView addSubview:verticalLibel];
    
    
    ox = 10;
    oy = _titleLabel.bottom + 10;
    width = _contentView.width - ox * 2;
    height = _leftButton.y - oy - 10;
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.frame = CGRectMake(ox, oy, width, height);
    _contentLabel.font = [UIFont systemFontOfSize:18];
    _contentLabel.textColor = RGBA(0x96a2a8, 1);
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = 0;
    [_contentView addSubview:_contentLabel];
    
}

-(void)actionSelf
{

}

-(void)actionLeft
{
    if (_selectBlock) {
        _selectBlock(0);
    }
    [self hiddenAlterView];
}

-(void)actionRight
{
    if (_selectBlock) {
        _selectBlock(1);
    }
    [self hiddenAlterView];
}

-(void)openAlterViewType:(MyAlterViewHighType )alterType
                   title:(NSString *)title
                 content:(NSString *)content
                    left:(NSString *)left
                   right:(NSString *)right
             selectBlock:(MyAlterViewDidSelectBlock )selectBlock{
    [self openAlterViewType:alterType title:title content:content backguandColor:RGBA(0x00a7ff, 1) contentColor:RGBA(0xffffff, 1) left:left right:right selectBlock:selectBlock];
}
-(void)openAlterViewType:(MyAlterViewHighType )alterType
                   title:(NSString *)title
                 content:(NSString *)content
          backguandColor:(UIColor *)color
            contentColor:(UIColor *)contentColor
                    left:(NSString *)left
                   right:(NSString *)right
             selectBlock:(MyAlterViewDidSelectBlock )selectBlock
{
    if (_isShow) {
        return;
    }
    
    _isShow = true;
    _selectBlock = selectBlock;
    
    if (alterType == MyAlterViewHighTypeLeft) {
        
        [_leftButton setTitle:left forState:UIControlStateNormal];
        [_leftButton setTitleColor:RGBA(0x00a7ff, 1) forState:UIControlStateNormal];
        
        [_rightButton setTitle:right forState:UIControlStateNormal];
        [_rightButton setTitleColor:RGBA(0x303030 ,1) forState:UIControlStateNormal];
        
    }else if(alterType == MyAlterViewHighTypeRight) {
        
        [_leftButton setTitle:left forState:UIControlStateNormal];
        [_leftButton setTitleColor:RGBA(0x303030, 1) forState:UIControlStateNormal];
        
        [_rightButton setTitle:right forState:UIControlStateNormal];
        [_rightButton setTitleColor:RGBA(0x00a7ff ,1) forState:UIControlStateNormal];
    }
    
    _titleLabel.text = title;
    _contentLabel.text = content;
    _titleLabel.textColor = contentColor;
    _contentLabel.textColor = contentColor;
    _contentView.backgroundColor = color;
    [[AppDelegate app].window addSubview:self];

    
    CGRect contentFrame = _contentView.frame;
    contentFrame.origin.y = SCREENHEIGHT/2 - contentFrame.size.height/2;
    
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _contentView.frame = contentFrame;
        _backgourdView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
    
}

-(void)hiddenAlterView
{
    _isShow = false;
    CGRect contentFrame = _contentView.frame;
    contentFrame.origin.y = SCREENHEIGHT;
    
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _contentView.frame = contentFrame;
        _backgourdView.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
        CGRect contentFrame = _contentView.frame;
        contentFrame.origin.y = -contentFrame.size.height;
        _contentView.frame = contentFrame;
    }];
}



@end
