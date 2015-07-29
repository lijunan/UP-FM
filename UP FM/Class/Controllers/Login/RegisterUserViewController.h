//
//  RegisterUserViewController.h
//  UP FM
//
//  Created by liubin on 15/2/1.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMViewController.h"
#import "LoginInfo.h"


@interface RegisterUserViewController : UPFMViewController<UITextFieldDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    
    UIImageView *photoView;
    UILabel *photoViewText;
    UIButton *photoBut;
    
    UITextField *niceNameField;
    UITextField *pwdField;
    UITextField *pwd2Field;
    
    float viewTop;
    float viewHeight;
    
    float photoViewWidth;
    
}


@property (nonatomic,assign) LoginInfo *loginInfo;


@end
