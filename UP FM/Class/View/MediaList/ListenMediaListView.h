//
//  ListenMediaListView.h
//  UP FM
//
//  Created by liubin on 15/1/26.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMView.h"

@class Album;
@protocol listenViewDelegate


@optional
-(void)listenToAlbum:(Album *)album;
-(void)listenDel:(Music *) music;

@end

@interface ListenMediaListView : UPFMView<UITableViewDataSource, UITableViewDelegate>{
    
    NSMutableArray *mediaArray;
    
    float frameWidth;
    float tableHeight;
    
    float imgWidth;
    
    UITableView *_tableView;
    
}

@property(strong,nonatomic) NSMutableArray *mediaArray;
@property (nonatomic, assign) id<listenViewDelegate> delegate;
@property(nonatomic,assign) BOOL isDelBut;


@end
