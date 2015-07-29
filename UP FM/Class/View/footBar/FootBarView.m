//
//  FootBarView.m
//  UP FM
//
//  Created by liubin on 15-1-23.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "FootBarView.h"

@implementation FootBarView

@synthesize delegate;
@synthesize barArray;


- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView:frame];
    }
    return self;
}

-(void) initView:(CGRect) frame{
    currentIndex=-1;
    
    UIView *footView=[[UIView alloc] initWithFrame:frame];
    footView.backgroundColor=[UIColor whiteColor];
    [self addSubview:footView];
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
    line.backgroundColor=FOOT_BORDER_COLOR;
    [footView addSubview:line];
    
    len=(int)self.barArray.count;
    float butHeight=frame.size.height-1;
    float butWidth=frame.size.width/len;
    float butImgWidth=frame.size.width*(60.0/DESING_WIDTH);
    float butTextHeight=frame.size.width*(32.0/DESING_WIDTH);
    float butImgTop=(butHeight-butImgWidth-butTextHeight)/2;
    
    butView=[[UIView alloc] initWithFrame:CGRectMake(0, 1, frame.size.width, butHeight)];
    
    [footView addSubview:butView];
    
    for(int i=0;i<len;i++){
        NSArray *arr=[self.barArray objectAtIndex:i];
        UIButton *but=[[UIButton alloc] initWithFrame:CGRectMake(butWidth*i, 0, butWidth, butHeight)];
        but.tag=i;
        [but addTarget:self action:@selector(butParss:) forControlEvents:UIControlEventTouchUpInside];
        [butView addSubview:but];
        
        UIImageView *butImg=[[UIImageView alloc] initWithFrame:CGRectMake((butWidth-butImgWidth)/2, butImgTop, butImgWidth, butImgWidth)
                             ];
        butImg.image=[UIImage imageNamed:[arr objectAtIndex:1]];
        [but addSubview:butImg];
        
        UILabel *butText=[[UILabel alloc] initWithFrame:CGRectMake(0, butImgTop+butImgWidth, butWidth, butTextHeight)];
        butText.text=[arr objectAtIndex:0];
        butText.font=FONT_12;
        butText.textAlignment=NSTextAlignmentCenter;
        butText.textColor=[UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1];
        [but addSubview:butText];
    }

}

-(void)butParss:(UIButton *) paramSender{
    int index=(int)paramSender.tag;
    if(currentIndex!=index){
        [self.delegate footBarParss:index direction:index-currentIndex];
    }
    
}

-(void)setCurrentBut:(NSString *)title{
    NSArray *butArr=[butView subviews];
    NSArray *barSubArr;
    for(int i=0;i<len;i++){
        barSubArr=[self.barArray objectAtIndex:i];
        if([[barSubArr objectAtIndex:0] isEqualToString:title]){
            currentIndex=i;
            break;
        }
        
    }
    if(currentIndex!=-1){
        UIButton *but=[butArr objectAtIndex:currentIndex];
        NSArray *arr=[but subviews];
        
        UILabel *butText=[arr objectAtIndex:1];
        butText.textColor=RED_COLOR;
        UIImageView *butImg=[arr objectAtIndex:0];
        NSString *imgUrl=[NSString stringWithFormat:@"%@-on",[barSubArr objectAtIndex:1]];
        butImg.image=[UIImage imageNamed:imgUrl];
    }
    
}

@end
