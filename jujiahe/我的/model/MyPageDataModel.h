//
//  MyPageDataModel.h
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/23.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MyPageData,CountPropertyServiceDto;
@interface MyPageDataModel : RootDataModel

@property (nonatomic,strong)MyPageData *data;

@end

@interface MyPageData : NSObject

@property (nonatomic,assign)BOOL messageFlag;

@property (nonatomic,strong) CountPropertyServiceDto *countPropertyServiceDto;

@end

@interface CountPropertyServiceDto : NSObject

@property (nonatomic,assign)NSInteger waitNum;
@property (nonatomic,assign)NSInteger lookedNum;
@property (nonatomic,assign)NSInteger completeNum;
@property (nonatomic,assign)NSInteger totalNum;

@end
