//
//  MCPlayer.m
//  Mica
//
//  Created by hiseh yin on 13-6-4.
//  Copyright (c) 2013年 movivi. All rights reserved.
//

#import "MCPlayer.h"
#import "Music.h"
#import "CurrentUser.h"
#import "MCMath.h"
#import "UPFMBase.h"
#import "UrlAPI.h"
#import "UPHTTPTools.h"
#import "PlayHistoryController.h"
#import "DownloadController.h"


@implementation MCPlayer
@synthesize musicArray = _playerDataSource;
@synthesize order, repeat;

static MCPlayerItem *currentMCPlayerItem;
+ (MCPlayer *)sharedInstance
{
    static dispatch_once_t onceToken;
    static MCPlayer *mcPlayer;
    dispatch_once(&onceToken, ^{
        mcPlayer = [[self alloc] init];
        mcPlayer.order = YES;
        mcPlayer.repeat = NO;
        currentMCPlayerItem = [[MCPlayerItem alloc] init];
    });
    return mcPlayer;
}

#pragma mark - 初始化播放器
- (void)initPlayer:(NSArray *)musicArray
{
    [_queuePlayer pause];
    //初始化播放列表
    self.playerMusicArray=[NSMutableArray arrayWithArray:musicArray];
    _playerDataSource = [[NSMutableArray alloc] initWithCapacity:musicArray.count];
    _queuePlayerDataSource = [[NSMutableArray alloc] initWithCapacity:musicArray.count];
    for (Music *music in musicArray) {
        MCPlayerItem *playerItem = [[MCPlayerItem alloc] init];
        AVPlayerItem *queryPlayerItem;
        if ([[DownloadController sharedInstance] downloadState:music] == Downloaded) {
            
            queryPlayerItem = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:[[DownloadController sharedInstance] getDownloadedFile:music]]];
            
        } else {
            
            queryPlayerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:music.fileURL]];
            
        }
        
        playerItem.encryption = MPEG1_LAYER3;
        
        
        
        playerItem.song = music;
        [_playerDataSource addObject:playerItem];
        
        [_queuePlayerDataSource addObject:queryPlayerItem];
    }
    _prevIndex = -1;
    _seekToZeroBeforePlay = NO;
    
    //初始化播放器
    _queuePlayer = [[AVQueuePlayer alloc] initWithItems:_queuePlayerDataSource];
    
    //后台播放
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    //监听
    __weak MCPlayer *weakSelf = self;
    CMTime interval = CMTimeMake(1, 10);
    [_queuePlayer addPeriodicTimeObserverForInterval:interval
                                               queue:NULL
                                          usingBlock:^(CMTime time) {
                                              [weakSelf refreshCurrItemInfo];
                                          }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[_queuePlayer currentItem]];
}

#pragma mark - 播放控制
- (void)play:(NSInteger)index
{
    
    [_queuePlayer removeAllItems];
    for (int i = (int)index; i < _queuePlayerDataSource.count; i ++) {
        AVPlayerItem *obj = [_queuePlayerDataSource objectAtIndex:i];
        if ([_queuePlayer canInsertItem:obj afterItem:nil]){
            [_queuePlayer insertItem:obj afterItem:nil];
        }
    }
    
    if (_seekToZeroBeforePlay) {
        [_queuePlayer seekToTime:kCMTimeZero];
        _seekToZeroBeforePlay = NO;
    }
    
    [self play];
}
#pragma mark 上一首
- (void)playPrev
{
    if (self.order) {
        for (int i = 0; i < [_queuePlayerDataSource count]; i ++) {
            AVPlayerItem *obj = [_queuePlayerDataSource objectAtIndex:i];
            if ([obj isEqual:_queuePlayer.currentItem]) {
                if (i == 0) {
                    [self play:[_queuePlayerDataSource count] - 1];
                    break;
                } else {
                    [self play:-- i];
                    break;
                }
            }
        }
    } else {
        NSInteger i = [NSNumber random:[_queuePlayerDataSource count]]- 1;
        [self play:i];
    }
}
#pragma mark 播放
- (void)play
{
    
    _seekToZeroBeforePlay = NO;
    [_queuePlayer play];
    _mRestoreAfterScrubbingRate = _queuePlayer.rate;
    [self refreshCurrItemInfo];
}

#pragma mark 暂停
- (void)pause
{
    [_queuePlayer pause];
    _mRestoreAfterScrubbingRate = 0.f;
    _queuePlayer.rate = 0.f;
}

