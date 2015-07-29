//
//  Adv.m
//  UP FM
//
//  Created by liubin on 15/2/12.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "Adv.h"

@implementation Adv

@synthesize aId;
@synthesize title;
@synthesize icon;
@synthesize type;
@synthesize proId;
@synthesize musicId;
@synthesize userId;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(Adv *)initAdvByDictionary:(NSDictionary *)dict{
    Adv *adv=[[Adv alloc] init];
    adv.aId=[dict objectForKey:@"adv_id"]?[dict objectForKey:@"adv_id"]:nil;
    adv.title=[dict objectForKey:@"adv_name"]?[dict objectForKey:@"adv_name"]:@"";
    adv.icon=[dict objectForKey:@"adv_icon"]?[dict objectForKey:@"adv_icon"]:@"";
    adv.type=[dict objectForKey:@"adv_type"]?[dict objectForKey:@"adv_type"]:[NSNumber numberWithInt:-1];
    adv.proId=[dict objectForKey:@"program_id"]?[dict objectForKey:@"program_id"]:nil;
    adv.musicId=[dict objectForKey:@"subject_id"]?[dict objectForKey:@"subject_id"]:nil;
    adv.userId=[dict objectForKey:@"user_id"]?[dict objectForKey:@"user_id"]:nil;
    
    return adv;
}
@end
