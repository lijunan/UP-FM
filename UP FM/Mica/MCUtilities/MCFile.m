//
//  MCFile.m
//  Mica
//
//  Created by hiseh yin on 13-5-23.
//  Copyright (c) 2013年 movivi. All rights reserved.
//

#import "MCFile.h"

@implementation MCFile

+ (BOOL)create:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager changeCurrentDirectoryPath:path];
    return  [fileManager createFileAtPath:path contents:nil attributes:nil];
}

+ (BOOL)createDirectory:(NSString *)path
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:path]
                                        withIntermediateDirectories:YES
                                                         attributes:nil
                                                              error:nil];
    }
    return NO;
}

+ (BOOL)delete:(NSString *)path
{
    @try {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager changeCurrentDirectoryPath:path];
        [fileManager removeItemAtPath:path error:nil];
        return YES;
    }
    @catch (NSException *exception) {
        return NO;
    }
    @finally {
    }
}

+ (BOOL)isExit:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:path];
}

+ (NSArray *)filesInDirectory:(NSString *)path
{
    return nil;
}

@end
