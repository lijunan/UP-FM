//
//  PlayerViewController.h
//  UP FM
//
//  Created by liubin on 15/1/29.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMViewController.h"
#import "CommentListView.h"
#import "Album.h"

@interface PlayerViewController : UPFMViewController<UIAlertViewDelegate,commentViewDelegate>{
    
    Music *music;
    Album *album;
    MCPlayerItem *mcPlayItem;
    
    //大图
    UIImageView *patternmakingImg;
    
    
    
    //播放器按钮
    UIButton *musicPlayBut;
    UIButton *musicStopBut;
    UIButton *musicRandomBut;
    UIButton *musicPrveBut;
    UIButton *musicNextBut;
    UIButton *musicTimerBut;
    
    
    //进度条
    UIView *progressBar;
    UIView *progressChunk;
    UIView *progressAlready;
    UILabel *progressAlreadyTopTime;
    UILabel *progressAlreadyTime;
    UIView *progressAvailableDuration;
    float progressHeight;
    float progressTop;
    float progressAlreadyHeight;
    float progressAlreadyWidth;
    float progressAlreadyTop;
    float progressAlreadyLeft;
    NSTimeInterval currentTime;
    NSTimeInterval durationTime;
    float touchStartLeft;
    BOOL isDrag;
    
    
    //音乐信息
    UIButton *infoView;
    
    //交互
    UIView *mutualView;
    NSArray *mutualArray;
    
    //赞
    UIButton *goodView;
    NSMutableArray *goodArray;
    
    //评论
    CommentListView *commentListView;
    NSMutableArray *commentArray;
    
    
    float mainTop;
    float mainHeight;
    
}

@end
