//
//  WheelView.m
//  UP FM
//
//  Created by liubin on 15-1-22.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "WheelView.h"
#import "Adv.h"

@implementation WheelView

@synthesize delegate;
@synthesize wheelArray;


- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView:frame];
    }
    return self;
}

-(void) initView:(CGRect) frame{
    UIView *mainView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self addSubview:mainView];
    
    
    int len=(int)self.wheelArray.count;
    
    wheelIndex=0;
    wheelWidth=frame.size.width;
    wheelHeight=frame.size.height;
    
    UIScrollView *wheel=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, wheelWidth, wheelHeight)];
    wheel.backgroundColor = [UIColor clearColor];
    wheel.delegate = self;
    wheel.contentSize=CGSizeMake(wheelWidth*len, wheelHeight);
    wheel.pagingEnabled=YES;
    wheel.showsVerticalScrollIndicator=NO;
    wheel.showsHorizontalScrollIndicator=NO;
    wheel.bounces=NO;
    [self addSubview:wheel];
    //点
    viewSum=[[UIView alloc] initWithFrame:CGRectMake(25, wheelHeight-25-5, wheelWidth-50, 10)];
    viewSum.backgroundColor=[UIColor clearColor];
    [self addSubview:viewSum];
    
    for(int i=0;i<len;i++){
        NSDictionary *dict=[self.wheelArray objectAtIndex:i];
        Adv *adv=[[Adv alloc] initAdvByDictionary:dict];
        UIView *but=[[UIView alloc] initWithFrame:CGRectMake(i*wheelWidth, 0, wheelWidth, wheelHeight)];
        but.userInteractionEnabled=YES;
        UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
        
        
        [but addGestureRecognizer:gesture];
        [wheel addSubview:but];
        
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, wheelWidth, wheelHeight)];
        [imgView setImageWithURL:[NSURL URLWithString:adv.icon] placeholderImage:DEFAULT_IMAGE_472];
        [but addSubview:imgView];
        
        UIView *sum=[[UIView alloc] initWithFrame:CGRectMake((10+5)*i, 0, 10, 10)];
        if(i==0){
            sum.backgroundColor=[UIColor colorWithRed:0.79 green:0 blue:0.42 alpha:1];
        }else{
            sum.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        }
        sum.layer.cornerRadius=5.0;
        
        [viewSum addSubview:sum];
    }
    
}

-(void)handleTap{
    [self.delegate wheelParss:wheelIndex];
}
//滚动完成事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    wheelIndex=ceil(scrollView.contentOffset.x/wheelWidth);
    NSArray *sums=[viewSum subviews];
    int len=(int)sums.count;
    for(int i=0;i<len;i++){
        UIView *sum=[sums objectAtIndex:i];
        if(i==wheelIndex){
            sum.backgroundColor=[UIColor colorWithRed:0.79 green:0 blue:0.42 alpha:1];
        }else{
            sum.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        }
    }
    
}
@end
