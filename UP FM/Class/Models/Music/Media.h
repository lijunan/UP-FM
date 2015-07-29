//
//  Media.h
//  UP FM
//
//  Created by liubin on 15-1-24.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UPFMBase.h"


@class Announcer;
@interface Media : NSObject

@property (nonatomic, strong) NSNumber *mediaId;    //id
@property (nonatomic, strong) NSString *title;      //名称
@property (nonatomic, strong) NSString *mediaTag;   //标签
@property (nonatomic, strong) NSString *icon;       //展示图
@property (nonatomic, strong) NSString *cover;  //封面图
@property (nonatomic, assign) MediaType mediaType;  //媒体类型
@property (nonatomic, strong) NSString *introduction;    //简介
@property (nonatomic, strong) NSString *notice; //公告
@property (nonatomic, assign) NSNumber *date;    //日期
@property (nonatomic, strong) NSArray *languages;  //语言
@property (nonatomic,strong) Announcer *owner;   //所有者

@end
