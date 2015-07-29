//
//  PlayerViewController.m
//  UP FM
//
//  Created by liubin on 15/1/29.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "PlayerViewController.h"
#import "User.h"
#import "Announcer.h"
#import "Comment.h"
#import "Functions.h"
#import "AnnouncerViewController.h"
#import "ShutdownViewController.h"
#import "MarqueeLabel.h"
#import "CommentViewController.h"


@interface PlayerViewController(){
    
    UIView *mainView;
    
    MarqueeLabel *titleView;
    //专辑icon
    UIImageView *albumIcon;
    //订阅数
    UILabel *subscriptionSum;
    //专辑名
    UILabel *albumTitle;
    //粉丝数
    UILabel *fansSumView;
    //日期
    UILabel *dateView;
    //收听
    UILabel *listenView;
    //赞数量
    UILabel *goodSum;
    //赞头像
    
    float goodButTop;
    float goodButImgWidth;
    float goodButHeight;
    float goodIconWidth;
    float goodSumLeft;
    float goodSumWidth;
    float goodButImgLeft;
}

@end

@implementation PlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    commentArray=[NSMutableArray arrayWithObjects:
                  [[[Comment alloc] init] getCommentById:[NSNumber numberWithInt:1]],
                  [[[Comment alloc] init] getCommentById:[NSNumber numberWithInt:2]],
                  [[[Comment alloc] init] getCommentById:[NSNumber numberWithInt:3]],
                  [[[Comment alloc] init] getCommentById:[NSNumber numberWithInt:1]],
                  nil];
    
    //播放中
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(playerPlayingProgress:)
                               name:MCPlayerDidPlayingNotification
                             object:nil];
    music=[self.mcPlayer.playerMusicArray objectAtIndex:self.mcPlayer.currIndex];
    //设置导航
    
    [self navBackShow];
    
    [self navMusicButtonHide:YES];
    
    titleView=[[MarqueeLabel alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH-80, NAV_HEIGHT)];
    titleView.font=FONT_16B;
    titleView.textColor=TEXT_COLOR;
    titleView.textAlignment=NSTextAlignmentCenter;
    titleView.marqueeType = MLContinuous;
    titleView.scrollDuration = 20.0f;
    titleView.fadeLength = 10.0f;
    titleView.trailingBuffer = 60.0f;
    self.navigationItem.titleView=titleView;
    
    
    mainTop=NAV_HEIGHT+STATUS_BAR_HEIGHT;
    mainHeight=WIN_HEIGHT-mainTop;
    
    mainView=[[UIView alloc] initWithFrame:CGRectMake(0, mainTop, WIN_HEIGHT, mainHeight)];
    mainView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:mainView];
    
    
    
    //大图
    float patternmakingImgHeight=WIN_WIDTH*(472/DESING_WIDTH);
    patternmakingImg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, patternmakingImgHeight)];
    
    [mainView addSubview:patternmakingImg];
    
    //播放器
    float musicPlayViewHeight=80.0;
    UIView *musicPlayView=[[UIView alloc] initWithFrame:CGRectMake(0, patternmakingImgHeight-musicPlayViewHeight, WIN_WIDTH, musicPlayViewHeight)];
    [mainView addSubview:musicPlayView];
    UIView *musicPlayBj=[[UIView alloc] initWithFrame:CGRectMake(0, 20, WIN_WIDTH, musicPlayViewHeight-20)];
    musicPlayBj.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [musicPlayView addSubview:musicPlayBj];
    
    float musicButWidth=20.0;
    float musicButInterval=28.0;
    float musicButTop=(musicPlayViewHeight-musicButWidth+20)/2;
    float musicButLeft=musicButInterval;
    float musicPlayWidth=musicPlayViewHeight-10;
    
    //随机播放
    musicRandomBut=[[UIButton alloc] initWithFrame:CGRectMake(musicButLeft, musicButTop, musicButWidth, musicButWidth)];
    [musicRandomBut setImage:[UIImage imageNamed:@"but-player-random"] forState:UIControlStateNormal];
    [musicRandomBut setImage:[UIImage imageNamed:@"but-player-random-on"] forState:UIControlStateHighlighted];
    [musicRandomBut addTarget:self action:@selector(musicRandomParss) forControlEvents:UIControlEventTouchUpInside];
    [musicPlayView addSubview:musicRandomBut];
    
    
    //前一首
    musicButLeft=musicButLeft+musicButWidth+musicButInterval;
    musicPrveBut=[[UIButton alloc] initWithFrame:CGRectMake(musicButLeft, musicButTop, musicButWidth, musicButWidth)];
    [musicPrveBut setImage:[UIImage imageNamed:@"but-player-prve"] forState:UIControlStateNormal];
    [musicPrveBut setImage:[UIImage imageNamed:@"but-player-prve-on"] forState:UIControlStateHighlighted];
    [musicPrveBut addTarget:self action:@selector(musicPrveParss) forControlEvents:UIControlEventTouchUpInside];
    [musicPlayView addSubview:musicPrveBut];
    
    
    //播放
    musicButLeft=musicButLeft+musicButWidth+musicButInterval;
    musicPlayBut=[[UIButton alloc] initWithFrame:CGRectMake(musicButLeft, 0, musicPlayWidth, musicPlayWidth)];
    musicPlayBut.backgroundColor=RED_COLOR;
    musicPlayBut.layer.cornerRadius=musicPlayWidth/2;
    [musicPlayBut addTarget:self action:@selector(musicPlayParss) forControlEvents:UIControlEventTouchUpInside];
    [musicPlayView addSubview:musicPlayBut];
    
    UIImageView *musicPlayButImg=[[UIImageView alloc] initWithFrame:CGRectMake((musicPlayWidth-musicButWidth)*0.55, (musicPlayWidth-musicButWidth)*0.5, musicButWidth, musicButWidth)];
    musicPlayButImg.image=[UIImage imageNamed:@"but-player-play"];
    [musicPlayBut addSubview:musicPlayButImg];
    
    //暂停
    musicStopBut=[[UIButton alloc] initWithFrame:CGRectMake(musicButLeft, 0, musicPlayWidth, musicPlayWidth)];
    musicStopBut.backgroundColor=RED_COLOR;
    
    musicStopBut.layer.cornerRadius=musicPlayWidth/2;
    [musicStopBut addTarget:self action:@selector(musicStopParss) forControlEvents:UIControlEventTouchUpInside];
    [musicPlayView addSubview:musicStopBut];
    if([self.mcPlayer isPlaying]){
        musicPlayBut.hidden=YES;
    }else{
        musicStopBut.hidden=YES;
    }
    
    UIImageView *musicStopButImg=[[UIImageView alloc] initWithFrame:CGRectMake((musicPlayWidth-musicButWidth)*0.5, (musicPlayWidth-musicButWidth)*0.5, musicButWidth, musicButWidth)];
    musicStopButImg.image=[UIImage imageNamed:@"but-player-stop"];
    [musicStopBut addSubview:musicStopButImg];
    
    
    
    //下一首
    musicButLeft=musicButLeft+musicPlayWidth+musicButInterval;
    musicNextBut=[[UIButton alloc] initWithFrame:CGRectMake(musicButLeft, musicButTop, musicButWidth, musicButWidth)];
    [musicNextBut setImage:[UIImage imageNamed:@"but-player-next"] forState:UIControlStateNormal];
    [musicNextBut setImage:[UIImage imageNamed:@"but-player-next-on"] forState:UIControlStateHighlighted];
    [musicNextBut addTarget:self action:@selector(musicNextParss) forControlEvents:UIControlEventTouchUpInside];
    [musicPlayView addSubview:musicNextBut];
    
    
    //时间
    musicButLeft=musicButLeft+musicButWidth+musicButInterval;
    musicTimerBut=[[UIButton alloc] initWithFrame:CGRectMake(musicButLeft, musicButTop, musicButWidth, musicButWidth)];
    [musicTimerBut setImage:[UIImage imageNamed:@"but-player-timer"] forState:UIControlStateNormal];
    [musicTimerBut setImage:[UIImage imageNamed:@"but-player-timer-on"] forState:UIControlStateHighlighted];
    [musicTimerBut addTarget:self action:@selector(musicTimerParss) forControlEvents:UIControlEventTouchUpInside];
    [musicPlayView addSubview:musicTimerBut];
    
    //进度条
    progressTop=patternmakingImgHeight;
    progressHeight=7;
    progressBar=[[UIView alloc] initWithFrame:CGRectMake(0, progressTop, WIN_WIDTH, progressHeight)];
    progressBar.backgroundColor=[UIColor blackColor];
    [mainView addSubview:progressBar];
    
    
    //缓存进度
    progressAvailableDuration=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, progressHeight)];
    progressAvailableDuration.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    progressAvailableDuration.layer.cornerRadius=3.0;
    [progressBar addSubview:progressAvailableDuration];
    progressChunk=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, progressHeight)];
    progressChunk.backgroundColor=RED_COLOR;
    [progressBar addSubview:progressChunk];
    //滑块
    progressAlreadyHeight=progressHeight+6;
    progressAlreadyWidth=40;
    progressAlreadyLeft=0;
    isDrag=NO;
    progressAlreadyTop=progressTop+(progressHeight-progressAlreadyHeight)/2;
    
    progressAlready=[[UIView alloc] initWithFrame:CGRectMake(0, progressAlreadyTop, progressAlreadyWidth,progressAlreadyHeight)];
    progressAlready.backgroundColor=[UIColor whiteColor];
    progressAlready.layer.shadowColor=[UIColor blackColor].CGColor;
    progressAlready.layer.shadowOffset=CGSizeMake(2, 2);
    progressAlready.layer.shadowOpacity=0.9;
    progressAlready.layer.cornerRadius=(progressHeight+6)/2;
    progressAlready.userInteractionEnabled=YES;
    progressAlready.multipleTouchEnabled=NO;
    progressAlready.tag=1001;
    [mainView addSubview:progressAlready];
    float progressAlreadyTopTimeWidth=(WIN_WIDTH-musicPlayWidth)/2;
    //缓存进度
    progressAlreadyTopTime=[[UILabel alloc] initWithFrame:CGRectMake(0,5, progressAlreadyTopTimeWidth, 15)];
    progressAlreadyTopTime.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
    progressAlreadyTopTime.textAlignment=NSTextAlignmentCenter;
    progressAlreadyTopTime.textColor=[UIColor whiteColor];
    progressAlreadyTopTime.font=FONT_10;
    progressAlreadyTopTime.hidden=YES;
    [musicPlayView addSubview:progressAlreadyTopTime];
    progressAlreadyTime=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, progressAlreadyWidth, progressAlreadyHeight)];
    
    progressAlreadyTime.text=[NSDate timeIntervalToString:0];
    progressAlreadyTime.font=FONT_10;
    progressAlreadyTime.textAlignment=NSTextAlignmentCenter;
    [progressAlready addSubview:progressAlreadyTime];
    progressChunk.frame=CGRectMake(0, 0, 0, progressHeight);
    
    
    
    [self initMusicView];
    //专辑信息
    float infoViewTop=progressTop+progressHeight;
    float infoViewHeight=80.0;
    infoView=[[UIButton alloc] initWithFrame:CGRectMake(0, infoViewTop, WIN_WIDTH, infoViewHeight)];
    infoView.backgroundColor=[UIColor whiteColor];
    [infoView addTarget:self action:@selector(infoButParss) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:infoView];
    
    //主播icon
    float userIconWidth=infoViewHeight-20;
    albumIcon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, userIconWidth, userIconWidth)];
    
    [infoView addSubview:albumIcon];
    
    //已订阅
    float subscriptionButWidth=90.0;
    UIButton *subscriptionBut=[[UIButton alloc] initWithFrame:CGRectMake(WIN_WIDTH-subscriptionButWidth-10, 10, subscriptionButWidth, 20)];
    subscriptionBut.backgroundColor=RED_COLOR;
    subscriptionBut.layer.cornerRadius=3.0;
    [infoView addSubview:subscriptionBut];
    UILabel *subscriptionText=[[UILabel alloc] initWithFrame:CGRectMake(3, 0, 50, 20)];
    subscriptionText.text=@"已订阅";
    subscriptionText.font=FONT_16;
    subscriptionText.textColor=[UIColor whiteColor];
    [subscriptionBut addSubview:subscriptionText];
    subscriptionSum=[[UILabel alloc] initWithFrame:CGRectMake(50+3, 4, subscriptionButWidth-50-6, 15)];
    
    subscriptionSum.textColor=[UIColor whiteColor];
    subscriptionSum.font=FONT_14;
    subscriptionSum.adjustsFontSizeToFitWidth=YES;
    subscriptionSum.numberOfLines=1;
    [subscriptionBut addSubview:subscriptionSum];
    
    
    //专辑名
    float userNameleft=10+userIconWidth+10;
    albumTitle=[[UILabel alloc] initWithFrame:CGRectMake(userNameleft, 10, WIN_WIDTH-userNameleft-subscriptionButWidth-10, 20)];
    
    albumTitle.font=FONT_16B;
    albumTitle.adjustsFontSizeToFitWidth=YES;
    
    albumTitle.numberOfLines=1;
    albumTitle.textColor=TEXT_COLOR;
    [infoView addSubview:albumTitle];
    
    
    //粉丝
    fansSumView=[[UILabel alloc] initWithFrame:CGRectMake(userNameleft, 35, WIN_WIDTH-userNameleft-10, 20)];
    
    fansSumView.font=FONT_14;
    fansSumView.textColor=TEXT_COLOR_SHALLOW;
    [infoView addSubview:fansSumView];
    //日期
    dateView=[[UILabel alloc] initWithFrame:CGRectMake(userNameleft, 55, 60, 20)];
    
    dateView.font=FONT_14;
    dateView.textColor=TEXT_COLOR;
    [infoView addSubview:dateView];
    
    //收听
    listenView=[[UILabel alloc] initWithFrame:CGRectMake(userNameleft+70, 55, WIN_WIDTH-userNameleft-60, 20)];
    listenView.font=FONT_14;
    listenView.textColor=TEXT_COLOR;
    [infoView addSubview:listenView];
    [mainView bringSubviewToFront:progressAlready];
    
    [self initAlbumView];
    
    //赞
    goodButTop=infoViewTop+infoViewHeight;
    goodButImgWidth=WIN_WIDTH*(100/DESING_WIDTH);
    goodButHeight=goodButImgWidth+10;
    goodIconWidth=20.0;
    goodSumLeft=10+goodIconWidth;
    goodSumWidth=40.0;
    goodButImgLeft=goodSumLeft+goodSumWidth+5;
    
    
    [self initGoodList];
    
    //交互高
    float mutualViewHeight=50.0;
    //评论
    
    float commentTop=goodButTop+goodButHeight;
    float commentHeight=mainHeight-commentTop-mutualViewHeight;
    UIView *commentView=[[UIView alloc] initWithFrame:CGRectMake(0, commentTop, WIN_WIDTH, commentHeight)];
    [mainView addSubview:commentView];
    commentListView=[CommentListView alloc];
    commentListView.commentArray=commentArray;
    commentListView.delegate=self;
    commentListView=[commentListView initWithFrame:CGRectMake(0, 0, WIN_WIDTH, commentHeight)];
    [commentView addSubview:commentListView];
    
    
    //交互
    mutualView=[[UIView alloc] initWithFrame:CGRectMake(0, mainHeight-mutualViewHeight, WIN_WIDTH, mutualViewHeight)];
    mutualView.backgroundColor=[UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1];
    [mainView addSubview:mutualView];
    UIView *mutualViewSeparate=[[UIView alloc] initWithFrame:CGRectMake(0,0, WIN_WIDTH, 1)];
    mutualViewSeparate.backgroundColor=FOOT_BORDER_COLOR;
    [mutualView addSubview:mutualViewSeparate];
    
    //交互按钮
    mutualArray=[NSArray arrayWithObjects:
                 [NSArray arrayWithObjects:@"icon-download",@"下载", nil],
                 [NSArray arrayWithObjects:@"icon-comments.png",@"评", nil],
                 [NSArray arrayWithObjects:@"icon-good.png",@"赞", nil],
                 [NSArray arrayWithObjects:@"icon-share.png",@"分享", nil],
                 nil
                 ];
    int mutualButLen=(int)mutualArray.count;
    float mutualButTop=1.0;
    float mutualButWidth=(WIN_WIDTH-mutualButLen+1)/mutualButLen;
    float mutualButHeight=mutualViewHeight-mutualButTop;
    float mutualButImgWidth=20.0;
    float mutualButImgTop=(mutualButHeight-mutualButImgWidth)/2;
    float mutualButTextWidth=25.0;
    float mutualButImgLeft=(mutualButWidth-mutualButImgWidth-mutualButTextWidth)/2;
    
    for (int i=0; i<mutualButLen; i++) {
        NSArray *arr=[mutualArray objectAtIndex:i];
        UIButton *but=[[UIButton alloc] initWithFrame:CGRectMake((mutualButWidth+1)*i, mutualButTop, mutualButWidth, mutualButHeight)];
        [but setBackgroundImage:[Functions imageWithColor:[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1] size:CGSizeMake(mutualButWidth, mutualButHeight)] forState:UIControlStateNormal];
        [but setBackgroundImage:[Functions imageWithColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1] size:CGSizeMake(mutualButWidth, mutualButHeight)] forState:UIControlStateHighlighted];
        but.tag=i;
        [but addTarget:self action:@selector(mutualButParss:) forControlEvents:UIControlEventTouchUpInside];
        [mutualView addSubview:but];
        
        UIImageView *butImg=[[UIImageView alloc] initWithFrame:CGRectMake(mutualButImgLeft, mutualButImgTop, mutualButImgWidth, mutualButImgWidth)];
        butImg.image=[UIImage imageNamed:[arr objectAtIndex:0]];
        [but addSubview:butImg];
        UILabel *butText=[[UILabel alloc] initWithFrame:CGRectMake(mutualButImgLeft+mutualButImgWidth, mutualButImgTop, mutualButTextWidth, mutualButImgWidth)];
        butText.text=[arr objectAtIndex:1];
        butText.font=FONT_12;
        butText.textAlignment=NSTextAlignmentCenter;
        [but addSubview:butText];
    }

}

