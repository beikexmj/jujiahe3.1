//
//  HappenDataModel.h
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HappenData,HappenDataMyCircles,HappenDataCirclesThings;
@interface HappenDataModel : RootDataModel
@property (nonatomic,strong)HappenData *data;
@end

@interface HappenData : NSObject
@property (nonatomic,strong)NSArray <HappenDataMyCircles *>*myCircles;
@property (nonatomic,strong)NSArray <HappenDataCirclesThings *>*microdistrictCircles;
@property (nonatomic,strong)NSArray <HappenDataCirclesThings *>*cityCircles;
@end

@interface HappenDataMyCircles : NSObject
@property (nonatomic,copy) NSString *ids;
@property (nonatomic,copy) NSString *path;
@property (nonatomic,copy) NSString *name;
@end

@interface HappenDataCirclesThings : NSObject
@property (nonatomic,copy) NSString *ids;
@property (nonatomic,copy) NSString *path;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *subName;

@end

