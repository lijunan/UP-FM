//
//  SuggestSubmitViewController.h
//  UP FM
//
//  Created by liubin on 15/1/29.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMViewController.h"

@interface SuggestSubmitViewController : UPFMViewController<UITextFieldDelegate,UIAlertViewDelegate>{
    
    float viewTop;
    float viewHeight;
    
    UITextField *_phoneField;
    UITextField *_qqField;
    UITextField *_weixinField;
}

@property(strong,nonatomic) NSString *titleText;
@property(strong,nonatomic) NSString *textText;

@end
