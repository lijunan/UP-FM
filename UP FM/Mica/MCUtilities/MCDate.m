//
//  MCDate.m
//  Mica
//
//  Created by hiseh yin on 13-5-22.
//  Copyright (c) 2013年 movivi. All rights reserved.
//

#import "MCDate.h"
#import "MCString.h"


@implementation NSDate (MCDate)


+ (NSInteger)timeStamp
{
    NSTimeInterval timeStamp    = [[NSDate date] timeIntervalSince1970];
    return (NSInteger)timeStamp;
}

//时间差
+ (NSDateComponents *)dateDiff:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSCalendar *sysCalendar     = [NSCalendar currentCalendar];
    unsigned int unitFlags      = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *compInfo  = [sysCalendar components:unitFlags
                                                 fromDate:fromDate
                                                   toDate:toDate
                                                  options:0];
    return compInfo;
}

+ (NSDate *)dateWithString:(NSString *)string dateParttern:(MCDateParttern)dateParttern
{
    if ([string isEmpty]) {
        string = @"1970-01-01";
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    switch (dateParttern) {
        case MCDatePartternHHmm:
        {
            [dateFormat setDateFormat:@"HH:mm"];
            break;
        }
        case MCDatePartternMMddHHmm:
            [dateFormat setDateFormat:@"MM-dd HH:mm"];
            break;
            
        case MCDatePartternyyyy:
            [dateFormat setDateFormat:@"yyyy"];
            break;
            
        case MCDatePartternyyyyMMdd:
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            break;
            
        case MCDatePartternyyyyMMddHHmm:
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
            
        default:
//            NSLog(@"error");
            break;
    }
    
    return [dateFormat dateFromString:string];
}

+ (NSString *)stringValue:(NSDate *)date dateParttern:(MCDateParttern)dateParttern
{
    if ([date isEqual:[NSNull null]] || (date == nil)) {
        return @"";
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    switch (dateParttern) {
        case MCDatePartternHHmm:
            [dateFormat setDateFormat:@"HH:mm"];
            break;
            
        case MCDatePartternMMddHHmm:
            [dateFormat setDateFormat:@"MM-dd HH:mm"];
            break;
            
        case MCDatePartternyyyy:
            [dateFormat setDateFormat:@"yyyy"];
            break;
            
        case MCDatePartternyyyyMMdd:
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            break;
            
        case MCDatePartternyyyyMMddHHmm:
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
            
        default:
//            NSLog(@"error");
            break;
    }
    
    return [dateFormat stringFromDate:date];
}

//友好的时间格式
+ (NSString *)friendlyValue:(NSDate *)date
{
    if ([date isEqual:[NSNull null]] || (date == nil)) {
        return @"";
    }
    NSDate *now = [[NSDate alloc] init];
    NSDateComponents *dateDiffs = [self dateDiff:(NSDate *)date toDate:now];
    
    if ((dateDiffs.minute == 0) && (dateDiffs.hour == 0) && (dateDiffs.day == 0) && (dateDiffs.month == 0) && (dateDiffs.year ==0)) {
        return @"1分钟内";
    } else if ((dateDiffs.hour == 0) && (dateDiffs.day == 0) && (dateDiffs.month == 0) && (dateDiffs.year ==0)) {
        return [NSString stringWithFormat:@"%d分钟前", (int)dateDiffs.minute];
    } else if ([[self stringValue:date dateParttern:MCDatePartternyyyyMMdd] isEqualToString:[self stringValue:now dateParttern:MCDatePartternyyyyMMdd]]) {
        return [NSString stringWithFormat:@"今天%@", [self stringValue:date dateParttern:MCDatePartternHHmm]];
    } else if ([[self stringValue:date dateParttern:MCDatePartternyyyy] isEqualToString:[self stringValue:now dateParttern:MCDatePartternyyyy]]) {
        return [NSString stringWithFormat:@"%@", [self stringValue:date dateParttern:MCDatePartternMMddHHmm]];
    } else {
        return [NSString stringWithFormat:@"%@", [self stringValue:date dateParttern:MCDatePartternyyyyMMddHHmm]];
    }
}

+ (NSString *)humanValue:(NSTimeInterval)duration
{
    NSInteger durationTimeInt   = (NSInteger) (duration + 0.5);
    return [NSString stringWithFormat:@"%d:%02d", (int)durationTimeInt / 60, (int)durationTimeInt % 60];
}

+(NSString *)timeIntervalToString:(NSInteger)time{
    int _time=(int)time;
    if(_time>3600){
        return [NSString stringWithFormat:@"%02li:%02li:%02li",lround(floor(_time / 3600)) % 100,lround(floor(_time / 60)) % 60,lround(floor(_time)) % 60];
    }else{
        return [NSString stringWithFormat:@"%02li:%02li",lround(floor(_time / 60)) % 60,lround(floor(_time)) % 60];
    }
}
@end
