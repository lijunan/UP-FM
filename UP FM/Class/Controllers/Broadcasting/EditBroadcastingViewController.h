//
//  EditBroadcastingViewController.h
//  UP FM
//  编辑我的电台
//  Created by liubin on 15/3/2.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMViewController.h"
#import "Broadcasting.h"
#import "TableCheckboxViewController.h"


@interface EditBroadcastingViewController : UPFMViewController<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,TableCheckboxViewDelegate>{
    
    Broadcasting *_broadcasting;
    
    float mainTop;
    float mainHeight;
    float mainContentHeight;
    
    //电台
    UIImageView *coverImage;    //节目封面图
    UITextField *titleField;    //节目标题
    UILabel *columnLabel;   //节目栏目
    UIImageView *iconImage; //节目icon
    UITextField *tagField;  //节目标签
    UITextView *introductionField;  //简介
    UITextView *noticeField;    //公告
    UILabel *languagesLabel;    //语言
    
    PhotoUpdateType _photoType;
    
    CurrentUser *_currentUser;
    
    NSMutableArray *columnArray;    //栏目选择项
    NSMutableArray *columnCheckedArray; //栏目已选择
    
    NSMutableArray *languagesArray; //语种选择项
    NSMutableArray *languagesCheckedArray;  //语种已选择
}


@property(nonatomic,assign) BOOL creation;

@end
