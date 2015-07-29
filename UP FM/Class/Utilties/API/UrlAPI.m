//
//  UrlAPI.m
//  UP FM
//
//  Created by liubin on 15/2/3.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UrlAPI.h"
#import "Mica.h"
#import "CurrentUser.h"


@implementation UrlAPI


//搜索
+(NSString *)getSearch{
    NSString *_type=@"search";
    NSDictionary *propertiesDict = [MCPlist dictionaryWithContentOfSystemFile:@"API"];
    
    NSString *apiURLStr = [NSString stringWithFormat:@"%@/%@?c=%@",[self getUrl],_type,[propertiesDict objectForKey:_type]];
    return apiURLStr;
}


//用户操作--订阅
+(NSString *)getProgramOrder{
    NSString *_type=@"program";
    NSDictionary *propertiesDict = [MCPlist dictionaryWithContentOfSystemFile:@"API"];
    
    NSString *apiURLStr = [NSString stringWithFormat:@"%@/%@?c=%@",[self getUrl],_type,[[propertiesDict objectForKey:_type] objectForKey:@"order"]];
    return apiURLStr;
}



//用户订阅列表
+(NSString *)getProgramOrderList{
    NSString *_type=@"program";
    NSDictionary *propertiesDict = [MCPlist dictionaryWithContentOfSystemFile:@"API"];
    
    NSString *apiURLStr = [NSString stringWithFormat:@"%@/%@?c=%@",[self getUrl],_type,[[propertiesDict objectForKey:_type] objectForKey:@"orderlist"]];
    return apiURLStr;
}



//主题--下载+1
+(NSString *)getSubjectDownloadAdd{
    NSString *_type=@"subject";
    NSDictionary *propertiesDict = [MCPlist dictionaryWithContentOfSystemFile:@"API"];
    
    NSString *apiURLStr = [NSString stringWithFormat:@"%@/%@?c=%@",[self getUrl],_type,[[propertiesDict objectForKey:_type] objectForKey:@"downloadadd"]];
    return apiURLStr;
}

//主题--赞过用户列表
+(NSString *)getSubjectGoodList{
    NSString *_type=@"subject";
    NSDictionary *propertiesDict = [MCPlist dictionaryWithContentOfSystemFile:@"API"];
    
    NSString *apiURLStr = [NSString stringWithFormat:@"%@/%@?c=%@",[self getUrl],_type,[[propertiesDict objectForKey:_type] objectForKey:@"goodlist"]];
    return apiURLStr;
}

//主题--赞+1
+(NSString *)getSubjectGoodAdd{
    NSString *_type=@"subject";
    NSDictionary *propertiesDict = [MCPlist dictionaryWithContentOfSystemFile:@"API"];
    
    NSString *apiURLStr = [NSString stringWithFormat:@"%@/%@?c=%@",[self getUrl],_type,[[propertiesDict objectForKey:_type] objectForKey:@"goodadd"]];
    return apiURLStr;
}

//主题--播放+1
+(NSString *)getSubjectPlayAdd{
    NSString *_type=@"subject";
    NSDictionary *propertiesDict = [MCPlist dictionaryWithContentOfSystemFile:@"API"];
    NSString *apiURLStr = [NSString stringWithFormat:@"%@/%@?c=%@",[self getUrl],_type,[[propertiesDict objectForKey:_type] objectForKey:@"addplaysum"]];
    return apiURLStr;
}

//主题--详细信息
+(NSString *)getSubjectDetail{
    NSString *_type=@"subject";
    NSDictionary *propertiesDict = [MCPlist dictionaryWithContentOfSystemFile:@"API"];
    NSString *apiURLStr = [NSString stringWithFormat:@"%@/%@?c=%@",[self getUrl],_type,[[propertiesDict objectForKey:_type] objectForKey:@"detail"]];
    return apiURLStr;
}

//节目-主题列表
+(NSString *)getProgramSubjectList{
    NSString *_type=@"program";
    NSDictionary *propertiesDict = [MCPlist dictionaryWithContentOfSystemFile:@"API"];
    
    NSString *apiURLStr = [NSString stringWithFormat:@"%@/%@?c=%@",[self getUrl],_type,[[propertiesDict objectForKey:_type] objectForKey:@"subjectlist"]];
    return apiURLStr;
}

