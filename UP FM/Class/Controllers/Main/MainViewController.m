//
//  MainViewController.m
//  UP FM
//
//  Created by liubin on 15-1-22.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "MainViewController.h"
#import "Music.h"
#import "Album.h"
#import "PlayerViewController.h"
#import "AlbumViewController.h"
#import "ChannelViewController.h"
#import "SearchMediaViewController.h"
#import "RegisterViewController.h"
#import "AreaAPI.h"

@interface MainViewController (){
    
    float wheelHeight;
    UIView *wheelView;
    
    UIView *navView;
    float moduleNavHeight;
    
    UIView *mediaView;
    float mediaTop;
    float mediaHeight;
    
    
    
}
@end

@implementation MainViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    if([[UPHTTPTools sharedClient] isEqualToString:@"no"]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"当前无网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag=1;
        [alert show];
    }
    //判断是跳过否注册
    BOOL isRegister =[[NSUserDefaults standardUserDefaults] boolForKey:@"isRegister"];
    if(!isRegister){
        RegisterViewController *_viewController = [[RegisterViewController alloc] init];
        _viewController.isMain=YES;
        [self pushView:_viewController];
    }

    
    /*
     * 导航条设置
     */
    
    //搜索条

    search=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    search.placeholder=@"搜索声音、专辑、人";
    search.delegate=self;
    
    self.navigationItem.titleView=search;
    
    
    
    //加载底部导航
    [self footBarShow];
    //设置当前底部导航
    [self setFootBarCurrentBut:@"发现"];
    
    
    
    
    //按比例计算出轮播高

    wheelHeight=WIN_WIDTH*(320.0/DESING_WIDTH);
    
     wheelView=[[UIView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT+STATUS_BAR_HEIGHT, WIN_WIDTH, wheelHeight)];
    
    [self initWheel];
    
    
    
    
    //模块导航
    //按比例计算出模块导航高
    moduleNavHeight=WIN_WIDTH*(351.0/DESING_WIDTH)/2;
    navView=[[UIView alloc] initWithFrame:CGRectMake(0,STATUS_BAR_HEIGHT+NAV_HEIGHT+wheelHeight, WIN_WIDTH,moduleNavHeight)];
    [self.view addSubview:navView];
    [self initNavData];
    
    //音乐列表
    mediaTop=STATUS_BAR_HEIGHT+NAV_HEIGHT+wheelHeight+moduleNavHeight;
    mediaHeight=WIN_HEIGHT-mediaTop-footHeight;
    mediaView=[[UIView alloc] initWithFrame:CGRectMake(0, mediaTop, WIN_WIDTH,mediaHeight)];
    [self.view addSubview:mediaView];
    
    
}

