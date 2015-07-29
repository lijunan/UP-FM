//
//  ChannelViewController.h
//  UP FM
//
//  Created by liubin on 15/1/30.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "FootBarViewController.h"
#import "MediaListView.h"


@interface ChannelViewController : FootBarViewController<mediaViewDelegate,UISearchBarDelegate>{

    UISearchBar *search;
    UIButton *sortButton;
    
    NSMutableArray *mediaArray;
    UIView *mediaView;
    MediaListView *mediaListView;
    float mediaListContentTop;
    
    float mediaHeight;
    float mediaTop;
    
    int pageSum;
    int pageSize;
}


@property(nonatomic,strong) NSString *title;
@property(nonatomic,assign) NSNumber *columnId;

@end
