//
//  VerificationViewController.m
//  UP FM
//
//  Created by liubin on 15/2/1.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "RegisterVerificationViewController.h"
#import "RegisterUserViewController.h"


@implementation RegisterVerificationViewController

@synthesize loginInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     * 导航条设置
     */
    self.title=@"注册";
    
    [self navBackShow];
    
    //加载导航右侧按钮
//    UIButton *butSkip=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, NAV_HEIGHT)];
//    [butSkip addTarget:self action:@selector(goToHome) forControlEvents:UIControlEventTouchUpInside];
//    UILabel *butSkipText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, NAV_HEIGHT)];
//    butSkipText.text=@"跳过";
//    butSkipText.font=FONT_14;
//    butSkipText.textAlignment=NSTextAlignmentRight;
//    [butSkip addSubview:butSkipText];
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:butSkip];
    
    
    codeVal=@"123456";
    
    viewTop=NAV_HEIGHT+STATUS_BAR_HEIGHT;
    viewHeight=WIN_HEIGHT-viewTop;;
    
    
    UIView *mainView=[[UIView alloc] initWithFrame:CGRectMake(0, viewTop, WIN_WIDTH, viewHeight)];
    mainView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:mainView];
    
    float phoneViewTop=20.0;
    float phoneViewHeight=30.0;
    UILabel *phoneView=[[UILabel alloc] initWithFrame:CGRectMake(20, phoneViewTop, WIN_WIDTH-40, phoneViewHeight)];
    phoneView.text=[NSString stringWithFormat:@"验证码已发送到手机:%@",self.loginInfo.phone];
    phoneView.font=FONT_16;
    phoneView.textColor=TEXT_COLOR;
    [mainView addSubview:phoneView];
    
    float codeViewTop=phoneViewTop+phoneViewHeight+10;
    float codeViewHeight=50.0;
    UIView *codeView=[[UIView alloc] initWithFrame:CGRectMake(0, codeViewTop, WIN_WIDTH, codeViewHeight)];
    codeView.backgroundColor=[UIColor whiteColor];
    [mainView addSubview:codeView];
    
    float codeTextWidth=80;
    UILabel *codeText=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, codeTextWidth, 30)];
    codeText.text=@"输入验证码";
    
    codeText.font=FONT_14;
    codeText.textColor=TEXT_COLOR;
    [codeView addSubview:codeText];
    
    float codeButWidth=90;
    UIButton *codeBut=[[UIButton alloc] initWithFrame:CGRectMake(WIN_WIDTH-codeButWidth-10, 10, codeButWidth, 30)];
    [codeView addSubview:codeBut];
    codeButText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, codeButWidth, 30)];
    codeButText.text=@"重新获取(60)";
    
    codeButText.textColor=TEXT_COLOR_SHALLOW;
    codeButText.font=FONT_14;
    [codeBut addSubview:codeButText];
    
    codeField=[[UITextField alloc] initWithFrame:CGRectMake(codeTextWidth+20, 10, WIN_WIDTH-codeTextWidth-20-codeButWidth-20, 30)];
    codeField.returnKeyType = UIReturnKeyDone;
    codeField.clearButtonMode = YES;
    codeField.delegate = self;
    codeField.font=FONT_14;
    codeField.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    codeField.placeholder = @"请输入";
    [codeView addSubview:codeField];
    
    
    float butNextTop=codeViewTop+codeViewHeight+30;
    float butNextHeight=44.0;
    UIButton *butNext=[[UIButton alloc] initWithFrame:CGRectMake(0, butNextTop, WIN_WIDTH, butNextHeight)];
    butNext.backgroundColor=[UIColor whiteColor];
    [butNext addTarget:self action:@selector(nextParss) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:butNext];
    UILabel *butText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, butNextHeight)];
    butText.text=@"下一步";
    butText.textAlignment=NSTextAlignmentCenter;
    butText.textColor=RED_COLOR;
    butText.font=FONT_16;
    [butNext addSubview:butText];
    
}

//输入框协议
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    int max=6;
    if (toBeString.length > max) {
        
        textField.text = [toBeString substringToIndex:max];
        
        return NO;
        
    }
    
    return YES;
}


//下一步事件
-(void)nextParss{
    NSString *_codeText=codeField.text;
    if(![_codeText isEqualToString:codeVal]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"请输入收到的验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        RegisterUserViewController *_viewController = [[RegisterUserViewController alloc] init];
        _viewController.loginInfo=self.loginInfo;
        [self pushViewRight:_viewController];
    }
}
//UIAlertView协议
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}



@end
