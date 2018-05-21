//
//  MKManager.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/21.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "BMKConfiguration.h"

@interface BMKConfiguration ()<BMKGeneralDelegate>

@end

@implementation BMKConfiguration

+ (instancetype)sharedInstance
{
    static BMKConfiguration *configuation;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configuation = [[BMKConfiguration alloc] init];
    });
    return configuation;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mapManager = [[BMKMapManager alloc] init];
    }
    return self;
}

@end
