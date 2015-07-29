//
//  SubscriptionViewController.m
//  UP FM
//  
//  Created by liubin on 15-1-24.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "SubscriptionViewController.h"
#import "Music.h"
#import "Album.h"
#import "Functions.h"
#import "PlayerViewController.h"
#import "AlbumViewController.h"
#import "LoginViewController.h"
#import "PlayHistoryController.h"
#import "DownloadController.h"
#import "CommentViewController.h"
#import "DownloadQueue.h"

@interface SubscriptionViewController (){
    float searchHeight;
}

@end

@implementation SubscriptionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    tabBarArray=[NSMutableArray arrayWithObjects:@"我的订阅",@"已下载",@"下载中",@"我听过的",nil];
    
    orderByArr=[NSArray arrayWithObjects:@"按更新时间",@"按订购时间",@"按节目名称", nil];
    orderTypeArr=[NSArray arrayWithObjects:@"升序",@"降序", nil];
    orderBy=[orderByArr indexOfObject:@"按更新时间"];
    orderType=[orderTypeArr indexOfObject:@"升序"];
    searchText=@"";
    pageSize=PAGE_SUM;
    pageSum=0;
    
    //加载底部导航
    [self footBarShow];
    //设置当前底部导航
    [self setFootBarCurrentBut:@"已订阅"];
    
    //设置导航
    self.title=@"已订阅";
    
    //加载tab
    tabBarHeight=WIN_WIDTH*(95/DESING_WIDTH);
    tabBarViewTop=NAV_HEIGHT+STATUS_BAR_HEIGHT;
    
    UIView *tabBarView=[[UIView alloc] initWithFrame:CGRectMake(0,tabBarViewTop , WIN_WIDTH, tabBarHeight)];
    [self.view addSubview:tabBarView];
    self.view.layer.masksToBounds=YES;
    tabBar=[TabBarView alloc];
    tabBar.tabArray=tabBarArray;
    tabBar.delegate=self;
    tabBar=[tabBar initWithFrame:CGRectMake(0, 0, WIN_WIDTH, tabBarHeight)];
    [tabBarView addSubview:tabBar];
    
    //加载列表
    listViewTop=tabBarViewTop+tabBarHeight;
    listViewHeight=WIN_HEIGHT-listViewTop-footHeight;
    
    listView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, listViewTop, WIN_WIDTH, listViewHeight)];
    listView.backgroundColor=[UIColor clearColor];
    listView.delegate=self;
    listView.contentSize=CGSizeMake(WIN_WIDTH*(int)tabBarArray.count, listViewHeight);
    listView.pagingEnabled=YES;
    listView.showsVerticalScrollIndicator=NO;
    listView.showsHorizontalScrollIndicator=NO;
    listView.bounces=NO;
    listView.scrollEnabled=NO;
    
    [listView setCanCancelContentTouches:YES];
    [self.view addSubview:listView];
    
    
    
    //我的订阅
    //搜索
    searchHeight=50.0;
    searchBoxView=[[UIView alloc] initWithFrame:CGRectMake(WIN_WIDTH*0, 0, WIN_WIDTH, searchHeight)];
    searchBoxView.backgroundColor=[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
    [listView addSubview:searchBoxView];
    _searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH-70, searchHeight)];
    _searchBar.backgroundImage=[Functions createImageWithColor:[UIColor clearColor]];
    _searchBar.placeholder=@"搜索节目或主播名称";
    _searchBar.delegate=self;
    [searchBoxView addSubview:_searchBar];
    
    sortButton=[[UIButton alloc] initWithFrame:CGRectMake(WIN_WIDTH-70, 0, 70, searchHeight)];
    float sortTextWidth=50.0;
    UILabel *sortText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, sortTextWidth, searchHeight)];
    sortText.text=@"更新时间";
    sortText.font=FONT_12;
    sortText.textColor=TEXT_COLOR;
    [sortButton addSubview:sortText];
    float sortImgWidth=WIN_WIDTH*(16/DESING_WIDTH);
    float sortImgHeight=WIN_WIDTH*(14/DESING_WIDTH);
    UIImageView *sortImg=[[UIImageView alloc] initWithFrame:CGRectMake(sortTextWidth+1, (searchHeight-sortImgHeight)/2+1, sortImgWidth, sortImgHeight)];
    sortImg.image=[UIImage imageNamed:@"icon-arrows-down"];
    [sortButton addSubview:sortImg];
    [searchBoxView addSubview:sortButton];
    
    
    //我的订阅列表
    mediaArray=[NSMutableArray arrayWithCapacity:0];
    mediaListContentTop=0.0;
    mediaView=[[UIView alloc] initWithFrame:CGRectMake(WIN_WIDTH*0, searchHeight, WIN_WIDTH, listViewHeight-searchHeight)];
    [listView addSubview:mediaView];

    
    //已下载
    saveView=[[UIView alloc] initWithFrame:CGRectMake(WIN_WIDTH*1, 0, WIN_WIDTH, listViewHeight)];
    [listView addSubview:saveView];
    
    
    //下载中列表
    downloadView=[[UIView alloc] initWithFrame:CGRectMake(WIN_WIDTH*2, 0, WIN_WIDTH, listViewHeight)];
    [listView addSubview:downloadView];
    
    //我听过的列表
    lsitenView=[[UIView alloc] initWithFrame:CGRectMake(WIN_WIDTH*3, 0, WIN_WIDTH, listViewHeight-searchHeight)];
    [listView addSubview:lsitenView];
    
    //监听
    [self initDownloadManagementListNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void) viewWillAppear:(BOOL)animated{
    [self inspectLogin];
}

