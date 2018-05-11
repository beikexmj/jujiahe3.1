//
//  WaringAlertView.m
//  Weizhi
//
//  Created by 何月 on 2017/9/28.
//  Copyright © 2017年 hy. All rights reserved.
//

#import "WaringAlertView.h"
#import "UIView+XLExtension.h"
@interface WaringAlertView()
{
    UIView *_backgourdView;
    UIView *_contentView;
    
    UILabel *_titleLabel;
    UILabel *_contentLabel;
    
    UIButton *_iKnowButton;
    
    ActionBlock _actionBlock;
    
    BOOL _isShow;
}
@end

@implementation WaringAlertView

+(instancetype) shareInstance
{
    static dispatch_once_t pred;
    __strong static WaringAlertView *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[WaringAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionIknow)];
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
    
    ox = 0;
    oy = 0;
    width = _contentView.width;
    height = 50;
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(ox, oy, width, height);
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = RGBA(0xffffff, 1);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:_titleLabel];
    
//    width = _titleLabel.height;
//    height = width;
//    ox = _contentView.width - width;
//    oy = 0;
//    UIImage *closeImg = [UIImage imageNamed:@"01_5_popup_icon_close"];
//    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    closeButton.frame = FrameSelf;
//    [closeButton setImage:closeImg forState:UIControlStateNormal];
//    [_contentView addSubview:closeButton];
    
   // [closeButton addTarget:self action:@selector(actionIknow) forControlEvents:UIControlEventTouchUpInside];
    
    width = _contentView.width + 2;
    height = 54;
    oy = _contentView.height - height + 1;
    ox = _contentView.width/2 - width/2;
    _iKnowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _iKnowButton.frame = CGRectMake(ox, oy, width, height);
    _iKnowButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [_iKnowButton setTitle:@"取消" forState:UIControlStateNormal];
    [_iKnowButton setTitleColor:RGBA(0x00a7ff, 2) forState:UIControlStateNormal];
    _iKnowButton.backgroundColor = RGBA(0xffffff, 1);
    _iKnowButton.clipsToBounds = true;
    _iKnowButton.layer.borderColor = RGBA(0xd8d8d8, 1).CGColor;
    _iKnowButton.layer.borderWidth = 0.5;
    //_iKnowButton.layer.cornerRadius = _iKnowButton.height/2;
    [_contentView addSubview:_iKnowButton];
    [_iKnowButton addTarget:self action:@selector(actionIknow) forControlEvents:UIControlEventTouchUpInside];

    ox = 10;
    oy = _titleLabel.frame.origin.y + 10;
    width = _contentView.width - ox * 2;
    height = _iKnowButton.y - oy - 10;
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.frame = CGRectMake(ox, oy, width, height);
    _contentLabel.font = [UIFont systemFontOfSize:17];
    _contentLabel.textColor = RGBA(0x333333, 1);
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = 0;
    [_contentView addSubview:_contentLabel];
    
}
-(void)openAlterViewtitle:(NSString *)title
                  content:(NSString *)content
              buttonTitle:(NSString *)buttonTitle
              actionBlock:(ActionBlock )actionBlock{
    [self openAlterViewtitle:title content:content buttonTitle:buttonTitle backguandColor:RGBA(0x00a7ff, 1) contentColor:RGBA(0xffffff, 1) okBtnColor:RGBA(0x00a7ff, 1) actionBlock:actionBlock];
    
}
-(void)openAlterViewtitle:(NSString *)title
                  content:(NSString *)content
              buttonTitle:(NSString *)buttonTitle
           backguandColor:(UIColor *)color
             contentColor:(UIColor *)contentColor
               okBtnColor:(UIColor *)okBtnColor
              actionBlock:(ActionBlock )actionBlock
{
    
    if (_isShow == true) {
        return;
    }
    _isShow = true;
    _actionBlock = actionBlock;
    
    _titleLabel.text = title;
    _contentLabel.text = content;
    _contentView.backgroundColor = color;
    _titleLabel.textColor = contentColor;
    _contentLabel.textColor = contentColor;
    [_iKnowButton setTitle:buttonTitle forState:UIControlStateNormal];
    [_iKnowButton setTitleColor:okBtnColor forState:UIControlStateNormal];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.paragraphSpacingBefore = 2.f;
    paragraphStyle.paragraphSpacing = 2.f;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString.string length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:contentColor range:NSMakeRange(0, [attributedString.string length])];
    _contentLabel.attributedText = attributedString;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CGRect contentFrame = _contentView.frame;
    contentFrame.origin.y = SCREENHEIGHT/2 - contentFrame.size.height/2;
    
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _contentView.frame = contentFrame;
        _backgourdView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

-(void)actionIknow
{
    if(_actionBlock){
        _actionBlock();
    }
    [self hiddenAlterView];
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
