//
//  CommunityDataModel.h
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/23.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CommunityData;
@interface CommunityDataModel : RootDataModel
@property (nonatomic,strong)NSArray <CommunityData *> *data;
@end
@interface CommunityData : NSObject
@property (nonatomic,copy)NSString *pictureUrl;
@property (nonatomic,copy)NSString *themeName;
@property (nonatomic,copy)NSString *ids;
@property (nonatomic,copy)NSString *propertyId;
@property (nonatomic,copy)NSString *communityId;
@property (nonatomic,assign)NSInteger articleNum;
@property (nonatomic,copy)NSString *createGuid;
@property (nonatomic,assign)NSInteger useStateFlag;
@end