-(void)initMusicView{
    //self.title=music.title;
    titleView.text=music.title;
    [patternmakingImg setImageWithURL:[NSURL URLWithString:music.cover] placeholderImage:DEFAULT_IMAGE_472];
}

-(void)initAlbumView{
    if(!album || ![album.mediaId isEqualToNumber:music.albumId]){
        NSString *url=[UrlAPI getProgramDetail];
        NSDictionary *parameters = @{@"program_id":music.albumId};
        [UPHTTPTools post:url params:parameters success:^(id responseObj) {
            NSNumber *code=[responseObj objectForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]]){
                NSDictionary *dict=[responseObj objectForKey:@"content"];
                album=[[Album alloc] initAlbumByDictionary:dict];
                album.musicArray=self.mcPlayer.playerMusicArray;
                [albumIcon setImageWithURL:[NSURL URLWithString:album.icon] placeholderImage:DEFAULT_IMAGE];
                subscriptionSum.text=[album.subscriptionSum stringValue];
                albumTitle.text=album.title;
                fansSumView.text=[NSString stringWithFormat:@"粉丝数：%d",[album.fansSum intValue]];
                NSDateFormatter *dateAtter=[[NSDateFormatter alloc] init];
                [dateAtter setDateFormat:@"MM月DD日"];
                dateView.text=[dateAtter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[album.date integerValue]]];
                listenView.text=[NSString stringWithFormat:@"[听] %d",[music.playSum intValue]];
            }
        } failure:^(NSError *error) {
            
        }];

        
    }
    
}

