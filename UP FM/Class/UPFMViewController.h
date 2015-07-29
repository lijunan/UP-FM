//
//  UPFMViewController.h
//  UP FM
//
//  Created by liubin on 15-1-22.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPFMBase.h"
#import "Music.h"
#import "Mica.h"
#import "UrlAPI.h"
#import "CurrentUser.h"
#import "GPS.h"



@interface UPFMViewController : UIViewController<GPSDelegate>{
    
    
    
    float NAV_HEIGHT;    //导航栏高
    #pragma mark
    float STATUS_BAR_HEIGHT; //状态栏高
    
    UIButton *navMusicButton;
    
    
    //当前音乐
    NSString *documentPath;
    NSString *currentMusicFileName;
    
    
    
    MCPlayerItem  *_currentItem;
    
    GPS *_gps;
    
}

@property(nonatomic,strong) MCPlayer *mcPlayer;
@property(nonatomic,assign) NSTimeInterval playTime;

-(void)musicContinuePlay;
-(void)musicPause;

-(void)pushViewLeft:(id)view;
-(void)pushViewRight:(id)view;
-(void)pushView:(id)view;

-(void)goToBack;
-(void)goToBack:(int)index;
-(void)goToHome;
-(void)goToHome:(BOOL) animate;

//加载右侧音乐播放器按钮
-(void)navMusicButtonHide:(BOOL)hide;

-(void)navBackShow;

-(void)musicPlay:(NSMutableArray *)musicArray index:(NSInteger)index;




@end
