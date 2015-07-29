//
//  MCSystem.h
//  Mica
//
//  Created by hiseh yin on 13-5-23.
//  Copyright (c) 2013年 movivi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MCSystem : NSObject

+ (NSString *)getAppVersion;    //获得app版本
+ (NSString *)getDeviceVersion; //获得设备版本
+ (NSString *)getAppId;     //获得appid
+ (NSString *)getSource;    //获得源


@end
