//
//  PDError.h
//  PandaReaderSDK
//
//  Created by changle on 2017/7/18.
//  Copyright © 2017年 hongli. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PDErrorCode) {
    PDErrorCodeUnknown = -999,
    PDErrorCodeConnectionFailed = -998,
    
    PDErrorCodeOK = 0,
};



NS_ASSUME_NONNULL_BEGIN
@interface PDError : NSObject

@property (nonatomic, assign) PDErrorCode code;
@property (nonatomic, copy) NSString *message;

- (nullable instancetype)initWithCode:(PDErrorCode)code message:(nullable NSString *)message NS_DESIGNATED_INITIALIZER;
+ (nullable instancetype)errorWithCode:(PDErrorCode)code message:(nullable NSString *)message;
+ (nullable instancetype)noError;

@end

NS_ASSUME_NONNULL_END
