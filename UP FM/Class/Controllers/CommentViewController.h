//
//  CommentViewController.h
//  UP FM
//
//  Created by liubin on 15/2/20.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMViewController.h"



@interface CommentViewController : UPFMViewController<UIAlertViewDelegate,UITextFieldDelegate>{
    
    float mainTop;
    float mainHeight;
    
    UIView *commentFieldView;
    UITextField *commentField;
}

@property(nonatomic,strong) NSNumber *commentId;
@property(nonatomic,strong) NSString *commentTitle;
@property(nonatomic,assign) CommentType commentType;

@end
