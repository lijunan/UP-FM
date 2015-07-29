//
//  MCPlist.h
//  Mica
//
//  Created by hiseh yin on 13-5-28.
//  Copyright (c) 2013年 movivi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCPlist : NSObject

+ (NSDictionary *)dictionaryWithContentOfSystemFile:(NSString *)fileName;
+ (NSArray *)arrayWithContentOfSystemFile:(NSString *)fileName;

+ (NSDictionary *)dictionaryWithContentOfUserFile:(NSString *)fileName;
+ (NSArray *)arrayWithContentOfUserFile:(NSString *)fileName;

@end
