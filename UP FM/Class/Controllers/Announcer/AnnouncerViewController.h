//
//  AnnouncerViewController.h
//  UP FM
//
//  Created by liubin on 15/1/31.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMViewController.h"
#import "OperationMediaListView.h"
#import "Announcer.h"

@interface AnnouncerViewController : UPFMViewController<operationMediaViewDelegate>{
    
    NSMutableArray *mediaArray;
    Announcer *announcer;
    
    //大图
    UIImageView *patternmakingImg;
    
    //信息
    UIView *infoView;
    

    OperationMediaListView *operationListView;
    
    
    
    float mainTop;
    float mainHeight;

    
}


@property(nonatomic,assign) NSString *announcerId;

@end
