//
//  TableSelectEditViewController.m
//  UP FM
//
//  Created by liubin on 15/2/2.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "TableSelectEditViewController.h"
#import "Functions.h"


@implementation TableSelectEditViewController


@synthesize labelString;
@synthesize content;
@synthesize delegate;
@synthesize editTextMax;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     * 导航条设置
     */
    [self navBackShow];

    //导航右侧完成按钮
    UIButton *finishButton=[Functions initBarRightButton:BarButtonTypeFinish];
    [finishButton addTarget:self action:@selector(accomplish) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:finishButton];
    
    
    if(!self.editTextMax){
        self.editTextMax=20;
    }
    
    
    tableTop=NAV_HEIGHT+STATUS_BAR_HEIGHT;
    tableHeight=WIN_HEIGHT-tableTop;
    
    UIView *mainView=[[UIView alloc] initWithFrame:CGRectMake(0, tableTop, WIN_WIDTH, tableHeight)];
    [self.view addSubview:mainView];
    
    
    float titTop=20;
    float titWidth=WIN_WIDTH-40;
    float titHeight=[Functions getTextHeight:self.labelString :CGSizeMake(titWidth, 1000) :FONT_14];
    
    UILabel *tit=[[UILabel alloc] initWithFrame:CGRectMake(titTop, 20, titWidth, titHeight)];
    tit.text=self.labelString;
    tit.font=FONT_14;
    [mainView addSubview:tit];
    
    
    float contentTop=titTop+titHeight+10;
    UIView *contentView=[[UIView alloc] initWithFrame:CGRectMake(0, contentTop, WIN_WIDTH, 50)];
    contentView.backgroundColor=[UIColor whiteColor];
    [mainView addSubview:contentView];
    
    deitField=[[UITextField alloc] initWithFrame:CGRectMake(20, 0, WIN_WIDTH-40,50)];
    deitField.placeholder=@"请输入";
    deitField.text=self.content;
    deitField.delegate=self;
    deitField.returnKeyType=UIReturnKeyDone;
    deitField.font=FONT_14;
    deitField.textColor=TEXT_COLOR;
    [contentView addSubview:deitField];
    
    maxLenText=[[UILabel alloc] initWithFrame:CGRectMake(20, contentTop+50+5, WIN_WIDTH-40, 20)];
    maxLenText.text=[NSString stringWithFormat:@"还可输入%d个字符，一个汉字等于两个字符",(int)self.editTextMax-[Functions stringLeng:self.content]];
    maxLenText.textColor=TEXT_COLOR_SHALLOW;
    maxLenText.font=FONT_12;
    maxLenText.textAlignment=NSTextAlignmentRight;
    [mainView addSubview:maxLenText];
    
}

//输入框协议
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    int residue=(int)self.editTextMax-[Functions stringLeng:toBeString];
    
    if (residue<0) {
        textField.text = [toBeString substringToIndex:self.editTextMax];
        return NO;
        
    }else{
        maxLenText.text=[NSString stringWithFormat:@"还可输入%d个字符，一个汉字等于两个字符",residue];
    }
    
    return YES;
}

-(void)accomplish{
    NSString *string=deitField.text;
    int len=[Functions stringLeng:string];
    if(len<=0 || len>(int)self.editTextMax){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"输入的字符数量有误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [self.delegate tableSelectEditComplete:string];
        [self goToBack];
    }
    
}
//UIAlertView 协议
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

@end
