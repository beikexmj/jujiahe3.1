//
//  PDConstants.h
//  PandaReaderSDK
//
//  Created by changle on 2017/7/18.
//  Copyright © 2017年 hongli. All rights reserved.
//

#ifndef PDConstants_h
#define PDConstants_h

@class PDError, PDUser;

typedef void(^ _Nullable PDBasicBlock)(PDError * _Nullable error);
typedef void(^ _Nullable PDLoginBlock)(PDUser * _Nullable user, PDError * _Nullable error);
typedef void(^ _Nullable PDLoginOutBlock)(PDUser * _Nullable user, PDError * _Nullable error);


#endif /* PDConstants_h */