-(void)initWheel{
    
    NSString *url=[UrlAPI getAdvHome];
    
    wheelListArray=[NSMutableArray arrayWithCapacity:0];
    NSDictionary *parameters = @{@"top":[NSNumber numberWithInt:0]};
    
    
    [UPHTTPTools post:url params:parameters success:^(id responseObj) {
        NSNumber *code=[responseObj objectForKey:@"code"];
        
        if([code isEqualToNumber:[NSNumber numberWithInt:0]]){
            
            [wheelListArray addObjectsFromArray:[responseObj objectForKey:@"content"]];
            
            WheelView *wheel=[WheelView alloc];
            wheel.wheelArray=wheelListArray;
            wheel.delegate=self;
            wheel=[wheel initWithFrame:CGRectMake(0, 0, WIN_WIDTH,wheelHeight)];
            [wheelView addSubview:wheel];
            [self.view addSubview:wheelView];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}

-(void)initNavData{
    
    NSString *url=[UrlAPI getColumnList];
    navArray=[NSMutableArray arrayWithCapacity:0];
    NSDictionary *parameters = @{@"top":[NSNumber numberWithInt:0]};
    [UPHTTPTools post:url params:parameters success:^(id responseObj) {
        NSNumber *code=[responseObj objectForKey:@"code"];
        if([code isEqualToNumber:[NSNumber numberWithInt:0]]){
            [navArray addObjectsFromArray:[responseObj objectForKey:@"content"]];
//            if(navArray.count<8){
//                NSNumber *_id=[NSNumber numberWithInt:-1];
//                NSDictionary *dictMore=[NSDictionary dictionaryWithObjectsAndKeys:@"更多",@"column_name",_id,@"column_id",@"icon-more.png",@"column_icon", nil];
//                [navArray addObject:dictMore];
//            }
            ModuleNavView *moduleNavView=[ModuleNavView alloc];
            moduleNavView.navArray=navArray;
            moduleNavView.delegate=self;
            moduleNavView=[moduleNavView  initWithFrame:CGRectMake(0, 0, WIN_WIDTH, moduleNavHeight)];
            [navView addSubview:moduleNavView];
            
            mediaListContentTop=0.0;
            [self getMediaData];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
//获取数据
-(void)getMediaData{
    NSString *url=[UrlAPI getProgramList];
    mediaArray=[NSMutableArray arrayWithCapacity:0];
    NSDictionary *parameters = @{@"column_id":[[navArray objectAtIndex:0] objectForKey:@"column_id"],@"page_index":[NSNumber numberWithInt:0],@"page_size":[NSNumber numberWithInt:5]};
    
    [UPHTTPTools post:url params:parameters success:^(id responseObj) {
        NSNumber *code=[responseObj objectForKey:@"code"];
//        NSLog(@"responseObj:%@",responseObj);
        if([code isEqualToNumber:[NSNumber numberWithInt:0]]){
            NSMutableArray *arr=[[responseObj objectForKey:@"content"] objectForKey:@"programs"];
            NSMutableArray *dict=[NSMutableArray arrayWithCapacity:0];
            int len=(int)arr.count;
            for (int i=0; i<len; i++) {
                [dict addObject:[[Album alloc] initAlbumByDictionary:[arr objectAtIndex:i]]];
            }
            [self initMediaView:dict];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
//加载内容
-(void)initMediaView:(NSMutableArray *)dict{
    [mediaListView removeFromSuperview];
    [mediaArray addObjectsFromArray:dict];
    mediaListView=[MediaListView alloc];
    mediaListView.delegate=self;
    mediaListView.mediaArray=mediaArray;
    mediaListView.isDelBut=NO;
    [mediaListView setOffset:CGPointMake(0, mediaListContentTop)];
    mediaListView=[mediaListView initWithFrame:CGRectMake(0, 0, WIN_WIDTH, mediaHeight)];
    [mediaView addSubview:mediaListView];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void) viewWillAppear:(BOOL)animated{
   
    if([self.mcPlayer isPlaying]){
        [self navMusicButtonHide:NO];
    }else{
        [self navMusicButtonHide:YES];
    }

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
    NSString *searchText=[searchBar.text trim];
    if([searchBar.text isEmpty]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"请输入搜索内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        NSString *tit=[NSString stringWithFormat:@"搜索:%@",searchText];
        searchBar.showsCancelButton = NO;
        [searchBar resignFirstResponder];
        SearchMediaViewController *_viewController = [[SearchMediaViewController alloc] init];
        _viewController.title=tit;
        _viewController.searchText=searchText;
        [self pushViewRight:_viewController];
    }
    
}
//键盘每次点击事件
-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    int max=30;
    NSString * toBeString = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    if (toBeString.length > max) {
        
        search.text = [toBeString substringToIndex:max];
        
        return NO;
        
    }

    
    return YES;
}

//轮播点击协议
-(void)wheelParss:(int)index{
    NSLog(@"点击第%d个图",index);
}

//模块导航点击协议
-(void)navButParss:(int)index{
        NSString *tit=[[navArray objectAtIndex:index] objectForKey:@"column_name"];
        NSNumber *columnId=[[navArray objectAtIndex:index] objectForKey:@"column_id"];
    if([columnId intValue]>-1){
        ChannelViewController *_viewController = [[ChannelViewController alloc] init];
        _viewController.title=tit;
        _viewController.columnId=columnId;
        [self pushViewRight:_viewController];
    }

}

-(void)mediaToAlbum:(Album *)album{
    AlbumViewController *_viewController = [[AlbumViewController alloc] init];
    _viewController.mediaId= album.mediaId;
    [self pushViewRight:_viewController];
}
-(void)mediaToMusic:(int)index{
    PlayerViewController *_viewController = [[PlayerViewController alloc] init];
    
    [self pushViewRight:_viewController];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}
@end
