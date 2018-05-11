//
//  ScaleButton.m
//  Joys
//
//  Created by TangGuo on 15/1/27.
//  Copyright (c) 2015年 TangGuo. All rights reserved.
//

#import "ScaleButton.h"

@implementation ScaleButton


-(void) setScale:(CGPoint)scale
{
    _scale = scale;
    self.exclusiveTouch = YES;
}

-(void) setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (_scale.x == 0) {
        _scale = CGPointMake(0.9f, 0.9f);
    }
    if (highlighted) {
        [UIView animateWithDuration:0.2f
                              delay:0.f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.transform = CGAffineTransformMakeScale(_scale.x, _scale.y);
                         } completion:nil];
    }else{
        [UIView animateWithDuration:0.2f
                              delay:0.f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.transform = CGAffineTransformMakeScale(1.f, 1.f);
                         } completion:nil];
    }
}

-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [super addTarget:target action:action forControlEvents:controlEvents];
}

-(void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    [super sendAction:action to:target forEvent:event];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
