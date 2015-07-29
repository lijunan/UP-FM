//
//  TableSelectEditViewController.h
//  UP FM
//
//  Created by liubin on 15/2/2.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMViewController.h"



@protocol TableSelectEditViewDelegate

-(void)tableSelectEditComplete:(NSString *)string;

@end

@interface TableSelectEditViewController : UPFMViewController<UIAlertViewDelegate,UITextFieldDelegate>{
    
    float tableTop;
    float tableHeight;
    
    UITextField *deitField;
    UILabel *maxLenText;
    
}

@property (nonatomic,assign) NSString *labelString;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,assign) NSInteger editTextMax;
@property (nonatomic, assign) id<TableSelectEditViewDelegate> delegate;

@end
