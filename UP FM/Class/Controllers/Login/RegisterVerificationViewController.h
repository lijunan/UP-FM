//
//  VerificationViewController.h
//  UP FM
//
//  Created by liubin on 15/2/1.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMViewController.h"
#import "LoginInfo.h"

@interface RegisterVerificationViewController : UPFMViewController<UITextFieldDelegate,UIAlertViewDelegate>{
    
    UITextField *codeField;
    
    UILabel *codeButText;
    
    NSString *codeVal;
    
    float viewTop;
    float viewHeight;
}


@property (nonatomic,assign) LoginInfo *loginInfo;

@end
