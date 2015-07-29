//
//  MCPlayer.h
//  Mica
//
//  Created by hiseh yin on 13-6-4.
//  Copyright (c) 2013年 movivi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "MCPlayerItem.h"

@interface MCPlayer : NSObject {
@private
    /**
     解码器，可以自动播放队列
     */
    AVQueuePlayer   *_queuePlayer;
    
    /**
     解码器用的播放列表
     */
    NSMutableArray  *_queuePlayerDataSource;
    
    /**
     为了与其它模块沟通，而设定的一个列表
     */
    NSMutableArray  *_playerDataSource;
    
    /**
     播放元素，也是为了和其它模块沟通用
     */
    AVPlayerItem    *_playerItem;
    
    /**
     上一个播放坐标
     */
    NSInteger       _prevIndex;
    
    /**
     回放速度。1-正常播放；0-停啦
     */
    float           _mRestoreAfterScrubbingRate;
    
    /**
     是否从头开始播放
     */
    BOOL            _seekToZeroBeforePlay;
    
}
/**
 一个数组，数组元素是music对象（就用到其中的fileURL属性）
 */
@property (nonatomic, strong) NSMutableArray *musicArray;
@property (nonatomic, strong) NSMutableArray *playerMusicArray;

/**
 是否顺序播放
 */
@property (nonatomic, assign) BOOL order;

/**
 是否循环播放
 */
@property (nonatomic, assign) BOOL repeat;

@property (nonatomic, assign) NSInteger index;


+ (MCPlayer *)sharedInstance;
/**
 初始化播放列表
 @param musicArray 一个数组，数组元素是music对象（就用到其中的fileURL属性）
 */
- (void)initPlayer:(NSArray *)musicArray;

/**
 播放指定index的歌曲
 */
- (void)play:(NSInteger)index;
/**
 播上一首
 */
- (void)playPrev;
/**
 播下一首
 */
- (void)playNext;
/**
 从指定时间开始播放
 @param time 秒值
 */
- (void)seekToTime:(NSTimeInterval)time;
/**
 解码器是否在播放
 */
- (BOOL)isPlaying;
/**
 暂停播放
 */
- (void)pause;
/**
 * 当前播放坐标
 */
- (NSUInteger)currIndex;
@end