-(void)inspectLogin{
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]){
        LoginViewController *_viewController=[[LoginViewController alloc] init];
        _viewController.isBackHide=YES;
        [self pushViewRight:_viewController];
    }else{
        mediaArray=[NSMutableArray arrayWithCapacity:0];
        [self getMediaData];
    }
}

//订阅列表
-(void)getMediaData{
    NSString *url=[UrlAPI getProgramOrderList];
    NSDictionary *parameters = @{@"search_content":searchText,@"order_by":[NSNumber numberWithInt:0],@"order_by":[NSNumber numberWithInteger:orderBy],@"order_desc":[NSNumber numberWithInteger:orderType],@"page_index":[NSNumber numberWithInt:pageSum],@"page_size":[NSNumber numberWithInt:pageSize]};
//    NSLog(@"parameters:%@",parameters);
    [UPHTTPTools post:url params:parameters success:^(id responseObj) {
//        NSLog(@"responseObj:%@",responseObj);
        NSNumber *code=[responseObj objectForKey:@"code"];
        if([code isEqualToNumber:[NSNumber numberWithInt:0]]){
            NSMutableArray *arr=[[responseObj objectForKey:@"content"] objectForKey:@"programs"];
            NSMutableArray *dict=[NSMutableArray arrayWithCapacity:0];
            int len=(int)arr.count;
            for (int i=0; i<len; i++) {
                [dict addObject:[[Album alloc] initAlbumByDictionary:[arr objectAtIndex:i]]];
            }
            [self initMediaList:dict];
            
        }else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:[responseObj objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//初始化我的订阅列表
-(void)initMediaList:(NSMutableArray *)arr{
    
    [mediaListView removeFromSuperview];
    
    [mediaArray addObjectsFromArray:arr];
    
    mediaListView=[MediaListView alloc];
    mediaListView.delegate=self;
    mediaListView.mediaArray=mediaArray;
    mediaListView.isDelBut=YES;
    [mediaListView setOffset:CGPointMake(0, mediaListContentTop)];
    mediaListView=[mediaListView initWithFrame:CGRectMake(0,0, WIN_WIDTH, listViewHeight-searchHeight)];
    [mediaView addSubview:mediaListView];
    
}
//初始化已下载列表
-(void)initSaveList{
    [saveListView removeFromSuperview];
    NSArray *downList=[[DownloadController sharedInstance] getDownloadedList];
    saveArray=[NSMutableArray arrayWithCapacity:0];
    [saveArray addObjectsFromArray:downList];
    saveListView=[OperationMediaListView alloc];
    saveListView.delegate=self;
    saveListView.mediaArray=saveArray;
    saveListView.butFirst=2;
    saveListView=[saveListView initWithFrame:CGRectMake(0, 0, WIN_WIDTH, listViewHeight)];
    [saveView addSubview:saveListView];
}
//初始化下载中列表
-(void)initDownloadList{
    [downloadListView removeFromSuperview];
    downloadArray=[NSMutableArray arrayWithCapacity:0];
    [downloadArray addObjectsFromArray:[[DownloadController sharedInstance] getDownloadQueue]];
    downloadListView=[DownloadMediaListView alloc];
    downloadListView.delegate=self;
    downloadListView.mediaArray=downloadArray;
    downloadListView=[downloadListView initWithFrame:CGRectMake(0, 0, WIN_WIDTH, listViewHeight)];
    [downloadView addSubview:downloadListView];

}

//我听过的
-(void)initListenListView{
    [listenListView removeFromSuperview];
    NSArray *arr=[NSMutableArray arrayWithArray:[[PlayHistoryController sharedInstance] getHistoryWithPage:0 pageSize:10 timeType:ttAll]];
    listenArray=[NSMutableArray arrayWithCapacity:0];
    for (NSManagedObject *info in arr) {
        Music *music=[[Music alloc] init];
        Album *album=[[Album alloc] init];
        album.title=[info valueForKey:@"albumTitle"];
        album.icon=[info valueForKey:@"albumIcon"];
        album.mediaId=[info valueForKey:@"albumId"];
        album.mediaTag=[info valueForKey:@"albumTag"];
        //music.insertDate=[info valueForKey:@"insertDate"];
        music.albumId=[info valueForKey:@"albumId"];
        music.title=[info valueForKey:@"musicTitle"];
        music.mediaId=[info valueForKey:@"musicId"];
        music.timePlay=[info valueForKey:@"playTime"];
        music.album=album;
        [listenArray addObject:music];
    }
    
    listenListView=[ListenMediaListView alloc];
    listenListView.delegate=self;
    listenListView.mediaArray=listenArray;
    listenListView.isDelBut=YES;
    listenListView=[listenListView initWithFrame:CGRectMake(0,0, WIN_WIDTH, listViewHeight)];
    [lsitenView addSubview:listenListView];
}

//划动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
}
//划动停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    currentIndex=ceil(listView.contentOffset.x/WIN_WIDTH);
    [tabBar setCurrentTab:currentIndex];
}

/**
 * 搜索协议
 **/
//进入搜索框，显示取消按钮
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    return YES;
}
//点击搜索框上的 取消按钮时 调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
}
//点击搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"搜索:%@",searchBar.text);
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}
//键盘每次点击事件
-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    int max=30;
    NSString * toBeString = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    if (toBeString.length > max) {
        
        searchBar.text = [toBeString substringToIndex:max];
        
        return NO;
        
    }
    
    
    return YES;
}



