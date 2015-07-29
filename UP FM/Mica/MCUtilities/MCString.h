//
//  MCString.h
//  Mica
//
//  Created by hiseh yin on 13-5-22.
//  Copyright (c) 2013年 movivi. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSString (MCString)
- (BOOL)isEmpty;
- (NSString *)trim; //去空格
- (NSString *)lowercaseFirstCharacter;  //转小写
- (NSString *)uppercaseFirstCharacter;  //转大写

+ (BOOL)isContentSubstring:(NSString *)str1 substring:(NSString *)substring;//子串

- (NSString *)substringBetween:(NSString *)beginStr endStr:(NSString *)endStr;

+ (BOOL)stringContainsEmoji:(NSString *)string;

- (NSString *)stringFromEmoji;

+(NSString *)replaceUnicode:(NSString *)unicodeStr;


- (NSString *)stringByClearEmoji;

- (NSString *) md5;     //md5加密

- (NSString *)keyMd5;   //生成key



/*邮箱验证 MODIFIED BY HELENSONG*/
-(BOOL)isValidateEmail;

/*手机号码验证 MODIFIED BY HELENSONG*/
-(BOOL) isValidateMobile;

/*车牌号验证 MODIFIED BY HELENSONG*/
-(BOOL) validateCarNo;


@end
