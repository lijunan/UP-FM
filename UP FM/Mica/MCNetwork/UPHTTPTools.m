//
//  UPHTTPTools.m
//  UP FM
//
//  Created by liubin on 15/2/2.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPHTTPTools.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "MCSystem.h"
#import "CurrentUser.h"
#import "MCString.h"

@implementation UPHTTPTools



+(void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //3.发送Get请求
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary*responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *_platform=@"ios";
    NSString *_version=[MCSystem getAppVersion];
    NSString *_source=[MCSystem getSource];
    NSString *_appId=[MCSystem getAppId];
    NSString *_userId=[CurrentUser sharedInstance].uId;
    NSString *_auth=[CurrentUser sharedInstance].auth;
    
    NSString *keyUrl=[NSString stringWithFormat:@"radio%@%@%@%@%@%@request",url,_platform,_version,_source,_appId,_userId?_userId:@""];
    
    NSString *key=[[keyUrl md5] uppercaseString];
    
    NSMutableDictionary *reqBody = [NSMutableDictionary dictionary];
    [reqBody addEntriesFromDictionary:params];

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:reqBody options:NSJSONWritingPrettyPrinted error:nil];
        
    NSString *str=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *p=[NSDictionary dictionaryWithObjectsAndKeys:[str stringByClearEmoji],@"p", nil];
    
    //1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    //mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    
   
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [mgr.requestSerializer setValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
    [mgr.requestSerializer setValue:_platform forHTTPHeaderField:@"Platform"];
    [mgr.requestSerializer setValue:_version forHTTPHeaderField:@"Version"];
    
//    [mgr.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Platform"];
//    [mgr.requestSerializer setValue:@"1.0.0" forHTTPHeaderField:@"Version"];
    
    if(_source){
        [mgr.requestSerializer setValue:_source forHTTPHeaderField:@"Source"];
    }
    if(_userId){
        [mgr.requestSerializer setValue:_userId forHTTPHeaderField:@"UserId"];
        
        [mgr.requestSerializer setValue:@"OUizijVi8ljdhBrj" forHTTPHeaderField:@"UserId"];

    }
    if(_auth){
        [mgr.requestSerializer setValue:_auth forHTTPHeaderField:@"Auth"];
    }
    [mgr.requestSerializer setValue:_appId forHTTPHeaderField:@"AppId"];
    [mgr.requestSerializer setValue:key forHTTPHeaderField:@"Key"];
    
    //2.发送Post请求
    [mgr POST:url parameters:p success:^(AFHTTPRequestOperation *operation, NSDictionary*responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

//+(void)post1:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
//{
//    NSString *_platform=@"ios";
//    NSString *_version=[MCSystem getAppVersion];
//    NSString *_source=[MCSystem getSource];
//    NSString *_appId=[MCSystem getAppId];
//    NSString *_userId=[CurrentUser sharedInstance].uId;
//    //NSString *_auth=[CurrentUser sharedInstance].auth;
////    NSString *keyUrl=[NSString stringWithFormat:@"radio%@%@%@%@%@%@request",url,_platform,_version,_source,_appId,_userId?_userId:@""];
////
//    
//    
//    NSString * keyUrl = @"radiohttp://120.24.231.13:7090/ra/program?c=list_subjectios1.0.0OUizijVi8ljdhBrjrequest";
//    
//    NSString *key=[[keyUrl md5] uppercaseString];
//    
//    NSLog(@"%@=========%@",keyUrl,key);
//    
//    NSMutableDictionary *reqBody = [NSMutableDictionary dictionary];
//    [reqBody addEntriesFromDictionary:params];
//    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:reqBody options:NSJSONWritingPrettyPrinted error:nil];
//    
//    NSString *str=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
//    NSDictionary *p=[NSDictionary dictionaryWithObjectsAndKeys:[str stringByClearEmoji],@"p", nil];
//    
//    //1.获得请求管理者
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    
//    //申明返回的结果是json类型
//    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
//    //申明请求的数据是json类型
//    //mgr.requestSerializer=[AFJSONRequestSerializer serializer];
//    
//    
//    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [mgr.requestSerializer setValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
//    //    [mgr.requestSerializer setValue:_platform forHTTPHeaderField:@"Platform"];
//    //    [mgr.requestSerializer setValue:_version forHTTPHeaderField:@"Version"];
//    
//    [mgr.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Platform"];
//    [mgr.requestSerializer setValue:@"1.0.0" forHTTPHeaderField:@"Version"];
//    
//    //    if(_source){
//    //        [mgr.requestSerializer setValue:_source forHTTPHeaderField:@"Source"];
//    //    }
//    //    if(_userId){
//    //        [mgr.requestSerializer setValue:_userId forHTTPHeaderField:@"UserId"];
//    //        NSLog(@"******************%@",_userId);
//    
//    //OUizijVi8ljdhBrj
//    
//    //OUizijVi8ljdhBrjrequest
//    [mgr.requestSerializer setValue:@"OUizijVi8ljdhBrj" forHTTPHeaderField:@"UserId"];
//    
//    //   }
//    //    if(_auth){
//    //        [mgr.requestSerializer setValue:_auth forHTTPHeaderField:@"Auth"];
//    //    }
//    //    [mgr.requestSerializer setValue:_appId forHTTPHeaderField:@"AppId"];
//    [mgr.requestSerializer setValue:key forHTTPHeaderField:@"Key"];
//    //[mgr.requestSerializer setValue:@"ADCD4359AAADD671A8C5AF00E0132DB1" forHTTPHeaderField:@"Key"];
//    
//    //2.发送Post请求
//    [mgr POST:url parameters:p success:^(AFHTTPRequestOperation *operation, NSDictionary*responseObj) {
//        if (success) {
//            success(responseObj);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
//
//}

+(void)postFiel:(NSString *)url fiel:(NSData *)fiel params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *_platform=@"ios";
    NSString *_version=[MCSystem getAppVersion];
    NSString *_source=[MCSystem getSource];
    NSString *_appId=[MCSystem getAppId];
    NSString *_userId=nil;//[CurrentUser sharedInstance].uId;
    NSString *_auth=nil;//[CurrentUser sharedInstance].auth;
    NSString *_boundary=@"7dc4e20a06a8";
    NSString *keyUrl=[NSString stringWithFormat:@"radio%@%@%@%@%@%@request",url,_platform,_version,_source,_appId,_userId?_userId:@""];
    NSString *key=[[keyUrl md5] uppercaseString];
    
    
    
    NSMutableDictionary *reqBody = [NSMutableDictionary dictionary];
    [reqBody addEntriesFromDictionary:params];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:reqBody options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *str=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    str=[NSString stringWithFormat:@"%@--%@--%@",str,_boundary,fiel];
    NSDictionary *p=[NSDictionary dictionaryWithObjectsAndKeys:str,@"p", nil];
    NSLog(@"%@",p);
    //1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    //mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    
    
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [mgr.requestSerializer setValue:@"multipart/form-data"forHTTPHeaderField:@"Content-Type"];
    [mgr.requestSerializer setValue:@"form-data"forHTTPHeaderField:@"Content-Disposition"];
    
    [mgr.requestSerializer setValue:_boundary forHTTPHeaderField:@"boundary"];
    [mgr.requestSerializer setValue:_platform forHTTPHeaderField:@"Platform"];
    [mgr.requestSerializer setValue:_version forHTTPHeaderField:@"Version"];
    if(_source){
        [mgr.requestSerializer setValue:_source forHTTPHeaderField:@"Source"];
    }
    if(_userId){
        [mgr.requestSerializer setValue:_userId forHTTPHeaderField:@"UserId"];
    }
    if(_auth){
        [mgr.requestSerializer setValue:_auth forHTTPHeaderField:@"Auth"];
    }
    [mgr.requestSerializer setValue:_appId forHTTPHeaderField:@"AppId"];
    [mgr.requestSerializer setValue:key forHTTPHeaderField:@"Key"];
    
    //2.发送Post请求
    [mgr POST:url parameters:p success:^(AFHTTPRequestOperation *operation, NSDictionary*responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (NSString *)sharedClient{
    // 1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
        return @"wifi";
        
    } else if ([conn currentReachabilityStatus] != NotReachable) {
        // 没有使用wifi, 使用手机自带网络进行上网
        return @"3G/4G";
        
    } else { // 没有网络
        
        return @"no";
    }
}

    
@end
