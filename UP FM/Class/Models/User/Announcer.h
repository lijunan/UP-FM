//
//  Announcer.h
//  UP FM
//
//  Created by liubin on 15/1/31.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "Person.h"


@interface Announcer : Person

@property (nonatomic,assign) NSMutableArray *commentList;  //评论列表
@property (nonatomic,assign) NSInteger mediaSum;    //音乐数
@property (nonatomic,assign) NSMutableArray *mediaList;  //音乐列表
@property (nonatomic,assign) NSString *notice;
@property (nonatomic,assign) NSInteger subscriptionSum;


-(Announcer *)initAnnouncerById:(NSString *)uId;

-(Announcer *)getAnnouncerById:(NSString *)userId;

@end
