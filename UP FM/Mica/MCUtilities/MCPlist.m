//
//  MCPlist.m
//  Mica
//
//  Created by hiseh yin on 13-5-28.
//  Copyright (c) 2013年 movivi. All rights reserved.
//

#import "MCPlist.h"
#import "MCFile.h"

@implementation MCPlist

+ (NSDictionary *)dictionaryWithContentOfSystemFile:(NSString *)fileName
{
    NSString *defaultPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:defaultPath];
}

+ (NSArray *)arrayWithContentOfSystemFile:(NSString *)fileName
{
    NSString *defaultPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:defaultPath];
}

+ (NSDictionary *)dictionaryWithContentOfUserFile:(NSString *)fileName
{
    NSDictionary *dictionary;
    NSString *path = [[[[NSArray alloc] initWithArray:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)] firstObject] stringByAppendingFormat:@"/%@.plist", fileName];
    if ([MCFile isExit:path]){
        dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    } else {
        //to createrg file
        NSString *defaultPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
        [MCFile create:path];
        dictionary = [NSDictionary dictionaryWithContentsOfFile:defaultPath];
        [dictionary writeToFile:path atomically:YES];
    }
    return dictionary;
}

+ (NSArray *)arrayWithContentOfUserFile:(NSString *)fileName
{
    NSArray *array;
    NSString *path = [[[[NSArray alloc] initWithArray:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)] firstObject] stringByAppendingFormat:@"/%@.plist", fileName];
    if ([MCFile isExit:path]){
        array = [NSArray arrayWithContentsOfFile:path];
    } else {
        //to createrg file
        NSString *defaultPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
        [MCFile create:path];
        array = [NSArray arrayWithContentsOfFile:defaultPath];
        [array writeToFile:path atomically:YES];
    }
    return array;
    
}

@end