-(void)initGoodList{
    [goodView removeFromSuperview];
    goodView=[[UIButton alloc] initWithFrame:CGRectMake(0, goodButTop, WIN_WIDTH, goodButHeight)];
    [mainView addSubview:goodView];
    NSString *url=[UrlAPI getSubjectGoodList];
    NSDictionary *parameters = @{@"subject_id":music.albumId,@"page_index":[NSNumber numberWithInt:0],@"page_size":[NSNumber numberWithInt:5]};
    [UPHTTPTools post:url params:parameters success:^(id responseObj) {
        NSNumber *code=[responseObj objectForKey:@"code"];
        if([code isEqualToNumber:[NSNumber numberWithInt:0]]){
            NSDictionary *dict=[responseObj objectForKey:@"content"];
            NSMutableArray *subjects=[dict objectForKey:@"subjects"];
            int len=(int)subjects.count;
            goodArray=[NSMutableArray arrayWithCapacity:0];
            for (int i=0; i<len; i++) {
                NSDictionary *d=[subjects objectAtIndex:i];
                User *user=[[User alloc] initUserByDictionary:d];
                [goodArray addObject:user];
            }
            
            UIImageView *goodIcon=[[UIImageView alloc] initWithFrame:CGRectMake(10, (goodButHeight-goodIconWidth)/2, goodIconWidth, goodIconWidth)];
            goodIcon.image=[UIImage imageNamed:@"icon-good-on"];
            [goodView addSubview:goodIcon];
            
            goodSum=[[UILabel alloc] initWithFrame:CGRectMake(goodSumLeft, (goodButHeight-goodIconWidth)/2, goodSumWidth, goodIconWidth)];
            goodSum.text=[NSString stringWithFormat:@"%d",[music.goodSum intValue]];
            goodSum.font=FONT_14;
            goodSum.textColor=TEXT_COLOR_SHALLOW;
            [goodView addSubview:goodSum];
            
            //r箭头
            float goodArrowsWidth=13.0;
            UIImageView *goodArrows=[[UIImageView alloc] initWithFrame:CGRectMake(WIN_WIDTH-goodArrowsWidth-10, (goodButHeight-goodArrowsWidth)/2, goodArrowsWidth, goodArrowsWidth)];
            goodArrows.image=[UIImage imageNamed:@"icon-arrows-right"];
            [goodView addSubview:goodArrows];
            int goodButimgSum=floor((WIN_WIDTH-goodButImgLeft-30)/(goodButImgWidth));
            int goodImgLen=goodButimgSum>(int)goodArray.count?(int)goodArray.count:goodButimgSum;
            float goodButimgInterval=(WIN_WIDTH-goodButImgLeft-goodButimgSum*goodButImgWidth-30)/goodButimgSum/2;
            for(int i=0;i<goodImgLen;i++){
                User *goodUser=[goodArray objectAtIndex:i];
                UIImageView *goodUserImg=[[UIImageView alloc] initWithFrame:CGRectMake(goodButImgLeft+(goodButImgWidth+goodButimgInterval)*i, 5, goodButImgWidth-2, goodButImgWidth-2)];
                goodUserImg.image=[UIImage imageNamed:goodUser.icon];
                goodUserImg.layer.borderColor=[UIColor whiteColor].CGColor;
                goodUserImg.layer.borderWidth=1.5;
                goodUserImg.layer.masksToBounds=YES;
                goodUserImg.layer.cornerRadius=(goodButImgWidth-2)/2;
                [goodView addSubview:goodUserImg];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {  //按钮index
        case 0:
            switch (alertView.tag) {
                case 1: //无播放内容时
                    [self goToBack];
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
}


//点击播放事件
-(void)musicPlayParss{
    musicStopBut.hidden=NO;
    musicPlayBut.hidden=YES;
    [self musicContinuePlay];
}
//点击停止事件
-(void)musicStopParss{
    musicStopBut.hidden=YES;
    musicPlayBut.hidden=NO;
    [self musicPause];
}
//随机播放事件
-(void)musicRandomParss{
    
}
//上一首事件
-(void)musicPrveParss{
    [self.mcPlayer playPrev];
}
//下一首事件
-(void)musicNextParss{
    [self.mcPlayer playNext];
}
//定时按钮事件
-(void)musicTimerParss{
    ShutdownViewController *_viewController = [[ShutdownViewController alloc] init];
    [self pushViewRight:_viewController];
}

//评论列表协议
-(void)commentParss:(NSInteger)index{
    
}

//底部按钮事件
-(void)mutualButParss:(UIButton *) paramSender{
    switch (paramSender.tag) {
        case 0:{ //下载
            [music downloadMusic];
            break;
        }
        case 1:{ //评论
            CommentViewController *_viewController=[[CommentViewController alloc] init];
            _viewController.commentId=music.mediaId;
            _viewController.commentTitle=music.title;
            _viewController.commentType=0;
            [self pushViewRight:_viewController];
            break;
        }
        case 2:{ //赞
            [music goodMusic:^{
                music.goodSum=[NSNumber numberWithInt:[music.goodSum intValue]+1];
                
            } failure:^(NSString * msg){
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }];
            break;
        }
        case 3:{ //分享
            
            break;
        }
        default:
            break;
    }
}

//主播信息点击事件
-(void)infoButParss{
//    AnnouncerViewController *_viewController = [[AnnouncerViewController alloc] init];
//    _viewController.announcerId=music.owner.uId;
//    [self pushViewRight:_viewController];
}

#pragma mark - 播放状态监听
- (void)playerPlayingProgress:(NSNotification *)notification{
    _currentItem = [notification object];
    if (_currentItem.isNew && _currentItem) {
        music=_currentItem.song;
        [self initMusicView];
        [self initAlbumView];
        [self initGoodList];
    }
    if(!isDrag){
        currentTime=_currentItem.currentTime;
        durationTime=_currentItem.duration;
        progressAlreadyLeft=(currentTime/durationTime)*(WIN_WIDTH-progressAlreadyWidth);
        [progressAlready setFrame:CGRectMake(progressAlreadyLeft, progressAlreadyTop, progressAlreadyWidth,progressAlreadyHeight)];
        currentTime=currentTime<0?0:currentTime;
        currentTime=currentTime>=durationTime?durationTime:currentTime;
        [progressChunk setFrame:CGRectMake(0, 0, progressAlreadyLeft+30, progressHeight)];
        progressAlreadyTime.text=[NSDate timeIntervalToString:(int)_currentItem.currentTime];
    }
    [progressAvailableDuration setFrame:CGRectMake(0, 0, (_currentItem.availableDuration/durationTime)*WIN_WIDTH, progressHeight)];
}

//时间轴拖动事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    switch (touch.view.tag) {
        case 1001:
            progressAlreadyTopTime.hidden=NO;
            progressAlreadyTopTime.text=[NSString stringWithFormat:@"%@/%@",[NSDate timeIntervalToString:currentTime],[NSDate timeIntervalToString:durationTime]];
            CGPoint originalLocation = [touch locationInView:self.view];
            touchStartLeft=originalLocation.x;
            isDrag=YES;
            break;
            
        default:
            break;
    }
};
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    switch (touch.view.tag) {
        case 1001:{
            CGPoint originalLocation = [touch locationInView:self.view];
            float endLeft=originalLocation.x;
            float _left=progressAlreadyLeft+(endLeft-touchStartLeft);
            _left=_left<0?0:_left;
            _left=_left>WIN_WIDTH-progressAlreadyWidth?WIN_WIDTH-progressAlreadyWidth:_left;
            currentTime=_left/(WIN_WIDTH-progressAlreadyWidth)*durationTime;
            [progressAlready setFrame:CGRectMake(_left, progressAlreadyTop, progressAlreadyWidth, progressAlreadyHeight)];
            NSString *currentTimeStr=[NSDate timeIntervalToString:currentTime];
            progressAlreadyTime.text=currentTimeStr;
            progressAlreadyTopTime.text=[NSString stringWithFormat:@"%@/%@",currentTimeStr,[NSDate timeIntervalToString:durationTime]];
            isDrag=YES;
            break;
        }
        default:
            break;
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    switch (touch.view.tag) {
        case 1001:
            [self.mcPlayer seekToTime:currentTime];
            progressAlreadyTopTime.hidden=YES;
            isDrag=NO;
            break;
            
        default:
            break;
    }
   
}

@end
