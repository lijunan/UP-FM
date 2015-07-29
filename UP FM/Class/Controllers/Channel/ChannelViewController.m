//
//  ChannelViewController.m
//  UP FM
//
//  Created by liubin on 15/1/30.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "ChannelViewController.h"
#import "Album.h"
#import "AlbumViewController.h"
#import "PlayerViewController.h"
#import "Functions.h"

@implementation ChannelViewController

@synthesize title;
@synthesize columnId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    /*
     * 导航条设置
     */
    //返回
    [self navBackShow];
    //加载底部导航
    [self footBarShow];
    //设置当前底部导航
    [self setFootBarCurrentBut:@"发现"];
    
    //搜索条
    float searchTop=STATUS_BAR_HEIGHT+NAV_HEIGHT;
    float searchHeight=50.0;
    UIView *searchBoxView=[[UIView alloc] initWithFrame:CGRectMake(0, searchTop, WIN_WIDTH, searchHeight)];
    searchBoxView.backgroundColor=[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
    [self.view addSubview:searchBoxView];
    search=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH-70, searchHeight)];
    search.backgroundImage=[Functions createImageWithColor:[UIColor clearColor]];
    search.placeholder=@"搜索节目或主播名称";
    search.delegate=self;
    [searchBoxView addSubview: search];
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
    
    
    
    
    
    mediaTop=searchTop+searchHeight;
    mediaHeight=WIN_HEIGHT-mediaTop-footHeight;
    mediaView=[[UIView alloc] initWithFrame:CGRectMake(0, mediaTop, WIN_WIDTH,mediaHeight)];
    [self.view addSubview:mediaView];
    
    mediaArray=[NSMutableArray arrayWithCapacity:0];
    mediaListContentTop=0;
    pageSize=PAGE_SUM;
    pageSum=0;
    
    [self getMediaData];
    
    
    
}
//获取数据
-(void)getMediaData{
    NSString *url=[UrlAPI getProgramList];
    NSDictionary *parameters = @{@"column_id":self.columnId,@"page_index":[NSNumber numberWithInt:pageSum],@"page_size":[NSNumber numberWithInt:pageSize]};
    
    [UPHTTPTools post:url params:parameters success:^(id responseObj) {
        //NSLog(@"responseObj:%@",responseObj);
        NSNumber *code=[responseObj objectForKey:@"code"];
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
        
        search.text = [toBeString substringToIndex:max];
        
        return NO;
        
    }
    
    
    return YES;
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


@end
