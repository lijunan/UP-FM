//
//  Comment.m
//  UP FM
//
//  Created by liubin on 15/1/29.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "Comment.h"
#import "User.h"

@implementation Comment

@synthesize cId;
@synthesize user;
@synthesize commentTime;
@synthesize sort;
@synthesize content;
@synthesize level;

- (id)init
{
    self = [super init];
    if (self) {
        self.level=[NSNumber numberWithInt:1];
    }
    return self;
}

-(Comment *)getCommentById:(NSNumber *)commentId{
    Comment *comment=[[Comment alloc] init];
    
    comment.cId=commentId;
    
    switch ([commentId intValue]) {
        case 1:
            comment.user=[[[User alloc] init] getUserById:[NSNumber numberWithInt:1]];
            comment.commentTime=[NSDate dateWithTimeIntervalSince1970:1396035591];
            comment.sort=[NSNumber numberWithInt:1];
            comment.content=@"不管是吉克隽逸还是阿鲁阿卓和她身边的山风组合，他们在音乐中暗藏与呈现出来的野心，都是要将自己民族音乐和特色介绍给全国。";
            comment.level=[NSNumber numberWithInt:1];
            break;
        case 2:
            comment.user=[[[User alloc] init] getUserById:[NSNumber numberWithInt:2]];
            comment.commentTime=[NSDate dateWithTimeIntervalSince1970:1396065591];
            comment.sort=[NSNumber numberWithInt:3];
            comment.content=@"从专辑制作和配器就可以看出，他使出十八般武艺完成这次“我”的重塑。";
            comment.level=[NSNumber numberWithInt:1];
             break;
        case 3:
            comment.user=[[[User alloc] init] getUserById:[NSNumber numberWithInt:2]];
            comment.commentTime=[NSDate dateWithTimeIntervalSince1970:1396065591];
            comment.sort=[NSNumber numberWithInt:14];
            comment.content=@"已经为这档节目带来了新鲜风气。";
            comment.level=[NSNumber numberWithInt:1];
            break;
        default:
            return nil;
            break;
    }
    
    return comment;
}

@end
