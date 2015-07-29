//
//  WheelView.h
//  UP FM
//
//  Created by liubin on 15-1-22.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMView.h"


@protocol WheelViewDelegate

-(void)wheelParss:(int)index;

@end

@interface WheelView : UPFMView<UIScrollViewDelegate>{
    int wheelIndex;
    float wheelWidth;
    float wheelHeight;
    
    //点
    UIView *viewSum;
}

@property(strong,nonatomic) NSMutableArray *wheelArray;
@property (nonatomic, assign) id<WheelViewDelegate> delegate;

@end
