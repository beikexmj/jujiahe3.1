//
//  QueryResultCell.h
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/18.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, QueryResultCellDividerType) {
    QueryResultCellDividerTypeDefault = 0,
    QueryResultCellDividerTypeOnlyTop,
    QueryResultCellDividerTypeOnlyBottom,
};

@interface QueryResultCell : UITableViewCell

@property (nonatomic) BOOL highlight;
@property (nonatomic) QueryResultCellDividerType dividerType;

- (void)setData;

@end

NS_ASSUME_NONNULL_END
