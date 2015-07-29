//
//  User.m
//  UP FM
//
//  Created by liubin on 15/1/29.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize subscriptionList;
@synthesize downloadList;


- (id)init
{
    self = [super init];
    if (self) {
        self.PersonType=@"user";
    }
    return self;
}


-(User *)initUserByDictionary:(NSDictionary *)dict{
    User *user=[[User alloc] init];
    user.uId=[dict objectForKey:@"user_id"]?[dict objectForKey:@"user_id"]:nil;
    user.nickName=[dict objectForKey:@"user_name"]?[dict objectForKey:@"user_name"]:nil;
    user.icon=[dict objectForKey:@"user_icon"]?[dict objectForKey:@"user_icon"]:nil;
    return user;
}



-(User *)getUserById:(NSString *)userId{
    User *user=[[User alloc] init];
    
    user.uId=userId;
    
   
    
    return user;
}


@end
