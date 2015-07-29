//
//  Album.m
//  UP FM
//
//  Created by liubin on 15-1-24.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "Album.h"
#import "Announcer.h"
#import "UrlAPI.h"
#import "Mica.h"

@implementation Album

@synthesize playSum;
@synthesize downloadSum;
@synthesize commentsSum;
@synthesize shareSum;
@synthesize goodSum;
@synthesize timeLength;
@synthesize timePlay;
@synthesize contentPlay;
@synthesize fansSum;
@synthesize subscriptionSum;
@synthesize imgUrl;
@synthesize count;
@synthesize musicArray;



- (id)init
{
    self = [super init];
    if (self) {
        self.mediaType = mediaTypeAlbum;
    }
    return self;
}

-(Album *)initAlbumByDictionary:(NSDictionary *)dict{
    Album *album=[[Album alloc] init];
    if([dict objectForKey:@"program_id"]){
        album.mediaId=[dict objectForKey:@"program_id"];
    }
    album.title=[dict objectForKey:@"program_name"] && ![[dict objectForKey:@"program_name"] isKindOfClass:[NSNull class]]?[dict objectForKey:@"program_name"]:@"";
    album.icon=[dict objectForKey:@"program_icon"] && ![[dict objectForKey:@"program_icon"] isKindOfClass:[NSNull class]]?[dict objectForKey:@"program_icon"]:@"";
    album.imgUrl=[dict objectForKey:@"program_images"] && ![[dict objectForKey:@"program_images"] isKindOfClass:[NSNull class]]?[dict objectForKey:@"program_images"]:@"";
    album.cover=[dict objectForKey:@"program_cover"] && ![[dict objectForKey:@"program_cover"] isKindOfClass:[NSNull class]]?[dict objectForKey:@"program_cover"]:@"";
    album.notice=[dict objectForKey:@"program_notice"] && ![[dict objectForKey:@"program_notice"] isKindOfClass:[NSNull class]]?[dict objectForKey:@"program_notice"]:@"";
    album.introduction=[dict objectForKey:@"program_intro"] && ![[dict objectForKey:@"program_intro"] isKindOfClass:[NSNull class]]?[dict objectForKey:@"program_intro"]:@"";
    album.languages=[dict objectForKey:@"program_languages"] && ![[dict objectForKey:@"program_languages"] isKindOfClass:[NSNull class]]?[dict objectForKey:@"program_languages"]:nil;
    
    album.mediaTag=[dict objectForKey:@"program_tag"] && ![[dict objectForKey:@"program_tag"] isKindOfClass:[NSNull class]]?[dict objectForKey:@"program_tag"]:@"";
    album.timeLength=[dict valueForKey:@"subject_duration"] && ![[dict objectForKey:@"subject_duration"] isKindOfClass:[NSNull class]]?[dict valueForKey:@"subject_duration"]:0;
    album.subscriptionSum=[dict valueForKey:@"program_orders"];
    album.downloadSum=[dict valueForKey:@"program_downloads"];
    album.count=[dict valueForKey:@"subject_count"];
    album.subjectTitle=[dict objectForKey:@"subject_title"] && ![[dict objectForKey:@"subject_title"] isKindOfClass:[NSNull class]]?[dict objectForKey:@"subject_title"]:@"";
    album.subjectAddTime=[dict valueForKey:@"subject_add_time"];
    album.date=[dict valueForKey:@"program_add_time"];
    
    if([dict objectForKey:@"user_id"]){
        album.owner=[[Announcer alloc] initAnnouncerById:[dict objectForKey:@"user_id"]];
    }else{
        album.owner.nickName=[dict objectForKey:@"user_name"]?[dict objectForKey:@"user_name"]:@"";
        album.owner.icon=[dict objectForKey:@"user_icon"]?[dict objectForKey:@"user_icon"]:@"";
    }
    
    
    
    return album;
}

-(void)orderAlbum:(void(^)(void))success failure:(void(^)(NSString *))failure state:(int)state{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]){
        failure(@"您还未登录");
        return;
    }
    NSString *url=[UrlAPI getProgramOrder];
//    NSLog(@"url:%@",url);
    NSDictionary *parameters = @{@"program_id":self.mediaId,@"order":[NSNumber numberWithInt:state]};
//    NSLog(@"parameters:%@",parameters);
    [UPHTTPTools post:url params:parameters success:^(id responseObj) {
        NSNumber *code=[responseObj objectForKey:@"code"];
        if([code isEqualToNumber:[NSNumber numberWithInt:0]]){
            success();
        }else{
            failure([responseObj objectForKey:@"msg"]);
        }
        
    } failure:^(NSError *error){
        if([[UPHTTPTools sharedClient] isEqualToString:@"no"]){
            failure(@"未知错误");
        }else{
            failure(@"未知错误");
        }
        
    }];
}




-(Album *)getAlbumById:(NSNumber *)mediaId{
    Album *album=[[Album alloc] init];
    return album;
}


@end
