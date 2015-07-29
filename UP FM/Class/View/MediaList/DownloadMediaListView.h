//
//  DownloadMediaListView.h
//  UP FM
//
//  Created by liubin on 15/1/26.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMView.h"

@protocol downloadMediaViewDelegate

@optional
-(void)downloadPlayParss:(int)index;
-(void)downloadPause:(Music *)music;
-(void)downloadResume:(Music *)music;
@end

@interface DownloadMediaListView : UPFMView<UITableViewDataSource, UITableViewDelegate>{
    
    float frameWidth;
    float viewWidth;
    float tableHeight;
    
    float imgWidth;
    
    float butPlayWidth;
    float butPlayImgWidth;
    float butPlayImgTop;
    
    UIView *downloadView;
    float downloadViewHeight;
    float downloadButWidth;
    float downloadIconWidth;
    float downloadIconTop;
    float downloadPercentageHeight;
    float downloadPercentageWidth;
    
    UITableView *_tableView;
    
}

@property(strong,nonatomic) NSMutableArray *mediaArray;
@property (nonatomic, assign) id<downloadMediaViewDelegate> delegate;

-(void)refreshView;

- (void)DLV_Downloading:(DownloadQueue *)downloadingElement;
- (void)DLV_DownloadedSuccess:(Music *)downloadedElement;
- (void)DLV_Pause:(Music *)pauseSong;
- (void)DLV_DeleteSuccess:(Music *)deleteSong;
@end
