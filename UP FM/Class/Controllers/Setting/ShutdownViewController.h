//
//  ShutdownViewController.h
//  UP FM
//
//  Created by liubin on 15/1/27.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMViewController.h"

@interface ShutdownViewController : UPFMViewController<UITableViewDataSource, UITableViewDelegate>{
    
    UITableView *_tableView;
    
    float tableTop;
    float tableHeight;
    
    NSInteger currentIndex;
    NSArray *timeArr;
    
    int currentTime;
    
    BOOL isShutdown;
}


@property(nonatomic,retain) UIView   *selectedBackgroundView;

@end
