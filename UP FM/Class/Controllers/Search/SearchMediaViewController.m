//
//  SearchMediaViewController.m
//  UP FM
//
//  Created by liubin on 15/1/31.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "SearchMediaViewController.h"
#import "Album.h"
#import "PlayerViewController.h"
#import "AlbumViewController.h"
#import "Functions.h"



@implementation SearchMediaViewController

@synthesize title;
@synthesize searchText;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    pageSize=PAGE_SUM;
    pageSum=0;
    
    
    /*
     * 导航条设置
     */
    //返回
    [self navBackShow];
    //加载底部导航
    [self footBarShow];
    //设置当前底部导航
    [self setFootBarCurrentBut:@"发现"];
    
    
    mediaTop=STATUS_BAR_HEIGHT+NAV_HEIGHT;
    mediaHeight=WIN_HEIGHT-mediaTop-footHeight;
    mediaView=[[UIView alloc] initWithFrame:CGRectMake(0, mediaTop, WIN_WIDTH,mediaHeight)];
    [self.view addSubview:mediaView];
    
    [self getMediaData];
    
    
}

//获取数据
-(void)getMediaData{
    NSString *url=[UrlAPI getSearch];
    mediaArray=[NSMutableArray arrayWithCapacity:0];
    NSDictionary *parameters = @{@"search_content":self.searchText,@"page_index":[NSNumber numberWithInt:pageSum],@"page_size":[NSNumber numberWithInt:pageSize]};
    [UPHTTPTools post:url params:parameters success:^(id responseObj) {
        NSNumber *code=[responseObj objectForKey:@"code"];
        NSLog(@"responseObj:%@",responseObj);
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

-(void)initMediaView:(NSMutableArray *)dict{
    [mediaListView removeFromSuperview];
    [mediaArray addObjectsFromArray:dict];
    mediaListView=[MediaListView alloc];
    mediaListView.delegate=self;
    mediaListView.mediaArray=mediaArray;
    mediaListView.isDelBut=NO;
    mediaListView=[mediaListView initWithFrame:CGRectMake(0, 0, WIN_WIDTH, mediaHeight)];
    [mediaView addSubview:mediaListView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void) viewWillAppear:(BOOL)animated{
    
}


-(void)mediaToAlbum:(Album *)album{
    AlbumViewController *_viewController = [[AlbumViewController alloc] init];
    _viewController.mediaId=album.mediaId;
    [self pushViewRight:_viewController];
}
-(void)mediaToMusic:(int)index{
    PlayerViewController *_viewController = [[PlayerViewController alloc] init];
    [self pushViewRight:_viewController];
}
-(void)mediaDel:(Album *)album{
    
}


@end