//节目详情
+(NSString *)getProgramDetail{
    NSString *_type=@"program";
    NSDictionary *propertiesDict = [MCPlist dictionaryWithContentOfSystemFile:@"API"];
    
    NSString *apiURLStr = [NSString stringWithFormat:@"%@/%@?c=%@",[self getUrl],_type,[[propertiesDict objectForKey:_type] objectForKey:@"detail"]];
    return apiURLStr;
}

//节目(音乐)列表
+(NSString *)getProgramList{
    NSString *_type=@"program";
    NSDictionary *propertiesDict = [MCPlist dictionaryWithContentOfSystemFile:@"API"];
    
    NSString *apiURLStr = [NSString stringWithFormat:@"%@/%@?c=%@",[self getUrl],_type,[[propertiesDict objectForKey:_type] objectForKey:@"list"]];
    return apiURLStr;
}

//栏目列表
+(NSString *)getColumnList{
    NSString *_type=@"column";
    NSDictionary *propertiesDict = [MCPlist dictionaryWithContentOfSystemFile:@"API"];
    
    NSString *apiURLStr = [NSString stringWithFormat:@"%@/%@?c=%@",[self getUrl],_type,[[propertiesDict objectForKey:_type] objectForKey:@"list"]];
    return apiURLStr;
    
}

//首页轮播广告
+(NSString *)getAdvHome{
    NSString *_type=@"adv";
    NSDictionary *propertiesDict = [MCPlist dictionaryWithContentOfSystemFile:@"API"];
    
    NSString *apiURLStr = [NSString stringWithFormat:@"%@/%@?c=%@",[self getUrl],_type,[[propertiesDict objectForKey:_type] objectForKey:@"home"]];
    return apiURLStr;
    
}



/**
 * 用户
 */
//修改用户信息
+(NSString *)getUserUpdateInfo{
    NSString *_type=@"user";
    NSDictionary *propertiesDict = [MCPlist dictionaryWithContentOfSystemFile:@"API"];
    
    NSString *apiURLStr = [NSString stringWithFormat:@"%@/%@?c=%@",[self getUrl],_type,[[propertiesDict objectForKey:_type] objectForKey:@"updateinfo"]];
    return apiURLStr;
    
}

//匿名注册
+(NSString *)getUserRegAnonymous{
    NSString *_type=@"user";
    NSDictionary *propertiesDict = [MCPlist dictionaryWithContentOfSystemFile:@"API"];
    
    NSString *apiURLStr = [NSString stringWithFormat:@"%@/%@?c=%@",[self getUrl],_type,[[propertiesDict objectForKey:_type] objectForKey:@"anonymous"]];
    return apiURLStr;

}
//注册-带头像
+(NSString *)getUserRegFiel{
    NSString *_type=@"user";
    NSDictionary *propertiesDict = [MCPlist dictionaryWithContentOfSystemFile:@"API"];
    NSString *apiURLStr = [NSString stringWithFormat:@"%@/%@?c=%@",[self getUrl],_type,[[propertiesDict objectForKey:_type] objectForKey:@"regfiel"]];
    return apiURLStr;
}

//注册
+(NSString *)getUserReg{
    NSString *_type=@"user";
    NSDictionary *propertiesDict = [MCPlist dictionaryWithContentOfSystemFile:@"API"];
    NSString *apiURLStr = [NSString stringWithFormat:@"%@/%@?c=%@",[self getUrl],_type,[[propertiesDict objectForKey:_type] objectForKey:@"reg"]];
    return apiURLStr;
}

//登录
+(NSString *)getUserLogin{
    NSString *_type=@"user";
    NSDictionary *propertiesDict = [MCPlist dictionaryWithContentOfSystemFile:@"API"];
    NSString *apiURLStr = [NSString stringWithFormat:@"%@/%@?c=%@",[self getUrl],_type,[[propertiesDict objectForKey:_type] objectForKey:@"login"]];
    return apiURLStr;
}

//网站url
+(NSString *)getUrl{
    NSDictionary *propertiesDict = [MCPlist dictionaryWithContentOfSystemFile:@"API"];
    if([[NSString stringWithFormat:@"%@",[propertiesDict objectForKey:@"isPublic"]] isEqualToString:@"y"]){
        return [NSString stringWithFormat:@"%@",[propertiesDict objectForKey:@"public"]];
    }else{
        return [NSString stringWithFormat:@"%@",[propertiesDict objectForKey:@"private"]];
    }
    
}


@end
