//
//  CircleCommentDataModel.h
//  copooo
//
//  Created by XiaMingjiang on 2017/11/20.
//  Copyright © 2017年 夏明江. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CircleCommentDataList;
@interface CircleCommentDataModel : NSObject

@property (nonatomic, assign) NSInteger rcode;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<CircleCommentDataList *> *form;

@end


@interface CircleCommentDataList : NSObject

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *ids;

@property (nonatomic, copy) NSString *modifySource;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *postId;

@property (nonatomic, copy) NSString *postThumbView;

@property (nonatomic, copy) NSString *postUserId;

@property (nonatomic, copy) NSString *postUserRead;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *targetName;

@property (nonatomic, copy) NSString *updateTime;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *sex;

@end
