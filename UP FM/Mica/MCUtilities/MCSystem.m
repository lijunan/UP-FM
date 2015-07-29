//
//  MCSystem.m
//  Mica
//
//  Created by hiseh yin on 13-5-23.
//  Copyright (c) 2013年 movivi. All rights reserved.
//

#import "MCSystem.h"
#include <sys/sysctl.h>

@implementation MCSystem

+ (NSString *)getAppVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)getDeviceVersion
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname("hw.machine", model, &size, NULL, 0);
    NSString *deviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    free(model);
    return deviceModel;
}

+(NSString *)getAppId{
    return @"";
}

+ (NSString *)getSource{
    return @"";
}


@end
