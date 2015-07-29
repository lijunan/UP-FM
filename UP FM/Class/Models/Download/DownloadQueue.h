//
//  DownloadQueue.h
//  iDouKou
//
//  Created by hiseh yin on 14-5-5.
//  Copyright (c) 2014年 vividomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DownloadQueue : NSManagedObject

@property(nonatomic,retain) NSNumber *mediaId;  //音乐id
@property(nonatomic,retain) NSString *title;    //标题
@property(nonatomic,retain) NSString *icon;     //图标
@property(nonatomic,retain) NSString *iconUrl;  //图标地址
@property(nonatomic,retain) NSString *cover;  //封面图
@property(nonatomic,retain) NSString *coverUrl;  //封面图地址
@property(nonatomic,retain) NSString *fileURL;  //音乐本地地址
@property(nonatomic,retain) NSString *songUrl;  //音乐地址
@property (nonatomic,retain) NSString *introduction;    //简介
@property (nonatomic,retain) NSString *notice; //公告
@property (nonatomic, retain) NSNumber *date;    //日期
@property(nonatomic,retain) NSString *format;   //格式
@property(nonatomic,retain) NSNumber *timeLength;   //总时间

@property(nonatomic,retain) NSNumber *index;    //专辑排位
@property(nonatomic,retain) NSNumber *sample;     //采样率
@property(nonatomic,retain) NSNumber *bit;        //位数
@property(nonatomic,retain) NSNumber *bitrate;    //速率
@property (nonatomic, retain) NSNumber *playSum;    //播放次数
@property (nonatomic, retain) NSNumber *downloadSum;    //下载次数
@property (nonatomic, retain) NSNumber *commentsSum;    //评论次数
@property (nonatomic, retain) NSNumber *shareSum;      //分享次数
@property (nonatomic, retain) NSNumber *goodSum;      //赞次数
@property (nonatomic, retain) NSNumber *timePlay;   //上次播放时间
@property (nonatomic, retain) NSDate * createDate;  //下载时间

@property(nonatomic,retain) NSNumber *albumId;  //主题id
@property (nonatomic, retain) NSString *albumTitle; //主题title
@property (nonatomic, retain) NSString *albumTag;   //主题albumTag
@property (nonatomic, retain) NSString *albumIcon;  //主题icon

@property (nonatomic, retain) NSString *currentUserId; //下载用户id

@property (nonatomic, retain) NSNumber * downloadState;
@property (nonatomic, retain) NSNumber * totalBytesExpectedToRead;
@property (nonatomic, retain) NSNumber * totalBytesRead;
@end
