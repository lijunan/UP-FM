//
//  Comment.h
//  UP FM
//
//  Created by liubin on 15/1/29.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface Comment : NSObject

@property (nonatomic, strong) NSNumber *cId;    //评论id
@property (nonatomic,strong) User *user;   //评论人
@property (nonatomic,strong) NSDate *commentTime;    //谁评论时间
@property (nonatomic,strong) NSNumber *sort;    //评论排序
@property (nonatomic,strong) NSString *content;    //评论内容
@property (nonatomic, strong) NSNumber *level;    //评论级别

-(Comment *)getCommentById:(NSNumber *)cId;

@end
