//
//  RegisterViewController.h
//  UP FM
//
//  Created by liubin on 15/2/1.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMViewController.h"
#import "LoginInfo.h"

@interface RegisterViewController : UPFMViewController<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>{
    
    UITableView *_tableView;
    UITextField *phoneField;
    
    float tableTop;
    float tableHeight;
 
    LoginInfo *loginInfo;
}

@property (nonatomic,assign) BOOL isMain;
@property (nonatomic,assign) BOOL isLogin;
@end
