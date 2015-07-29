//
//  SuggestSubmitViewController.m
//  UP FM
//
//  Created by liubin on 15/1/29.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "SuggestSubmitViewController.h"

@implementation SuggestSubmitViewController

@synthesize titleText;
@synthesize textText;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     * 导航条设置
     */
    
    
    [self navBackShow];
    
    self.title=@"建议和投诉";
    
    viewTop=NAV_HEIGHT+STATUS_BAR_HEIGHT+20;
    viewHeight=WIN_HEIGHT-viewTop;
    
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(10, viewTop, WIN_WIDTH-20, 60)];
    title.text=@"请输入联系方式，作为进一步了解问题，以及不定期兑奖用途。";
    title.textColor=TEXT_COLOR;
    [self.view addSubview:title];
    title.numberOfLines=0;
    title.font=FONT_14;
    [self.view addSubview:title];
    
    UIView *mainView=[[UIView alloc] initWithFrame:CGRectMake(0, viewTop+60, WIN_WIDTH, 150)];
    mainView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:mainView];
    
    UILabel *phoneLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 35, 35)];
    phoneLabel.text=@"手机";
    phoneLabel.textColor=TEXT_COLOR;
    phoneLabel.font=FONT_14;
    [mainView addSubview:phoneLabel];
    
    _phoneField=[[UITextField alloc] initWithFrame:CGRectMake(60, 10, WIN_WIDTH-70, 35)];
    _phoneField.placeholder=@"请输入";
    _phoneField.delegate=self;
    _phoneField.font=FONT_14;
    _phoneField.textColor=TEXT_COLOR;
    _phoneField.returnKeyType=UIReturnKeyDone;
    _phoneField.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    [mainView addSubview:_phoneField];
    
    UIView *line1=[[UIView alloc] initWithFrame:CGRectMake(20, 50, WIN_WIDTH-20, 1)];
    line1.backgroundColor=[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [mainView addSubview:line1];
    
    
    UILabel *qqLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 60, 35, 35)];
    qqLabel.text=@"QQ";
    qqLabel.textColor=TEXT_COLOR;
    qqLabel.font=FONT_14;
    [mainView addSubview:qqLabel];
    
    _qqField=[[UITextField alloc] initWithFrame:CGRectMake(60, 60, WIN_WIDTH-70, 35)];
    _qqField.placeholder=@"请输入";
    _qqField.delegate=self;
    _qqField.font=FONT_14;
    _qqField.textColor=TEXT_COLOR;
    _qqField.returnKeyType=UIReturnKeyDone;
    _qqField.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    [mainView addSubview:_qqField];
    
    UIView *line2=[[UIView alloc] initWithFrame:CGRectMake(20, 100, WIN_WIDTH-20, 1)];
    line2.backgroundColor=[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [mainView addSubview:line2];
    
    UILabel *weixinLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 110, 35, 35)];
    weixinLabel.text=@"微信";
    weixinLabel.textColor=TEXT_COLOR;
    weixinLabel.font=FONT_14;
    [mainView addSubview:weixinLabel];
    
    _weixinField=[[UITextField alloc] initWithFrame:CGRectMake(60,110, WIN_WIDTH-70, 35)];
    _weixinField.placeholder=@"请输入";
    _weixinField.delegate=self;
    _weixinField.font=FONT_14;
    _weixinField.textColor=TEXT_COLOR;
    _weixinField.returnKeyType=UIReturnKeyDone;
    _weixinField.keyboardType=UIKeyboardTypeDefault;
    [mainView addSubview:_weixinField];
    
    
    
    UIButton *butSubmit=[[UIButton alloc] initWithFrame:CGRectMake(0, viewTop+60+150+30, WIN_WIDTH, 50)];
    butSubmit.backgroundColor=[UIColor whiteColor];
    [butSubmit addTarget:self action:@selector(butSubmitParss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:butSubmit];
    UILabel *butSubmitText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 50)];
    butSubmitText.text=@"提交";
    butSubmitText.font=FONT_18B;
    butSubmitText.textColor=RED_COLOR;
    butSubmitText.textAlignment=NSTextAlignmentCenter;
    [butSubmit addSubview:butSubmitText];
}

-(void) viewWillAppear:(BOOL)animated{
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > 30) {
        
        textField.text = [toBeString substringToIndex:30];
        
        return NO;
        
    }
    
    return YES;
    
}



-(void)butSubmitParss{
    NSLog(@"titleText:%@",self.titleText);
    NSLog(@"textText:%@",self.textText);
    NSString *_phoneText=_phoneField.text;
    NSString *_qqText=_qqField.text;
    NSString *_weixinText=_weixinField.text;
    NSString *alertMsg=@"";
    NSString *alertTitle=@"提示";
    int _tag=0;
    if([_phoneText isEqualToString:@""] && [_qqText isEqualToString:@""] && [_weixinText isEqualToString:@""]){
        alertMsg=@"请至少输入一种联系方式";
    }else{
        _tag=1;
        alertTitle=@"成功";
        alertMsg=@"提交成功，感谢您的支持";
    }
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:alertMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.tag=_tag;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==1){
        int pageIndex=(int)[[self.navigationController viewControllers] indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:pageIndex-2]animated:YES];
    }
}

@end
