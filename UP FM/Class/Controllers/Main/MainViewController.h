//
//  MainViewController.h
//  UP FM
//  首页
//  Created by liubin on 15-1-22.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "FootBarViewController.h"
#import "WheelView.h"
#import "ModuleNavView.h"
#import "MediaListView.h"


@interface MainViewController : FootBarViewController<WheelViewDelegate,navViewDelegate,mediaViewDelegate,UISearchBarDelegate,UIAlertViewDelegate>{
    
    UISearchBar *search;
    
    
    NSMutableArray *wheelListArray;
    NSMutableArray *navArray;
    NSMutableArray *mediaArray;
    
    MediaListView *mediaListView;
    float mediaListContentTop;
    
    
}



@end
