//
//  DynamicCell.h
//  jujiahe
//
//  Created by kerwin on 2018/5/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DynamicCellData : NSObject

@property (nonatomic, copy, nullable) NSString   *title;
@property (nonatomic, copy, nullable) NSString  *imageName;

+ (DynamicCellData *)dataWithTitle:(nullable NSString *)title imageName:(nullable NSString *)imageName;

@end

@interface DynamicCell : UICollectionViewCell

@property (nonatomic, strong, nullable) DynamicCellData *data;

@end

NS_ASSUME_NONNULL_END
