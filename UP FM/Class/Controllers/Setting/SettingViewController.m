//
//  SettingViewController.m
//  UP FM
//
//  Created by liubin on 15/1/27.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "SettingViewController.h"
#import "ShutdownViewController.h"
#import "InformationViewController.h"
#import "MessageSetViewController.h"
#import "SuggestViewController.h"
#import "LoginViewController.h"
#import "Broadcasting.h"
#import "MyBroadcastingViewController.h"

@implementation SettingViewController

@synthesize selectedBackgroundView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    /*
     * 导航条设置
     */
    
    //加载底部导航
    [self footBarShow];
    //设置当前底部导航
    [self setFootBarCurrentBut:@"设置"];
    
    self.title=@"设置";
    
    mainTop=NAV_HEIGHT+STATUS_BAR_HEIGHT;
    mainHeight=WIN_HEIGHT-mainTop-footHeight;
    
    
    UIView *mainView=[[UIView alloc] initWithFrame:CGRectMake(0, mainTop, WIN_WIDTH, mainHeight)];
    [self.view addSubview:mainView];
    
    //头像部分
    float photoViewHeight=140; //WIN_WIDTH*(280/DESING_WIDTH);
    UIView *photoView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, photoViewHeight)];
    [mainView addSubview:photoView];
    UIImageView *photoViewBj=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, photoViewHeight)];
    photoViewBj.image=[UIImage imageNamed:@"bj-home"];
    [photoView addSubview:photoViewBj];
    
    photoImageWidth=96.0;
    float photoImageTop=(photoViewHeight-photoImageWidth)/2;
    UIButton *photoButton=[[UIButton alloc] initWithFrame:CGRectMake(photoImageTop, photoImageTop, photoImageWidth, photoImageWidth)];
    [photoButton addTarget:self action:@selector(photoButtonParss) forControlEvents:UIControlEventTouchUpInside];
    photoButton.layer.cornerRadius=photoImageWidth/2;
    photoButton.layer.borderColor=[UIColor whiteColor].CGColor;
    photoButton.layer.borderWidth=2.0;
    photoButton.layer.masksToBounds=YES;
    [photoView addSubview:photoButton];
    photoImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, photoImageWidth, photoImageWidth)];
    [photoButton addSubview:photoImageView];
    
    //用户名
    float userNameLeft=photoImageTop+photoImageWidth+10;
    float userNameHeight=60;
    float userNameWidth=WIN_WIDTH-userNameLeft;
    UIButton *userNameBut=[[UIButton alloc] initWithFrame:CGRectMake(userNameLeft, (photoViewHeight-userNameHeight)/2, userNameWidth, userNameHeight)];
    
    [photoView addSubview:userNameBut];
    [userNameBut addTarget:self action:@selector(infoButtonParss) forControlEvents:UIControlEventTouchUpInside];
    userName=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, userNameWidth-50, userNameHeight)];
    userName.font=FONT_14;
    userName.textColor=[UIColor whiteColor];
    
    userName.numberOfLines=0;
    [userNameBut addSubview:userName];
    
    float infoButImageWidth=14.0;
    UIImageView *rightMoreImage=[[UIImageView alloc] initWithFrame:CGRectMake(userNameWidth-infoButImageWidth-10, (userNameHeight-infoButImageWidth)/2, infoButImageWidth, infoButImageWidth)];
    rightMoreImage.image=[UIImage imageNamed:@"icon-arrows-right25"];
    [userNameBut addSubview:rightMoreImage];
    
    
    
    
    //操作列表
    float tableViewTop=photoViewHeight;
    float tableViewHeight=mainHeight-tableViewTop;
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, tableViewTop, WIN_WIDTH, tableViewHeight) style:UITableViewStyleGrouped];
    _tableView.rowHeight = SETTING_HEIGHT;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [mainView addSubview:_tableView];
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(void) viewWillAppear:(BOOL)animated{
    if([self isLogin]){
        CurrentUser *_currentUser=[CurrentUser sharedInstance];
        [photoImageView setImageWithURL:[NSURL URLWithString:_currentUser.icon] placeholderImage:DEFAULT_PHOTO];
        userName.text=_currentUser.nickName;
    }else{
        photoImageView.image=DEFAULT_PHOTO;
        userName.text=@"点击头像登录";
    }
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 5;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    BOOL isBackColor=YES;
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    NSString *labelText=@"开通我的电台";
                    if([self isLogin] && [self isBroadcasting]){
                        labelText = @"我的电台";
                    }
                    cell.textLabel.text = labelText;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    
                    cell.textLabel.text = @"只在Wifi环境才下载";
                    BOOL notOnlyWifi = [[NSUserDefaults standardUserDefaults] boolForKey:@"notOnlyWifi"];
                    
                    UISwitch *wifiSwitch=[[UISwitch alloc] initWithFrame:CGRectMake(WIN_WIDTH-70, 10, 50, 30)];
                    wifiSwitch.on=notOnlyWifi;
                    [cell addSubview:wifiSwitch];
                    
                    [wifiSwitch addTarget:self
                                   action:@selector(setWifi)
                         forControlEvents:UIControlEventValueChanged];
                    
                    
                    isBackColor=NO;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }
                case 1:{
                    
                    cell.textLabel.text = @"定时关闭";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 2:{
                    
                    cell.textLabel.text = @"主播设置";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
//                case 2:{
//                    
//                    cell.textLabel.text = @"消息提醒设置";
//                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                    break;
//                }
                case 3:{
                    
                    cell.textLabel.text = @"检查版本更新";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 4:{
                    
                    cell.textLabel.text = @"建议和投诉（有奖！）";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    UIView *aView = [[UIView alloc] initWithFrame:cell.contentView.frame];
    aView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    self.selectedBackgroundView = aView;
    cell.selectedBackgroundView=aView;
    return cell;
}

//点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            if([self isLogin]){
                MyBroadcastingViewController *_viewController=[[MyBroadcastingViewController alloc] init];
                [self pushViewRight:_viewController];
                
            }else{
                [self loginParss];
            }
            break;
        }
        case 1:{
            switch (indexPath.row) {
                case 1:{
                    //定时关机
                    ShutdownViewController *_viewController = [[ShutdownViewController alloc] init];
                    [self pushViewRight:_viewController];
                   
                    break;
                }
                case 2:{
                    //主播设置
                    [self toHost];
                    break;
                }
//                case 2:{
//                    //消息设置
//                    MessageSetViewController *_viewController = [[MessageSetViewController alloc] init];
//                    [self pushViewRight:_viewController];
//                    break;
//                }
                case 3:{
                    //检测版本
                    [self checkForUpdates];
                    break;
                }
                case 4:{
                    //消息设置
                    SuggestViewController *_viewController = [[SuggestViewController alloc] init];
                    [self pushViewRight:_viewController];
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
}
#pragma mark 设置Wifi
- (void)setWifi
{
    BOOL notOnlyWifi = [[NSUserDefaults standardUserDefaults] boolForKey:@"notOnlyWifi"];
    [[NSUserDefaults standardUserDefaults] setBool:!notOnlyWifi forKey:@"notOnlyWifi"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark 新版本检测
- (void)checkForUpdates {
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"版本检测" message:@"当前已经是最新版本！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.delegate=self;
    alert.tag=1;
    [alert show];
}
-(void)toHost{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"主播设置正在建设中..." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.delegate=self;
    [alert show];
}
//UIAlertView协议
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

//头像
-(void)photoButtonParss{
    if([self isLogin]){
        [self updateIcon];
    }else{
        [self loginParss];
    }
    
}
#pragma mark - 照片
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
    tempImage = [tempImage resizeWithSize:CGSizeMake(photoImageWidth, photoImageWidth)];
    photoImageView.image=tempImage;
    
}
//我的资料
-(void)infoButtonParss{
    if([self isLogin]){
        InformationViewController *_viewController = [[InformationViewController alloc] init];
        [self pushViewRight:_viewController];
    }else{
        [self loginParss];
    }
}

-(void)loginParss{
    LoginViewController *_viewController=[[LoginViewController alloc] init];
    [self pushViewRight:_viewController];
}
//判断是否登录
-(BOOL)isLogin{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    
}
-(BOOL)isBroadcasting{
    Broadcasting *broadcasting=[Broadcasting sharedInstance];
    return broadcasting.open;
}
@end
