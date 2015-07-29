//
//  FootBarViewController.h
//  UP FM
//  底部总导航
//  Created by liubin on 15-1-24.
//  Copyright (c) 2015年 liubin. All rights reserved.
//


#import "UPFMViewController.h"
#import "FootBarView.h"

@interface FootBarViewController : UPFMViewController<FootBarViewDelegate>{
    
    FootBarView *footBar;
    
    float footHeight;
    
    NSArray *footArray;
    
}


-(void)footBarShow;
-(void)setFootBarCurrentBut:(NSString *)title;

@end
