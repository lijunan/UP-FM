//
//  SuggestViewController.h
//  UP FM
//
//  Created by liubin on 15/1/28.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMViewController.h"

@interface SuggestViewController : UPFMViewController<UITextViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>{
    
    float viewTop;
    float viewHeight;
    
    UITextField *_titleView;
    UITextView *_textView;
}

@end
