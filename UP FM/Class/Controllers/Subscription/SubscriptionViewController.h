//
//  SubscriptionViewController.h
//  UP FM
//  已订阅模块首页
//  Created by liubin on 15-1-24.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "FootBarViewController.h"
#import "TabBarView.h"
#import "MediaListView.h"
#import "OperationMediaListView.h"
#import "DownloadMediaListView.h"
#import "ListenMediaListView.h"

@interface SubscriptionViewController : FootBarViewController<tabBarViewDelegate,UIScrollViewDelegate,UISearchBarDelegate,mediaViewDelegate,operationMediaViewDelegate,downloadMediaViewDelegate,listenViewDelegate>{
    
    //tab
    NSArray *tabBarArray;
    TabBarView *tabBar;
    float tabBarViewTop;
    float tabBarHeight;
    
    
    //列表
    UIScrollView *listView;
    float listViewTop;
    float listViewHeight;
    
    
    int currentIndex;   //当前列表下标
    //子列表，我的订阅
    UIView *mediaView;
    MediaListView *mediaListView;
    NSMutableArray *mediaArray;
    float mediaListContentTop;
    //子列表，已下载
    UIView *saveView;
    OperationMediaListView *saveListView;
    NSMutableArray *saveArray;
    //子列表，下载中
    UIView *downloadView;
    DownloadMediaListView *downloadListView;
    NSMutableArray *downloadArray;
    //子列表，我听过的
    UIView *lsitenView;
    ListenMediaListView *listenListView;
    NSMutableArray *listenArray;
    
    
    
    //搜索排序
    UIView *searchBoxView;
    UISearchBar *_searchBar;
    UIButton *sortButton;
    
    NSArray *orderByArr;
    NSInteger orderBy;
    NSArray *orderTypeArr;
    NSInteger orderType;
    NSString *searchText;
    int pageSum;
    int pageSize;
    
}



@end
