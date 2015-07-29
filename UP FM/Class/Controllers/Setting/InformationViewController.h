//
//  InformationViewController.h
//  UP FM
//
//  Created by liubin on 15/1/28.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMViewController.h"
#import "GroupedView.h"
#import "TabBarView.h"
#import "TableSelectViewController.h"
#import "LoginInfo.h"

@interface InformationViewController : UPFMViewController<groupedViewDelegate,tabBarViewDelegate,UIScrollViewDelegate,UISearchBarDelegate,TableSelectViewDelegate,UIAlertViewDelegate>{
    
    //tab
    NSArray *tabBarArray;
    TabBarView *tabBar;
    float tabBarViewTop;
    float tabBarHeight;
    
    //列表
    UIScrollView *listView;
    float listViewTop;
    float listViewHeight;
    
    //子列表，基本信息
    GroupedView *basicListView;
    NSMutableArray *basicArray;
    NSMutableArray *basicTitleArray;

    //子列表，账号信息
    GroupedView *accountListView;
    NSMutableArray *accountArray;
    NSMutableArray *accountTitleArray;
    
    
    NSMutableArray *constellationArr;  //星座
    
    NSMutableArray *provinceArr;   //省
    NSMutableArray *cityArr;    //市
    
    
    NSArray *sexArr;
    NSArray *conditionArr;
    
    NSInteger _currSection;
    NSInteger _currRow;
    int currentIndex;
    
    CurrentUser *_currentUser;
    
    
}


@property (nonatomic,strong) LoginInfo *loginInfo;

@end
