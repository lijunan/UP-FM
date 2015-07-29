//
//  LoginViewController.m
//  UP FM
//
//  Created by liubin on 15/2/20.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "Functions.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     * 导航条设置
     */
    self.title=@"登录";
    
    
    
    
    if(!self.isRge){
        //加载导航右侧按钮
        UIButton *butLogin=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, NAV_HEIGHT)];
        [butLogin addTarget:self action:@selector(goToReg) forControlEvents:UIControlEventTouchUpInside];
        UILabel *butLoginText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, NAV_HEIGHT)];
        butLoginText.text=@"注册";
        butLoginText.font=FONT_14;
        butLoginText.textAlignment=NSTextAlignmentRight;
        [butLogin addSubview:butLoginText];
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:butLogin];
    }
    
    viewTop=NAV_HEIGHT+STATUS_BAR_HEIGHT+20;
    viewHeight=WIN_HEIGHT-viewTop;
    
    
    UIView *mainView=[[UIView alloc] initWithFrame:CGRectMake(0, viewTop, WIN_WIDTH, 100)];
    mainView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:mainView];
    
    UILabel *phoneLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 35, 35)];
    phoneLabel.text=@"昵称";
    phoneLabel.textColor=TEXT_COLOR;
    phoneLabel.font=FONT_14;
    [mainView addSubview:phoneLabel];
    
    _phoneField=[[UITextField alloc] initWithFrame:CGRectMake(60, 10, WIN_WIDTH-70, 35)];
    _phoneField.placeholder=@"请输入";
    _phoneField.clearButtonMode = YES;
    _phoneField.delegate=self;
    _phoneField.font=FONT_14;
    _phoneField.textColor=TEXT_COLOR;
    _phoneField.returnKeyType=UIReturnKeyDone;
//    _phoneField.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    [mainView addSubview:_phoneField];
    
    UIView *line1=[[UIView alloc] initWithFrame:CGRectMake(20, 50, WIN_WIDTH-20, 1)];
    line1.backgroundColor=[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [mainView addSubview:line1];
    
    
    UILabel *pwdLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 60, 35, 35)];
    pwdLabel.text=@"密码";
    pwdLabel.textColor=TEXT_COLOR;
    pwdLabel.font=FONT_14;
    [mainView addSubview:pwdLabel];
    
    _pwdField=[[UITextField alloc] initWithFrame:CGRectMake(60, 60, WIN_WIDTH-70, 35)];
    _pwdField.placeholder=@"请输入";
    _pwdField.delegate=self;
    _pwdField.clearButtonMode = YES;
    _pwdField.font=FONT_14;
    _pwdField.textColor=TEXT_COLOR;
    _pwdField.returnKeyType=UIReturnKeyDone;
    _pwdField.secureTextEntry=YES;
    
    [mainView addSubview:_pwdField];
    
    
    
    UIButton *butSubmit=[[UIButton alloc] initWithFrame:CGRectMake(0, viewTop+100+30, WIN_WIDTH, 50)];
    butSubmit.backgroundColor=[UIColor whiteColor];
    [butSubmit addTarget:self action:@selector(butSubmitParss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:butSubmit];
    UILabel *butSubmitText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 50)];
    butSubmitText.text=@"登 录";
    butSubmitText.font=FONT_18B;
    butSubmitText.textColor=RED_COLOR;
    butSubmitText.textAlignment=NSTextAlignmentCenter;
    [butSubmit addSubview:butSubmitText];
    
    if(self.isBackHide){
        UIButton *skip=[[UIButton alloc] initWithFrame:CGRectMake((WIN_WIDTH-50)/2, WIN_HEIGHT-60, 50, 50)];
        [skip addTarget:self action:@selector(skipParss) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:skip];
        UILabel *skipText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        skipText.text=@"取消";
        skipText.textColor=TEXT_COLOR_SHALLOW;
        skipText.font=FONT_16;
        skipText.textAlignment=NSTextAlignmentCenter;
        [skip addSubview:skipText];
        UIImageView *skipImg=[[UIImageView alloc] initWithFrame:CGRectMake((50-20)/2, 20, 20, 20)];
        skipImg.image=[UIImage imageNamed:@"icon-skip"];
        [skip addSubview:skipImg];
    }else{
        [self navBackShow];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)goToReg{
    RegisterViewController *_viewController = [[RegisterViewController alloc] init];
    _viewController.isLogin=YES;
    [self pushViewRight:_viewController];
}

