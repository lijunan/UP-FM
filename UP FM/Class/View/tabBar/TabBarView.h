//
//  TabBarView.h
//  UP FM
//
//  Created by liubin on 15-1-25.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMView.h"


@protocol tabBarViewDelegate

-(void)tabButParss:(int)index;

@end

@interface TabBarView : UPFMView{
    UIView *butView;
    
    UIView *pointerView;
    
    int currentIndex;
    float butWidth;
    float butHeight;
    float pointerHeight;
}


@property(strong,nonatomic) NSArray *tabArray;
@property (nonatomic, assign) id<tabBarViewDelegate> delegate;


-(void)setCurrentTab:(int)index;

@end
