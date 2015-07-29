//
//  Music.h
//  UP FM
//
//  Created by liubin on 15-1-24.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "Media.h"
#import "Album.h"
#import "DownloadedList.h"

@interface Music : Media


@property (nonatomic, strong) NSNumber *albumId;    //主题id
@property (nonatomic, strong) Album *album; //主题
@property (nonatomic, strong) NSNumber *timeLength;      //总时间
@property (nonatomic, strong) NSString *format;     //格式
@property (nonatomic, strong) NSNumber *index;      //专辑排位
@property (nonatomic, strong) NSNumber *sample;     //采样率
@property (nonatomic, strong) NSNumber *bit;        //位数
@property (nonatomic, strong) NSNumber *bitrate;    //速率
@property (nonatomic, strong) NSString *fileURL;    //音乐地址


@property (nonatomic, strong) NSNumber *playSum;    //播放次数
@property (nonatomic, strong) NSNumber *downloadSum;    //下载次数
@property (nonatomic, strong) NSNumber *commentsSum;    //评论次数
@property (nonatomic, strong) NSNumber *shareSum;      //分享次数
@property (nonatomic, strong) NSNumber *goodSum;      //赞次数

@property (nonatomic, strong) NSNumber *timePlay;   //上次播放时间
@property (nonatomic, assign) BOOL addPlaySum;



-(Music *)initMusicByDictionary:(NSDictionary *)dict;
-(Music *)initMusicByDownloaded:(DownloadedList *)song;
-(Music *)initMusicById:(NSNumber *)mediaId;

//下载
-(void)downloadMusic;
//下载数量+1
-(void)downloadSumAdd;
//赞
-(void)goodMusic:(void(^)(void))success failure:(void(^)(NSString *))failure;


-(Music *)getMusicById:(NSNumber *)mediaId;

@end
