//
//  Music.m
//  UP FM
//
//  Created by liubin on 15-1-24.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "Music.h"
#import "Announcer.h"
#import "UrlAPI.h"
#import "Mica.h"
#import "DownloadController.h"


@implementation Music

@synthesize albumId;
@synthesize timeLength;
@synthesize format;
@synthesize sample;
@synthesize bit;
@synthesize bitrate;
@synthesize fileURL;
@synthesize playSum;
@synthesize downloadSum;
@synthesize commentsSum;
@synthesize shareSum;
@synthesize goodSum;
@synthesize addPlaySum;
@synthesize album;


- (id)init
{
    self = [super init];
    if (self) {
        self.mediaType = mediaTypeMusic;
        self.addPlaySum=NO;
    }
    return self;
}

-(Music *)initMusicByDictionary:(NSDictionary *)dict{
    Music *music=[[Music alloc] init];
    if([dict objectForKey:@"subject_id"]){
        music.mediaId=[dict objectForKey:@"subject_id"];
    }
    music.date=[dict objectForKey:@"subject_add_time"]?[dict objectForKey:@"subject_add_time"]:[NSNumber numberWithInt:0];
    music.bit=[dict objectForKey:@"subject_bit"]?[dict objectForKey:@"subject_bit"]:[NSNumber numberWithInt:0];
    music.bitrate=[dict objectForKey:@"subject_bitrate"]?[dict objectForKey:@"subject_bitrate"]:[NSNumber numberWithInt:0];
    music.commentsSum=[dict objectForKey:@"subject_comment"]?[dict objectForKey:@"subject_comment"]:[NSNumber numberWithInt:0];
    music.cover=[dict objectForKey:@"subject_cover"]?[dict objectForKey:@"subject_cover"]:nil;
    music.downloadSum=[dict objectForKey:@"subject_download"]?[dict objectForKey:@"subject_download"]:[NSNumber numberWithInt:0];
    music.timeLength=[dict objectForKey:@"subject_duration"]?[NSNumber numberWithInt:[[dict objectForKey:@"subject_duration"] intValue]/1000]:[NSNumber numberWithInt:0];
    music.format=[dict objectForKey:@"format"]?[dict objectForKey:@"format"]:@"mp3";
    music.icon=[dict objectForKey:@"subject_icon"]?[dict objectForKey:@"subject_icon"]:nil;
    music.index=[dict objectForKey:@"subject_index"]?[dict objectForKey:@"subject_index"]:[NSNumber numberWithInt:0];
    music.playSum=[dict objectForKey:@"subject_listen"]?[dict objectForKey:@"subject_listen"]:[NSNumber numberWithInt:0];
    music.goodSum=[dict objectForKey:@"subject_praise"]?[dict objectForKey:@"subject_praise"]:[NSNumber numberWithInt:0];
    music.shareSum=[dict objectForKey:@"subject_share"]?[dict objectForKey:@"subject_share"]:[NSNumber numberWithInt:0];
    music.title=[dict objectForKey:@"subject_title"]?[dict objectForKey:@"subject_title"]:@"";
    music.fileURL=[dict objectForKey:@"subject_url"]?[dict objectForKey:@"subject_url"]:@"";
    music.albumId=[dict objectForKey:@"program_id"]?[dict objectForKey:@"program_id"]:[NSNumber numberWithInt:0];
    return music;
}

-(Music *)initMusicByDownloaded:(DownloadedList *)song{
    
    Music *music=[[Music alloc] init];
    
    music.mediaId=song.mediaId;
    music.title=song.title;
    music.icon=song.icon;
    music.cover=song.cover;
    music.fileURL=song.fileURL;
    music.introduction=song.introduction;
    music.notice=song.notice;
    music.date=song.date;
    music.format=song.format;
    music.timeLength=song.timeLength;
    music.albumId=song.albumId;
    music.index=song.index;
    music.sample=song.sample;
    music.bit=song.bit;
    music.bitrate=song.bitrate;
    music.playSum=song.playSum;
    music.downloadSum=song.downloadSum;
    music.commentsSum=song.commentsSum;
    music.shareSum=song.shareSum;
    music.goodSum=song.goodSum;
    music.timePlay=song.timePlay;
    
    music.album=[[Album alloc] init];
    music.album.mediaId=song.albumId;
    music.album.title=song.albumTitle;
    music.album.mediaTag=song.albumTag;
    music.album.icon=song.albumIcon;
    
    music.mediaType = mediaTypeDownloadMusic;
    return music;
}



-(Music *)initMusicById:(NSNumber *)mediaId{
    Music *music=[[Music alloc] init];
    
    return music;
}

//下载
-(void)downloadMusic{
    [[DownloadController sharedInstance] addToQueue:self];
}
//下载数量+1
-(void)downloadSumAdd{
    NSString *url=[UrlAPI getSubjectDownloadAdd];
    //    NSLog(@"%@",url);
    NSDictionary *parameters = @{@"subject_id":self.mediaId};
    [UPHTTPTools post:url params:parameters success:^(id responseObj) {
//        NSLog(@"下载+");
        
    } failure:^(NSError *error){
        if([[UPHTTPTools sharedClient] isEqualToString:@"no"]){
           
        }else{

        }
        
    }];
}
//赞
-(void)goodMusic:(void(^)(void))success failure:(void(^)(NSString *))failure{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]){
        failure(@"您还未登录");
        return;
    }
    NSString *url=[UrlAPI getSubjectGoodAdd];
//    NSLog(@"%@",url);
    NSDictionary *parameters = @{@"subject_id":self.mediaId};
    //    NSLog(@"url:%@",url);
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


-(Music *)getMusicById:(NSNumber *)mediaId{
    Music *music=[[Music alloc] init];
    
    music.mediaId=mediaId;
    
    
    
    return music;
}

@end
