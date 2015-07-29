//
//  MCDate.h
//  Mica
//
//  Created by hiseh yin on 13-5-22.
//  Copyright (c) 2013年 movivi. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    MCDatePartternyyyy = 1,
    MCDatePartternyyyyMMdd,
    MCDatePartternHHmm,
    MCDatePartternMMddHHmm,
    MCDatePartternyyyyMMddHHmm
} MCDateParttern;

@interface NSDate (MCDate)
//时间戳
+ (NSInteger)timeStamp;
//日期比较
+ (NSDateComponents *)dateDiff:(NSDate *)fromDate toDate:(NSDate *)toDate;

+ (NSDate *)dateWithString:(NSString *)string dateParttern:(MCDateParttern)dateParttern;
+ (NSString *)stringValue:(NSDate *)date dateParttern:(MCDateParttern)dateParttern;
+ (NSString *)friendlyValue:(NSDate *)date;
+ (NSString *)humanValue:(NSTimeInterval)duration;

+(NSString *)timeIntervalToString:(NSInteger)time;
@end
