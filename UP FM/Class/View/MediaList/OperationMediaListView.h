//
//  SaveMediaListView.h
//  UP FM
//
//  Created by liubin on 15/1/25.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMView.h"

@protocol operationMediaViewDelegate

@optional
-(void)operationPlayParss:(NSInteger)index;
-(void)operationDeleteParss:(NSInteger)index;
-(void)operationCommentsParss:(NSInteger)index;
-(void)operationGoodParss:(NSInteger)index;
-(void)operationShareParss:(NSInteger)index;
-(void)operationDownloadParss:(NSInteger)index;

@end

@interface OperationMediaListView : UPFMView<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>{
    
    float frameWidth;
    float viewWidth;
    float tableHeight;
    
    float imgWidth;
    
    float butPlayWidth;
    float butPlayImgWidth;
    float butPlayImgTop;
    
    UIView *butView;
    float butViewHeight;
    float butWidth;
    float butIconWidth;
    float butSubTop;
    
    UIButton *butDel;
    UIButton *butDownload;
    
    UITableView *_tableView;
    
    NSInteger operationIndex;
}

@property(strong,nonatomic) NSMutableArray *mediaArray;
@property(nonatomic,assign) int butFirst;   //第一个按钮，1=删除，2＝下载
@property (nonatomic, assign) id<operationMediaViewDelegate> delegate;

-(void)setOffset:(CGPoint)point;
-(void)refreshView;


@end
