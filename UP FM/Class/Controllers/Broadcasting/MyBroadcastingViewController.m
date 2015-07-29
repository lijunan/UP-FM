//
//  MyBroadcastingViewController.m
//  UP FM
//
//  Created by liubin on 15/3/2.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "MyBroadcastingViewController.h"
#import "EditBroadcastingViewController.h"
#import "RecordViewController.h"
#import "Functions.h"



@interface MyBroadcastingViewController ()

@end

@implementation MyBroadcastingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"我的电台";
    [self navBackShow];
    _broadcasting=[Broadcasting sharedInstance];
    _currentUser=[CurrentUser sharedInstance];
    
    if(!_broadcasting.open){
        EditBroadcastingViewController *_viewController=[[EditBroadcastingViewController alloc] init];
        _viewController.creation=YES;
        [self pushView:_viewController];
    }
    //主体
    mainTop=0;
    mainHeight=WIN_HEIGHT-mainTop;
    mainContentHeight=0;
    
    mainView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, mainTop, WIN_WIDTH, mainHeight)];
    mainView.delegate=self;
    mainView.bounces=YES;
    mainView.scrollEnabled=YES;
    mainView.showsHorizontalScrollIndicator=NO;
    mainView.showsVerticalScrollIndicator=NO;
    mainView.maximumZoomScale=1;
    mainView.minimumZoomScale=1;
    [self.view addSubview:mainView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self initData];
}
-(void)initData{
    mainContentHeight=0;
    for(UIView *view in [mainView subviews])
    {
        [view removeFromSuperview];
    }
    _broadcasting=[Broadcasting sharedInstance];
    float coverHeight=WIN_WIDTH*(504/DESING_WIDTH);
    UIView *coverView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, coverHeight)];
    coverView.layer.masksToBounds=YES;
    [mainView addSubview:coverView];
    coverImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, COVER_WIDTH, COVER_HEIGHT)];
    if(_broadcasting.cover){
        coverImage.image=[UIImage imageWithContentsOfFile:[DROADASTING_FILE_BATH stringByAppendingFormat:@"/%@",_broadcasting.cover]];
    }else{
        coverImage.image=DEFAULT_COVER;
    }
    [coverView addSubview:coverImage];
    mainContentHeight+=coverHeight;
    
    //公告
    float noticeHeight=40.0;
    float noticeImgWidth=25.0;
    float noticeTextLeft=10+noticeImgWidth;
    
    UIView *noticeView=[[UIView alloc] initWithFrame:CGRectMake(0, coverHeight-noticeHeight, WIN_WIDTH, noticeHeight)];
    noticeView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [mainView addSubview:noticeView];
    
    UIImageView *noticeImg=[[UIImageView alloc] initWithFrame:CGRectMake(10, (noticeHeight-noticeImgWidth)/2, noticeImgWidth, noticeImgWidth)];
    noticeImg.image=[UIImage imageNamed:@"icon-guidepost"];
    [noticeView addSubview:noticeImg];
    
    noticeLalel=[[MarqueeLabel alloc] initWithFrame:CGRectMake(noticeTextLeft, (noticeHeight-noticeImgWidth)/2, WIN_WIDTH-noticeTextLeft-10, noticeImgWidth)];
    
    noticeLalel.font=FONT_14;
    noticeLalel.textColor=[UIColor whiteColor];
    noticeLalel.marqueeType = MLContinuous;
    noticeLalel.scrollDuration = 10.0f;
    noticeLalel.fadeLength = 10.0f;
    noticeLalel.trailingBuffer = 70.0f;
    noticeLalel.numberOfLines=1;
    noticeLalel.text=_broadcasting.notice;
    [noticeView addSubview:noticeLalel];
    
    //信息
    float infoViewTop=coverHeight;
    NSString *introductionText=_broadcasting.introduction;
    float introductionWidth=WIN_WIDTH-20;
    float introductionHeight=[Functions getTextHeight:introductionText :CGSizeMake(introductionWidth, 1000) :FONT_14];
    float iconWidth=40.0;
    float infoViewHeight=10+iconWidth+introductionHeight+5+10;
    UIView *infoView=[[UIView alloc] initWithFrame:CGRectMake(0, infoViewTop, WIN_WIDTH, infoViewHeight)];
    infoView.backgroundColor=[UIColor whiteColor];
    [mainView addSubview:infoView];
    mainContentHeight+=infoViewHeight;
    
    //主播icon
    
    UIImageView *iconView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, iconWidth, iconWidth)];
    iconView.layer.cornerRadius=iconWidth/2;
    iconView.layer.masksToBounds=YES;
    if(_broadcasting.icon){
        iconView.image=[UIImage imageWithContentsOfFile:[DROADASTING_FILE_BATH stringByAppendingFormat:@"/%@",_broadcasting.icon]];
    }else{
        iconView.image=DEFAULT_IMAGE;
    }
    [infoView addSubview:iconView];
    
    //编辑按钮
    float editButHeight=25.0;
    float editButWidth=50.0;
    UIButton *editBut=[[UIButton alloc] initWithFrame:CGRectMake(WIN_WIDTH-editButWidth-10, 10, editButWidth, editButHeight)];
    editBut.backgroundColor=RED_COLOR;
    editBut.layer.cornerRadius=3.0;
    [editBut addTarget:self action:@selector(editButParss) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:editBut];
    UILabel *editButText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, editButWidth, editButHeight)];
    editButText.text=@"编辑";
    editButText.font=FONT_14;
    editButText.textColor=[UIColor whiteColor];
    editButText.textAlignment=NSTextAlignmentCenter;
    [editBut addSubview:editButText];
    
    float addButWidth=70.0;
    UIButton *addBut=[[UIButton alloc] initWithFrame:CGRectMake(WIN_WIDTH-editButWidth-10-addButWidth-5, 10, addButWidth, editButHeight)];
    addBut.backgroundColor=RED_COLOR;
    addBut.layer.cornerRadius=3.0;
    [addBut addTarget:self action:@selector(addButParss) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:addBut];
    UILabel *addButText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, addButWidth, editButHeight)];
    addButText.text=@"添加节目";
    addButText.font=FONT_14;
    addButText.textColor=[UIColor whiteColor];
    addButText.textAlignment=NSTextAlignmentCenter;
    [addBut addSubview:addButText];
    
    //标题
    float broadcastingTitleLeft=10+iconWidth+10;
    MarqueeLabel *broadcastingTitle=[[MarqueeLabel alloc] initWithFrame:CGRectMake(broadcastingTitleLeft, 10, WIN_WIDTH-broadcastingTitleLeft-editButWidth-10-10-addButWidth, 20)];
    broadcastingTitle.text=_broadcasting.title;
    broadcastingTitle.font=FONT_16B;
    broadcastingTitle.adjustsFontSizeToFitWidth=YES;
    broadcastingTitle.numberOfLines=1;
    broadcastingTitle.textColor=TEXT_COLOR;
    broadcastingTitle.marqueeType = MLContinuous;
    broadcastingTitle.scrollDuration = 10.0f;
    broadcastingTitle.fadeLength = 10.0f;
    broadcastingTitle.trailingBuffer = 50.0f;
    broadcastingTitle.numberOfLines=1;
    [infoView addSubview:broadcastingTitle];
    
    //标签
    UILabel *broadcastingTagView=[[UILabel alloc] initWithFrame:CGRectMake(broadcastingTitleLeft, 35, WIN_WIDTH-broadcastingTitleLeft-10, 20)];
    broadcastingTagView.text=_broadcasting.mediaTag;
    broadcastingTagView.textColor=TEXT_COLOR;
    broadcastingTagView.font=FONT_14;
    [infoView addSubview:broadcastingTagView];
    
    
    //简介
    UILabel *introductionView=[[UILabel alloc] initWithFrame:CGRectMake(10, iconWidth+10+5, introductionWidth, introductionHeight)];
    introductionView.text=[NSString stringWithFormat:@"简介：%@",introductionText];
    introductionView.font=FONT_14;
    introductionView.numberOfLines=0;
    [infoView addSubview:introductionView];
    
    mainView.contentSize=CGSizeMake(WIN_WIDTH, mainContentHeight);
}

//编辑事件
-(void)editButParss{
    
    EditBroadcastingViewController *_viewController=[[EditBroadcastingViewController alloc] init];
    [self pushViewRight:_viewController];
    
}
//添加节目事件
-(void)addButParss{
    RecordViewController *_viewController=[[RecordViewController alloc] init];
    [self pushViewRight:_viewController];
}
@end
