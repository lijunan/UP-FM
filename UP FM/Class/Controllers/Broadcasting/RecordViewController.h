//
//  BrcordViewController.h
//  UP FM
//  节目录音页面
//  Created by liubin on 15/3/5.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMViewController.h"
#import "Record.h"
#import <AVFoundation/AVFoundation.h>


@interface RecordViewController : UPFMViewController<UIScrollViewDelegate,AVAudioRecorderDelegate>{
    
    //界面主体
    UIScrollView *mainView;
    float mainTop;
    float mainHeight;
    float mainContentHeight;
    
    //时间轴
    float timeShaftViewHeight;
    float timeShaftWidth;
    UIView *timeShaftPercentageView;
    float timeShaftPercentageViewTop;
    float timeShaftPercentageViewLeft;
    float timeShaftPercentageViewHeight;
    float timeShaftSliderWidth;
    float timeShaftSliderHeight;
    float timeShaftSliderLeft;
    
    int maxTime;
    int currentTime;
    
    //背景音乐
    float bgmViewHeight;
    UIScrollView *bgmView;
    
    float recordButtonViewHeight;
    
    //开始录音
    UIButton *recordStartButton;
    UILabel *recordStartText;
    
    //结束录音
    UIButton *recordEndButton;
    UILabel *recordEndText;
    
    //录音对象
    AVAudioRecorder *audioRecorder;
    NSMutableDictionary *recorderDict;
    
}

@property (nonatomic,strong) Record *record;



@end
