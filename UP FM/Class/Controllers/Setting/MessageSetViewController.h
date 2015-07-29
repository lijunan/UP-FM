//
//  MessageViewController.h
//  UP FM
//
//  Created by liubin on 15/1/28.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMViewController.h"

@interface MessageSetViewController : UPFMViewController<UITableViewDataSource, UITableViewDelegate>{
    
    UITableView *_tableView;
    
    float tableTop;
    float tableHeight;
    
}


@end
