//
//  FootBarViewController.m
//  UP FM
//
//  Created by liubin on 15-1-24.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "FootBarViewController.h"
#import "SubscriptionViewController.h"
#import "SettingViewController.h"


@interface FootBarViewController ()

@end

@implementation FootBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

-(void)footBarShow{
    footArray=[NSArray arrayWithObjects:
               [NSArray arrayWithObjects:@"发现",@"icon-discover", nil],
               [NSArray arrayWithObjects:@"已订阅",@"icon-subscription", nil],
               //[NSArray arrayWithObjects:@"互动",@"icon-interact", nil],
               //[NSArray arrayWithObjects:@"声活圈",@"icon-voice", nil],
               [NSArray arrayWithObjects:@"设置",@"icon-seting", nil],
               nil
               ];
    //按比例计算出模块导航高
    footHeight=self.view.frame.size.width*(120.0/DESING_WIDTH);
    
    UIView *footView=[[UIView alloc] initWithFrame:CGRectMake(0, WIN_HEIGHT-footHeight, WIN_WIDTH, footHeight)];
    [self.view addSubview:footView];
    
    footBar=[FootBarView alloc];
    footBar.barArray=footArray;
    
    footBar=[footBar initWithFrame:CGRectMake(0, 0, WIN_WIDTH, footHeight)];
    footBar.delegate=self;
    [footView addSubview:footBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)footBarParss:(int)index direction:(int)direction{
    switch (index) {
        case 0:{
            [self goToHome:NO];
            break;
        }
            
        case 1:{
            SubscriptionViewController *_viewController = [[SubscriptionViewController alloc] init];
            [self pushView:_viewController];
            break;
        }
            
        case 2:{
            SettingViewController *_viewController = [[SettingViewController alloc] init];
            [self pushView:_viewController];
            break;
        }
            
            
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        default:
            break;
    }
}

-(void)setFootBarCurrentBut:(NSString *)title{
    
    [footBar setCurrentBut:title];
}

@end
