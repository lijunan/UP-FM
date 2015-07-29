//
//  RegisterUserViewController.m
//  UP FM
//
//  Created by liubin on 15/2/1.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "RegisterUserViewController.h"
#import "Functions.h"
#import "RegisterDetailedViewController.h"

@implementation RegisterUserViewController

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
    
    viewTop=NAV_HEIGHT+STATUS_BAR_HEIGHT;
    viewHeight=WIN_HEIGHT-viewTop;;
    
    
    UIView *mainView=[[UIView alloc] initWithFrame:CGRectMake(0, viewTop, WIN_WIDTH, viewHeight)];
    mainView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:mainView];
    
    
    float photoViewTop=30.0;
    photoViewWidth=100.0;
    photoView=[[UIImageView alloc] initWithFrame:CGRectMake((WIN_WIDTH-photoViewWidth)/2, photoViewTop, photoViewWidth, photoViewWidth)];
    photoView.layer.cornerRadius=photoViewWidth/2;
    photoView.backgroundColor=[UIColor whiteColor];
    photoView.layer.borderColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor;
    photoView.layer.borderWidth=1.0f;
    photoView.layer.masksToBounds=YES;
    [mainView addSubview:photoView];
    photoViewText=[[UILabel alloc] initWithFrame:CGRectMake(0, (photoViewWidth-20)/2, photoViewWidth, 20)];
    photoViewText.text=@"上传头像";
    photoViewText.textColor=TEXT_COLOR_SHALLOW;
    photoViewText.font=FONT_16;
    photoViewText.textAlignment=NSTextAlignmentCenter;
    [photoView addSubview:photoViewText];
    
    float photoButLeft=WIN_WIDTH/2+25;
    float photoButTop=photoViewTop+65;
    float photoButWidth=30;
    
    photoBut=[[UIButton alloc] initWithFrame:CGRectMake(photoButLeft, photoButTop, photoButWidth, photoButWidth)];
    [photoBut addTarget:self action:@selector(photoButParss) forControlEvents:UIControlEventTouchUpInside];
    photoBut.backgroundColor=RED_COLOR;
    photoBut.layer.cornerRadius=photoButWidth/2;
    photoBut.layer.masksToBounds=NO;
    [mainView addSubview:photoBut];
    
    UIImageView *photoButImg=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, photoButWidth-10, photoButWidth-10)];
    photoButImg.image=[UIImage imageNamed:@"icon-add"];
    [photoBut addSubview:photoButImg];
    

    float formViewTop=photoViewTop+photoViewWidth+20;
    float formHeight=50;
    float formViewHeight=formHeight*3;
    
    UIView *formView=[[UIView alloc] initWithFrame:CGRectMake(0, formViewTop, WIN_WIDTH, formViewHeight)];
    formView.backgroundColor=[UIColor whiteColor];
    [mainView addSubview:formView];
    
    float formTextWidth=70;
    UILabel *niceNameText=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, formTextWidth, 30)];
    niceNameText.text=@"昵称";
    niceNameText.font=FONT_14;
    niceNameText.textColor=TEXT_COLOR;
    [formView addSubview:niceNameText];
    niceNameField=[[UITextField alloc] initWithFrame:CGRectMake(formTextWidth+20, 10, WIN_WIDTH-formTextWidth-20, 30)];
    niceNameField.returnKeyType = UIReturnKeyDone;
    niceNameField.clearButtonMode = YES;
    niceNameField.delegate = self;
    niceNameField.font=FONT_14;
    niceNameField.keyboardType=UIKeyboardAppearanceDefault;
    niceNameField.placeholder = @"20个字符以内，汉字算2个字符";
    [formView addSubview:niceNameField];
    
    float line1Top=50.0;
    UIView *line1=[[UIView alloc] initWithFrame:CGRectMake(20,line1Top-1, WIN_WIDTH-20,1)];
    line1.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    [formView addSubview:line1];
    UILabel *pwdNameText=[[UILabel alloc] initWithFrame:CGRectMake(20, line1Top+10, formTextWidth, 30)];
    pwdNameText.text=@"密码";
    pwdNameText.font=FONT_14;
    pwdNameText.textColor=TEXT_COLOR;
    [formView addSubview:pwdNameText];
    pwdField=[[UITextField alloc] initWithFrame:CGRectMake(formTextWidth+20, line1Top+10, WIN_WIDTH-formTextWidth-20, 30)];
    pwdField.returnKeyType = UIReturnKeyDone;
    pwdField.clearButtonMode = YES;
    pwdField.delegate = self;
    pwdField.font=FONT_14;
    pwdField.secureTextEntry=YES;
    pwdField.keyboardType=UIKeyboardAppearanceDefault;
    
    [formView addSubview:pwdField];
    
    float line2Top=100.0;
    UIView *line2=[[UIView alloc] initWithFrame:CGRectMake(20,line2Top-1, WIN_WIDTH-20,1)];
    line2.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    [formView addSubview:line2];
    UILabel *pwd2NameText=[[UILabel alloc] initWithFrame:CGRectMake(20, line2Top+10, formTextWidth, 30)];
    pwd2NameText.text=@"再输一次";
    pwd2NameText.font=FONT_14;
    pwd2NameText.textColor=TEXT_COLOR;
    [formView addSubview:pwd2NameText];
    pwd2Field=[[UITextField alloc] initWithFrame:CGRectMake(formTextWidth+20, line2Top+10, WIN_WIDTH-formTextWidth-20, 30)];
    pwd2Field.returnKeyType = UIReturnKeyDone;
    pwd2Field.clearButtonMode = YES;
    pwd2Field.delegate = self;
    pwd2Field.font=FONT_14;
    pwd2Field.secureTextEntry=YES;
    pwd2Field.keyboardType=UIKeyboardAppearanceDefault;
    
    [formView addSubview:pwd2Field];
    
    
    float butNextTop=formViewTop+formViewHeight+30;
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
    int max=20;
    if ([Functions stringLeng:toBeString] > max) {
        
        textField.text = [toBeString substringToIndex:max];
        
        return NO;
        
    }
    
    return YES;
}


