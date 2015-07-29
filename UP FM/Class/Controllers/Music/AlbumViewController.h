//
//  AlbumViewController.h
//  UP FM
//
//  Created by liubin on 15/2/14.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMViewController.h"
#import "OperationMediaListView.h"
#import "Announcer.h"
#import "Album.h"

@interface AlbumViewController : UPFMViewController<operationMediaViewDelegate>{
    
    NSMutableArray *mediaArray;
    Album *album;
    
    //大图
    UIImageView *patternmakingImg;
    
    //信息
    UIView *infoView;
    
    UIView *operationView;
    OperationMediaListView *operationListView;
    float mediaListContentTop;
    
    
    float mainTop;
    float mainHeight;
    
    float operationViewTop;
    float operationViewHehght;
    
    int pageSum;
    int pageSize;
    
}

@property(nonatomic,assign) NSNumber *mediaId;

@end
