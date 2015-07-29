//
//  SearchMediaViewController.h
//  UP FM
//
//  Created by liubin on 15/1/31.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "FootBarViewController.h"
#import "MediaListView.h"

@interface SearchMediaViewController : FootBarViewController<mediaViewDelegate>{
        
    NSMutableArray *mediaArray;
    UIView *mediaView;
    MediaListView *mediaListView;
    
    float mediaTop;
    float mediaHeight;
    
    int pageSum;
    int pageSize;
}


@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *searchText;
@end
