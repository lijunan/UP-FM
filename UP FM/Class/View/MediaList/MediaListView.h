//
//  MediaListView.h
//  UP FM
//
//  Created by liubin on 15-1-24.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMView.h"

@class Album;
@protocol mediaViewDelegate

@optional
-(void)mediaToAlbum:(Album *)album;
@end

@interface MediaListView : UPFMView<UITableViewDataSource, UITableViewDelegate>{
    
    NSMutableArray *_mediaArray;
    
    float frameWidth;
    float tableHeight;
    
    float imgWidth;
    
    UITableView *_tableView;
    
}


@property(strong,nonatomic) NSMutableArray *mediaArray;
@property(nonatomic, assign) id<mediaViewDelegate> delegate;
@property(nonatomic,assign) BOOL isDelBut;
@property(nonatomic,assign) DelMediaType delType;

-(void)setOffset:(CGPoint)point;


@end
