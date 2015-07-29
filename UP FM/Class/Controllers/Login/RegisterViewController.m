//
//  RegisterViewController.m
//  UP FM
//
//  Created by liubin on 15/2/1.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "RegisterViewController.h"
#import "AgreementViewController.h"
#import "RegisterVerificationViewController.h"
#import "LoginViewController.h"

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     * 导航条设置
     */
    self.title=@"注册";
    
    if(!self.isLogin){
        //加载导航右侧按钮
        UIButton *butLogin=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, NAV_HEIGHT)];
        [butLogin addTarget:self action:@selector(goToLogin) forControlEvents:UIControlEventTouchUpInside];
        UILabel *butLoginText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, NAV_HEIGHT)];
        butLoginText.text=@"登录";
        butLoginText.font=FONT_14;
        butLoginText.textAlignment=NSTextAlignmentRight;
        [butLogin addSubview:butLoginText];
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:butLogin];

    }
    loginInfo=[[LoginInfo alloc] init];
    
    
    tableTop=0.0;//NAV_HEIGHT+STATUS_BAR_HEIGHT;
    tableHeight=290;
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, tableTop, WIN_WIDTH, tableHeight) style:UITableViewStyleGrouped];
    _tableView.rowHeight = SETTING_HEIGHT;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled=NO;
    
    [self.view addSubview:_tableView];
    
    
    
    
    float agreementButWidth=200.0;
    UIButton *agreementBut=[[UIButton alloc] initWithFrame:CGRectMake((WIN_WIDTH-agreementButWidth)/2, tableHeight, agreementButWidth, 20)];
    [agreementBut addTarget:self action:@selector(agreementButParss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreementBut];
    UILabel *agreementButText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, agreementButWidth, 20)];
    agreementButText.text=@"注册即表示同意《用户协议》";
    agreementButText.font=FONT_14;
    agreementButText.textColor=TEXT_COLOR_SHALLOW;
    agreementButText.textAlignment=NSTextAlignmentCenter;
    [agreementBut addSubview:agreementButText];
    
    if(self.isMain){
        UIButton *skip=[[UIButton alloc] initWithFrame:CGRectMake((WIN_WIDTH-50)/2, WIN_HEIGHT-60, 50, 50)];
        [skip addTarget:self action:@selector(skipParss) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:skip];
        UILabel *skipText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        skipText.text=@"跳过";
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.showsReorderControl=YES;
    }

    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:{
                    
                    cell.textLabel.text = @"国家和地区区号";
                    cell.detailTextLabel.text=@"+86 中国";
                    cell.detailTextLabel.font=FONT_12;
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 1:{
                    
                    cell.textLabel.text = @"手机号码";
                    phoneField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0f, 215.0f, 31.0f)];
                    phoneField.returnKeyType = UIReturnKeyDone;
                    phoneField.clearButtonMode = YES;
                    phoneField.delegate = self;
                    phoneField.font=FONT_14;
                    phoneField.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
                    phoneField.placeholder = @"请输入";
                    cell.accessoryView = phoneField;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            switch (indexPath.row) {
                case 0:{
                    UIButton *butNext=[[UIButton alloc] initWithFrame:cell.frame];
                    [butNext addTarget:self action:@selector(nextParss) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:butNext];
                    UILabel *butText=[[UILabel alloc] initWithFrame:cell.frame];
                    butText.text=@"下一步";
                    butText.textAlignment=NSTextAlignmentCenter;
                    butText.textColor=RED_COLOR;
                    butText.font=FONT_16;
                    [butNext addSubview:butText];
                    
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    
    cell.textLabel.font=SETTING_FONT;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


//输入框协议
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    int max=20;
    if (toBeString.length > max) {
        
        textField.text = [toBeString substringToIndex:max];
        
        return NO;
        
    }
    
    return YES;
}
//下一步事件
-(void)nextParss{
    NSString *phone=phoneField.text;
    
    if([phone isValidateMobile]){
        loginInfo.phone=phone;
        RegisterVerificationViewController *_viewController = [[RegisterVerificationViewController alloc] init];
        _viewController.loginInfo=loginInfo;
        [self pushViewRight:_viewController];
        
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"请输入电话电码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
//UIAlertView协议
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}
//跳过按钮
-(void)skipParss{
    NSString *url=[UrlAPI getUserRegAnonymous];
    NSDictionary *parameters = @{};
    NSDictionary *pdictionary=[NSData getDictionaryForUrl:url parameters:parameters];
    [UPHTTPTools post:url params:pdictionary success:^(id responseObj) {

        NSNumber *code=[responseObj objectForKey:@"code"];
       
        if([code isEqualToNumber:[NSNumber numberWithInt:0]]){
            CurrentUser *currentUser=[CurrentUser sharedInstance];
            currentUser.uId=[NSString replaceUnicode:[[responseObj objectForKey:@"content"]objectForKey:@"user_id"]];
            currentUser.auth=[NSString replaceUnicode:[[responseObj objectForKey:@"content"] objectForKey:@"user_auth"]];
            currentUser.nickName=[NSString replaceUnicode:[[responseObj objectForKey:@"content"] objectForKey:@"user_name"]];
            currentUser.uName=[NSString replaceUnicode:[[responseObj objectForKey:@"content"] objectForKey:@"user_name"]];
            [currentUser save];
        }
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isRegister"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController popViewControllerAnimated:NO];
    } failure:^(NSError *error) {;
        [self.navigationController popViewControllerAnimated:NO];
    }];
    
}
//跳转到登录
-(void)goToLogin{
    LoginViewController *_viewController=[[LoginViewController alloc] init];
    _viewController.isRge=YES;
    [self pushViewRight:_viewController];
}

//跳转到协议
-(void)agreementButParss{
    AgreementViewController *_viewController = [[AgreementViewController alloc] init];
    [self pushViewRight:_viewController];
}



@end
