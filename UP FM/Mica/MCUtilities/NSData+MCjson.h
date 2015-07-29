//
//  NSData+MCjson.h
//  iDouKou
//
//  Created by hiseh yin on 13-6-27.
//  Copyright (c) 2013年 vividomedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (MCjson)

- (NSArray *)arrayWithJSON;
- (NSDictionary *)dictionaryWithJSON;
+ (NSString *)stringWithJSONObject:(id)object;

+(NSDictionary *)getDictionaryForUrl:(NSString *)url parameters:(NSDictionary *)parameters;


@end
