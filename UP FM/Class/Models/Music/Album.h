//
//  Album.h
//  UP FM
//
//  Created by liubin on 15-1-24.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "Media.h"

@interface Album : Media

@property (nonatomic, strong) NSNumber *playSum;    //播放次数
@property (nonatomic, strong) NSNumber *downloadSum;    //下载次数
@property (nonatomic, strong) NSNumber *commentsSum;    //评论次数
@property (nonatomic, strong) NSNumber *shareSum;      //分享次数
@property (nonatomic, strong) NSNumber *goodSum;      //赞次数
@property (nonatomic, strong) NSNumber *fansSum;      //粉丝数
@property (nonatomic, strong) NSNumber *subscriptionSum;  //订阅数
@property (nonatomic, strong) NSNumber *timeLength;      //总时间
@property (nonatomic, strong) NSNumber *timePlay;   //上次播放时间
@property (nonatomic, strong) NSString *contentPlay;    //上次播放内容
@property (nonatomic, strong) NSString *imgUrl;         //大图
@property (nonatomic, strong) NSNumber *count;  //节目主题数
@property (nonatomic, strong) NSString *subjectTitle;   //节目最后主题名称
@property (nonatomic, strong) NSNumber *subjectAddTime;    //节目最后主题添加时间
@property (nonatomic, strong) NSMutableArray *musicArray;   //音乐数组

-(Album *)initAlbumByDictionary:(NSDictionary *)dict;

-(Album *)getAlbumById:(NSNumber *)mediaId;

//订阅
-(void)orderAlbum:(void(^)(void))success failure:(void(^)(NSString *))failure state:(int)state;

@end
