//
//  LoginViewController.h
//  UP FM
//
//  Created by liubin on 15/2/20.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMViewController.h"

@interface LoginViewController : UPFMViewController<UITextFieldDelegate,UIAlertViewDelegate>{
    
    float viewTop;
    float viewHeight;
    
    UITextField *_phoneField;
    UITextField *_pwdField;
}

@property (nonatomic,assign) BOOL isRge;    //是否从注册页面进入
@property (nonatomic,assign) BOOL isBackHide;   //是否显示返回

@end
