//
//  ImageFlowView.h
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/19.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageFlowConfiguration : NSObject

@property (nonatomic) CGSize     multiImageSize;
@property (nonatomic) CGSize     singleImageSize;

@property (nonatomic) CGFloat    verticalSpacing;
@property (nonatomic) CGFloat    horizontalSpacing;

@property (nonatomic) CGFloat    preferredLayoutWidth;

@property (nonatomic, copy, nullable) void (^displayImage)(UIImageView *imageView, NSInteger position);

@end

@interface ImageFlowView : UIView

@property (nonatomic) NSUInteger imageCount;

- (instancetype)initWithConfiguration:(ImageFlowConfiguration *)configuration;

@end

NS_ASSUME_NONNULL_END
