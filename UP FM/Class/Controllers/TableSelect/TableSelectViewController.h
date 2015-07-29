//
//  TableSelectViewController.h
//  UP FM
//
//  Created by liubin on 15/2/1.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMViewController.h"
#import "TableSelectEditViewController.h"

@protocol TableSelectViewDelegate

-(void)tableSelectGoBack:(NSString *)currString section:(NSInteger)section;

@end

@interface TableSelectViewController : UPFMViewController<UITableViewDataSource, UITableViewDelegate,TableSelectEditViewDelegate>{
    
    UITableView *_tableView;
    
    float tableTop;
    float tableHeight;
    
    
}


@property (nonatomic,strong) NSMutableArray *selectArray;
@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,assign) NSInteger currSection;
@property (nonatomic,assign) NSInteger currRow;
@property (nonatomic,strong) NSString *currString;
@property (nonatomic,assign) NSInteger editTextMax;
@property (nonatomic, assign) id<TableSelectViewDelegate> delegate;


@end
