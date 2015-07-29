//
//  AlbumViewController.m
//  UP FM
//
//  Created by liubin on 15/2/14.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "AlbumViewController.h"
#import "Functions.h"
#import "MarqueeLabel.h"
#import "CommentViewController.h"

@interface AlbumViewController (){
    MarqueeLabel *titleView;
}

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    NSString *url=[UrlAPI getProgramDetail];

    NSDictionary *parameters = @{@"program_id":self.mediaId};
    
    [UPHTTPTools post:url params:parameters success:^(id responseObj) {
        NSNumber *code=[responseObj objectForKey:@"code"];
        if([code isEqualToNumber:[NSNumber numberWithInt:0]]){
            NSDictionary *dict=[responseObj objectForKey:@"content"];
            album=[[Album alloc] initAlbumByDictionary:dict];
            album.mediaId=self.mediaId;
            //设置导航
            
            titleView=[[MarqueeLabel alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH-80, NAV_HEIGHT)];
            titleView.font=FONT_16B;
            titleView.textColor=TEXT_COLOR;
            titleView.textAlignment=NSTextAlignmentCenter;
            titleView.marqueeType = MLContinuous;
            titleView.scrollDuration = 10.0f;
            titleView.fadeLength = 10.0f;
            titleView.trailingBuffer = 30.0f;
            titleView.text=album.title;
            self.navigationItem.titleView=titleView;
            [self navBackShow];
            
            
            mainTop=NAV_HEIGHT+STATUS_BAR_HEIGHT;
            mainHeight=WIN_HEIGHT-mainTop;
            
            UIView *mainView=[[UIView alloc] initWithFrame:CGRectMake(0, mainTop, WIN_HEIGHT, mainHeight)];
            mainView.backgroundColor=[UIColor clearColor];
            [self.view addSubview:mainView];
            
            //大图
            float patternmakingImgHeight=WIN_WIDTH*(472/DESING_WIDTH);
            patternmakingImg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, patternmakingImgHeight)];
            [patternmakingImg setImageWithURL:[NSURL URLWithString:album.cover] placeholderImage:DEFAULT_IMAGE_472];
            [mainView addSubview:patternmakingImg];
            
            float noticeHeight=40.0;
            float noticeImgWidth=25.0;
            float noticeTextLeft=10+noticeImgWidth;
            //公告
            UIView *noticeView=[[UIView alloc] initWithFrame:CGRectMake(0, patternmakingImgHeight-noticeHeight, WIN_WIDTH, noticeHeight)];
            noticeView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
            [mainView addSubview:noticeView];
            
            UIImageView *noticeImg=[[UIImageView alloc] initWithFrame:CGRectMake(10, (noticeHeight-noticeImgWidth)/2, noticeImgWidth, noticeImgWidth)];
            noticeImg.image=[UIImage imageNamed:@"icon-guidepost"];
            [noticeView addSubview:noticeImg];
            
            MarqueeLabel *noticeText=[[MarqueeLabel alloc] initWithFrame:CGRectMake(noticeTextLeft, (noticeHeight-noticeImgWidth)/2, WIN_WIDTH-noticeTextLeft-10, noticeImgWidth)];
            noticeText.text=album.notice;
            noticeText.font=FONT_14;
            noticeText.textColor=[UIColor whiteColor];
            noticeText.marqueeType = MLContinuous;
            noticeText.scrollDuration = 10.0f;
            noticeText.fadeLength = 10.0f;
            noticeText.trailingBuffer = 70.0f;
            //noticeText.adjustsFontSizeToFitWidth=YES;
            noticeText.numberOfLines=1;
            [noticeView addSubview:noticeText];
            
            
            //信息
            float infoViewTop=patternmakingImgHeight;
            NSString *introductionText=album.introduction;
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
            [userIcon setImageWithURL:[NSURL URLWithString:album.icon] placeholderImage:DEFAULT_IMAGE];
            [infoView addSubview:userIcon];
            
            //已订阅
            float subscriptionButWidth=90.0;
            UIButton *subscriptionBut=[[UIButton alloc] initWithFrame:CGRectMake(WIN_WIDTH-subscriptionButWidth-10, 10, subscriptionButWidth, 30)];
            subscriptionBut.backgroundColor=RED_COLOR;
            subscriptionBut.layer.cornerRadius=3.0;
            [subscriptionBut addTarget:self action:@selector(orderParss) forControlEvents:UIControlEventTouchUpInside];
            [infoView addSubview:subscriptionBut];
            UILabel *subscriptionText=[[UILabel alloc] initWithFrame:CGRectMake(3, 0, 50, 30)];
            subscriptionText.text=@"已订阅";
            subscriptionText.font=FONT_16;
            subscriptionText.textColor=[UIColor whiteColor];
            [subscriptionBut addSubview:subscriptionText];
            UILabel *subscriptionSum=[[UILabel alloc] initWithFrame:CGRectMake(50+3, 4, subscriptionButWidth-50-6, 20)];
            subscriptionSum.text=[album.subscriptionSum stringValue];
            subscriptionSum.textColor=[UIColor whiteColor];
            subscriptionSum.font=FONT_14;
            subscriptionSum.adjustsFontSizeToFitWidth=YES;
            subscriptionSum.numberOfLines=1;
            [subscriptionBut addSubview:subscriptionSum];
            
            
            //专辑
            float albumTitleLeft=10+userIconWidth+10;
            UILabel *albumTitle=[[UILabel alloc] initWithFrame:CGRectMake(albumTitleLeft, 10, WIN_WIDTH-albumTitleLeft-subscriptionButWidth-10, 20)];
            albumTitle.text=album.title;
            albumTitle.font=FONT_16B;
            albumTitle.adjustsFontSizeToFitWidth=YES;
            albumTitle.numberOfLines=1;
            albumTitle.textColor=TEXT_COLOR;
            [infoView addSubview:albumTitle];
            
            //标签
            UILabel *albumTagView=[[UILabel alloc] initWithFrame:CGRectMake(albumTitleLeft, 35, WIN_WIDTH-albumTitleLeft-subscriptionButWidth-10, 20)];
            albumTagView.text=album.mediaTag;
            albumTagView.textColor=TEXT_COLOR;
            albumTagView.font=FONT_14;
            [infoView addSubview:albumTagView];
            
            
            //简介
            UILabel *introductionView=[[UILabel alloc] initWithFrame:CGRectMake(10, userIconWidth+10+5, introductionWidth, introductionHeight)];
            introductionView.text=introductionText;
            introductionView.font=FONT_14;
            introductionView.numberOfLines=0;
            [infoView addSubview:introductionView];
            
            operationViewTop=infoViewTop+infoViewHeight;
            operationViewHehght=mainHeight-operationViewTop;
            operationView=[[UIView alloc] initWithFrame:CGRectMake(0, operationViewTop, WIN_WIDTH, operationViewHehght)];
            [mainView addSubview:operationView];
            
            mediaArray=[NSMutableArray arrayWithCapacity:0];
            mediaListContentTop=0;
            pageSize=PAGE_SUM;
            pageSum=0;
            [self getMediaData];
            
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}

