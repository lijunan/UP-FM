//
//  MCMath.m
//  Mica
//
//  Created by hiseh yin on 13-5-22.
//  Copyright (c) 2013年 movivi. All rights reserved.
//

#import "MCMath.h"

@implementation NSNumber (MCMath)

+(NSString *)friendlyNumber:(NSNumber *)number{
    int num=[number intValue];
    if(num>=10000){
        return [NSString stringWithFormat:@"%d万",num/10000];
    }else if(num>1000){
        return [NSString stringWithFormat:@"%d千",num/1000];
    }else{
        return [NSString stringWithFormat:@"%d",num];
    }
}

+ (NSInteger)random:(NSInteger)limitNum
{
    return arc4random() % limitNum;
}
@end
