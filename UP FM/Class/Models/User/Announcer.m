//
//  Announcer.m
//  UP FM
//
//  Created by liubin on 15/1/31.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "Announcer.h"

@implementation Announcer

@synthesize commentList;
@synthesize mediaList;
@synthesize mediaSum;
@synthesize notice;
@synthesize subscriptionSum;

- (id)init
{
    self = [super init];
    if (self) {
        self.PersonType=@"announcer";
    }
    return self;
}

-(Announcer *)initAnnouncerById:(NSString *)uId{
    Announcer *user=[[Announcer alloc] init];
    return user;
}

-(Announcer *)getAnnouncerById:(NSString *)userId{
    Announcer *user=[[Announcer alloc] init];
    
    user.uId=userId;
    
    
    
    return user;
}

@end
