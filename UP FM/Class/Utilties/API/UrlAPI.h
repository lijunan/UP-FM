//
//  UrlAPI.h
//  UP FM
//
//  Created by liubin on 15/2/3.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface UrlAPI : NSObject





/**
 *  主题(音乐)API
 **/

+(NSString *)getSubjectGoodAdd; //主题--赞+1
+(NSString *)getSubjectGoodList;    //主题--赞过用户列表
+(NSString *)getSubjectPlayAdd; //主题--播放+1
+(NSString *)getSubjectDetail;  //主题--详细信息
+(NSString *)getSubjectDownloadAdd; ////主题--下载+1


/**
 *  节目(专辑)详情API
 **/

+(NSString *)getProgramDetail;  //节目详情
+(NSString *)getProgramSubjectList; //节目-主题列表



/**
 *  节目(专辑)列表 API
 **/
+(NSString *)getProgramOrderList;   //用户订阅列表
+(NSString *)getSearch; //搜索
+(NSString *)getProgramList;    //节目(专辑)列表


+(NSString *)getProgramOrder;   //用户操作--订阅


/**
 *  首页API
 **/
+(NSString *)getColumnList;     //栏目列表
+(NSString *)getAdvHome;    //首页轮播广告


/**
 * 修改用户信息
 */

+(NSString *)getUserUpdateInfo; //修改用户信息

/**
 *  登录、注册API
 **/
+(NSString *)getUserRegAnonymous;    //匿名注册
+(NSString *)getUserReg;    //注册
+(NSString *)getUserRegFiel;    //注册-带头像

+(NSString *)getUserLogin;  //登录

+(NSString *)getUrl;    //网站url
@end
