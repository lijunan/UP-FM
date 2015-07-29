//
//  TableCheckboxViewController.h
//  UP FM
//
//  Created by liubin on 15/3/3.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMViewController.h"

@protocol TableCheckboxViewDelegate

-(void)tableCheckboxGoBack:(NSArray *)checkedArray signal:(NSInteger)signal;

@end

@interface TableCheckboxViewController : UPFMViewController<UITableViewDataSource, UITableViewDelegate>{
    
    UITableView *_tableView;
    
    float tableTop;
    float tableHeight;
    
}


@property (nonatomic,strong) NSMutableArray *checkboxArray; //选项数组
@property (nonatomic,strong) NSMutableArray *currentArray;  //已选中数组
@property (nonatomic,assign) NSInteger signal;
@property (nonatomic, assign) id<TableCheckboxViewDelegate> delegate;
@end
