//
//  HomePageDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2018/1/22.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HomePageData,WeatherResultModel,RecommendedResultModelList,
TopicModel,TopicModelData;
@interface HomePageDataModel : RootDataModel

@property (nonatomic, strong) HomePageData *data;

@end
@interface HomePageData : NSObject

@property (nonatomic, copy) NSString *messageFlag;

@property (nonatomic, strong) WeatherResultModel *weatherResultModel;
@property (nonatomic, strong) NSArray<RecommendedResultModelList *> *recommendedResultModelList;
@property (nonatomic, strong) TopicModel *topicModel;

@end

@interface WeatherResultModel : NSObject

@property (nonatomic, copy) NSString *value_level;
@property (nonatomic, copy) NSString *condition;
@property (nonatomic, copy) NSString *temp;
@property (nonatomic, copy) NSString *tempDay;
@property (nonatomic, copy) NSString *tempNight;

@end

@interface RecommendedResultModelList : NSObject

@property (nonatomic, copy) NSString *ids;

@property (nonatomic, copy) NSString *pictureUrl;

@property (nonatomic, copy) NSString *linkUrl;

@end

@interface TopicModel : NSObject

@property (nonatomic, copy) NSString *pageNum;

@property (nonatomic, copy) NSString *pageSize;

@property (nonatomic, copy) NSString *totalNum;

@property (nonatomic, copy) NSString *totalPage;

@property (nonatomic, strong) NSArray<TopicModelData *> *data;

@end
@interface TopicModelData : NSObject

@property (nonatomic, copy) NSString *ids;

@property (nonatomic, copy) NSString *updateTime;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *covers;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *viewNum;

@property (nonatomic, copy) NSString *typeName;

@property (nonatomic, assign) NSInteger attentionFlag;

@property (nonatomic, assign) NSInteger layerType;
@end




