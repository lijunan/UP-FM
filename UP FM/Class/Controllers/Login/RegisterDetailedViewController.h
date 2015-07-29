//
//  RegisterDetailedViewController.h
//  UP FM
//
//  Created by liubin on 15/2/1.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMViewController.h"
#import "LoginInfo.h"
#import "TableSelectViewController.h"

@interface RegisterDetailedViewController : UPFMViewController<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate,TableSelectViewDelegate>{
    
    UITableView *_tableView;
    
    float tableTop;
    float tableHeight;
    
    NSInteger _currSection;
    NSInteger _currRow;
    

    NSMutableArray *constellationArr;  //星座
    
    NSMutableArray *provinceArr;   //省
    NSMutableArray *cityArr;    //市
    
    NSArray *sexArr;
    NSArray *conditionArr;
}


@property (nonatomic,assign) LoginInfo *loginInfo;

@end
