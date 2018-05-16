//
//  RootDataModel.h
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/16.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RootDataModel : NSObject

@property (nonatomic, copy) NSString* code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, copy) NSString *sid;

@property (nonatomic, copy) NSString *uToken;

@property (nonatomic, assign) BOOL success;
@end