//输入框协议
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    int max=20;
    if ([Functions stringLeng:toBeString] > max) {
        
        textField.text = [toBeString substringToIndex:max];
        
        return NO;
        
    }
    
    return YES;
}

-(void)butSubmitParss{
    NSString *phone=_phoneField.text;
    NSString *pwd=_pwdField.text;
    if([phone isEmpty]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"请输入昵称" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if([pwd isEmpty]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"请输入密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSMutableDictionary *param=[[NSMutableDictionary alloc] init];
    [param setObject:phone forKey:@"user_name"];
    [param setObject:pwd forKey:@"user_password"];
    if(_gps){
        [param setObject:[NSNumber numberWithFloat:_gps.locationManager.location.coordinate.latitude] forKey:@"user_latitude"];
        [param setObject:[NSNumber numberWithFloat:_gps.locationManager.location.coordinate.longitude] forKey:@"user_longitude"];
    }
    NSString *url=[UrlAPI getUserLogin];
    NSLog(@"param:%@",param);
    
    [UPHTTPTools post:url params:param success:^(id responseObj) {
        NSNumber *code=[responseObj objectForKey:@"code"];
        NSLog(@"responseObj:%@",responseObj);
        if([code isEqualToNumber:[NSNumber numberWithInt:0]]){
            CurrentUser *currentUser=[CurrentUser sharedInstance];
            currentUser.uId=[NSString replaceUnicode:[[responseObj objectForKey:@"content"]objectForKey:@"user_id"]];
            currentUser.auth=[NSString replaceUnicode:[[responseObj objectForKey:@"content"] objectForKey:@"user_auth"]];
            currentUser.nickName=phone;
            currentUser.age=[NSString replaceUnicode:[[responseObj objectForKey:@"content"] objectForKey:@"user_age"]];
            NSArray *sexArr=SEX_ARR;
            NSNumber *sexIndex=[[responseObj objectForKey:@"content"] objectForKey:@"user_sex"];
            currentUser.sex=[sexArr objectAtIndex:[sexIndex integerValue]];
            currentUser.tel=[NSString replaceUnicode:[[responseObj objectForKey:@"content"] objectForKey:@"user_mobile"]];
            currentUser.constellation=[NSString replaceUnicode:[[responseObj objectForKey:@"content"] objectForKey:@"user_constellation"]];
            NSArray *conditionArr=CONDITION_ARR;
            NSNumber *conditionIndex=[[responseObj objectForKey:@"content"] objectForKey:@"user_marriage"];
            currentUser.condition=[conditionArr objectAtIndex:[conditionIndex integerValue]];
            
            currentUser.city=[NSString replaceUnicode:[[responseObj objectForKey:@"content"] objectForKey:@"user_city"]];
            currentUser.longitude=[NSNumber numberWithFloat:_gps.locationManager.location.coordinate.longitude];
            currentUser.latitude=[NSNumber numberWithFloat:_gps.locationManager.location.coordinate.latitude];
            currentUser.loginTime=[NSNumber numberWithInteger:[NSDate timeStamp]];
            
            [currentUser save];
            //设置为已登录
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self goToBack];
        }else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:[NSString replaceUnicode:[responseObj objectForKey:@"msg"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag=1;
            [alert show];
        }
        
        
        
    } failure:^(NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"注册失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag=1;
        [alert show];
    }];
    
}

//跳过按钮
-(void)skipParss{
    [self goToHome];
}
@end
