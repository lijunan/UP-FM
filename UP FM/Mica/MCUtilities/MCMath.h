//
//  MCMath.h
//  Mica
//
//  Created by hiseh yin on 13-5-22.
//  Copyright (c) 2013年 movivi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (MCMath)

+(NSString *)friendlyNumber:(NSNumber *)number;//友好数字格式
+ (NSInteger)random:(NSInteger)limitNum;
@end