-(void)tabButParss:(int)index{
    currentIndex=index;
    [listView setContentOffset:CGPointMake(WIN_WIDTH*index, 0) animated:YES];
    switch (index) {
        case 0:
            
            break;
        case 1:
            [self initSaveList];
            break;
        case 2:
            [self initDownloadList];
            break;
        case 3:
            [self initListenListView];
            break;
        default:
            break;
    }
}

//我的订阅列表协议
-(void)mediaToAlbum:(Album *)album{
    [self toAlbum:album];
}


//已下载列表协议
-(void)operationPlayParss:(NSInteger)index{
    Music *music=[[Music alloc] initMusicByDownloaded:[saveArray objectAtIndex:index]];
    
    [self musicPlay:[NSMutableArray arrayWithObject:music] index:0];
    
}
-(void)operationDeleteParss:(NSInteger)index{
    Music *music=[saveArray objectAtIndex:index];
    [[DownloadController sharedInstance] deleteDownloadedFile:music];
    [saveArray removeObjectAtIndex:index];
    saveListView.mediaArray=saveArray;
    [saveListView refreshView];
}
-(void)operationCommentsParss:(NSInteger)index{
    Music *music=[saveArray objectAtIndex:index];
    CommentViewController *_viewController=[[CommentViewController alloc] init];
    _viewController.commentId=music.mediaId;
    _viewController.commentTitle=music.title;
    _viewController.commentType=0;
    [self pushViewRight:_viewController];
}
-(void)operationGoodParss:(NSInteger)index{
    Music *music=[saveArray objectAtIndex:index];
    Music *music2=[[Music alloc] init];
    music2.mediaId=music.mediaId;
    [saveListView refreshView];

    [music2 goodMusic:^{
        music.goodSum=[NSNumber numberWithInt:[music.goodSum intValue]+1];
        [saveArray replaceObjectAtIndex:index withObject:music];
        
//        [[DownloadController sharedInstance] updateDownloadedList:saveArray];
        saveListView.mediaArray=saveArray;
        [saveListView refreshView];
    } failure:^(NSString * msg){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}
-(void)operationShareParss:(NSInteger)index{
    Music *music=[saveArray objectAtIndex:index];
    NSLog(@"分享:%@",music.title);
}
-(void)operationDownloadParss:(NSInteger)index{
//    Music *music=[saveArray objectAtIndex:index];
//    NSLog(@"下载:%@",music.title);
}


//下载中协议
-(void)downloadPlayParss:(int)index{
//    Music *music=[saveArray objectAtIndex:index];
//    NSLog(@"播放:%@",music.title);
}
-(void)downloadPause:(Music *)music{
    [[DownloadController sharedInstance] pause:music];
}
-(void)downloadResume:(Music *)music{
    [[DownloadController sharedInstance] resume:music];
}


//我听过的协议

-(void)listenToAlbum:(Album *)album{
    [self toAlbum:album];
}


-(void)toAlbum:(Album *)album{
    AlbumViewController *_viewController = [[AlbumViewController alloc] init];
    _viewController.mediaId=album.mediaId;
    [self pushViewRight:_viewController];
}



#pragma mark - notification 下载监听
- (void)initDownloadManagementListNotification
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(DMLVC_Downloading:)
                               name:MCResumeDownloadDidDownloadingNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(DMLVC_DownloadedSuccess:)
                               name:MCResumeDownloadDidDownloadSuccessNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(DMLVC_DeleteSuccess:)
                               name:MCResumeDownloadDidDeleteFileNotification
                             object:nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(DMLVC_Pause:)
                               name:MCResumeDownloadDidPauseNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(initData)
                               name:CoreDataDidSaveSucess
                             object:nil];
}