//下一步事件
-(void)nextParss{
    NSString *nineName=niceNameField.text;
    NSString *pwd=pwdField.text;
    NSString *pwd2=pwd2Field.text;
    int pwdMin=6;
    if([Functions stringLeng:nineName]<2 || [Functions stringLeng:nineName]>20){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"用户名为2到20个字符" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if([Functions stringLeng:pwd]<pwdMin){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat: @"请设置%d位以上密码",pwdMin ] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if(![pwd isEqual:pwd2]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"两次密码输入不一样" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    self.loginInfo.nickName=nineName;
    self.loginInfo.pwd=pwd;
    RegisterDetailedViewController *_viewController = [[RegisterDetailedViewController alloc] init];
    _viewController.loginInfo=self.loginInfo;
    [self pushViewRight:_viewController];
    
}
//UIAlertView协议
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

-(void)photoButParss{
#pragma mark - 照片
    [self updateIcon];
}
- (void)updateIcon{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"从相册选择", @"拍照", nil];
    [actionSheet showInView:self.view];
}
#pragma mark 选择
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            //从相册选择
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            else {
                UIAlertView *alert;
                alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                   message:@"这台设备没有可选择的图库"
                                                  delegate:self
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
                [alert show];
            }
            break;
            
        case 1:
            //拍照
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
                imagePicker.delegate = self;
                imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
                imagePicker.allowsEditing = YES;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            else {
                UIAlertView *alert;
                alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                   message:@"这台设备没有摄像头."
                                                  delegate:self
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
                [alert show];
            }
            break;
            
        default:
            break;
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
    
    //处理图片
    UIImage *tempImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    tempImage = [tempImage resizeWithSize:CGSizeMake(photoViewWidth, photoViewWidth)];
    photoViewText.hidden=YES;
    photoView.image=tempImage;
    self.loginInfo.iconImage=tempImage;
}
@end
