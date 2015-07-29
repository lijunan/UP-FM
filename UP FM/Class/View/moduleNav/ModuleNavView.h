//
//  ModuleNavView.h
//  UP FM
//
//  Created by liubin on 15-1-23.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMView.h"

@protocol navViewDelegate

-(void)navButParss:(int)index;

@end


@interface ModuleNavView : UPFMView

@property(strong,nonatomic) NSMutableArray *navArray;
@property (nonatomic, assign) id<navViewDelegate> delegate;

@end
