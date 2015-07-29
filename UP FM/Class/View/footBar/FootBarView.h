//
//  FootBarView.h
//  UP FM
//
//  Created by liubin on 15-1-23.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMView.h"

@protocol FootBarViewDelegate

-(void)footBarParss:(int)index direction:(int)direction;

@end

@interface FootBarView : UPFMView{
    UIView *butView;
    
    int len;
    int currentIndex;
}

@property(strong,nonatomic) NSArray *barArray;
@property (nonatomic, assign) id<FootBarViewDelegate> delegate;

-(void)setCurrentBut:(NSString *)title;

@end
