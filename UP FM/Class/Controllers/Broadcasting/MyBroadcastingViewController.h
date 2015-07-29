//
//  MyBroadcastingViewController.h
//  UP FM
//  我的电台首页
//  Created by liubin on 15/3/2.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMViewController.h"
#import "Broadcasting.h"
#import "MarqueeLabel.h"

@interface MyBroadcastingViewController : UPFMViewController<UIScrollViewDelegate>{
    
    Broadcasting *_broadcasting;
    CurrentUser *_currentUser;
    
    //界面主体
    UIScrollView *mainView;
    float mainTop;
    float mainHeight;
    float mainContentHeight;
    
    UIImageView *coverImage;    //节目封面图
    MarqueeLabel *noticeLalel;  //公告
    
}


@end
