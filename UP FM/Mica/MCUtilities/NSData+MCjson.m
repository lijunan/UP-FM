//
//  NSData+MCjson.m
//  iDouKou
//
//  Created by hiseh yin on 13-6-27.
//  Copyright (c) 2013年 vividomedia. All rights reserved.
//

#import "NSData+MCjson.h"
#import "MCSystem.h"
#import "CurrentUser.h"
#import "MCString.h"

@implementation NSData (MCjson)

- (NSArray *)arrayWithJSON {
    NSArray *resultArray = [[NSArray alloc] init];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:(NSData *)self options:NSJSONReadingAllowFragments error:&error];
    if (jsonObject != nil && error == nil) {
        if ([jsonObject isKindOfClass:[NSArray class]]) {
            resultArray = (NSArray *)jsonObject;
        }
    }
    return resultArray;
}

- (NSDictionary *)dictionaryWithJSON {
    NSDictionary *resultDictionary = [[NSDictionary alloc] init];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:(NSData *)self options:NSJSONReadingAllowFragments error:&error];
    if (jsonObject != nil && error == nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            resultDictionary = (NSDictionary *)jsonObject;
        }
    }
    return resultDictionary;
}

+ (NSString *)stringWithJSONObject:(id)object
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
#ifdef IDOUKOU_DEBUG
                                                       options:NSJSONWritingPrettyPrinted
#else
                                                       options:0
#endif
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"MCJSON: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

+(NSDictionary *)getDictionaryForUrl:(NSString *)url parameters:(NSDictionary *)parameters{
    NSString *_platform=@"ios";
    NSString *_version=[MCSystem getAppVersion];
    NSString *_source=[MCSystem getSource];
    NSString *_appId=[MCSystem getAppId];
    int _userId=[[CurrentUser sharedInstance].uId intValue];
    NSString *keyUrl=[NSString stringWithFormat:@"radio%@%@%@%@%@%@request",url,_platform,_version,_source,_appId,_userId==0?@"":[NSString stringWithFormat:@"%d",_userId]];
    
    NSString *key=[[keyUrl md5] uppercaseString];
    
    NSDictionary *pdictionary=[NSDictionary dictionaryWithObjectsAndKeys:_platform,@"Platfor",_version,@"Version",key,@"Key",parameters,@"p",nil];
    //NSLog(@"%@",pdictionary);
    return pdictionary;
}


@end
