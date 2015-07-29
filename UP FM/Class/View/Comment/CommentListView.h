//
//  CommentListView.h
//  UP FM
//
//  Created by liubin on 15/1/29.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMView.h"

@protocol commentViewDelegate

-(void)commentParss:(NSInteger)index;

@end


@interface CommentListView : UPFMView<UITableViewDataSource, UITableViewDelegate>{
    
    NSMutableArray *commentArray;
    
    NSMutableArray *contentHeightArray;
    
    float frameWidth;
    float contentWidth;
    
    float contentLeft;
    float iconWidth;
    
    UITableView *_tableView;
    
}

@property(strong,nonatomic) NSMutableArray *commentArray;
@property(nonatomic, assign) id<commentViewDelegate> delegate;

@end
