//
//  TabBarView.m
//  UP FM
//
//  Created by liubin on 15-1-25.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "TabBarView.h"

@implementation TabBarView

@synthesize delegate;
@synthesize tabArray;


- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView:frame];
        
    }
    return self;
}

-(void) initView:(CGRect) frame{
    
    currentIndex=0;
    
    UIView *mainView=[[UIView alloc] initWithFrame:frame];
    mainView.backgroundColor=[UIColor whiteColor];
    [self addSubview:mainView];
    
    int len=(int)self.tabArray.count;
    
    pointerHeight=frame.size.width*(6/DESING_WIDTH);
    butWidth=frame.size.width/len;
    butHeight=frame.size.height-pointerHeight;
    
    
    butView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, butHeight)];
    [mainView addSubview:butView];
    
    for(int i=0;i<len;i++){
        UIButton *but=[[UIButton alloc] initWithFrame:CGRectMake(butWidth*i, 0, butWidth, butHeight)];
        but.tag=i;
        [but addTarget:self action:@selector(butParss:) forControlEvents:UIControlEventTouchUpInside];
        [butView addSubview:but];
        UILabel *butText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, butWidth, butHeight)];
        butText.text=[self.tabArray objectAtIndex:i];
        UIColor *textColor=TEXT_COLOR;
        if(i==currentIndex){
            textColor=RED_COLOR;
        }
        butText.font=FONT_14B;
        butText.textAlignment=NSTextAlignmentCenter;
        [but addSubview:butText];
    }
    
    pointerView=[[UIView alloc] initWithFrame:CGRectMake(0, butHeight, butWidth, pointerHeight)];
    
    pointerView.backgroundColor=RED_COLOR;
    [mainView addSubview:pointerView];
}

-(void)butParss:(UIButton *) paramSender{
    int index=(int)paramSender.tag;
    if(index!=currentIndex){
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            pointerView.frame=CGRectMake(butWidth*index, butHeight, butWidth, pointerHeight);
            
        } completion:^(BOOL finished){
            
        }];

        currentIndex=index;
        [self.delegate tabButParss:(int)paramSender.tag];
    }
    
}
-(void)setCurrentTab:(int)index{
    if(index!=currentIndex){
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            pointerView.frame=CGRectMake(butWidth*index, butHeight, butWidth, pointerHeight);
            
        } completion:^(BOOL finished){
            
        }];
        currentIndex=index;
        
    }
}

@end
