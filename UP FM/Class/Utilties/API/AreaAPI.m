//
//  AreaAPI.m
//  UP FM
//
//  Created by liubin on 15/2/3.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "AreaAPI.h"
#import "Mica.h"

@implementation AreaAPI

+(NSArray *)getArea{
    NSArray *arr = [MCPlist arrayWithContentOfSystemFile:@"Area"];
    return arr;
}

@end
