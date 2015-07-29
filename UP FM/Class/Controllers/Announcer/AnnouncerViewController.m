//
//  AnnouncerViewController.m
//  UP FM
//
//  Created by liubin on 15/1/31.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "AnnouncerViewController.h"
#import "Music.h"
#import "Functions.h"

@implementation AnnouncerViewController

@synthesize announcerId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    announcer=[[[Announcer alloc] init] getAnnouncerById:self.announcerId];
    mediaArray=[NSMutableArray arrayWithObjects:
                [[[Music alloc] init] getMusicById:[NSNumber numberWithInt:1]],
                [[[Music alloc] init] getMusicById:[NSNumber numberWithInt:2]],
                [[[Music alloc] init] getMusicById:[NSNumber numberWithInt:3]],
                [[[Music alloc] init] getMusicById:[NSNumber numberWithInt:1]],
                [[[Music alloc] init] getMusicById:[NSNumber numberWithInt:2]],
                [[[Music alloc] init] getMusicById:[NSNumber numberWithInt:3]],
                [[[Music alloc] init] getMusicById:[NSNumber numberWithInt:1]],
                [[[Music alloc] init] getMusicById:[NSNumber numberWithInt:2]],
                [[[Music alloc] init] getMusicById:[NSNumber numberWithInt:3]],
                nil
                ];

    
    //设置导航
    self.title=announcer.nickName;
    
    [self navBackShow];
    
    
    mainTop=NAV_HEIGHT+STATUS_BAR_HEIGHT;
    mainHeight=WIN_HEIGHT-mainTop;
    
    UIView *mainView=[[UIView alloc] initWithFrame:CGRectMake(0, mainTop, WIN_HEIGHT, mainHeight)];
    mainView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:mainView];
    
    //大图
    float patternmakingImgHeight=WIN_WIDTH*(472/DESING_WIDTH);
    patternmakingImg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, patternmakingImgHeight)];
    patternmakingImg.image=[UIImage imageNamed:announcer.imgUrl];
    [mainView addSubview:patternmakingImg];
    
    float noticeHeight=40.0;
    float noticeImgWidth=25.0;
    float noticeTextLeft=10+noticeImgWidth;
    
    UIView *noticeView=[[UIView alloc] initWithFrame:CGRectMake(0, patternmakingImgHeight-noticeHeight, WIN_WIDTH, noticeHeight)];
    noticeView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [mainView addSubview:noticeView];
    
    UIImageView *noticeImg=[[UIImageView alloc] initWithFrame:CGRectMake(10, (noticeHeight-noticeImgWidth)/2, noticeImgWidth, noticeImgWidth)];
    noticeImg.image=[UIImage imageNamed:@"icon-guidepost"];
    [noticeView addSubview:noticeImg];
    
    UILabel *noticeText=[[UILabel alloc] initWithFrame:CGRectMake(noticeTextLeft, (noticeHeight-noticeImgWidth)/2, WIN_WIDTH-noticeTextLeft-10, noticeImgWidth)];
    noticeText.text=announcer.notice;
    noticeText.font=FONT_16;
    noticeText.textColor=[UIColor whiteColor];
    noticeText.adjustsFontSizeToFitWidth=YES;
    noticeText.numberOfLines=1;
    [noticeView addSubview:noticeText];
    
    
    //信息
    float infoViewTop=patternmakingImgHeight;
    NSString *introductionText=announcer.introduction;
    float introductionWidth=WIN_WIDTH-20;
    float introductionHeight=[Functions getTextHeight:introductionText :CGSizeMake(introductionWidth, 1000) :FONT_14];
    float userIconWidth=40.0;
    float infoViewHeight=10+userIconWidth+introductionHeight+5+10;
    infoView=[[UIView alloc] initWithFrame:CGRectMake(0, infoViewTop, WIN_WIDTH, infoViewHeight)];
    infoView.backgroundColor=[UIColor whiteColor];
    [mainView addSubview:infoView];
    
    //主播icon
    
    UIImageView *userIcon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, userIconWidth, userIconWidth)];
    userIcon.layer.cornerRadius=userIconWidth/2;
    userIcon.layer.masksToBounds=YES;
    userIcon.image=[UIImage imageNamed:announcer.icon];
    [infoView addSubview:userIcon];
    
    //已订阅
    float subscriptionButWidth=90.0;
    UIButton *subscriptionBut=[[UIButton alloc] initWithFrame:CGRectMake(WIN_WIDTH-subscriptionButWidth-10, 10, subscriptionButWidth, 30)];
    subscriptionBut.backgroundColor=RED_COLOR;
    subscriptionBut.layer.cornerRadius=3.0;
    [infoView addSubview:subscriptionBut];
    UILabel *subscriptionText=[[UILabel alloc] initWithFrame:CGRectMake(3, 0, 50, 30)];
    subscriptionText.text=@"已订阅";
    subscriptionText.font=FONT_16;
    subscriptionText.textColor=[UIColor whiteColor];
    [subscriptionBut addSubview:subscriptionText];
    UILabel *subscriptionSum=[[UILabel alloc] initWithFrame:CGRectMake(50+3, 4, subscriptionButWidth-50-6, 20)];
    subscriptionSum.text=[NSString stringWithFormat:@"%d",(int)announcer.subscriptionSum];
    subscriptionSum.textColor=[UIColor whiteColor];
    subscriptionSum.font=FONT_14;
    subscriptionSum.adjustsFontSizeToFitWidth=YES;
    subscriptionSum.numberOfLines=1;
    [subscriptionBut addSubview:subscriptionSum];
    
    
    //主播名
    float userNameleft=10+userIconWidth+10;
    UILabel *userName=[[UILabel alloc] initWithFrame:CGRectMake(userNameleft, 10, WIN_WIDTH-userNameleft-subscriptionButWidth-10, 20)];
    userName.text=announcer.nickName;
    userName.font=FONT_16B;
    userName.adjustsFontSizeToFitWidth=YES;
    
    userName.numberOfLines=1;
    userName.textColor=TEXT_COLOR;
    [infoView addSubview:userName];
    
    UILabel *introductionView=[[UILabel alloc] initWithFrame:CGRectMake(10, userIconWidth+10+5, introductionWidth, introductionHeight)];
    introductionView.text=introductionText;
    introductionView.font=FONT_14;
    introductionView.numberOfLines=0;
    [infoView addSubview:introductionView];
    
    float operationViewTop=infoViewTop+infoViewHeight;
    float operationViewHehght=mainHeight-operationViewTop;
    UIView *operationView=[[UIView alloc] initWithFrame:CGRectMake(0, operationViewTop, WIN_WIDTH, operationViewHehght)];
    [mainView addSubview:operationView];
    operationListView=[OperationMediaListView alloc];
    operationListView.delegate=self;
    operationListView.mediaArray=mediaArray;
    operationListView.butFirst=1;
    operationListView=[operationListView initWithFrame:CGRectMake(0, 0, WIN_WIDTH, operationViewHehght)];
    [operationView addSubview:operationListView];

    
}


-(void) viewWillAppear:(BOOL)animated{
    
    
}



//列表协议
-(void)operationPlayParss:(NSInteger)index{
    [self musicPlay:mediaArray index:index];
    
}
-(void)operationDeleteParss:(NSInteger)index{
    Music *music=[mediaArray objectAtIndex:index];
    NSLog(@"删除:%@",music.title);
}
-(void)operationCommentsParss:(NSInteger)index{
    Music *music=[mediaArray objectAtIndex:index];
    NSLog(@"评论:%@",music.title);
}
-(void)operationGoodParss:(NSInteger)index{
    Music *music=[mediaArray objectAtIndex:index];
    NSLog(@"赞:%@",music.title);
}
-(void)operationShareParss:(NSInteger)index{
    Music *music=[mediaArray objectAtIndex:index];
    NSLog(@"分享:%@",music.title);
}
-(void)operationDownloadParss:(NSInteger)index{
    Music *music=[mediaArray objectAtIndex:index];
    NSLog(@"下载:%@",music.title);
}

@end