#pragma mark 下一首
- (void)playNext
{
    AVPlayerItem *obj = [_queuePlayerDataSource lastObject];
    if ([obj isEqual:_queuePlayer.currentItem]) {
        if (self.repeat) {
            [self play:0];
        } else {
            [_queuePlayer pause];
        }
    } else {
        if (self.order) {
            [_queuePlayer advanceToNextItem];
            [self refreshCurrItemInfo];
        } else {
            NSInteger i = [NSNumber random:[_queuePlayerDataSource count]] - 1;
            [self play:i];
        }
    }
    
}
#pragma mark seek to time
- (void)seekToTime:(NSTimeInterval)time
{
    NSTimeInterval tempTime = time < [self availableDuration]? time: [self availableDuration] - 20;
    CMTime seekTime = CMTimeMake((NSInteger)tempTime, 1);
    [_queuePlayer seekToTime:seekTime];
}

#pragma mark - 当前播放坐标
- (NSUInteger)currIndex{
    AVPlayerItem *currentItem = _queuePlayer.currentItem;
    for (NSInteger i = 0; [_queuePlayerDataSource count]; i ++) {
        AVPlayerItem *obj = [_queuePlayerDataSource objectAtIndex:i];
        if ([obj isEqual:currentItem]) {
            return i;
        }
    }
    return 0;
}
#pragma mark 缓存进度
- (NSTimeInterval) availableDuration;
{
    NSArray *loadedTimeRanges = _queuePlayer.currentItem.loadedTimeRanges;
    CMTimeRange timeRange = [[loadedTimeRanges firstObject] CMTimeRangeValue];
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;
    return result;
}

#pragma mark 刷新数据
- (void)refreshCurrItemInfo
{
    if (_queuePlayer.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        NSUInteger currIndex = [self currIndex];
        currentMCPlayerItem = [_playerDataSource objectAtIndex:currIndex];
        currentMCPlayerItem.indexRow = currIndex;
        currentMCPlayerItem.availableDuration = [self availableDuration];
        currentMCPlayerItem.duration = CMTimeGetSeconds(_queuePlayer.currentItem.duration);
        currentMCPlayerItem.currentTime = CMTimeGetSeconds(_queuePlayer.currentItem.currentTime);
        
        if (_prevIndex != currentMCPlayerItem.indexRow) {
            _prevIndex = currentMCPlayerItem.indexRow;
            currentMCPlayerItem.isNew = YES;
            //添加到播放历史
            [[PlayHistoryController sharedInstance] playSong:currentMCPlayerItem.song];
            
        } else {
            currentMCPlayerItem.isNew = NO;
        }
        //播放1/4增加播放记录
        if(!currentMCPlayerItem.song.addPlaySum && currentMCPlayerItem.currentTime/currentMCPlayerItem.duration>0.25){
            currentMCPlayerItem.song.addPlaySum=YES;
            [self playSong:currentMCPlayerItem];
        }
        currentMCPlayerItem.playerItem = _queuePlayer.currentItem;
        [[NSNotificationCenter defaultCenter] postNotificationName:MCPlayerDidPlayingNotification
                                                            object:currentMCPlayerItem];
        
    }
    
}
#pragma mark 判断是否播放
- (BOOL)isPlaying
{
    //    return _queuePlayer.rate > 0.0;
    return _mRestoreAfterScrubbingRate != 0.f || _queuePlayer.rate != 0.f;
}

#pragma mark - 播放结束
- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    /* After the movie has played to its end time, seek back to time zero
     to play it again. */
    _seekToZeroBeforePlay = YES;
    _mRestoreAfterScrubbingRate = 0.f;
    NSLog(@"播放结束");
    if([self currIndex]==_playerDataSource.count-1){
        if (self.repeat) {
            [self play:0];
        } else {
            [self pause];
        }
    }else{
        [self playNext];
    }
    
    
}

#pragma mark - 增加播放记录
- (void)playSong:(MCPlayerItem *)_item{
    
    NSString *url=[UrlAPI getSubjectPlayAdd];
    NSDictionary *parameters = @{@"subject_id":_item.song.mediaId};
    [UPHTTPTools post:url params:parameters success:^(id responseObj) {
        NSNumber *code=[responseObj objectForKey:@"code"];
        if([code isEqualToNumber:[NSNumber numberWithInt:0]]){
//            NSLog(@"增加播放记录:%@",responseObj);
        }else{
            NSLog(@"增加播放记录:%@",[[responseObj objectForKey:@"msg"] uppercaseString]);
        }
        
    } failure:^(NSError *error){
        
    }];
    
}
@end