//获取数据
-(void)getMediaData{
    NSString *url=[UrlAPI getProgramSubjectList];
    
   NSDictionary *parameters = @{@"program_id":self.mediaId,@"page_index":[NSNumber numberWithInt:pageSum],@"page_size":[NSNumber numberWithInt:pageSize]};
    
//    NSLog(@"url:%@",url);
    [UPHTTPTools post:url params:parameters success:^(id responseObj) {
        NSLog(@"------================responseObj:%@",responseObj);
        NSNumber *code=[responseObj objectForKey:@"code"];
        if([code isEqualToNumber:[NSNumber numberWithInt:0]]){
            NSMutableArray *arr=[[responseObj objectForKey:@"content"] objectForKey:@"subjects"];
            [self initMediaView:arr];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

////获取数据
//-(void)getMediaData{
//    
//    NSString *urlStr = @"http://120.24.231.13:7090/ra/program?c=list_subject";
//    //NSString *urlStr = @"http://192.168.0.200:7090/ra/user?c=login";
//    
//    NSDictionary *parameters = @{@"program_id":[NSNumber numberWithInt:118],@"page_index":[NSNumber numberWithInt:0],@"page_size":[NSNumber numberWithInt:10]};
//    
//    NSString * keyUrl = @"radiohttp://120.24.231.13:7090/ra/column?c=listios1.0.0OUizijVi8ljdhBrjrequest";
//    NSString * key = [[keyUrl md5] uppercaseString];
//    
//    NSMutableDictionary *reqBody = [NSMutableDictionary dictionary];
//    [reqBody addEntriesFromDictionary:parameters];
//    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:reqBody options:NSJSONWritingPrettyPrinted error:nil];
//    
//    NSString *str=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
//    NSDictionary *p=[NSDictionary dictionaryWithObjectsAndKeys:[str stringByClearEmoji],@"p", nil];
//    
//    //1.获得请求管理者
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    
//    //申明返回的结果是json类型
//    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    
//    
//    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [mgr.requestSerializer setValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
//    [mgr.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Platform"];
//    [mgr.requestSerializer setValue:@"1.0.0" forHTTPHeaderField:@"Version"];
//    //    if(_source){
//    //        [mgr.requestSerializer setValue:_source forHTTPHeaderField:@"Source"];
//    //    }
//    
//    [mgr.requestSerializer setValue:@"OUizijVi8ljdhBrj" forHTTPHeaderField:@"UserId"];
//    
//    //    if(_auth){
//    //        [mgr.requestSerializer setValue:_auth forHTTPHeaderField:@"Auth"];
//    //    }
//    [mgr.requestSerializer setValue:@"" forHTTPHeaderField:@"AppId"];
//    
//    [mgr.requestSerializer setValue:key forHTTPHeaderField:@"Key"];
//    
//    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    //
//    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    //参数1,请求地址
//    //参数2,post参数
//    //参数3,请求成功的block回调
//    //参数4,请求失败的block回调
//    [mgr POST:urlStr parameters:p success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"%@",responseObject);
//        //        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        //        NSLog(@"%@",str);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error);
//    }];
//
//}

-(void)initMediaView:(NSMutableArray *) dict{
    
    [operationListView removeFromSuperview];
    int len=(int)dict.count;
    for (int i=0; i<len; i++) {
        Music *music=[[Music alloc] initMusicByDictionary:[dict objectAtIndex:i]];
        music.albumId=self.mediaId;
        music.album=album;
        [mediaArray addObject:music];
    }
    album.musicArray=mediaArray;
    operationListView=[OperationMediaListView alloc];
    operationListView.delegate=self;
    operationListView.mediaArray=mediaArray;
    operationListView.butFirst=1;
    operationListView=[operationListView initWithFrame:CGRectMake(0, 0, WIN_WIDTH, operationViewHehght)];
    [operationListView setOffset:CGPointMake(0, mediaListContentTop)];
    [operationView addSubview:operationListView];
}

-(void) viewWillAppear:(BOOL)animated{
    
    
}



//列表协议
-(void)operationPlayParss:(NSInteger)index{
    
    [self musicPlay:album.musicArray index:index];
    
}
-(void)operationDeleteParss:(NSInteger)index{
    Music *music=[mediaArray objectAtIndex:index];
    NSLog(@"删除:%@",music.title);
}
-(void)operationCommentsParss:(NSInteger)index{
    Music *music=[mediaArray objectAtIndex:index];
    CommentViewController *_viewController=[[CommentViewController alloc] init];
    _viewController.commentId=music.mediaId;
    _viewController.commentTitle=music.title;
    _viewController.commentType=0;
    [self pushViewRight:_viewController];
}
-(void)orderParss{
    [album orderAlbum:^{
        
    } failure:^(NSString * msg){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    } state:1];
}
-(void)operationGoodParss:(NSInteger)index{
//    Music *music=[mediaArray objectAtIndex:index];
//    NSLog(@"赞:%@",music.title);
}
-(void)operationShareParss:(NSInteger)index{
//    Music *music=[mediaArray objectAtIndex:index];
//    NSLog(@"分享:%@",music.title);
}
-(void)operationDownloadParss:(NSInteger)index{
//    Music *music=[mediaArray objectAtIndex:index];
//    NSLog(@"下载:%@",music.title);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
