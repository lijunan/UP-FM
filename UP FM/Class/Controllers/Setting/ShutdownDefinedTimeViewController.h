//
//  DefinedShutdownTimeViewController.h
//  UP FM
//  设置关机时间
//  Created by liubin on 15/1/28.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMViewController.h"

@interface ShutdownDefinedTimeViewController : UPFMViewController<UITextViewDelegate>{
    float viewTop;
    float viewHeight;

}
@property (nonatomic,retain) UITextView *textView;
@end
