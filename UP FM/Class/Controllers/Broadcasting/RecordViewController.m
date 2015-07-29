//
//  BrcordViewController.m
//  UP FM
//
//  Created by liubin on 15/3/5.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "RecordViewController.h"
#import "Functions.h"
#import "MarqueeLabel.h"

@interface RecordViewController ()

@end

@implementation RecordViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"录音";
    [self navBackShow];
    
    maxTime=RECORD_TIME_MAX;
    currentTime=0;
    
    //停止正播放的音乐
    [self musicPause];
    
    //设置导航右侧完成按钮
    UIButton *finishButton=[Functions initBarRightButton:BarButtonTypeFinishWhite];
    [finishButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:finishButton];
    
    self.view.backgroundColor=[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1];
    
    //获取当前应用的音频会话
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置音频类别
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    //激活当前应用的音频会话
    [audioSession setActive:YES error:nil];
    
    [self initView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self setNavStyle];
    [self setMainHeight];
    
}

-(void)initView{
    //主体
    mainTop=0;
    mainHeight=WIN_HEIGHT-mainTop-NAV_HEIGHT;
    
    mainView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, mainTop, WIN_WIDTH, mainHeight)];
    mainView.delegate=self;
    mainView.bounces=NO;
    mainView.scrollEnabled=YES;
    mainView.showsHorizontalScrollIndicator=NO;
    mainView.showsVerticalScrollIndicator=NO;
    mainView.maximumZoomScale=1;
    mainView.minimumZoomScale=1;
    [self.view addSubview:mainView];
    
    //时间轴
    timeShaftViewHeight=WIN_WIDTH*(304.0/DESING_WIDTH);
    
    UIView *timeShaftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, timeShaftViewHeight)];
    [mainView addSubview:timeShaftView];
    UIImageView *timeShaftBj=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, timeShaftViewHeight)];
    timeShaftBj.image=[UIImage imageNamed:@"bj-becord"];
    [timeShaftView addSubview:timeShaftBj];
    
    timeShaftSliderWidth=63*(WIN_WIDTH/DESING_WIDTH);
    timeShaftSliderHeight=26*(WIN_WIDTH/DESING_WIDTH);
    timeShaftWidth=620*(WIN_WIDTH/DESING_WIDTH)-timeShaftSliderWidth+3;
    timeShaftPercentageViewTop=175*(WIN_WIDTH/DESING_WIDTH);
    timeShaftPercentageViewLeft=(WIN_WIDTH-620*(WIN_WIDTH/DESING_WIDTH))/2;
    timeShaftPercentageViewHeight=5*(WIN_WIDTH/DESING_WIDTH);
    
    //时间进度条
    timeShaftPercentageView=[[UIView alloc] initWithFrame:CGRectMake(timeShaftPercentageViewLeft, timeShaftPercentageViewTop, 0, timeShaftPercentageViewHeight)];
    timeShaftPercentageView.backgroundColor=[UIColor colorWithRed:0.93 green:0.42 blue:0.12 alpha:1.0];
    timeShaftPercentageView.layer.cornerRadius=1.5;
    [timeShaftView addSubview:timeShaftPercentageView];
    //滑块
    timeShaftSliderLeft=timeShaftPercentageView.frame.size.width-2;
    UIImageView *timeShaftSlider=[[UIImageView alloc] initWithFrame:CGRectMake(timeShaftSliderLeft, -(timeShaftSliderHeight-timeShaftPercentageViewHeight)/2, timeShaftSliderWidth, timeShaftSliderHeight)];
    timeShaftSlider.image=[UIImage imageNamed:@"but-record-slider"];
    [timeShaftPercentageView addSubview:timeShaftSlider];
    
    float timeTextTop=timeShaftPercentageViewTop+timeShaftPercentageViewHeight+23;
    UILabel *currentTimeView=[[UILabel alloc] initWithFrame:CGRectMake(WIN_WIDTH/2-80, timeTextTop, 80, 20)];
    currentTimeView.text=[self timeToString:currentTime];
    currentTimeView.textColor=[UIColor colorWithRed:0.93 green:0.42 blue:0.12 alpha:1.0];
    currentTimeView.textAlignment=NSTextAlignmentRight;
    currentTimeView.font=FONT_14;
    [timeShaftView addSubview:currentTimeView];
    UILabel *maxTimeView=[[UILabel alloc] initWithFrame:CGRectMake(WIN_WIDTH/2, timeTextTop, 80, 20)];
    maxTimeView.text=[NSString stringWithFormat:@"/%@",[self timeToString:maxTime]];
    maxTimeView.textColor=[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    maxTimeView.font=FONT_14;
    [timeShaftView addSubview:maxTimeView];
    
    float bgmViewTop=timeShaftViewHeight;
    float bgmMusicViewHeight=89*(WIN_WIDTH/DESING_WIDTH);
    
    bgmViewHeight=bgmMusicViewHeight*2+3;
    float bgmVolumeButtonWidth=138*(WIN_WIDTH/DESING_WIDTH);
    float bgmVolumeHideWidth=82*(WIN_WIDTH/DESING_WIDTH);
    float bgmMusicViewWidth=WIN_WIDTH-bgmVolumeButtonWidth-1;
    float bgmViewWidth=WIN_WIDTH*2;
    
    bgmView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, bgmViewTop, WIN_WIDTH, bgmViewHeight)];
    bgmView.delegate=self;
    bgmView.contentSize=CGSizeMake(bgmViewWidth, bgmViewHeight);
    bgmView.backgroundColor=[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    bgmView.pagingEnabled=YES;
    bgmView.showsVerticalScrollIndicator=NO;
    bgmView.showsHorizontalScrollIndicator=NO;
    bgmView.bounces=NO;
    bgmView.scrollEnabled=NO;
    
    [mainView addSubview:bgmView];
    UIView *bgmViewLine1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, bgmViewWidth, 1)];
    bgmViewLine1.backgroundColor=[UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:1];
    [bgmView addSubview:bgmViewLine1];
    UIView *bgmViewLine2=[[UIView alloc] initWithFrame:CGRectMake(0, bgmMusicViewHeight+1, bgmMusicViewWidth, 1)];
    bgmViewLine2.backgroundColor=[UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:1];
    [bgmView addSubview:bgmViewLine2];
    UIView *bgmViewParting=[[UIView alloc] initWithFrame:CGRectMake(WIN_WIDTH-bgmVolumeButtonWidth-1,1, 1, bgmViewHeight-2)];
    bgmViewParting.backgroundColor=[UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:1];
    [bgmView addSubview:bgmViewParting];
    UIView *bgmViewLine4=[[UIView alloc] initWithFrame:CGRectMake(0, bgmViewHeight-1, bgmViewWidth, 1)];
    bgmViewLine4.backgroundColor=[UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:1];
    [bgmView addSubview:bgmViewLine4];
    UIView *bgmViewLine5=[[UIView alloc] initWithFrame:CGRectMake(WIN_WIDTH-0.5,1, 1, bgmViewHeight-2)];
    bgmViewLine5.backgroundColor=[UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:1];
    [bgmView addSubview:bgmViewLine5];
    UIView *bgmViewLine6=[[UIView alloc] initWithFrame:CGRectMake(WIN_WIDTH+bgmVolumeHideWidth,1, 1, bgmViewHeight-2)];
    bgmViewLine6.backgroundColor=[UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:1];
    [bgmView addSubview:bgmViewLine6];
    
    //添加背景音乐
    float bgmMusicButtonWidth=bgmMusicViewHeight-10;
    float bgmLoopLeft=bgmMusicViewWidth-bgmMusicButtonWidth-10;
    float bgmPlayLeft=bgmMusicViewWidth-bgmMusicButtonWidth*2-10;
    float bgmTimeLengthWidth=50.0;
    float bgmTimeLengthLeft=bgmPlayLeft-bgmTimeLengthWidth;
    float bgmTitleLeft=10+bgmMusicButtonWidth;
    float bgmTitleWidth=bgmMusicViewWidth-bgmTitleLeft-(bgmMusicViewWidth-bgmTimeLengthLeft)-5;
    for (int i=0; i<2; i++) {
        
        UIView *bgmMusicView=[[UIView alloc] initWithFrame:CGRectMake(0, (bgmMusicViewHeight+1)*i+1, bgmMusicViewWidth, bgmMusicViewHeight)];
        [bgmView addSubview:bgmMusicView];
        //添加
        UIButton *muaicAdd=[[UIButton alloc] initWithFrame:CGRectMake(10, 0, bgmMusicButtonWidth, bgmMusicViewHeight)];
        [bgmMusicView addSubview:muaicAdd];
        UIImageView *addIcon=[[UIImageView alloc] initWithFrame:CGRectMake(3, 8, bgmMusicButtonWidth-6, bgmMusicViewHeight-16)];
        addIcon.image=[UIImage imageNamed:@"but-record-add"];
        [muaicAdd addSubview:addIcon];
        
        //循环
        UIButton *musicLoop=[[UIButton alloc] initWithFrame:CGRectMake(bgmLoopLeft, 0, bgmMusicButtonWidth, bgmMusicViewHeight)];
        
        [bgmMusicView addSubview:musicLoop];
        musicLoop.hidden=YES;
        UIImageView *loopIcon=[[UIImageView alloc] initWithFrame:CGRectMake(3, 8, bgmMusicButtonWidth-6, bgmMusicViewHeight-16)];
        loopIcon.image=[UIImage imageNamed:@"record-loop"];
        [musicLoop addSubview:loopIcon];
        UIButton *musicLoopOn=[[UIButton alloc] initWithFrame:CGRectMake(bgmLoopLeft, 0, bgmMusicViewHeight, bgmMusicViewHeight)];
        musicLoopOn.hidden=YES;
        [bgmMusicView addSubview:musicLoopOn];
        UIImageView *loopOnIcon=[[UIImageView alloc] initWithFrame:CGRectMake(3, 8, bgmMusicViewHeight-6, bgmMusicViewHeight-16)];
        loopOnIcon.image=[UIImage imageNamed:@"record-loop-on"];
        [musicLoopOn addSubview:loopOnIcon];
        
        //播放
        UIButton *musicPlay=[[UIButton alloc] initWithFrame:CGRectMake(bgmPlayLeft, 0, bgmMusicButtonWidth, bgmMusicViewHeight)];
        musicPlay.hidden=YES;
        [bgmMusicView addSubview:musicPlay];
        UIImageView *musicPlayIcon=[[UIImageView alloc] initWithFrame:CGRectMake(3, 8, bgmMusicButtonWidth-6, bgmMusicViewHeight-16)];
        musicPlayIcon.image=[UIImage imageNamed:@"record-play"];
        [musicPlay addSubview:musicPlayIcon];
        //暂停
        UIButton *musicStop=[[UIButton alloc] initWithFrame:CGRectMake(bgmPlayLeft, 0, bgmMusicButtonWidth, bgmMusicViewHeight)];
        musicStop.hidden=YES;
        [bgmMusicView addSubview:musicStop];
        UIImageView *musicStopIcon=[[UIImageView alloc] initWithFrame:CGRectMake(3, 8, bgmMusicButtonWidth-6, bgmMusicViewHeight-16)];
        musicStopIcon.image=[UIImage imageNamed:@"record-stop"];
        [musicStop addSubview:musicStopIcon];
        
        //时间长度
        UILabel *musicTimeLength=[[UILabel alloc] initWithFrame:CGRectMake(bgmTimeLengthLeft, 0, bgmTimeLengthWidth, bgmMusicViewHeight)];
        musicTimeLength.hidden=YES;
        musicTimeLength.text=@"";
        musicTimeLength.font=FONT_12;
        musicTimeLength.textColor=[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        musicTimeLength.textAlignment=NSTextAlignmentRight;
        [bgmMusicView addSubview:musicTimeLength];
        
        MarqueeLabel *musicTitleView=[[MarqueeLabel alloc] initWithFrame:CGRectMake(bgmTitleLeft, 0, bgmTitleWidth, bgmMusicViewHeight)];
        
        musicTitleView.font=FONT_12;
        musicTitleView.textColor=[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        musicTitleView.marqueeType = MLContinuous;
        musicTitleView.scrollDuration = 20.0f;
        musicTitleView.fadeLength =5.0f;
        musicTitleView.trailingBuffer = 50.0f;
        musicTitleView.text=@"点击添加音乐";
        [bgmMusicView addSubview:musicTitleView];
        
    }
    
    //显示音量按钮
    UIButton *bgmVolumeShow=[[UIButton alloc] initWithFrame:CGRectMake(WIN_WIDTH-bgmVolumeButtonWidth, 1, bgmVolumeButtonWidth, bgmViewHeight-2)];
    [bgmVolumeShow addTarget:self action:@selector(bgmVolumeShowParss) forControlEvents:UIControlEventTouchUpInside];
    [bgmView addSubview:bgmVolumeShow];
    float bgmVolumeShowIconWidth=44*(WIN_WIDTH/DESING_WIDTH);
    UIImageView *bgmVolumeShowIcon=[[UIImageView alloc] initWithFrame:CGRectMake((bgmVolumeButtonWidth-bgmVolumeShowIconWidth)/2, (bgmViewHeight-2-bgmVolumeShowIconWidth)/2, bgmVolumeShowIconWidth, bgmVolumeShowIconWidth)];
    bgmVolumeShowIcon.image=[UIImage imageNamed:@"icon-record-volume"];
    [bgmVolumeShow addSubview:bgmVolumeShowIcon];
    
    UIButton *bgmVolumeHide=[[UIButton alloc] initWithFrame:CGRectMake(WIN_WIDTH, 1, bgmVolumeHideWidth, bgmViewHeight-2)];
    [bgmVolumeHide addTarget:self action:@selector(bgmVolumeHideParss) forControlEvents:UIControlEventTouchUpInside];
    [bgmView addSubview:bgmVolumeHide];
    UIImageView *bgmVolumeHideIcon=[[UIImageView alloc] initWithFrame:CGRectMake((bgmVolumeHideWidth-bgmVolumeShowIconWidth)/2, (bgmViewHeight-2-bgmVolumeShowIconWidth)/2, bgmVolumeShowIconWidth, bgmVolumeShowIconWidth)];
    bgmVolumeHideIcon.image=[UIImage imageNamed:@"icon-arrows-right"];
    [bgmVolumeHide addSubview:bgmVolumeHideIcon];
    
    float bgmVolumeIconLeft=WIN_WIDTH+bgmVolumeHideWidth+10;
    UIImageView *bgmVolumeIcon=[[UIImageView alloc] initWithFrame:CGRectMake(bgmVolumeIconLeft, (bgmViewHeight-2-bgmVolumeShowIconWidth)/2, bgmVolumeShowIconWidth, bgmVolumeShowIconWidth)];
    bgmVolumeIcon.image=[UIImage imageNamed:@"icon-record-volume"];
    [bgmView addSubview:bgmVolumeIcon];
    
    float bgmVlumeLeft=bgmVolumeIconLeft+bgmVolumeShowIconWidth+10;
    float bgmVlumeWidth=WIN_WIDTH-bgmVolumeHideWidth-bgmVolumeShowIconWidth-10-10-10;
    UISlider *bgmVlume=[[UISlider alloc] initWithFrame:CGRectMake(bgmVlumeLeft, 20,bgmVlumeWidth, bgmViewHeight-2-40)];
    bgmVlume.minimumValue=0;
    bgmVlume.maximumValue=100;
    bgmVlume.value=50;
    
    [bgmVlume setMinimumTrackImage:[Functions imageWithColor:[UIColor colorWithRed:1 green:0.45 blue:0.3 alpha:1] size:CGSizeMake(bgmVlumeWidth, 2)] forState:UIControlStateNormal];
    [bgmVlume setMaximumTrackImage:[Functions imageWithColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] size:CGSizeMake(bgmVlumeWidth, 2)] forState:UIControlStateNormal];
    UIImage *bgmVlumeThumb=[[Functions imageWithColor:[UIColor colorWithRed:0.99 green:0.45 blue:0.3 alpha:1] size:CGSizeMake(16, 16)] cutImageWithRadius:4];
    [bgmVlume setThumbImage:bgmVlumeThumb forState:UIControlStateNormal];
    [bgmView addSubview:bgmVlume];
    
    float recordButtonViewTop=bgmViewTop+bgmViewHeight;
    float recordButtonWidth=(350-28)*(WIN_WIDTH/DESING_WIDTH);
    float recordButtonTop=50.0;
    float recordTextTop=recordButtonTop+recordButtonWidth+20;
    float recordTextHeight=10.0;
    float recordButtonIconWidth=60.0;
    
    recordButtonViewHeight=recordButtonTop+recordButtonWidth+20+recordTextHeight;
    
    UIView *recordButtonView=[[UIView alloc] initWithFrame:CGRectMake(0, recordButtonViewTop, WIN_WIDTH, 300)];
    [mainView addSubview:recordButtonView];
    
    //开始按钮
    recordStartButton=[[UIButton alloc] initWithFrame:CGRectMake((WIN_WIDTH-recordButtonWidth)/2, recordButtonTop, recordButtonWidth, recordButtonWidth)];
    recordStartButton.backgroundColor=[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    recordStartButton.layer.cornerRadius=recordButtonWidth/2;
    recordStartButton.layer.borderColor=[UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:1].CGColor;
    recordStartButton.layer.borderWidth=7.0;
    [recordStartButton addTarget:self action:@selector(recordStartButtonParss) forControlEvents:UIControlEventTouchUpInside];
    [recordButtonView addSubview:recordStartButton];
    
    UIImageView *recordButtonStartIcon=[[UIImageView alloc] initWithFrame:CGRectMake((recordButtonWidth-recordButtonIconWidth)/2, (recordButtonWidth-recordButtonIconWidth)/2, recordButtonIconWidth, recordButtonIconWidth)];
    recordButtonStartIcon.image=[UIImage imageNamed:@"icon-becord-mic"];
    [recordStartButton addSubview:recordButtonStartIcon];
    recordStartText=[[UILabel alloc] initWithFrame:CGRectMake(0, recordTextTop, WIN_WIDTH, recordTextHeight)];
    recordStartText.text=@"点击开始录音";
    recordStartText.font=FONT_14;
    recordStartText.textColor=[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    recordStartText.textAlignment=NSTextAlignmentCenter;
    [recordButtonView addSubview:recordStartText];
    
    
    //结束按钮
    recordEndButton=[[UIButton alloc] initWithFrame:CGRectMake((WIN_WIDTH-recordButtonWidth)/2, recordButtonTop, recordButtonWidth, recordButtonWidth)];
    recordEndButton.hidden=YES;
    recordEndButton.backgroundColor=[UIColor colorWithRed:0.99 green:0.45 blue:0.13 alpha:1];
    recordEndButton.layer.cornerRadius=recordButtonWidth/2;
    recordEndButton.layer.borderColor=[UIColor colorWithRed:0.59 green:0.33 blue:0.13 alpha:1].CGColor;
    recordEndButton.layer.borderWidth=7.0;
    [recordEndButton addTarget:self action:@selector(recordEndButtonParss) forControlEvents:UIControlEventTouchUpInside];
    [recordButtonView addSubview:recordEndButton];
    
    UIImageView *recordButtonEndIcon=[[UIImageView alloc] initWithFrame:CGRectMake((recordButtonWidth-recordButtonIconWidth)/2, (recordButtonWidth-recordButtonIconWidth)/2, recordButtonIconWidth, recordButtonIconWidth)];
    recordButtonEndIcon.image=[UIImage imageNamed:@"icon-becord-mic"];
    [recordEndButton addSubview:recordButtonEndIcon];
    recordEndText=[[UILabel alloc] initWithFrame:CGRectMake(0, recordTextTop, WIN_WIDTH, recordTextHeight)];
    recordEndText.hidden=YES;
    recordEndText.text=@"录音中";
    recordEndText.font=FONT_14;
    recordEndText.textColor=[UIColor colorWithRed:0.99 green:0.45 blue:0.13 alpha:1];
    recordEndText.textAlignment=NSTextAlignmentCenter;
    [recordButtonView addSubview:recordEndText];

}

-(void)setMainHeight{
    mainContentHeight=0;
    mainContentHeight+=timeShaftViewHeight;
    mainContentHeight+=bgmViewHeight;
    mainContentHeight+=recordButtonViewHeight-NAV_HEIGHT-STATUS_BAR_HEIGHT;
    mainView.contentSize=CGSizeMake(WIN_WIDTH, mainContentHeight);
}
//设置导航样式
-(void)setNavStyle{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:1]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}
//时间格式化
-(NSString *)timeToString:(int)time{
    return [NSString stringWithFormat:@"%02d:%02d",time/60,time%60];
}
//点击完成事件
-(void)finishAction{
    
}
//显示音量按钮点击事件
-(void)bgmVolumeShowParss{
    [bgmView setContentOffset:CGPointMake(WIN_WIDTH, 0) animated:YES];
}
//隐藏音量按钮点击事件
-(void)bgmVolumeHideParss{
    [bgmView setContentOffset:CGPointMake(0, 0) animated:YES];
}
//点击开始录音
-(void)recordStartButtonParss{
    recordStartButton.hidden=YES;
    recordStartText.hidden=YES;
    recordEndButton.hidden=NO;
    recordEndText.hidden=NO;
    
    //开始录音
    NSString *destinationString=[[Functions documentPath] stringByAppendingPathComponent:@"tempRecord.wav"];
    NSURL *destinationURL=[NSURL fileURLWithPath:destinationString];
    
    recorderDict=[[NSMutableDictionary alloc] init];
    //设置音频格式
    [recorderDict setObject:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //设置采样率
    [recorderDict setObject:[NSNumber numberWithInt:44100] forKey:AVSampleRateKey];
    //设置录制音频的通道数
    [recorderDict setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    //设置录制音频的每个样点的位数
    [recorderDict setObject:[NSNumber numberWithInt:32] forKey:AVLinearPCMBitDepthKey];
    //设置录制音频采用商位优先的记录格式
    [recorderDict setObject:[NSNumber numberWithBool:YES] forKey:AVLinearPCMIsBigEndianKey];
    //设置采样信号采用浮点数
    [recorderDict setObject:[NSNumber numberWithBool:YES] forKey:AVLinearPCMIsFloatKey];
    
    NSError *err=nil;
    audioRecorder=[[AVAudioRecorder alloc] initWithURL:destinationURL settings:recorderDict error:&err];
    audioRecorder.delegate=self;
    [audioRecorder record];
    
    
}
//点击录音中
-(void)recordEndButtonParss{
    recordStartButton.hidden=NO;
    recordStartText.hidden=NO;
    recordEndButton.hidden=YES;
    recordEndText.hidden=YES;
    //停止录音
    [audioRecorder stop];
}
@end
