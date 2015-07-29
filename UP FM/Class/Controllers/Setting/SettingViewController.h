//
//  SettingViewController.h
//  UP FM
//
//  Created by liubin on 15/1/27.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "FootBarViewController.h"

@interface SettingViewController : FootBarViewController<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    UITableView *_tableView;
    
    float mainTop;
    float mainHeight;
    
    UIButton *butLogin;
    UIButton *butOutlogin;
    
    float photoImageWidth;
    UIImageView *photoImageView;
    UILabel *userName;
    
}

@property(nonatomic,retain) UIView   *selectedBackgroundView;

@end
