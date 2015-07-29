//
//  ModuleNavView.m
//  UP FM
//
//  Created by liubin on 15-1-23.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "ModuleNavView.h"
#import "Functions.h"

@implementation ModuleNavView

@synthesize delegate;
@synthesize navArray;


- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView:frame];

    }
    return self;
}

-(void) initView:(CGRect) frame{
    UIView *mainView=[[UIView alloc] initWithFrame:frame];
    
    [self addSubview:mainView];
    
    int len=(int)self.navArray.count;
    
    int row=4;
    int line=ceil(1.0f*len/row);
    float width=frame.size.width;
    float height=frame.size.height;
    float butWidth=(width-row+1)/row;
    float butHeight=(height-line+1)/line;
    float butImgWidth=width*(50.0/DESING_WIDTH);
    float butImgTop=(butHeight-butImgWidth-20)/2;
    
    for(int i=0; i<len; i++) {
        NSDictionary *dict=[self.navArray objectAtIndex:i];
        float t=(butHeight+1)*floor(i/row);
        UIButton *but=[[UIButton alloc] initWithFrame:CGRectMake((butWidth+1)*(i%row),t , butWidth, butHeight)];
        but.backgroundColor=[UIColor whiteColor];
        
        but.tag=i;
        [but addTarget:self action:@selector(butParss:) forControlEvents:UIControlEventTouchUpInside];
        
        [but setImage:[Functions imageWithColor:[UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1] size:CGSizeMake(butWidth, butHeight)] forState:UIControlStateHighlighted];
        [mainView addSubview:but];
        
        UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake((butWidth-butImgWidth)/2, butImgTop, butImgWidth, butImgWidth)];
        if([[dict objectForKey:@"column_id"] isEqualToNumber:[NSNumber numberWithInt:-1] ]){
            img.image=[UIImage imageNamed:[dict objectForKey:@"column_icon"]];
        }else{
            img.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"column_icon"]]]];
        }
        
        
        [but addSubview:img];
        
        UILabel *tit=[[UILabel alloc] initWithFrame:CGRectMake(0, butImgTop+butImgWidth+8, butWidth, 20)];
        tit.text=[dict objectForKey:@"column_name"];
        tit.font=FONT_14;
        tit.textAlignment=NSTextAlignmentCenter;
        [but addSubview:tit];
    }
    
}

-(void)butParss:(UIButton *) paramSender{
    [self.delegate navButParss:(int)paramSender.tag];
}


@end