- (void)DMLVC_Downloading:(NSNotification *)notification
{
    DownloadQueue *queueElement = [notification object];
    [downloadListView DLV_Downloading:queueElement];
}

- (void)DMLVC_DownloadedSuccess:(NSNotification *)notification
{
    
    DownloadQueue *queueElement = [notification object];
    Music *song = [[Music alloc] init];
    song.mediaId=queueElement.mediaId;
    [song downloadSumAdd];
    int len=(int)downloadArray.count;
    int index=-1;
    for(int i=0;i<len;i++){
        Music *m=[downloadArray objectAtIndex:i];
        if([m.mediaId isEqualToNumber:song.mediaId]){

            index=i;
            
        }
    }
    
    if(index>-1 && index<len){
        [downloadArray removeObjectAtIndex:index];
        downloadListView.mediaArray=downloadArray;
        [downloadListView DLV_DownloadedSuccess:song];
    }
    [self initSaveList];
}

- (void)DMLVC_DeleteSuccess:(NSNotification *)notification
{
    Music *song = [notification object];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_MSEC * 500), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [downloadListView DLV_DeleteSuccess:song];
    });
}

- (void)DMLVC_Pause:(NSNotification *)notification
{
    Music *song = [notification object];
    [downloadListView DLV_Pause:song];
}
-(void)initData{
    
}
@end
