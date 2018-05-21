//
//  MKManager.m
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/21.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import "BMKConfiguration.h"

static NSString *const BMKPrivateKey = @"fzZSVYYDriqmjVwKZDfbvWZ0VVf63jfo";

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
        
        if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
            XMJLog(@"经纬度类型设置成功");
        } else {
            XMJLog(@"经纬度类型设置失败");
        }
        BOOL ret = [_mapManager start:BMKPrivateKey generalDelegate:self];
        if (!ret) {
            XMJLog(@"manager start failed!");
        }
    }
    return self;
}

#pragma mark - BMKGeneralDelegate

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        XMJLog(@"联网成功");
    }
    else{
        XMJLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        XMJLog(@"授权成功");
    }
    else {
        XMJLog(@"onGetPermissionState %d",iError);
    }
}

@end
