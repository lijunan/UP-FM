//
//  MCString.m
//  Mica
//
//  Created by hiseh yin on 13-5-22.
//  Copyright (c) 2013年 movivi. All rights reserved.
//

#import "MCString.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (MCString)

-(BOOL)isEmpty{
    NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [self stringByTrimmingCharactersInSet:charSet];
    return [trimmed isEqualToString:@""];
}

-(NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)lowercaseFirstCharacter {
    NSRange range = NSMakeRange(0,1);
    NSString *lowerFirstCharacter = [[self substringToIndex:1] lowercaseString];
    return [self stringByReplacingCharactersInRange:range withString:lowerFirstCharacter];
}

- (NSString *)uppercaseFirstCharacter {
    NSRange range = NSMakeRange(0,1);
    NSString *upperFirstCharacter = [[self substringToIndex:1] uppercaseString];
    return [self stringByReplacingCharactersInRange:range withString:upperFirstCharacter];
}
- (NSString *)keyMd5 {
    return [[[NSString stringWithFormat:@"radio%@request",self] md5] uppercaseString];
}

+ (BOOL)isContentSubstring:(NSString *)str1 substring:(NSString *)substring
{
    if ([str1 isEmpty] || [substring isEmpty]) {
        return NO;
    } else {
        return [str1 rangeOfString:substring].location != NSNotFound;
    }
}

- (NSString *)substringBetween:(NSString *)beginStr endStr:(NSString *)endStr
{
    NSRange rangBegin = [self rangeOfString:beginStr];
    if (rangBegin.location == NSNotFound) {
        return @"";
    }
    
    NSRange rangEnd;
    if (endStr) {
        rangEnd = [self rangeOfString:endStr
                              options:NSLiteralSearch
                                range:NSMakeRange(rangBegin.location + rangBegin.length,
                                                  self.length - rangBegin.location - rangBegin.length)];
    } else {
        rangEnd = NSMakeRange([self length], 0);
    }
    return [self substringWithRange:NSMakeRange(rangBegin.location + rangBegin.length,
                                                rangEnd.location - rangBegin.location - rangBegin.length)];
}

+(NSString *)replaceUnicode:(NSString *)unicodeStr {
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *returnStr=[NSPropertyListSerialization propertyListWithData:tempData options:0 format:NULL error:nil];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    __block NSString *resultString = string;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     NSLog(@"substring is %@", substring);
                     resultString = [resultString stringByReplacingOccurrencesOfString:substring withString:@""];
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 NSLog(@"substring is %@", substring);
                 resultString = [resultString stringByReplacingOccurrencesOfString:substring withString:@""];
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 NSLog(@"substring is %@", substring);
                 resultString = [resultString stringByReplacingOccurrencesOfString:substring withString:@""];
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 NSLog(@"substring is %@", substring);
                 resultString = [resultString stringByReplacingOccurrencesOfString:substring withString:@""];
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 NSLog(@"substring is %@", substring);
                 resultString = [resultString stringByReplacingOccurrencesOfString:substring withString:@""];
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 NSLog(@"substring is %@", substring);
                 resultString = [resultString stringByReplacingOccurrencesOfString:substring withString:@""];
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 NSLog(@"substring is %@", substring);
                 resultString = [resultString stringByReplacingOccurrencesOfString:substring withString:@""];
                 returnValue = YES;
             }
         }
     }];
    NSLog(@"result string is\n%@", resultString);
    return returnValue;
}

- (NSString *)stringByClearEmoji
{
    __block NSString *resultString = self;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     resultString = [resultString stringByReplacingOccurrencesOfString:substring withString:@""];
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 resultString = [resultString stringByReplacingOccurrencesOfString:substring withString:@""];
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 resultString = [resultString stringByReplacingOccurrencesOfString:substring withString:@""];
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 resultString = [resultString stringByReplacingOccurrencesOfString:substring withString:@""];
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 resultString = [resultString stringByReplacingOccurrencesOfString:substring withString:@""];
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 resultString = [resultString stringByReplacingOccurrencesOfString:substring withString:@""];
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 resultString = [resultString stringByReplacingOccurrencesOfString:substring withString:@""];
             }
         }
     }];
    return resultString;
}

- (NSString *)stringFromEmoji{
    NSData *data = [self dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *) md5{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (int)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}



/*邮箱验证 MODIFIED BY HELENSONG*/
-(BOOL)isValidateEmail{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

/*手机号码验证 MODIFIED BY HELENSONG*/
-(BOOL) isValidateMobile{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^(1[3-9][0-9])\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:self];
}

/*车牌号验证 MODIFIED BY HELENSONG*/
-(BOOL) validateCarNo{
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:self];
}
@end
