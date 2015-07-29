//
//  MCFile.h
//  Mica
//
//  Created by hiseh yin on 13-5-23.
//  Copyright (c) 2013年 movivi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCFile : NSObject
+ (BOOL)create:(NSString *)path;
+ (BOOL)createDirectory:(NSString *)path;
+ (BOOL)delete:(NSString *)path;
+ (BOOL)isExit:(NSString *)path;
+ (NSArray *)filesInDirectory:(NSString *)path;

@end
