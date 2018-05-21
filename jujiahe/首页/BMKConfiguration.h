//
//  MKManager.h
//  jujiahe
//
//  Created by XiaMingjiang on 2018/5/21.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMKConfiguration : NSObject

@property (nonatomic, strong) BMKMapManager *mapManager;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
