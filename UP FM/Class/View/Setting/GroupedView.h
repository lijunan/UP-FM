//
//  GroupedView.h
//  UP FM
//
//  Created by liubin on 15/1/28.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMView.h"


@protocol groupedViewDelegate

-(void)groupedButParss:(NSInteger)section row:(NSInteger)row;

@end

@interface GroupedView : UPFMView<UITableViewDataSource, UITableViewDelegate>{
    
   
    
    NSInteger currentIndex;
    
}

@property(strong,nonatomic) NSArray *groupedArray;
@property(strong,nonatomic) NSArray *groupedTieleArray;
@property (nonatomic, assign) id<groupedViewDelegate> delegate;

@property(nonatomic,strong) UIView   *selectedBackgroundView;
@property(nonatomic,strong) UITableView *_tableView;

@end
